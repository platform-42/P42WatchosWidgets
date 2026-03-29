//
//  KPIView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 28/03/2026.
//

import SwiftUI
import Foundation
import P42Extensions


public enum KPIState {
    case none
    case normal
    case warning
    case alert
}


public enum ValueType {
    case number
    case currency(code: String) // e.g. "EUR"
}


public enum ValueSemantic {
    case absolute
    case delta
}


private func kpiColor(
    kpistate: KPIState
) -> Color {
    switch kpistate {
    case .none:
        return .primary
    case .normal:
        return .white
    case .warning:
        return .white
    case .alert:
        return .white
    }
}

private func kpiBGColor(
    kpistate: KPIState
) -> Color {
    switch kpistate {
    case .none:
        return Color.clear
    case .normal:
        return Color(hex: ColorRGB.kpiStateNormal)
    case .warning:
        return Color(hex: ColorRGB.kpiStateWarning)
    case .alert:
        return Color(hex: ColorRGB.kpiStateAlert)
    }
}


private func prefix(
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


private func formatCompactNumber(
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


@ViewBuilder
private func numbersView(
    _ value: Double,
    type: ValueType,
    semantics: ValueSemantic = .absolute
) -> some View {
    
    let prefix = prefix(value, semantics: semantics)
    let absValue = abs(value)
    let valueString = formatCompactNumber(absValue)
    Text("\(prefix)\(valueString)")
}


private func currencySymbol(
    for code: String
) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = code
    return formatter.currencySymbol ?? code
}


private func currencyView(
    value: Double,
    code: String,
    semantics: ValueSemantic
) -> some View {

    let symbol = currencySymbol(for: code)
    let prefix = prefix(value, semantics: semantics)
    let valueString = formatCompactNumber(abs(value))

    return HStack(alignment: .firstTextBaseline, spacing: 2) {
        
        Text(symbol)
            .font(.system(
                size: KPIDimension.quantityFontSize * 0.7,
                weight: .semibold,
                design: .rounded
            ))
            .foregroundColor(.primary.opacity(0.6))
        
        Text("\(prefix)\(valueString)")
            .font(.system(
                size: KPIDimension.quantityFontSize,
                weight: .bold,
                design: .rounded
            ))
            .monospacedDigit()
            .foregroundColor(.primary)
    }
}


public struct KPIViewItem: Identifiable {
    public let id = UUID()
    public let quantitySemantic: ValueSemantic
    public let quantity: Double
    public let quantityType: ValueType
    public let kpiState: KPIState
    public let label: String
    
    public init(
        quantitySemantic: ValueSemantic = .absolute,
        quantity: Double,
        quantityType: ValueType = .number,
        kpiState: KPIState = .none,
        label: String
    ) {
        self.quantitySemantic = quantitySemantic
        self.quantity = quantity
        self.quantityType = quantityType
        self.kpiState = kpiState
        self.label = label
    }
}


public struct KPIView: View {
    
    public let title: String
    public let titleBadge: String?
    public let footer: String
    public let kpiListItems: [KPIViewItem]
    public let latency: String?
    
    public init(
        title: String,
        titleBadge: String? = nil,
        footer: String,
        kpiListItems: [KPIViewItem] = [],
        latency: String? = nil
    ) {
        self.title = title
        self.titleBadge = titleBadge
        self.footer = footer
        self.kpiListItems = kpiListItems
        self.latency = latency
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: title.uppercased(),
                titleBadge: titleBadge,
                latency: latency
            )
            .padding(.bottom, 4)
            ForEach(kpiListItems.prefix(3)) { item in
                kpiRow(kpiItem: item)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
            }
            FooterView(footer: footer)
            .padding(.top, 4)
        }
    }
}


extension KPIView {
    
    private func kpiRow(
        kpiItem: KPIViewItem
    ) -> some View {
        
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
                quantityLabelCell(kpiItem: kpiItem)
                    .frame(width: geo.size.width * KPIDimension.quantityLabelCellWidth, alignment: .leading)
                    .frame(maxHeight: .infinity, alignment: .center)
                
                quantityCell(kpiItem: kpiItem)
                    .padding(.horizontal, 8)
                    .frame(width: geo.size.width * KPIDimension.quantityCellWidth, alignment: .trailing)
                    .frame(maxHeight: .infinity, alignment: .center)

            }
        }
        .frame(height: KPIDimension.badgeSize + 10)
        .padding(.horizontal, 8)
        .background(baseRowGradient)
        .background(semanticOverlay(kpiItem: kpiItem))
        .clipShape(
            RoundedRectangle(
                cornerRadius: KPIDimension.cornerRadiusRow,
                style: .continuous
            )
        )
    }
}


extension KPIView {
    
    private var baseRowGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.gray.opacity(0.65),
                Color.gray.opacity(0.05)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func semanticOverlay(
        kpiItem: KPIViewItem
    ) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                kpiBGColor(kpistate: kpiItem.kpiState),
                Color.clear
            ]),
            startPoint: .leading,
            endPoint: .center
        )
    }
    

    @ViewBuilder
    private func quantityCell(
        kpiItem: KPIViewItem
    ) -> some View {
        
        switch kpiItem.quantityType {
            
        case .number:
            numbersView(
                kpiItem.quantity,
                type: kpiItem.quantityType,
                semantics: kpiItem.quantitySemantic
            )
            .font(.system(
                size: KPIDimension.quantityFontSize,
                weight: .bold,
                design: .rounded
            ))
            .monospacedDigit()
            .foregroundColor(.primary)
            
        case .currency(let code):
            currencyView(
                value: kpiItem.quantity,
                code: code,
                semantics: kpiItem.quantitySemantic
            )
        }
    }
    
    
    private func quantityLabelCell(
        kpiItem: KPIViewItem
    ) -> some View {

        Text(kpiItem.label)
            .font(.system(
                size: KPIDimension.companyFontSize,
                weight: .semibold,
                design: .rounded
            ))
            .foregroundColor(kpiColor(kpistate: kpiItem.kpiState))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(kpiBGColor(kpistate: kpiItem.kpiState))
            .clipShape(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
            )
    }

    
}
