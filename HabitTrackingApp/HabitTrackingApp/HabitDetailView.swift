//
//  HabitDetailView.swift
//  HabitTrackingApp
//
//  Created by Shivansh omer on 18/04/25.
//

import SwiftUI

struct HabitDetailView: View {
    var habit: Habit
    @Bindable var store: HabitStore
    
    var body: some View {
        VStack(spacing: 20) {
            Text(habit.description)
                .font(.body)
            
            Text("Completed: \(habit.count) times")
                .font(.title2)
            
            Button("Add 1") {
                if let index = store.habits.firstIndex(of: habit) {
                    var updatedHabit = habit
                    updatedHabit.count += 1
                    store.habits[index] = updatedHabit
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .navigationTitle(habit.title)
    }
}


#Preview {
    let sampleHabit = Habit(title: "Read a book", description: "Read at least 10 pages daily", count: 3)
    let sampleStore = HabitStore()
    sampleStore.habits = [sampleHabit]
    
    return HabitDetailView(habit: sampleHabit, store: sampleStore)
}
