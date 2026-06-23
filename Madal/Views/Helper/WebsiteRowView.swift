//
//  WebsiteRowView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI

struct WebsiteRowView: View {

    let image: String
    let title: String
    let url: String
    let category: String

    var body: some View {
        NavigationLink(destination: WebsitePageView(id: title, url: url, image: image, category: category)) {
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

                Image(systemName: "chevron.right")
                    .imageScale(.small)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .frame(height: 55)
        }
        .buttonStyle(.plain)
    }
}

struct WebsiteRowView_Previews: PreviewProvider {

    static var previews: some View {
        let item = webSitesItems[0]
        WebsiteRowView(image: item.image, title: item.id, url: item.url, category: item.category)
    }
}
