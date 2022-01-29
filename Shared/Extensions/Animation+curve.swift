import SwiftUI

extension Animation {
    enum Curve {
        case linear, easeIn, easeOut, easeInOut
    }
    
    func animate(_ block: () -> Void) {
        withAnimation(self) { block() }
    }
    
    static func curve(_ curve: Curve, duration: Double = 0.3) -> Animation {
        switch curve {
        case .linear:
            return .linear(duration: duration)
        case .easeIn:
            return .easeIn(duration: duration)
        case .easeOut:
            return .easeOut(duration: duration)
        case .easeInOut:
            return .easeInOut(duration: duration)
        }
    }
}

