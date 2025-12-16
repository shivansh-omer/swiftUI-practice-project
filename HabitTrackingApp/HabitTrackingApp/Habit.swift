//
//  Habit.swift
//  HabitTrackingApp
//
//  Created by Shivansh omer on 18/04/25.
//

import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var count: Int
    
    init(id: UUID = UUID(), title: String, description: String, count: Int = 0) {
        self.id = id
        self.title = title
        self.description = description
        self.count = count
    }
}
