//
//  Mc2_ModifierApp.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/23.
//

import SwiftUI

@main
struct Mc2_ModifierApp: App {
    let persistenceController = PersistenceController.shared
    
    let stateManage = StateManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stateManage)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
