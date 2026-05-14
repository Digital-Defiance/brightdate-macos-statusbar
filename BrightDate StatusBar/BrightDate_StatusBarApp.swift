import SwiftUI
import Combine

@main
struct BrightDate_StatusBarApp: App {
    @AppStorage("refreshRate") private var refreshRate: Double = 1.0
    @AppStorage("floatDigits") private var floatDigits: Int = 5
    
    @State private var currentBD: String = ""
    
    // The computed property handles the timer creation
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: refreshRate, on: .main, in: .common).autoconnect()
    }

    var body: some Scene {
        MenuBarExtra {
            Text("J2000.0 Era Scalar")
            
            Button("Copy to Clipboard") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(currentBD, forType: .string)
            }

            Divider()

            // This opens the Settings window defined below
            SettingsLink {
                Text("Settings...")
            }

            Divider()
            
            Button("Quit BrightDate") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
                Text(currentBD)
                    .font(.system(.body, design: .monospaced))
                    // This reacts to the timer
                    .onReceive(timer) { _ in
                        updateDisplay()
                    }
                    // This ensures it updates the moment you move the slider
                    // or change digits in the Settings window
                    .onChange(of: refreshRate) { _ in updateDisplay() }
                    .onChange(of: floatDigits) { _ in updateDisplay() }
                    .onAppear { updateDisplay() }
            }

            Settings {
                SettingsView()
            }
        }
        
        // Helper function to keep code DRY
        private func updateDisplay() {
            currentBD = BrightDateEngine.formatted(precision: floatDigits)
        }
    }
