import SwiftUI

/// Кастомный стиль для квадратного ProgressView с закругленными краями
public struct RoundedSquareProgressViewStyle: ProgressViewStyle {
    
    private let cornerRadius: CGFloat = 6
    private let lineWidth: CGFloat = 2
    private let animation: Animation
    
    init(customAnimation: Animation = .linear) {
        self.animation = customAnimation
    }
    
    public func makeBody(configuration: Configuration) -> some SwiftUI.View {
        Rectangle()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(.gray.opacity(0.4))
            .mask(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.black, style: StrokeStyle(lineWidth: lineWidth))
                    .foregroundColor(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .trim(from: 0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .stroke(.green, style: StrokeStyle(lineWidth: lineWidth * 2))
                    .animation(animation, value: configuration.fractionCompleted)
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(.green)
            )
            .mask(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.black, style: StrokeStyle(lineWidth: lineWidth))
                    .foregroundColor(Color.clear)
            )
    }
}

public extension ProgressViewStyle where Self == RoundedSquareProgressViewStyle {
    /// Квадратный прогрессбар с закругленными углами
    static var roundedSquare: RoundedSquareProgressViewStyle { RoundedSquareProgressViewStyle() }
}
