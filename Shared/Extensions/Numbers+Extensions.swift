import Foundation

extension Int {
    var double: Double {
        Double(self)
    }
    
    func splitToTargets() -> [TargetNumber] {
        var i = self
        var targets = [TargetNumber]()
        var step = 0
        
        let maxId = String(self).count - 1
        
        while i > 0 {
            targets.append(.init(id: step, maxId: maxId, previous: i / 10, main: i % 10))
            i = i / 10
            step += 1
        }
        return targets.reversed()
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}

