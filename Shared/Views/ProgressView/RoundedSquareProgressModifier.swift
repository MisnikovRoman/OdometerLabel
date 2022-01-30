import SwiftUI

/// Модификатор View добавляющий квадратный ProgressView с закругленными краями
/// Бекграунд не учитывается при расчете размеров вью
/// После применения данного модификатора стоит задать frame
public struct RoundedSquareProgressModifier: ViewModifier {
    
    private let total: CGFloat
    private let value: CGFloat
    private let animation: Animation
    
    public init(total: CGFloat, value: CGFloat, animation: Animation = .linear) {
        self.total = total
        self.value = value
        self.animation = animation
    }
    
    public func body(content: Content) -> some SwiftUI.View {
        content
            .background(
                ProgressView(value: value, total: total)
                    .progressViewStyle(RoundedSquareProgressViewStyle(
                        customAnimation: animation
                    ))
            )
    }
}

// MARK: - Preview

struct RoundedProgressModifierModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("🎄")
            .font(.title3)
            .frame(width: 48, height: 48)
            .modifier(RoundedSquareProgressModifier(total: 1.0, value: 0.37))
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
