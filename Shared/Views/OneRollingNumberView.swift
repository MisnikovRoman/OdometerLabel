import SwiftUI

struct OneRollingNumberView: View {

    struct Debug {
        var isClipped: Bool
        var showBorder: Bool
        var from: Int
        var to: Int
        var isIncreasing: Bool
        var rounds: Int
        var duration: Double
        var animationToggle: Bool
    }
    
    let target: TargetNumber
    let debug: Debug
    
    init(target: TargetNumber, debug: Debug? = nil) {
        self.target = target
        self.debug = debug ?? .init(isClipped: true, showBorder: false, from: 0, to: 0, isIncreasing: true, rounds: 0, duration: 1.0, animationToggle: false)
    }
    
    @State private var selectedNumber: Int = 0
    private let oneNumberHeight: CGFloat = 20

    var body: some View {
        ZStack {
            ForEach(0...10, id: \.self) { i in
                Text("\(i % 10)")
                    .offset(x: 0, y: CGFloat(i) * oneNumberHeight + totalOffset)
            }
        }
        .clipped(isActive: debug.isClipped)
        .border(Color.red.opacity(debug.showBorder ? 0.2 : 0.0))
        .onChange(of: target) { new in
             smartAnimate(from: target, to: new)
        }
        .onAppear {
             smartAnimate(from: .init(id: target.id, previous: 0, main: 0), to: target)
        }
        .onDisappear {
             smartAnimate(from: target, to: .init(id: target.id, previous: 0, main: 0))
        }
        .onChange(of: debug.animationToggle) { new in
            animate(from: debug.from, to: debug.to, isIncreasing: debug.isIncreasing, fullRoundsCount: debug.rounds, duration: debug.duration, delay: 0)
        }
    }
    
    var totalOffset: CGFloat {
        CGFloat(selectedNumber) * oneNumberHeight * -1
    }
    
    // MARK: - Animation

    /// change 25 -> 369 344
    /// 0 9 -> 34 3 оборота  0.3
    /// 1 6 -> 3  0.6
    /// 2 3 -> 0  1.0
    func smartAnimate(from oldTarget: TargetNumber, to newTarget: TargetNumber) {
        
        let totalSteps = oldTarget.steps(to: newTarget)
        let totalAnimationTime = 1.0
        let stepDuration = totalAnimationTime / totalSteps.double
        
        let previousDiff = newTarget.previous - oldTarget.previous
        
        if previousDiff == 0 {
            // десятки не изменились, простая анимация к новому числу
            animate(from: oldTarget.main, to: newTarget.main, duration: totalAnimationTime)
        } else if previousDiff < 0 {
//            // предыдущее число изменилось (нужно сделать несколько переходов через 0 в обратную сторону)
//            // уменьшаем до нуля
//            let t1 = oldTarget.main.double * stepDuration
//            animate(from: oldTarget.main, to: 0, duration: t1)
//
//            let fullCircleRepeats = 1 + previousDiff
//            let oneLapTime = stepDuration * 10.0
//            let t2 = fullCircleRepeats.double * oneLapTime
//            if fullCircleRepeats < 0 {
//                // сколько раз повторить полный круг анимаций 9 -> 0
//                animate(from: 10, to: 0, repeatCount: fullCircleRepeats, duration: oneLapTime, delay: t1)
//            }
//
//            // последний шаг возвращаемся от 0 справа (10) в нужное число
//            let t3 = (10 - newTarget.main).double * stepDuration
//            animate(from: 10, to: newTarget.main, duration: t3, delay: t1 + t2)
//            print("ID: \(target.id)", t1, t2, t3)
            
            // ⚠️ DELETE
            animate(from: oldTarget.main, to: newTarget.main, duration: totalAnimationTime)
            
        } else if previousDiff == 1 {
            let t1 = stepDuration * (10.0 - oldTarget.main.double)
            animate(from: oldTarget.main, to: 10, duration: t1)
            let t2 = stepDuration * newTarget.main.double
            animate(from: 0, to: newTarget.main, duration: t2, delay: t1)
        } else if previousDiff > 1 {
            // если нужно сделать несколько полных оборотов
            
            let maxFullCircleRepeats = 5
            let fullCircleRepeats = min(previousDiff - 1, maxFullCircleRepeats) // обрезаем кол-во оборотов
             
            let stepsCount1 = 10 - oldTarget.main // увеличиваем до 10 (дальний ноль)
            let stepsCount2 = 10 * fullCircleRepeats // делаем несколько полных оборотов
            let stepsCount3 = newTarget.main // доходим до нужного числа от 0
            
            let totalEditedSteps = stepsCount1 + stepsCount2 + stepsCount3 // новое кол-во шагов
            let editedStepDuration = totalAnimationTime / totalEditedSteps.double // новое время шага
            
            let t1 = stepsCount1.double * editedStepDuration // время первой части анимации
            let t2 = stepsCount2.double * editedStepDuration // время второй части анимации
            let t3 = stepsCount3.double * editedStepDuration // время третьей части анимации
            
            animate(from: oldTarget.main, to: 10, duration: t1) //
            animate(from: 0, to: 10, repeatCount: fullCircleRepeats, duration: t2 / fullCircleRepeats.double, delay: t1)
            animate(from: 0, to: newTarget.main, duration: t3, delay: t1 + t2)
            
            print("ID: \(target.id)", t1, t2, t3)
        }
    }
    
