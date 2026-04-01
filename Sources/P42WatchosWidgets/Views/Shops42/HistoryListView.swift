//
//  HistoryListView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 29/03/2026.
//

import SwiftUI
import P42Extensions


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
                    .padding(.horizontal, 8)
                    .frame(width: geo.size.width * HistoryListDimension.orderDetailCellWidth, alignment: .trailing)
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
            Text(historyItem.financialStatus.label)
                .font(.system(
                    size: KPIDimension.quantityLabelFontSize,
                    weight: .semibold,
                    design: .rounded
                ))
                .foregroundColor(historyItem.financialStatus.textColor)
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(historyItem.financialStatus.color)
                .clipShape(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                )
        }
    }
    
    private func orderDetailCell(
        historyItem: HistoryListItem
    ) -> some View {
        VStack {
            currencyView(
                value: historyItem.quantity,
                code: {
                    if case let .currency(code) = historyItem.quantityType {
                        return code
                    }
                    return ""
                }(),
                semantics: .absolute
            )
            Text(formatShopifyDate(historyItem.createdAt))
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


