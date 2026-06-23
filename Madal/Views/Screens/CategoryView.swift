//
//  CategoryView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI

struct CategoryView: View {

    let category: String

    // macOS: callback when a row is tapped (no NavigationLink → no hover popup)
    // iOS: unused (nil)
    var onSiteSelected: ((String, String, String, String) -> Void)? = nil

    @State var showMenu: Bool = false

    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: All.entity(), sortDescriptors: [])
    var favourites: FetchedResults<All>

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
        // ── macOS: List with plain Buttons — NO NavigationLink ──────────
        // WHY: NavigationLink shows destination-preview popups on hover.
        // Plain Buttons call onSiteSelected(); OpeningPageView reacts to
        // that state change and swaps the detail column to WebsitePageView.
        //
        // ZStack WHY: .background(Color("Unity")) only fills the List scroll
        // area (where the rows are). The empty space below the last row, and
        // the overall NavigationView detail column, shows the system window
        // background (near-black in dark mode). Placing Color("Unity") as the
        // bottommost ZStack layer fills the entire detail column uniformly.
        ZStack {
            Color("Unity").ignoresSafeArea()

            List {
                if category == "Favourite" {
                    ForEach(favourites, id: \.self) { item in
                        Button(action: {
                            onSiteSelected?(item.id, item.url, item.image, category)
                        }) {
                            macRow(image: item.image, title: item.id)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color("Unity"))
                    }
                } else {
                    ForEach(webSitesItems.filter { $0.category == category }, id: \.self) { item in
                        Button(action: {
                            onSiteSelected?(item.id, item.url, item.image, item.category)
                        }) {
                            macRow(image: item.image, title: item.id)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color("Unity"))
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(category)
        .foregroundColor(.white)

        #else
        // ── iOS / iPadOS: Slide-out hamburger menu approach ─────────────
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ScrollView(.vertical, showsIndicators: false) {
                    Divider()
                        .background(Color.white)
                        .padding(.top)

                    if category == "Favourite" {
                        ForEach(favourites, id: \.self) { item in
                            WebsiteRowView(image: item.image, title: item.id, url: item.url, category: category)
                            Divider().background(Color.white)
                        }
                    } else {
                        ForEach(webSitesItems, id: \.self) { item in
                            if item.category == category {
                                WebsiteRowView(image: item.image, title: item.id, url: item.url, category: item.category)
                                Divider().background(Color.white)
                            }
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .offset(x: showMenu ? geo.size.width / 2 : 0)
                .disabled(showMenu)
                .background(Color("Unity"))

                if showMenu {
                    MenuView()
                        .frame(width: geo.size.width / 2)
                }
            }
            .gesture(dragGesture)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation, content: {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.8)) {
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
        .toolbar {
            ToolbarItemGroup(placement: .principal, content: {
                Text(category)
                    .font(.system(size: 21, weight: .regular, design: .serif))
                    .foregroundColor(.white)
            })
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .foregroundColor(.white)
        #endif
    }

    // macOS row layout (no chevron — clicking anywhere on the row navigates)
    #if os(macOS)
    @ViewBuilder
    private func macRow(image: String, title: String) -> some View {
        HStack(spacing: 21) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 33, height: 33)
                .clipShape(Circle())
            Text(title)
                .font(.system(size: 15, weight: .bold, design: .serif))
                .kerning(2.7)
            Spacer()
        }
        .foregroundColor(.white)
        .frame(height: 55)
        .padding(.horizontal, 4)
    }
    #endif
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: "Races")
    }
}
