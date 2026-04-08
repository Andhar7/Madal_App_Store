//
//  HomeView.swift
//  Madal
//
//  Created by Solver on 04.04.2022.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var showMenu : Bool
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Button(action: {
                        withAnimation(.spring()){
                            showMenu.toggle()
                        }
                    }, label: {
                        Image("harmony")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(Color("Delight"), lineWidth: 1))
                    })
                    
                    Spacer()
                    
                    NavigationLink {
                        
                        Text("Next Some View")
                            .font(.system(size: 21, weight: .regular, design: .serif))
                            .navigationTitle("Some View")
                        
                    } label: {
                        
                        Image(systemName: "sparkles")
                            .imageScale(.large)
                            .foregroundColor(Color("Unity"))
                        
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                Divider()
                    .background(Color("Delight"))
            }
            .overlay(
            
                Image("g1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 42)
                    .background(Color.gray, in: Circle())
                    .clipShape(Circle())
                   
            )
            
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showMenu: .constant(false))
    }
}
