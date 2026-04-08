//
//  WebView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let urlString: String?
    @Binding var isLoading: Bool

    init(urlString: String?, isLoading: Binding<Bool> = .constant(false)) {
        self.urlString = urlString
        self._isLoading = isLoading
    }

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

    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        var lastLoadedURL: URL?
        @Binding var isLoading: Bool

        init(isLoading: Binding<Bool>) {
            self._isLoading = isLoading
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }
    }
}

