//
//  Shopify.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 01/04/2026.
//

import SwiftUI


public enum OrderStatus {
    case paid, pending, refunded, unknown
    
    public init(
        shopifyStatus: String
    ) {
        switch shopifyStatus.lowercased() {
        case "paid":
            self = .paid
        case "pending", "authorized":
            self = .pending
        case "refunded", "partially_refunded":
            self = .refunded
        default:
            self = .unknown
        }
    }
    
    public var color: Color {
        switch self {
        case .paid: return Color(hex: ColorRGB.kpiStateNormal)
        case .pending: return Color(hex: ColorRGB.kpiStateWarning)
        case .refunded: return Color(hex: ColorRGB.kpiStateAlert)
        case .unknown: return .gray
        }
    }
    
    public var textColor: Color {
        switch self {
        case .paid: return .white
        case .pending: return .white
        case .refunded: return .white
        case .unknown: return .white
        }
    }
    
    public var label: String {
        switch self {
        case .paid: return "Paid"
        case .pending: return "Pending"
        case .refunded: return "Refunded"
        case .unknown: return "Unknown"
        }
    }
}
