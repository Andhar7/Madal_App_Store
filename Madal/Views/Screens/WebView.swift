//
//  WebView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI
import WebKit

// Shared observable that lets WebsitePageView read canGoBack/canGoForward
// and call goBack()/goForward() on the underlying WKWebView.
// Only wired up on macOS; iOS uses system browser back gestures.
class WebNavigation: ObservableObject {
    @Published var canGoBack = false
    @Published var canGoForward = false
    // WHY weak: the Coordinator already strongly owns the WKWebView reference
    // via NSViewRepresentable — we don't want a second strong reference here.
    weak var webView: WKWebView?

    func goBack()    { webView?.goBack() }
    func goForward() { webView?.goForward() }
}

// Cross-platform wrapper View — callers use WebView(urlString:) unchanged.
struct WebView: View {
    let urlString: String?
    @Binding var isLoading: Bool
    var webNav: WebNavigation?      // macOS only; nil on iOS or when not needed

    init(urlString: String?,
         isLoading: Binding<Bool> = .constant(false),
         webNav: WebNavigation? = nil) {
        self.urlString = urlString
        self._isLoading = isLoading
        self.webNav = webNav
    }

    var body: some View {
        #if os(macOS)
        MacWebViewRepresentable(urlString: urlString, isLoading: $isLoading, webNav: webNav)
        #else
        iOSWebViewRepresentable(urlString: urlString, isLoading: $isLoading)
        #endif
    }
}

// MARK: - macOS — AppKit (NSViewRepresentable)

#if os(macOS)
private struct MacWebViewRepresentable: NSViewRepresentable {
    let urlString: String?
    @Binding var isLoading: Bool
    var webNav: WebNavigation?

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading, webNav: webNav)
    }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        // Allow HTML5 video elements to request fullscreen (macOS 12.3+).
        // Without this the fullscreen button in video players does nothing.
        if #available(macOS 12.3, *) {
            config.preferences.isElementFullscreenEnabled = true
        }
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        // Give WebNavigation a reference so toolbar buttons can call goBack()/goForward()
        context.coordinator.webNav?.webView = webView
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              context.coordinator.lastLoadedURL != url else { return }
        context.coordinator.lastLoadedURL = url
        nsView.load(URLRequest(url: url))
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var lastLoadedURL: URL?
        @Binding var isLoading: Bool
        weak var webNav: WebNavigation?

        init(isLoading: Binding<Bool>, webNav: WebNavigation?) {
            self._isLoading = isLoading
            self.webNav = webNav
        }

        // MARK: WKNavigationDelegate

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
            // Update back/forward availability so toolbar buttons enable/disable
            webNav?.canGoBack    = webView.canGoBack
            webNav?.canGoForward = webView.canGoForward
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }

        // MARK: WKUIDelegate

        // Handle target=_blank links — some sites open videos in a new window.
        // We load them in the same WKWebView instead.
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}

// MARK: - iOS / iPadOS — UIKit (UIViewRepresentable)

#else
private struct iOSWebViewRepresentable: UIViewRepresentable {
    let urlString: String?
    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              context.coordinator.lastLoadedURL != url else { return }
        context.coordinator.lastLoadedURL = url
        uiView.load(URLRequest(url: url))
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var lastLoadedURL: URL?
        @Binding var isLoading: Bool

        init(isLoading: Binding<Bool>) {
            self._isLoading = isLoading
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { isLoading = true }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { isLoading = false }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { isLoading = false }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { isLoading = false }
    }
}
#endif
