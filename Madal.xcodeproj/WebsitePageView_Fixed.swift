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
    
    let id : String
    let url : String
    let image : String
    let category : String
    
    @State var showMenu : Bool = false
    @State var isFavourite : Bool = false
    @StateObject private var networkMonitor = WebPageNetworkMonitor()
    
    @Environment(\.presentationMode) var dismiss
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: All.entity(), sortDescriptors: [])
    var favourite : FetchedResults<All>
    
    var body: some View {
        
        let dragGesture = DragGesture()
        
            .onEnded({
                if $0.translation.width < -100 {
                    withAnimation(.easeIn(duration: 0.8)){
                        showMenu.toggle()
                    }
                }
            })
        
        GeometryReader { geo in
            
            ZStack(alignment: .leading) {
                
                // Network check
                if networkMonitor.isConnected {
                    WebView(urlString: url)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .offset(x: showMenu ? geo.size.width / 2 : 0)
                        .disabled(showMenu ? true : false)
                        .background(Color("Unity"))
                    
                    if showMenu {
                        
                        MenuView()
                            .frame(width: geo.size.width / 2)
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
        .toolbar {
            
            ToolbarItemGroup(placement: .navigationBarLeading, content: {
                
                Button(action: {
                    dismiss.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Text(category)
                         .font(.system(size: 21, weight: .regular, design: .serif))
                         .kerning(2.4)
                         .foregroundColor(.white)
                    }
                })
            })
        }
        .toolbar {
            
            ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                
                Button(action: {
                    withAnimation{
                        isFavourite.toggle()
                    }
                    
                    if isFavourite {
                        let newFavouriteItem = All(context: context)
                        newFavouriteItem.id = id
                        newFavouriteItem.url = url
                        newFavouriteItem.image = image
                        
                        do {
                            
                            try context.save()
                            
                        } catch {
                            
                            print(error.localizedDescription)
                        }
                        
                    } else {
                        
                        for favouriteItem in favourite {
                            
                            if id == favouriteItem.id{
                                
                                context.delete(favouriteItem)
                                
                                break
                            }
                        }
                        
                        do {
                            
                            try context.save()
                            
                        } catch {
                            
                            print(error.localizedDescription)
                        }
                    }
                }, label: {
                    
                    if isFavourite {
                        
                        Image(systemName: "star.fill")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        
                    } else {
                        
                        Image(systemName: "star")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                })
            })
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            
            for favouriteItem in favourite {
                
                if id == favouriteItem.id{
                    
                   isFavourite = true
                    
                    break
                }
            }
        })
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

//struct WebsitePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebsitePageView(id: "Library", url: "https://www.srichinmoylibrary.com", image: "apple", category: "Lybrary")
//    }
//}
