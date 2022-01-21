import SwiftUI

struct TargetNumber: Hashable {
    // уникальный идентификатор, а также порядковый номер цифры в числе справа (начиная с нуля)
    // например, для числа 2738
    //   id: 3 2 1 0
    //    n: 2 7 3 8
    let id: Int
    
    // "кол-во десятков"
    // например, для числа 2738 previous = 273
    let previous: Int
    
    // основное число (последнее)
    // например, для числа 2738 main = 8
    let main: Int
    
    var lapTime: Double { pow(10, id).doubleValue }
}

struct OneRollingNumberView: View {
    
    let target: TargetNumber

    
    @State private var selectedNumber: Int = 0
    private let oneNumberHeight: CGFloat = 20
    
    // Animation timings
    /*
     pow(10, target.id)
     target.id == 0 -> 1.0s (10^0)
     target.id == 1 -> 10.0s (10^1)
     target.id == 2 -> 100.0s (10^2)
     */
    private var oneLapTime: Double { target.lapTime }
    private var oneNumberMoveTime: Double { oneLapTime / 10 }
    
    var body: some View {
        ZStack {
            ForEach(0...10, id: \.self) { i in
                Text("\(i % 10)")
                    .offset(x: 0, y: CGFloat(i) * oneNumberHeight + totalOffset)
            }
        }
        .clipped()
//        .border(Color.red)
        .onChange(of: target) { new in
            smartAnimate(from: target, to: new)
        }
    }
    
    var totalOffset: CGFloat {
        CGFloat(selectedNumber) * oneNumberHeight * -1
    }

    func smartAnimate(from oldTarget: TargetNumber, to newTarget: TargetNumber) {
        
        let previousDiff = newTarget.previous - oldTarget.previous
        
        if previousDiff == 0 {
            // десятки не изменились, простая анимация к новому числу
            let t = abs(oldTarget.main - newTarget.main).double * oneNumberMoveTime
            animate(from: oldTarget.main, to: newTarget.main, duration: t)
        } else if previousDiff < 0 {
            // предыдущее число изменилось (нужно сделать несколько переходов через 0 в обратную сторону)
            // уменьшаем до нуля
            let t1 = oldTarget.main.double * oneNumberMoveTime
            animate(from: oldTarget.main, to: 0, duration: t1)
        
            let fullCircleRepeats = 1 + previousDiff
            let t2 = max(0, fullCircleRepeats).double * oneLapTime
            if fullCircleRepeats < 0 {
                // сколько раз повторить полный круг анимаций 9 -> 0
                animate(from: 10, to: 0, repeatCount: fullCircleRepeats, duration: oneLapTime, delay: t1)
            }
            
            // последний шаг возвращаемся от 0 справа (10) в нужное число
            let t3 = (10 - newTarget.main).double * oneNumberMoveTime
            animate(from: 10, to: newTarget.main, duration: t3, delay: t1 + t2)
        } else if previousDiff > 0 {
            // предыдущее число изменилось (нужно сделать несколько переходов через 0 в прямую сторону)
            // увеличиваем до нуля
            let t1 = (10 - oldTarget.main).double * oneNumberMoveTime
            animate(from: oldTarget.main, to: 10, duration: t1)
            
            // сколько раз повторить полный круг анимаций 0 -> 9
            let fullCircleRepeats = previousDiff - 1
            let t2 = max(0, fullCircleRepeats).double * oneLapTime
            if fullCircleRepeats > 0 {
                animate(from: 0, to: 10, repeatCount: fullCircleRepeats, duration: oneLapTime, delay: t1)
            }
            
            // последний шаг возвращаемся от 0 слева в нужное число
            let t3 = newTarget.main.double * oneNumberMoveTime
            animate(from: 0, to: newTarget.main, duration: t3, delay: t1 + t2)
            print(t1, t2, t3)
        }
    }
    
    func animate(from: Int, to: Int, repeatCount: Int = 1, duration: Double, delay: Double = 0) {
        withAnimation(
            Animation
                .linear(duration: 0.001)
                .delay(delay)
        ) {
            selectedNumber = from
        }
        withAnimation(
            Animation
                .linear(duration: duration - 0.001)
                .repeatCount(repeatCount, autoreverses: false)
                .delay(delay + 0.001)
        ) {
            print("🦉 Animate \(from)->\(to) \(duration)sec x\(repeatCount) after \(delay)sec")
            selectedNumber = to
        }
    }
}

struct DEBUG_OneRollingNumberView: View {
    
    let target: TargetNumber
    
    var body: some View {
        VStack {
            Text("\(Int(target.lapTime))").font(.footnote).foregroundColor(.gray)
            OneRollingNumberView(target: target)
        }
    }
}

struct RollingNumbersTestScreen: View {
    
    @State var text = ""
    @State var selectedNumber = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(splitToTargets(num: selectedNumber), id: \.id) { target in
                    DEBUG_OneRollingNumberView(target: target)
                }
            }
            .padding()
            
            HStack {
                TextField("Число", text: $text, prompt: nil)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Animate") {
                    selectedNumber = Int(text) ?? 7
                }
            }
        }.padding()
    }
    
    func splitToTargets(num: Int) -> [TargetNumber] {
        var i = num
        var targets = [TargetNumber]()
        var step = 0
        
        while i > 0 {
            targets.append(.init(id: step, previous: i / 10, main: i % 10))
            i = i / 10
            step += 1
        }
        return targets.reversed()
    }
}

struct RollingNumbersLabel_Previews: PreviewProvider {
    static var previews: some View {
        RollingNumbersTestScreen()
            .previewDevice(.init(stringLiteral: "iPhone 13"))
    }
}

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

extension Int {
    var double: Double {
        Double(self)
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
