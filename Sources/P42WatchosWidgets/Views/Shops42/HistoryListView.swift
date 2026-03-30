//
//  HistoryListView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 29/03/2026.
//

import SwiftUI
import P42Extensions


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
        case .refunded: return Color(hex: ColorRGB.kpiStateWarning)
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


public struct HistoryListItem: Identifiable {
    public let id: Int
    public let name: String
    public let createdAt: String
    public let financialStatus: OrderStatus
    public let quantity: Double
    public let quantityType: ValueType
    
    public init(
        id: Int,
        name: String,
        createdAt: String,
        financialStatus: OrderStatus,
        quantity: Double,
        quantityType: ValueType
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.financialStatus = financialStatus
        self.quantity = quantity
        self.quantityType = quantityType
    }
    
}

public struct HistoryListView: View {
    public let title: String
    public let titleBadge: String?
    public let footer: String
    public let historyList: [HistoryListItem]
    public let latency: String?

    public init(
        title: String,
        titleBadge: String? = nil,
        footer: String,
        historyList: [HistoryListItem],
        latency: String? = nil
    ) {
        self.title = title
        self.titleBadge = titleBadge
        self.footer = footer
        self.historyList = historyList
        self.latency = latency
    }
    
    public var body: some View {
        VStack {
            HeaderView(
                title: title.uppercased(),
                titleBadge: titleBadge,
                latency: latency
            )
            List(historyList) { order in
                historyRow(historyItem: order)
            }
            .scrollIndicators(.hidden)
            #if os(watchOS)
            .listStyle(CarouselListStyle())
            #endif
            FooterView(footer: footer)
        }
    }
}

extension HistoryListView {
    
    private func historyRow(
        historyItem: HistoryListItem
    ) -> some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
                orderStatusCell(historyItem: historyItem)
                    .frame(width: geo.size.width * HistoryListDimension.orderStatusCellWidth, alignment: .leading)
                    .frame(maxHeight: .infinity, alignment: .center)
                orderDetailCell(historyItem: historyItem)
                    .frame(width: geo.size.width * HistoryListDimension.orderDetailCellWidth, alignment: .leading)
                    .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .padding(.horizontal, 8)
        .background(baseRowGradient)
        .clipShape(
            RoundedRectangle(
                cornerRadius: KPIDimension.cornerRadiusRow,
                style: .continuous
            )
        )
    }
    
    private func orderStatusCell(
        historyItem: HistoryListItem
    ) -> some View {
        VStack {
            Text(historyItem.name)
            BadgedLabel(
                content: .text(historyItem.financialStatus.label),
                foregroundColor: historyItem.financialStatus.textColor,
                backgroundColor: historyItem.financialStatus.color,
                padding: EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
            )
        }
    }
    
    private func orderDetailCell(
        historyItem: HistoryListItem
    ) -> some View {
        VStack {
            Text("USD")
            Text("27 mar 2026")
                .font(.system(size: 8))
        }
    }
    
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
}


