//
//  MadalApp.swift
//  Madal
//
//  Created by Solver on 04.04.2022.
//

import SwiftUI

@main
struct MadalApp: App {

    let persistenceController = PersistenceController.shared

    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    #if os(iOS)
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    #endif
                }
                .onChange(of: scenePhase) { _, newScenePhase in
                    switch newScenePhase {
                    case .background:
                        print("background")
                        persistenceController.saveContext()
                    case .inactive:
                        print("inactive")
                    case .active:
                        print("active")
                    @unknown default:
                        print("something must have changed")
                    }
                }
        }
    }
}
