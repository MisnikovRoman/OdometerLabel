import SwiftUI

class MultipleRollingNumbersViewModel: ObservableObject {
    @Published var basicSettings = OneRollingNumberView.Debug(isClipped: true, showBorder: false, from: 0, to: 1, isIncreasing: true, rounds: 1, duration: 1.0, animationToggle: false)
    @Published var initialNumber = 0
    @Published var finalNumber = 1
    
    var debugs: [OneRollingNumberView.Debug] {
        finalNumber.
    }
}

struct MultipleRollingNumbersView: View {
    
    var body: some View {
        VStack {
            HStack {
                OneRollingNumberView(target: .zero, debug: debug1)
                OneRollingNumberView(target: .zero, debug: debug2)
            }
            Form {
                Section("Settings") {
                    Toggle("⛔️ clipped", isOn: $debugData.isClipped)
                    Toggle("🖼 border", isOn: $debugData.showBorder)
                }
                Section("direction") {
                    Toggle("⬆️ increasing", isOn: $debugData.isIncreasing)
                }
                Section("values") {
                    HStack(spacing: 16) {
                        Stepper("🚀 start", onIncrement: { debugData.from += 1 }, onDecrement: { debugData.from -= 1 })
                        Text("\(debugData.from)")
                            .frame(width: 32)
                    }
                    HStack(spacing: 16) {
                        Stepper("🏁 end", onIncrement: { debugData.to += 1 }, onDecrement: { debugData.to -= 1 })
                        Text("\(debugData.to)")
                            .frame(width: 32)
                    }
                    HStack(spacing: 16) {
                        Stepper("🔁 rounds", onIncrement: { debugData.rounds += 1 }, onDecrement: { debugData.rounds -= 1 })
                        Text("\(debugData.rounds)")
                            .frame(width: 32)
                    }
                    HStack(spacing: 16) {
                        Stepper("⏲ duration", onIncrement: { debugData.duration += 0.2 }, onDecrement: { debugData.duration -= 0.2 })
                        Text("\(debugData.duration, specifier: "%.1f")")
                            .frame(width: 32)
                    }
                }
                Button("animate") { debugData.animationToggle.toggle() }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct MultipleRollingNumbersView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        MultipleRollingNumbersView()
    }
}
#endif
