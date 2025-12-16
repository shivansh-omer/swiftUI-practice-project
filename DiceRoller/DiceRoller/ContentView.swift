//
//  ContentView.swift
//  DiceRoller
//
//  Created by Shivansh omer on 05/06/25.
//

import SwiftUI

// MARK: - Data Models
struct DiceRoll: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let diceType: Int
    let numberOfDice: Int
    let results: [Int]
    let total: Int
    
    init(timestamp: Date, diceType: Int, numberOfDice: Int, results: [Int], total: Int) {
        self.id = UUID()
        self.timestamp = timestamp
        self.diceType = diceType
        self.numberOfDice = numberOfDice
        self.results = results
        self.total = total
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

struct DiceConfiguration {
    var numberOfDice: Int = 2
    var diceType: Int = 6
    
    var availableDiceTypes: [Int] {
        [4, 6, 8, 10, 12, 20, 100]
    }
}

// MARK: - Main App View
struct ContentView: View {
    @State private var diceConfig = DiceConfiguration()
    @State private var currentRoll: [Int] = []
    @State private var isRolling = false
    @State private var rollHistory: [DiceRoll] = []
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DiceRollerView(
                diceConfig: $diceConfig,
                currentRoll: $currentRoll,
                isRolling: $isRolling,
                rollHistory: $rollHistory
            )
            .tabItem {
                Image(systemName: "dice")
                Text("Roll Dice")
            }
            .tag(0)
            
            HistoryView(rollHistory: rollHistory)
            .tabItem {
                Image(systemName: "clock.arrow.circlepath")
                Text("History")
            }
            .tag(1)
        }
        .onAppear {
            loadRollHistory()
        }
    }
    
    private func loadRollHistory() {
        if let data = UserDefaults.standard.data(forKey: "rollHistory"),
           let history = try? JSONDecoder().decode([DiceRoll].self, from: data) {
            rollHistory = history
        }
    }
}

// MARK: - Dice Roller View
struct DiceRollerView: View {
    @Binding var diceConfig: DiceConfiguration
    @Binding var currentRoll: [Int]
    @Binding var isRolling: Bool
    @Binding var rollHistory: [DiceRoll]
    
    @State private var rollTimer: Timer?
    @State private var rollCount = 0
    private let maxRollAnimations = 10
    
