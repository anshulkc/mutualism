//
//  mutualismApp.swift
//  mutualism
//
//  Created by Anshul Chennavaram on 10/2/25.
//

import SwiftUI

@main
struct mutualismApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
