//
//  SettingsView.swift
//  BrightDate StatusBar
//
//  Created by Jessica Mulein on 5/13/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("refreshRate") private var refreshRate: Double = 1.0
    @AppStorage("floatDigits") private var floatDigits: Int = 5

    var body: some View {
        Form {
            Section(header: Text("Display Precision")) {
                Stepper("Decimal Places: \(floatDigits)", value: $floatDigits, in: 1...9)
                Text("Current resolution: \(1.0 / pow(10, Double(floatDigits)), specifier: "%.9f") days")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Update Frequency")) {
                VStack(alignment: .leading, spacing: 8) {
                    Slider(value: $refreshRate, in: 0.1...60.0, step: 0.1) {
                        Text("Refresh Rate")
                    }
                    
                    // This HStack ensures the label has a stable "home"
                    // while the slider takes up the rest of the space.
                    HStack {
                        Text("Refresh every")
                        
                        // The magic happens here: monospaced digits + fixed width
                        Text("\(refreshRate, specifier: "%.1f")s")
                            .font(.system(.body, design: .monospaced))
                            .frame(width: 50, alignment: .leading)
                        
                        Spacer()
                    }
                    .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("High Performance")
                    Spacer()
                    Text("Battery Saver")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(width: 350)
    }
}
