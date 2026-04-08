//
//  BaseView.swift
//  Madal
//
//  Created by Solver on 04.04.2022.
//

import SwiftUI

struct BaseView: View {
    
    @State var showMenu : Bool = false
    @State var currentTab : String = "homekit"
    
    // Offset for Both Drag Gesture and showing Menu...
    @State var offset : CGFloat = 0
    @State var lastStoredOffset : CGFloat = 0
    
    @GestureState var gestureOffset : CGFloat = 0
    
    init(){
        
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        let sideBarWidth = getRect().width - 90
        
        NavigationView {
            
            HStack(spacing: 0) {
                
                SideMenu(showMenu: $showMenu)
                
                VStack(spacing: 0){
                    
                    TabView(selection: $currentTab){
                        
                        HomeView(showMenu: $showMenu)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("homekit")
                        
                        Text("Biography")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("heart.fill")
                        
                        Text("Centers")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("gear.circle")
                    }
                    
                    // Custom Tab Bar ...
                    VStack(spacing: 0) {
                        
                        Divider()
                            .background(Color("Unity"))
                        
                        HStack(spacing: 0){
                            
                            CustomTabButton(imageName: "homekit")
                            
                            CustomTabButton(imageName: "heart.fill")
                            
                            CustomTabButton(imageName: "gear.circle")
                        }
                        .padding(.top, 12)
                        
                    }
                }
                .frame(width: getRect().width)
                // BG when menu is showing...
                .overlay(
                
                    Rectangle()
                        .fill(Color("Unity").opacity(Double((offset / sideBarWidth) / 2)))
                            .ignoresSafeArea(.container, edges: .vertical)
                            .onTapGesture {
                                withAnimation{
                                    showMenu.toggle()
                                }
                            }
                )
            }
            // MAX SIZE..
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset > 0 ? offset : 0)
            .gesture(
            
                DragGesture()
                    .updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded(onEnd(value:))
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack) // 🔥 iPad fix!
        .animation(.easeOut(duration: 0.8), value: offset == 0)
        .onChange(of: showMenu, perform: { newValue in
            
            if showMenu && offset == 0 {
                
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth{
                
                offset = 0
                lastStoredOffset = 0
            }
        })
        .onChange(of: gestureOffset, perform: { newValue in
            onChange()
        })
    }
    func onChange() {
        
        let sideBarWidth = getRect().width - 90
        
        offset = (gestureOffset != 0) ? (gestureOffset + lastStoredOffset < sideBarWidth ? gestureOffset + lastStoredOffset : offset) : offset
        
    }
    func onEnd(value: DragGesture.Value){
        
        let sideBarWidth = getRect().width - 90
        
        let translation = value.translation.width
        
        // Checking...
        if translation > 0 {
            
            if translation > (sideBarWidth / 2){
                
                // showing menu...
                offset = sideBarWidth
                showMenu = true
                
            } else {
                
                // Extra Cases...
                if offset == sideBarWidth {
                    
                    return
                }
                
                offset = 0
                showMenu = false
                
            }
        } else {
            
            if -translation > (sideBarWidth / 2){
                
                offset = 0
                showMenu = false
                
            } else {
                
                // Extra ...
                if offset == 0 || !showMenu {
                    
                    return
                }
                
                offset = sideBarWidth
                showMenu = true
            }
        }
        
        lastStoredOffset = offset
        
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}

extension BaseView {
    
    @ViewBuilder
    func CustomTabButton(imageName: String) -> some View {
        
        Button(action: {
            withAnimation(.spring()){
                currentTab = imageName
            }
        }, label: {
            
            Image(systemName: imageName)
                .imageScale(.large)
                .foregroundColor(currentTab == imageName ? Color("Delight") : Color("Consciousness"))
                .frame(maxWidth: .infinity)
        })
    }
}
