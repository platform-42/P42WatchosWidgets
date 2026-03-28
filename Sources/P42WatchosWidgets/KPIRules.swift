//
//  KPIRules.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 28/03/2026.
//

public enum KPIOperator: String {
    case gt = ".GT."
    case ge = ".GE."
    case lt = ".LT."
    case le = ".LE."
    case eq = ".EQ."
    case ne = ".NE."
}


public extension KPIOperator {
    func matches(
        _ metric: Double,
        _ objective: Double
    ) -> Bool {
        switch self {
        case .gt: return metric > objective
        case .ge: return metric >= objective
        case .lt: return metric < objective
        case .le: return metric <= objective
        case .eq: return metric == objective
        case .ne: return metric != objective
        }
    }
}


public struct KPIRule {
    public let op: KPIOperator
    public let value: Double
    
    public init(op: KPIOperator, value: Double) {
        self.op = op
        self.value = value
    }
    
    public func matches(_ input: Double) -> Bool {
        op.matches(input, value)
    }
}


public struct KPIStateRules {
    public let normal: KPIRule?
    public let warning: KPIRule?
    public let error: KPIRule?
    
    public init(
        normal: KPIRule? = nil,
        warning: KPIRule? = nil,
        error: KPIRule? = nil
    ) {
        self.normal = normal
        self.warning = warning
        self.error = error
    }
    
    public func evaluate(_ value: Double) -> KPIState {
        if let error, error.matches(value) {
            return .alert
        }
        if let warning, warning.matches(value) {
            return .warning
        }
        if let normal, normal.matches(value) {
            return .normal
        }
        return .none
    }
}

