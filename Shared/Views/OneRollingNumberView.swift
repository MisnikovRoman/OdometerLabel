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
        var delay: Double
    }
    
    let target: TargetNumber
    let settings: RollingNumberLabel.Settings
    let debug: Debug
    
    init(target: TargetNumber, settings: RollingNumberLabel.Settings = .basic, debug: Debug? = nil) {
        self.target = target
        self.settings = settings
        self.debug = debug ?? .init(isClipped: true, showBorder: false, from: 0, to: 0, isIncreasing: true, rounds: 0, duration: 1.0, animationToggle: false, delay: 0.0)
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
             animateWithOneExtraRound(from: target, to: new)
        }
        .onAppear {
            directionalAnimate(
                from: 0,
                to: target.main,
                isIncreasing: true,
                fullRoundsCount: settings.rounds,
                duration: settings.numberAnimationDuration,
                delay: target.id.double * settings.interNumberDelay
            )
        }
        .onDisappear {
            directionalAnimate(
                from: target.main,
                to: 0,
                isIncreasing: false,
                fullRoundsCount: settings.rounds,
                duration: settings.numberAnimationDuration,
                delay: target.id.double * settings.interNumberDelay
            )
        }
        .onChange(of: debug.animationToggle) { new in
            directionalAnimate(from: debug.from, to: debug.to, isIncreasing: debug.isIncreasing, fullRoundsCount: debug.rounds, duration: debug.duration, delay: debug.delay)
        }
    }
    
    var totalOffset: CGFloat {
        CGFloat(selectedNumber) * oneNumberHeight * -1
    }
    
    // MARK: - Animation
    
    /// Прямая анимация от одного числа к другому
    /// - Parameters:
    ///   - from: начальное положение
    ///   - to: конечное положение
    ///   - repeatCount: сколько раз повторить анимацию
    ///   - duration: время периода анимации
    ///   - delay: задержка начала анимации
    ///   - curve: Вид кривой для анимации
    func dummyAnimate(
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
    func directionalAnimate(
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
            dummyAnimate(from: from, to: to, duration: t1 + t2 + t3, delay: delay, curve: .easeInOut)
        } else if !isIncreasing, fullRoundsCount == 0, from > to {
            dummyAnimate(from: from, to: to, duration: t1 + t2 + t3, delay: delay, curve: .easeInOut)
        } else if isIncreasing {
            dummyAnimate(from: from, to: 10, duration: t1, delay: delay, curve: .easeIn)
            if fullRoundsCount > 0 {
                dummyAnimate(from: 0, to: 10, repeatCount: fullRoundsCount, duration: t2 / fullRoundsCount.double, delay: delay + t1)
            }
            dummyAnimate(from: 0, to: to, duration: t3, delay: delay + t1 + t2, curve: .easeOut)
        } else {
            dummyAnimate(from: from, to: 0, duration: t1, delay: delay, curve: .easeIn)
            if fullRoundsCount > 0 {
                dummyAnimate(from: 10, to: 0, repeatCount: fullRoundsCount, duration: t2 / fullRoundsCount.double, delay: delay + t1)
            }
            dummyAnimate(from: 10, to: to, duration: t3, delay: delay + t1 + t2, curve: .easeOut)
        }
    }
    
    func animateWithOneExtraRound(from oldTarget: TargetNumber, to newTarget: TargetNumber) {
        
        let isIncreasing = newTarget.origin > oldTarget.origin
        let delay = newTarget.id.double * settings.interNumberDelay
        
        directionalAnimate(
            from: oldTarget.main,
            to: newTarget.main,
            isIncreasing: isIncreasing,
            fullRoundsCount: settings.rounds,
            duration: settings.numberAnimationDuration,
            delay: delay
        )
    }
}

