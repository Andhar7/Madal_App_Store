//
//  CategoryView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI

struct CategoryView: View {
    
    let category : String
    
    @State var showMenu : Bool = false
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: All.entity(), sortDescriptors: [])
    var favourites : FetchedResults<All>
    
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
            
            ZStack(alignment: .topLeading) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Divider()
                        .background(Color.white)
                        .padding(.top)
                    
                    if category == "Favourite" {
                        
                        ForEach(favourites, id:\.self) { item in
                            
                            WebsiteRowView(image: item.image, title: item.id, url: item.url, category: category)
                            
                            Divider()
                                .background(Color.white)
                        }
                    } else {
                        
                        ForEach(webSitesItems, id:\.self) { item in
                            
                            if item.category == category {
                                
                                WebsiteRowView(image: item.image, title: item.id, url: item.url, category: item.category)
                                
                                Divider()
                                    .background(Color.white)
                            }
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .offset(x: showMenu ? geo.size.width / 2 : 0)
                .disabled(showMenu ? true : false)
                .background(Color("Unity"))
                
                if showMenu {
                    
                    MenuView()
                        .frame(width: geo.size.width / 2)
                }
            }
            .gesture(dragGesture)
        }
        .toolbar {
            
            ToolbarItemGroup(placement: .navigationBarLeading, content: {
                
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
            })
        }
        .toolbar{
            ToolbarItemGroup(placement: .principal, content: {
                
                Text(category)
                 .font(.system(size: 21, weight: .regular, design: .serif))
                 .foregroundColor(.white)
            })
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .foregroundColor(.white)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: "Races")
    }
}
