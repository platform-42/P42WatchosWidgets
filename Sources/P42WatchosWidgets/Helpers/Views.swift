//
//  Views.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 01/04/2026.
//

import SwiftUI


public enum KPIState {
    case none, normal, warning, alert
    
    public var color: Color {
        switch self {
        case .none: return Color.clear
        case .normal: return Color(hex: ColorRGB.kpiStateNormal)
        case .warning: return Color(hex: ColorRGB.kpiStateWarning)
        case .alert: return Color(hex: ColorRGB.kpiStateAlert)
        }
    }
    
    public var textColor: Color {
        switch self {
        case .none: return .primary
        case .normal: return .white
        case .warning: return .black
        case .alert: return .white
        }
    }
}
