//
//  NameSnapApp.swift
//  NameSnap
//
//  Created by Shivansh omer on 18/05/25.
//
 
import SwiftUI

@main
struct PhotoNamerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: NamedPhoto.self)
    }
}
