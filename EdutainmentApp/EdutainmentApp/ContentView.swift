//
//  ContentView.swift
//  EdutainmentApp
//
//  Created by Shivansh omer on 04/04/25.
//

import SwiftUI

struct Question {
    let text: String
    let answer: Int
}

struct ContentView: View {
    @State private var gameStarted = false
    @State private var selectedTable = 2
    @State private var questionCount = 5
    
    @State private var questions = [Question]()
    @State private var currentQuestion = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var gameOver = false
    
    var body: some View {
        if gameStarted {
            if gameOver {
                VStack {
                    Text("Game Over!")
                        .font(.largeTitle)
                    Text("You scored \(score) out of \(questionCount)")
                    Button("Play Again") {
                        resetGame()
                    }
                    .padding()
                }
            } else {
                VStack(spacing: 20) {
                    Text("Question \(currentQuestion + 1)")
                    Text(questions[currentQuestion].text)
                        .font(.title)
                    
                    TextField("Your Answer", text: $userAnswer)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Button("Submit") {
                        checkAnswer()
                    }
                }
                .padding()
            }
        } else {
            VStack {
                Stepper("Up to table: \(selectedTable)", value: $selectedTable, in: 2...12)
                
                Picker("Number of Questions", selection: $questionCount) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("20").tag(20)
                }
                .pickerStyle(.segmented)
                .padding()
                
                Button("Start Game") {
                    startGame()
                }
            }
            .padding()
        }
    }
    
    func startGame() {
        questions = []
        for _ in 1...questionCount {
            let num1 = Int.random(in: 1...selectedTable)
            let num2 = Int.random(in: 1...12)
            let text = "\(num1) × \(num2) = ?"
            let answer = num1 * num2
            questions.append(Question(text: text, answer: answer))
        }
        currentQuestion = 0
        score = 0
        userAnswer = ""
        gameStarted = true
        gameOver = false
    }
    
    func checkAnswer() {
        let correct = questions[currentQuestion].answer
        if Int(userAnswer) == correct {
            score += 1
        }
        userAnswer = ""
        currentQuestion += 1
        if currentQuestion >= questionCount {
            gameOver = true
        }
    }
    
    func resetGame() {
        gameStarted = false
    }
}

#Preview {
    ContentView()
}
