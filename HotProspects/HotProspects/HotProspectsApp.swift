//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Shivansh omer on 19/05/25.
//
import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
