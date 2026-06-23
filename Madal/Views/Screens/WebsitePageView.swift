//
//  WebsitePageView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI
import WebKit
import Network

struct WebsitePageView: View {

    let id: String
    let url: String
    let image: String
    let category: String

    // macOS: called when the user taps the back button in the toolbar.
    // OpeningPageView sets this to `{ selectedSite = nil }` so the detail
    // column returns to the category list. iOS ignores it (uses its own back).
    var onDismiss: (() -> Void)? = nil

    @State var showMenu: Bool = false
    @State var isFavourite: Bool = false
    @StateObject private var networkMonitor = WebPageNetworkMonitor()
    #if os(macOS)
    @StateObject private var webNav = WebNavigation()
    #endif

    @Environment(\.presentationMode) var dismiss
    @Environment(\.managedObjectContext) var context

    @FetchRequest(entity: All.entity(), sortDescriptors: [])
    var favourite: FetchedResults<All>

    var body: some View {

        // DragGesture is cross-platform — only used on iOS
        let dragGesture = DragGesture()
            .onEnded({
                if $0.translation.width < -100 {
                    withAnimation(.easeIn(duration: 0.8)) { showMenu.toggle() }
                }
            })

        #if os(macOS)
        // ── macOS: Full-screen web view, toolbar handles all navigation ─
        ZStack {
            // Base layer — ensures the detail column is always dark blue,
            // not black, even during the brief moment before the page loads.
            Color("Unity").ignoresSafeArea()

            if networkMonitor.isConnected {
                WebView(urlString: url, webNav: webNav)
            } else {
                VStack(spacing: 25) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 70))
                        .foregroundColor(.white.opacity(0.8))
                    Text("No Internet Connection")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .foregroundColor(.white)
                }
            }
        }
        .toolbar {
            // ← Category — returns to the category list
            ToolbarItem(placement: .navigation) {
                Button(action: { onDismiss?() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text(category)
                    }
                }
            }
            // ⬅ ➡ — web history back / forward within the current website
            ToolbarItem(placement: .navigation) {
                HStack(spacing: 2) {
                    Button(action: { webNav.goBack() }) {
                        Image(systemName: "chevron.backward")
                    }
                    .disabled(!webNav.canGoBack)

                    Button(action: { webNav.goForward() }) {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!webNav.canGoForward)
                }
            }
            // ★ — favourite toggle
            ToolbarItem(placement: .primaryAction) {
                Button(action: { toggleFavourite() }) {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                        .imageScale(.large)
                }
            }
        }
        .navigationTitle(id)
        .onAppear { checkIfFavourite() }

        #else
        // ── iOS / iPadOS: Slide-out menu approach ───────────────────────
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                if networkMonitor.isConnected {
                    WebView(urlString: url)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .offset(x: showMenu ? geo.size.width / 2 : 0)
                        .disabled(showMenu)
                        .background(Color("Unity"))

                    if showMenu {
                        MenuView()
                            .frame(width: geo.size.width / 2)
                    }
                } else {
                    ZStack {
                        Color(red: 0.1, green: 0.1, blue: 0.3).ignoresSafeArea()
                        VStack(spacing: 25) {
                            Image(systemName: "wifi.slash")
                                .font(.system(size: 70))
                                .foregroundColor(.white.opacity(0.8))
                            Text("No Internet Connection")
                                .font(.system(size: 24, weight: .medium, design: .serif))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Text("Please check your internet\nconnection and try again.")
                                .font(.system(size: 16, weight: .regular, design: .serif))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.2)
                                .padding(.top, 10)
                        }
                    }
                }
            }
            .gesture(dragGesture)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation, content: {
                Button(action: { dismiss.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Text(category)
                            .font(.system(size: 21, weight: .regular, design: .serif))
                            .kerning(2.4)
                            .foregroundColor(.white)
                    }
                }
            })
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction, content: {
                Button(action: { toggleFavourite() }) {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
            })
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear { checkIfFavourite() }
        #endif
    }

    // MARK: - Helpers

    private func checkIfFavourite() {
        for item in favourite {
            if id == item.id { isFavourite = true; break }
        }
    }

    private func toggleFavourite() {
        withAnimation { isFavourite.toggle() }
        if isFavourite {
            let newItem = All(context: context)
            newItem.id = id
            newItem.url = url
            newItem.image = image
            try? context.save()
        } else {
            for item in favourite {
                if id == item.id { context.delete(item); break }
            }
            try? context.save()
        }
    }
}

// Simple inline network monitor for web pages
class WebPageNetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "WebPageNetworkMonitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
