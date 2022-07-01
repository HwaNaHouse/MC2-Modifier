//
//  Mc2_ModifierApp.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/23.
//

import SwiftUI

@main
struct Mc2_ModifierApp: App {
    let stateManage = StateManager()
    let mapViewModel = MapViewModel()
    let coreDataViewModel = CoreDataViewModel()

    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stateManage)
                .environmentObject(mapViewModel)
                .environmentObject(coreDataViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
