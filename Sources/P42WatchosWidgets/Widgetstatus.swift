//
//  Utils.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 23/04/2023.
//

import Foundation
import SwiftUI
import P42_extensions


/*
 *  state model and colors
 */
public enum WidgetStateIcon: String {
    case up = "arrowtriangle.up.fill"
    case down = "arrowtriangle.down.fill"
    case neutral = "arrowtriangle.right.fill"
    case none
}

public enum WidgetState: String {
    case up
    case down
    case neutral
    case none
}

public enum WidgetStateColor: Int {
    case up = 0x008E00
    case down = 0xFF2500
    case neutral = 0xFDC209
    case none
}


/*
 *  status model and colors
 */
public enum WidgetStatus: String {
    case alert
    case warning
    case normal
    case none
}

public enum WidgetStatusColor: Int {
    case alert = 0xFF2500
    case warning = 0xFDC209
    case normal = 0x008E00
    case none
}


public class Widget {

    public static func stateFieldImage(_ stateLogic: WidgetState) -> String {
        switch (stateLogic) {
            case .up: return WidgetStateIcon.up.rawValue
            case .down: return WidgetStateIcon.down.rawValue
            case .neutral: return WidgetStateIcon.neutral.rawValue
            case .none: return WidgetStateIcon.neutral.rawValue
        }
    }
    
    public static func stateFieldColor(_ stateLogic: WidgetState) -> Color {
        switch (stateLogic) {
            case .up: return Color(hex: WidgetStateColor.up.rawValue)
            case .down: return Color(hex: WidgetStateColor.down.rawValue)
            case .neutral: return Color(hex: WidgetStateColor.neutral.rawValue)
            case .none: return Color.clear
        }
    }
    
    public static func statusFieldColor(_ statusLogic: WidgetStatus) -> Color {
        switch (statusLogic) {
            case .alert: return .white
            case .warning: return .black
            case .normal: return .primary
            case .none: return .primary
        }
    }
    
    public static func statusFieldBackgroundColor(_ statusLogic: WidgetStatus) -> Color {
        switch (statusLogic) {
            case .alert: return Color(hex: WidgetStatusColor.alert.rawValue)
            case .warning: return Color(hex: WidgetStatusColor.warning.rawValue)
            case .normal: return Color(hex: WidgetStatusColor.normal.rawValue)
            case .none: return Color.clear
        }
    }
        
}
