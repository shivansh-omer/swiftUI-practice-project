//
//  ContentView.swift
//  HabitTrackingApp
//
//  Created by Shivansh omer on 18/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showAddHabit = false
    @State private var store = HabitStore()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.habits) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit, store: store)) {
                        VStack(alignment: .leading) {
                            Text(habit.title)
                                .font(.headline)
                            Text("Completed: \(habit.count) times")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("My Habits")
            .toolbar {
                Button {
                    showAddHabit = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView(store: store)
            }
        }
    }
}



#Preview {
    ContentView()
}
