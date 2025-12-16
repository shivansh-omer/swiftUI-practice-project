//
//  BookwormAppApp.swift
//  BookwormApp
//
//  Created by Shivansh omer on 22/04/25.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Student.self)
    }
}
