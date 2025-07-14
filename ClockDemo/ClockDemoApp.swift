//
//  ClockDemoApp.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 6.01.2025.
//

import SwiftUI
import SwiftData

@main
struct ClockDemoApp: App {
   
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
   
    
   

    var body: some Scene {
        WindowGroup {
           ContentView()
            
        }
        .modelContainer(sharedModelContainer)
    }
}
