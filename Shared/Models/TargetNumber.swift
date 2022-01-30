import Foundation

struct TargetNumber: Hashable {
    // уникальный идентификатор, а также порядковый номер цифры в числе справа (начиная с нуля)
    // например, для числа 2738
    //   id: 3 2 1 0
    //    n: 2 7 3 8
    let id: Int
    
    // максимальный id
    let maxId: Int
    
    // "кол-во десятков"
    // например, для числа 2738 previous = 273
    let previous: Int
    
    // основное число (последнее)
    // например, для числа 2738 main = 8
    let main: Int
    
    // оригинальное число
    let origin: Int
    
    var lapTime: Double {
        0.3 * id.double + 0.2
    }
    
    var value: Int {
        previous * 10 + main
    }
    
    func steps(to target: TargetNumber) -> Int {
        abs(value - target.value)
    }
}

extension TargetNumber {
    static var zero: Self {
        .init(id: 0, maxId: 0, previous: 0, main: 0, origin: 0)
    }
}
