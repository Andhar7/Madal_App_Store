//
//  MenuView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI

struct MenuView: View {

    @State var isNavigationBarHidden = true

    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {

            VStack(alignment: .leading, spacing: 18) {

                ForEach(MenuItems, id:\.self) { item in

                    NavigationLink(destination: CategoryView(category: item.category)) {

                        HStack(spacing: 33) {

                            Image(systemName: item.image)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)

                            Text(item.category)
                             .font(.system(size: 18, weight: .regular, design: .serif))
                             .kerning(2.4)
                             .foregroundColor(.white)
                        }
                    }
                    .transition(.move(edge: .trailing))

                    Divider()
                        .background()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color("Unity").ignoresSafeArea())
        .onAppear(perform: {
            isNavigationBarHidden = true
        })
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
