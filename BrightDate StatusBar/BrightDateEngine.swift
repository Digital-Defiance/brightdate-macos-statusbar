import Foundation

struct BrightDateEngine {
    static let taiOffset: Double = 37.0
    static let j2000EpochOffset: Double = 946727967.816
    
    static func current() -> Double {
        let now = Date().timeIntervalSince1970
        return (now + taiOffset - j2000EpochOffset) / 86400.0
    }

    // New helper to handle the dynamic precision
    static func formatted(precision: Int) -> String {
        return String(format: "%.\(precision)f", current())
    }
}
