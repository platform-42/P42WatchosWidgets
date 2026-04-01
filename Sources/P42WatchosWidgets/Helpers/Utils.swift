//
//  Utils.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 01/04/2026.
//

import Foundation


func formatShopifyDate(
    _ isoString: String
) -> String {
    let isoFormatter = ISO8601DateFormatter()
    var date = isoFormatter.date(from: isoString)
    if date == nil {
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        date = isoFormatter.date(from: isoString)
    }
    guard let date else { return isoString } // fallback: return original if parsing fails
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, HH:mm"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
}


func prefix(
    _ value: Double,
    semantics: ValueSemantic
) -> String {
    if semantics == .absolute {
        return ""
    }
    if value > 0 {
        return "+"
    }
    if value < 0 {
        return "-"
    }
    return ""
}


func formatCompactNumber(
    _ value: Double
) -> String {
    let absValue = abs(value)
    
    switch absValue {
    case 1_000_000_000...:
        return String(format: "%.1fB", value / 1_000_000_000)
    case 1_000_000...:
        return String(format: "%.1fM", value / 1_000_000)
    case 1_000...:
        return String(format: "%.1fK", value / 1_000)
    default:
        return String(format: "%.0f", value)
    }
}
