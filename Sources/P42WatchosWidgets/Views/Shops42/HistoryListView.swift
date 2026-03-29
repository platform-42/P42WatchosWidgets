//
//  HistoryListView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 29/03/2026.
//

import SwiftUI
import P42Extensions


public enum OrderStatus {
    case paid, pending, refunded

    var color: Color {
        switch self {
        case .paid: return .green
        case .pending: return .yellow
        case .refunded: return .red
        }
    }

    var label: String {
        switch self {
        case .paid: return "Paid"
        case .pending: return "Pending"
        case .refunded: return "Refunded"
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
            List{
                ForEach(historyList) { order in
                    HStack {
                        VStack {
                            Text(order.name)
                            BadgedLabel(
                                content: .text(order.financialStatus.label),
                                foregroundColor: .black,
                                backgroundColor: order.financialStatus.color,
                                padding: EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
                            )
                        }
                        VStack {
                            Text("USD")
                            Text("27 mar 2026")
                                .font(.system(size: 8))
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            #if os(watchOS)
            .listStyle(CarouselListStyle())
            #endif
            FooterView(footer: footer)
        }
    }
}


