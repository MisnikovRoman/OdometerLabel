import SwiftUI

extension Color {
    static var random: Color {
        .init(
            .sRGB,
            red: Double.random(in: 0.3...0.9),
            green: Double.random(in: 0.3...0.9),
            blue: Double.random(in: 0.3...0.9),
            opacity: 1.0
        )
    }
}

