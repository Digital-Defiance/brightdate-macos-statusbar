//
//  SettingsView.swift
//  BrightDate StatusBar
//
//  Created by Jessica Mulein on 5/13/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("refreshRate") private var refreshRate: Double = 1.0
    // Helper for non-linear slider
    private let sliderMin: Double = 0.1
    private let sliderMax: Double = 60.0
    private let sliderSteps: [Double] = {
        // 0.1s steps from 0.1 to 1.0
        let a = stride(from: 0.1, through: 1.0, by: 0.1)
        // 1s steps from 2 to 10
        let b = stride(from: 2.0, through: 10.0, by: 1.0)
        // 10s steps from 20 to 60
        let c = stride(from: 20.0, through: 60.0, by: 10.0)
        // 1s steps from 1 to 10 (excluding 1, already in a)
        let b2 = stride(from: 1.0, through: 10.0, by: 1.0).dropFirst()
        // 10s steps from 10 to 60 (excluding 10, already in b2)
        let c2 = stride(from: 10.0, through: 60.0, by: 10.0).dropFirst()
        return Array(a) + Array(b2) + Array(c2)
    }()

    private var sliderIndex: Binding<Double> {
        Binding<Double>(
            get: {
                // Find the closest index for the current refreshRate
                let idx = sliderSteps.enumerated().min(by: { abs($0.1 - refreshRate) < abs($1.1 - refreshRate) })?.0 ?? 0
                return Double(idx)
            },
            set: { newValue in
                let idx = Int(round(newValue))
                if sliderSteps.indices.contains(idx) {
                    refreshRate = sliderSteps[idx]
                }
            }
        )
    }
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
                    Slider(value: sliderIndex, in: 0...Double(sliderSteps.count - 1), step: 1) {
                        Text("Refresh Rate")
                    }
                    // This HStack ensures the label has a stable "home"
                    // while the slider takes up the rest of the space.
                    HStack {
                        Text("Refresh every")
                        Text("\(refreshRate, specifier: refreshRate < 1 ? "%.1f" : "%.0f")s")
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