    /*
        I want to change number for 1 s

        1_537     ->   3_743
     
        0: 153 7        0: 374 3  1s:
        1:  15 3        1:  37 4  1s:
        2:   1 5        2:   3 7  1s:
        3:   0 1        3:   0 3  1s:
    */
    func simpleAnimate(from: TargetNumber, to: TargetNumber) {
        let previousDiff = to.previous - from.previous
        let basicDuration = 1.0
        
        if previousDiff == 0 {
            animate(from: from.main, to: to.main, duration: basicDuration)
        } else if previousDiff < 0 {
            animate(from: from.main, to: 0, duration: basicDuration / 2)
            animate(from: 10, to: to.main, duration: basicDuration / 2, delay: basicDuration / 2)
        } else if previousDiff > 0 {
            animate(from: from.main, to: 10, duration: basicDuration / 2)
            animate(from: 0, to: to.main, duration: basicDuration / 2, delay: basicDuration)
        }
    }
    
    /// Прямая анимация от одного числа к другому
    /// - Parameters:
    ///   - from: начальное положение
    ///   - to: конечное положение
    ///   - repeatCount: сколько раз повторить анимацию
    ///   - duration: время периода анимации
    ///   - delay: задержка начала анимации
    ///   - curve: Вид кривой для анимации
    func animate(
        from: Int,
        to: Int,
        repeatCount: Int = 1,
        duration: Double,
        delay: Double = 0,
        curve: Animation.Curve = .linear
    ) {
        Animation
            .linear(duration: 0.001)
            .delay(delay)
            .animate { selectedNumber = from }
        Animation
            .curve(curve, duration: duration)
            .repeatCount(repeatCount, autoreverses: false)
            .delay(delay + 0.001)
            .animate {
                print("🦉\(target.id) Animate \(from)->\(to) \(duration)sec x\(repeatCount) after \(delay)sec")
                selectedNumber = to
            }
    }
    
    /// Анимация числа вращением за заданное время
    /// - Parameters:
    ///   - from: начальное число
    ///   - to: конечное число
    ///   - isIncreasing: true - числа вращаются от меньшего к большего; false - в обратную сторону
    ///   - fullRoundsCount: кол-во полных оборотов от 0,1,... -> ...,9,0
    ///   - duration: общая длительность анимации
    ///   - delay: задержка начала анимации
    func animate(
        from: Int,
        to: Int,
        isIncreasing: Bool,
        fullRoundsCount: Int = 0,
        duration: Double,
        delay: Double = 0
    ) {
        
        let stepsCount1 = isIncreasing
            ? 10 - from // увеличиваем до 10 (дальний ноль)
            : from      // уменьшаем до 0 (ближний ноль)
        let stepsCount2 = 10 * fullRoundsCount // делаем несколько полных оборотов
        let stepsCount3 = isIncreasing
            ? to      // доходим до нужного числа от 0
            : 10 - to // возвращаемся до нужнуго числа от 10 (дальний ноль)
        let totalEditedSteps = stepsCount1 + stepsCount2 + stepsCount3 // новое кол-во шагов
        
        let editedStepDuration = duration / totalEditedSteps.double // новое время шага (переключения с одного числа на другое)
        
        let t1 = stepsCount1.double * editedStepDuration // время первой части анимации
        let t2 = stepsCount2.double * editedStepDuration // время второй части анимации
        let t3 = stepsCount3.double * editedStepDuration // время третьей части анимации
        
        if isIncreasing, fullRoundsCount == 0, from < to {
            animate(from: from, to: to, duration: t1 + t2 + t3, curve: .easeInOut)
        } else if !isIncreasing, fullRoundsCount == 0, from > to {
            animate(from: from, to: to, duration: t1 + t2 + t3, curve: .easeInOut)
        } else if isIncreasing {
            animate(from: from, to: 10, duration: t1, curve: .easeIn)
            if fullRoundsCount > 0 {
                animate(from: 0, to: 10, repeatCount: fullRoundsCount, duration: t2 / fullRoundsCount.double, delay: t1)
            }
            animate(from: 0, to: to, duration: t3, delay: t1 + t2, curve: .easeOut)
        } else {
            animate(from: from, to: 0, duration: t1, curve: .easeIn)
            if fullRoundsCount > 0 {
                animate(from: 10, to: 0, repeatCount: fullRoundsCount, duration: t2 / fullRoundsCount.double, delay: t1)
            }
            animate(from: 10, to: to, duration: t3, delay: t1 + t2, curve: .easeOut)
        }
    }
}
