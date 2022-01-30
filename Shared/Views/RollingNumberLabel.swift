import SwiftUI

struct RollingNumberLabel: View {
    
    struct Settings {
        var rounds: Int
        var interNumberDelay: Double
        var numberAnimationDuration: Double
        
        static var basic: Self {
            .init(rounds: 1, interNumberDelay: 0.3, numberAnimationDuration: 1.5)
        }
    }
    
    let number: Int
    let settings: Settings
    
    init(_ number: Int, settings: Settings = .basic) {
        self.number = number
        self.settings = settings
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(number.splitToTargets(), id: \.id) { target in
                OneRollingNumberView(target: target, settings: settings)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

struct RollingNumberLabelTestScreen: View {
    @State private var number = 0
    @State private var total = 50000
    @State private var enteredAmount = 0
    
    @State private var settings = RollingNumberLabel.Settings(
        rounds: 1,
        interNumberDelay: 0.3,
        numberAnimationDuration: 1.5
    )
    
    var body: some View {
        Form {
            Section("Анимируемая ячейка") {
                HStack(alignment: .center, spacing: 16) {
                    Text("🚀")
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 6).scale(0.9).foregroundColor(.gray.opacity(0.4)))
                        .modifier(RoundedSquareProgressModifier(
                            total: 1.0,
                            value: number.double / total.double,
                            animation: .easeInOut(duration: settings.numberAnimationDuration)
                        ))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Робот-пылесос")
                            .font(.callout)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            RollingNumberLabel(number, settings: settings)
                            Text("из \(total) ₽")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section("Настройки ячейки") {
                LabeledTextNumberFieldView(title: "amount", number: $enteredAmount, step: 1000)
                LabeledTextNumberFieldView(title: "total", number: $total, step: 1000)
                Button("Применить значения") { number = enteredAmount }
            }
            
            
            Section {
                LabeledTextNumberFieldView(title: "rounds", number: $settings.rounds, step: 1)
            } header: {
                Text("Настройки анимации")
            } footer: {
                Text("Количество полный оборотов, которое происходит при анимации одной цифры")
            }
            
            Section {
                LabeledTextNumberFieldView(title: "delay", number: $settings.interNumberDelay, step: 0.1)
            } footer: {
                Text("Задержка анимации между цифрами")
            }
            
            Section {
                LabeledTextNumberFieldView(title: "duration", number: $settings.numberAnimationDuration, step: 0.1)
            } footer: {
                Text("Длительность анимации каждой цифры")
            }

            Section {
                Button("Сброс настроек анимации", role: .destructive) {
                    settings = .basic
                }
            }
        }
    }
}

struct RollingNumberLabel_Previews: PreviewProvider {
    static var previews: some View {
        RollingNumberLabelTestScreen()
    }
}
    
    // MARK: - Helpers

struct LabeledTextNumberFieldView<T: StringConvertible>: View {
    let title: String
    @Binding var number: T
    let step: T
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField(
                "value",
                text: .init(get: { number.toString() }, set: { number = .init($0) })
            ).multilineTextAlignment(.trailing)
            Stepper("", onIncrement: { number += step }, onDecrement: { number -= step })
                .scaleEffect(0.6)
                .frame(width: 50, height: 30)
        }
    }
}

protocol StringConvertible {
    init(_ text: String)
    func toString() -> String
    static func += (lhs: inout Self, rhs: Self)
    static func -= (lhs: inout Self, rhs: Self)
}

extension Int: StringConvertible {
    init(_ text: String) { self = .init(text) ?? 0 }
    func toString() -> String { "\(self)" }
}

extension Double: StringConvertible {
    init(_ text: String) { self = .init(text) ?? 0 }
    func toString() -> String { String(format: "%.2f", self) }
}
