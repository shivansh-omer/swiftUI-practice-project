//
//  AddHabitView.swift
//  HabitTrackingApp
//
//  Created by Shivansh omer on 18/04/25.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: HabitStore
    
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationTitle("New Habit")
            .toolbar {
                Button("Save") {
                    let newHabit = Habit(title: title, description: description)
                    store.habits.append(newHabit)
                    dismiss()
                }
            }
        }
    }
}


#Preview {
    let store = HabitStore()
    return AddHabitView(store: store)
}
