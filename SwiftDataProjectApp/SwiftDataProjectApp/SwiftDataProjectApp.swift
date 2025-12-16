//
//  SwiftDataProjectAppApp.swift
//  SwiftDataProjectApp
//
//  Created by Shivansh omer on 27/04/25.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
