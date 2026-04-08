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

    var body: some View {
        
        let dragGesture = DragGesture()
            .onEnded({
                if $0.translation.width < -100 {
                    
                    withAnimation(.easeIn(duration: 0.8)){
                        showMenu.toggle()
                    }
                }
            })
        
        NavigationView {
            
            GeometryReader { geo in
                
                ZStack(alignment: .leading) {
                    
                    // Network check
                    if networkMonitor.isConnected {
                        WebView(urlString: "https://www.srichinmoy.org", isLoading: $isWebLoading)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .offset(x: showMenu ? geo.size.width / 2 : 0)
                            .disabled(showMenu ? true : false)
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
                        
                        if showMenu{
                            
                            MenuView()
                                .frame(width: geo.size.width / 2 )
                        }
                    } else {
                        // No internet screen
                        ZStack {
                            Color(red: 0.1, green: 0.1, blue: 0.3)
                                .ignoresSafeArea()
                            
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
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    
                                    Button(action: {
                withAnimation(.easeIn(duration: 0.8)){
                    showMenu.toggle()
                }
            }, label: {
                
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                    .scaleEffect(1.8)
                    .foregroundColor(.white)
            })
                                        .padding(.leading, 23)
                                        .padding(.bottom, 21)
            )
        }
        .navigationViewStyle(.stack) // 🔥 This fixes iPad layout!
    }
}

// Simple inline network monitor
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
