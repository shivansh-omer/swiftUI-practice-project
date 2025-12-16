//
//  HabitStore.swift
//  HabitTrackingApp
//
//  Created by Shivansh omer on 18/04/25.
//

import Foundation
import Observation

@Observable
class HabitStore {
    var habits: [Habit] = [] {
        didSet {
            save()
        }
    }
    
    let saveKey = "SavedHabits"
    
    init() {
        load()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
                habits = decoded
            }
        }
    }
}
