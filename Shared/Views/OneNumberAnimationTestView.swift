import SwiftUI

struct OneNumberAnimationTestView: View {
    
    @State private var debugData = OneRollingNumberView.Debug(
        isClipped: true,
        showBorder: false,
        from: 0,
        to: 9,
        isIncreasing: true,
        rounds: 0,
        duration: 1.0,
        animationToggle: false
    )
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Тестирование анимации отдельного числа")
                .font(.title)
                .padding()
            
            HStack {
                Text("👉")
                OneRollingNumberView(target: .init(id: 0, previous: 0, main: 0), debug: debugData)
                Text("👈")
            }
            
            Spacer()
            
            Rectangle()
                .foregroundColor(Color(.sRGB, red: 0.95, green: 0.95, blue: 0.97, opacity: 1.0))
                .frame(height: 32)
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 64, height: 4)
                        .foregroundColor(.black)
                )
            
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
            .frame(height: 400)
        }
    }
    
    private var startText: Binding<String> {
        .init(get: { "\(debugData.from)" }, set: { debugData.from = Int($0) ?? 0 })
    }
    
    private var endText: Binding<String> {
        .init(get: { "\(debugData.to)" }, set: { debugData.to = Int($0) ?? 0 })
    }
    
    private var roundsText: Binding<String> {
        .init(get: { "\(debugData.rounds)" }, set: { debugData.rounds = Int($0) ?? 0 })
    }
    
    private var durationText: Binding<String> {
        .init(get: { "\(Int(debugData.duration))" }, set: { debugData.duration = Double($0) ?? 0.0 })
    }
}


// MARK: - Preview

#if DEBUG
import SwiftUI

struct OneNumberAnimationTestView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        OneNumberAnimationTestView()
    }
}
#endif
