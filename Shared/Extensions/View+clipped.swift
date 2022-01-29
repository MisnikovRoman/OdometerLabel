import SwiftUI

struct ClippedModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        if isActive {
            content.clipped()
        } else {
            content
        }
    }
}

extension View {
    func clipped(isActive: Bool) -> some View {
        self.modifier(ClippedModifier(isActive: isActive))
    }
}
