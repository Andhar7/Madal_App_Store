//
//  SideMenu.swift
//  Madal
//
//  Created by Solver on 04.04.2022.
//

import SwiftUI

struct SideMenu: View {
    
    @Binding var showMenu : Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0.0) {
            
            VStack(alignment: .leading, spacing: 12.0) {
                
                Image("g2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .padding(2)
                    .overlay(Circle().stroke(Color("Delight"), lineWidth: 1))
                
                Text("Sri Chinmoy Family")
                 .font(.system(size: 18, weight: .bold, design: .serif))
                 .kerning(2.1)
                 .foregroundColor(Color("Consciousness"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack {
                    
                    ForEach(MenuItems) { item in
                        VStack(alignment: .leading, spacing: 42.0) {
                            
                            TabButton(title: item.category, imageName: item.image)
                            
                            //                        TabButton(title: "Library", imageName: "rectangle.and.pencil.and.ellipsis")
                            //
                            //                        TabButton(title: "3100 miles", imageName: "figure.walk")
                            //
                            //                        TabButton(title: "Ashram Ponduchery", imageName: "sparkles")
                            //
                            //                        TabButton(title: "OSN", imageName: "globe.europe.africa.fill")
                            //
                            //                        TabButton(title: "Meditation", imageName: "leaf.circle")
                            
                        }
                        .padding(.leading)
                        .padding(.top, 13)
                        
                        
                        Divider()
                            .background(Color("Delight"))
                            .padding(.top, 8)
                        
//                        TabButton(title: item.category imageName: item.image)
//                            .padding(.top, 33)
//                            .padding(.leading)
                        
                    }
                }
            }
        }
        .padding()
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(Color("Glory").opacity(0.2).ignoresSafeArea(.container, edges: .vertical))
        .frame(maxWidth: .infinity, alignment: .leading )
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu(showMenu: .constant(false))
    }
}

extension View {
    
    @ViewBuilder
    func TabButton(title: String, imageName: String) -> some View {
        
        NavigationLink{
            
            Text("\(title) View")
                .navigationTitle(title)
            
        } label: {
            
            HStack(spacing: 14){
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 33, height: 33)
                
                Text(title)
                    .font(.system(size: 15, weight: .regular, design: .serif))
                    .kerning(2.1)
            }
            .foregroundColor(Color("light"))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
    
    func getRect() -> CGRect {
        
        return UIScreen.main.bounds
    }
}
