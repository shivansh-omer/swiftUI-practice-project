//
//  ContentView.swift
//  UnitConversion
//
//  Created by Shivansh omer on 21/03/25.
//

import SwiftUI

struct ContentView: View {
    let lengthUnits = ["Meters", "Kilometers", "Feet", "Yards", "Miles"]
    let conversionRates: [String: Double] = [
        "Meters": 1.0,
        "Kilometers": 1000.0,
        "Feet": 0.3048,
        "Yards": 0.9144,
        "Miles": 1609.34
    ]
    
    @State private var inputUnit = "Meters"
    @State private var outputUnit = "Feet"
    @State private var inputValue = 0.0
    
    var convertedValue: Double {
        let baseValue = inputValue * (conversionRates[inputUnit] ?? 1.0)
        let outputValue = baseValue / (conversionRates[outputUnit] ?? 1.0)
        return outputValue
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Value")) {
                    TextField("Amount", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Select Input Unit")) {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(lengthUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Select Output Unit")) {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(lengthUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Converted Value")) {
                    Text(convertedValue.formatted())
                        .font(.largeTitle)
                }
            }
            .navigationTitle("Unit Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