    var currentTotal: Int {
        currentRoll.reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Configuration Section
                VStack(spacing: 20) {
                    Text("Dice Configuration")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                    
                    HStack {
                        Text("Number of Dice:")
                        Spacer()
                        Stepper(value: $diceConfig.numberOfDice, in: 1...10) {
                            Text("\(diceConfig.numberOfDice)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .accessibilityLabel("Number of dice: \(diceConfig.numberOfDice)")
                    }
                    
                    HStack {
                        Text("Dice Type:")
                        Spacer()
                        Picker("Dice Type", selection: $diceConfig.diceType) {
                            ForEach(diceConfig.availableDiceTypes, id: \.self) { sides in
                                Text("d\(sides)")
                                    .tag(sides)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accessibilityLabel("Dice type: \(diceConfig.diceType) sided")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Dice Display Section
                VStack(spacing: 20) {
                    Text("Current Roll")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                    
                    if !currentRoll.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: min(5, diceConfig.numberOfDice)), spacing: 15) {
                            ForEach(Array(currentRoll.enumerated()), id: \.offset) { index, value in
                                DiceView(value: value, isRolling: isRolling, diceType: diceConfig.diceType)
                                    .accessibilityLabel("Die \(index + 1): \(value)")
                            }
                        }
                        
                        if diceConfig.numberOfDice > 1 {
                            Text("Total: \(currentTotal)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .accessibilityLabel("Total rolled: \(currentTotal)")
                        }
                    } else {
                        Text("Tap 'Roll Dice' to get started!")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .frame(minHeight: 200)
                
                Spacer()
                
                // Roll Button
                Button(action: rollDice) {
                    HStack {
                        Image(systemName: isRolling ? "arrow.clockwise" : "dice")
                            .rotationEffect(.degrees(isRolling ? 360 : 0))
                            .animation(isRolling ? .linear(duration: 0.5).repeatForever(autoreverses: false) : .default, value: isRolling)
                        
                        Text(isRolling ? "Rolling..." : "Roll Dice")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRolling ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isRolling)
                .accessibilityHint("Double tap to roll the dice")
            }
            .padding()
            .navigationTitle("Dice Roller")
        }
        .onChange(of: diceConfig.numberOfDice) {
            if !currentRoll.isEmpty && !isRolling {
                currentRoll = Array(repeating: 1, count: diceConfig.numberOfDice)
            }
        }
    }
    
    private func rollDice() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        isRolling = true
        rollCount = 0
        currentRoll = Array(repeating: 1, count: diceConfig.numberOfDice)
        
        // Start animation timer
        rollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            rollCount += 1
            
            // Generate random values during animation
            currentRoll = (0..<diceConfig.numberOfDice).map { _ in
                Int.random(in: 1...diceConfig.diceType)
            }
            
            if rollCount >= maxRollAnimations {
                timer.invalidate()
                rollTimer = nil
                finishRoll()
            }
        }
    }
    
    private func finishRoll() {
        // Final roll values
        let finalRoll = (0..<diceConfig.numberOfDice).map { _ in
            Int.random(in: 1...diceConfig.diceType)
        }
        
        currentRoll = finalRoll
        isRolling = false
        
        // Add haptic feedback for completion
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        // Save to history
        let diceRoll = DiceRoll(
            timestamp: Date(),
            diceType: diceConfig.diceType,
            numberOfDice: diceConfig.numberOfDice,
            results: finalRoll,
            total: finalRoll.reduce(0, +)
        )
        
        rollHistory.insert(diceRoll, at: 0)
        saveRollHistory()
        
        // Announce result for VoiceOver
        let announcement = diceConfig.numberOfDice == 1 ?
            "Rolled \(finalRoll.first!)" :
            "Rolled \(finalRoll.map(String.init).joined(separator: ", ")), total \(currentTotal)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIAccessibility.post(notification: .announcement, argument: announcement)
        }
    }
    
    private func saveRollHistory() {
        // Keep only last 100 rolls
        if rollHistory.count > 100 {
            rollHistory = Array(rollHistory.prefix(100))
        }
        
        if let data = try? JSONEncoder().encode(rollHistory) {
            UserDefaults.standard.set(data, forKey: "rollHistory")
        }
    }
}

// MARK: - Individual Dice View
struct DiceView: View {
    let value: Int
    let isRolling: Bool
    let diceType: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isRolling ? Color.orange : Color.blue)
                .frame(width: 60, height: 60)
                .scaleEffect(isRolling ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isRolling)
            
            Text("\(value)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .shadow(radius: isRolling ? 8 : 4)
    }
}

// MARK: - History View
struct HistoryView: View {
    let rollHistory: [DiceRoll]
    
    var body: some View {
        NavigationView {
            Group {
                if rollHistory.isEmpty {
                    VStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No rolls yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("Roll some dice to see your history here!")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(rollHistory) { roll in
                            RollHistoryRow(roll: roll)
                        }
                    }
                    .accessibilityLabel("Roll history list")
                }
            }
            .navigationTitle("Roll History")
        }
    }
}

// MARK: - History Row View
struct RollHistoryRow: View {
    let roll: DiceRoll
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(roll.numberOfDice)d\(roll.diceType)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("Total: \(roll.total)")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Results: \(roll.results.map(String.init).joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(roll.formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Roll: \(roll.numberOfDice) d\(roll.diceType) dice, results \(roll.results.map(String.init).joined(separator: ", ")), total \(roll.total), rolled on \(roll.formattedDate)")
    }
}

#Preview {
    ContentView()
}
