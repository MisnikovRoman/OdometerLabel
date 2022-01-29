import SwiftUI

// MARK: - Debugging

struct DEBUG_OneRollingNumberView: View {
    
    let target: TargetNumber
    
    var body: some View {
        VStack {
            // Text("\(Int(target.lapTime))").font(.footnote).foregroundColor(.gray)
            OneRollingNumberView(target: target)
        }
    }
}


struct RollingNumbersTestScreen: View {
    
    @State var text = ""
    @State var selectedNumber = 0
    
    var body: some View {
        VStack(alignment: .leading) {

            HStack(spacing: 0) {
                ForEach(selectedNumber.splitToTargets(), id: \.id) { target in
                    DEBUG_OneRollingNumberView(target: target)
                        .transition(.move(edge: .bottom))
                }
            }
            .padding()
            
            HStack {
                TextField("Число", text: $text, prompt: nil)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Animate") {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        selectedNumber = Int(text) ?? 7
                    }
                }
            }
        }.padding()
    }
}

// MARK: - Preview

struct RollingNumbersLabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RollingNumbersTestScreen()
            OneNumberAnimationTestView()
        }
        .previewDevice(.init(stringLiteral: "iPhone 13"))
    }
}
