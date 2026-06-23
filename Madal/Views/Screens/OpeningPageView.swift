//
//  OpeningPageView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI
import WebKit
import Network

struct OpeningPageView: View {

    @State var showMenu: Bool = false
    @State var isWebLoading: Bool = true
    @StateObject private var networkMonitor = SimpleNetworkMonitor()

    // macOS: drives what the detail column shows
    #if os(macOS)
    @State private var selectedCategory: String? = nil
    @State private var selectedSite: MacSiteSelection? = nil
    #endif

    var body: some View {

        // DragGesture is cross-platform — computed once, used only on iOS
        let dragGesture = DragGesture()
            .onEnded({
                if $0.translation.width < -100 {
                    withAnimation(.easeIn(duration: 0.8)) {
                        showMenu.toggle()
                    }
                }
            })

        #if os(macOS)
        // ── macOS: State-driven two-column layout ──────────────────────
        // WHY: NavigationLink shows hover preview popups on macOS no matter
        // what — even with EmptyView labels. The only fix is to remove
        // NavigationLink from content rows entirely. The sidebar uses
        // List(selection:) to track the chosen category; content rows are
        // plain Buttons that set selectedSite state; the detail column
        // re-renders automatically when state changes.
        NavigationView {

            // ── LEFT: category sidebar ──
            List(selection: $selectedCategory) {
                ForEach(MenuItems, id: \.category) { item in
                    Label(item.category, systemImage: item.image)
                        .font(.system(size: 14, weight: .regular, design: .serif))
                        .tag(item.category)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Madal")
            .onChange(of: selectedCategory) { _, _ in
                // Moving to a different category resets any open website
                selectedSite = nil
            }

            // ── RIGHT: state-driven detail ──
            macDetailView
        }
        .frame(minWidth: 960, minHeight: 640)

        #else
        // ── iOS / iPadOS: Hamburger slide-out menu ─────────────────────
        NavigationView {

            GeometryReader { geo in

                ZStack(alignment: .leading) {

                    if networkMonitor.isConnected {
                        WebView(urlString: "https://www.srichinmoy.org", isLoading: $isWebLoading)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .offset(x: showMenu ? geo.size.width / 2 : 0)
                            .disabled(showMenu)
                            .background(Color("Unity"))

                        if isWebLoading {
                            ZStack {
                                Color("Unity").ignoresSafeArea()
                                VStack(spacing: 20) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(1.5)
                                    Text("Loading...")
                                        .font(.system(size: 16, weight: .regular, design: .serif))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .frame(width: geo.size.width, height: geo.size.height)
                        }

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
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.8)) {
                            showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .scaleEffect(1.8)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        #endif
    }

    // MARK: - macOS detail column (state-driven)

    #if os(macOS)
    @ViewBuilder
    private var macDetailView: some View {
        if let site = selectedSite {
            // A specific website was chosen → show it
            WebsitePageView(
                id: site.id,
                url: site.url,
                image: site.image,
                category: site.category,
                onDismiss: { selectedSite = nil }
            )
            .id(site.url)  // force fresh view when URL changes
        } else if let category = selectedCategory {
            // A category was chosen → show its website list
            CategoryView(
                category: category,
                onSiteSelected: { id, url, image, cat in
                    selectedSite = MacSiteSelection(id: id, url: url, image: image, category: cat)
                }
            )
        } else {
            // Nothing selected yet → show the main Sri Chinmoy website
            ZStack {
                Color("Unity").ignoresSafeArea()
                if networkMonitor.isConnected {
                    WebView(urlString: "https://www.srichinmoy.org", isLoading: $isWebLoading)
                    if isWebLoading {
                        ZStack {
                            Color("Unity").ignoresSafeArea()
                            VStack(spacing: 20) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                                Text("Loading...")
                                    .font(.system(size: 16, weight: .regular, design: .serif))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                } else {
                    VStack(spacing: 25) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 70))
                            .foregroundColor(.white.opacity(0.8))
                        Text("No Internet Connection")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .foregroundColor(.white)
                        Text("Please check your internet\nconnection and try again.")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
    #endif
}

// MARK: - macOS site selection model

#if os(macOS)
struct MacSiteSelection {
    let id: String
    let url: String
    let image: String
    let category: String
}
#endif

// MARK: - Network monitor

class SimpleNetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

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

struct OpeningPageView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningPageView()
    }
}
