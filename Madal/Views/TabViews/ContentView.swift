//
//  ContentView.swift
//  Madal
//
//  Created by Solver on 04.04.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        OpeningPageView()
      //  BaseView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
