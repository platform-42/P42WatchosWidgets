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
    public let financialStatus: String
    public let quantity: Double
    public let quantityType: ValueType
    
    public init(
        id: Int,
        name: String,
        createdAt: String,
        financialStatus: String,
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
    public let historyList: [HistoryListItem]
    public let latency: String?

    public init(
        title: String,
        titleBadge: String? = nil,
        historyList: [HistoryListItem],
        latency: String? = nil
    ) {
        self.title = title
        self.titleBadge = titleBadge
        self.historyList = historyList
        self.latency = latency
    }
    
    public var body: some View {
        
        VStack {
            List{
                headerView(
                    title: title,
                    titleBadge: "",
                    latency: latency
                )
                ForEach(historyList) { order in
                    HStack {
                        VStack {
                            Text(order.name)
                            BadgedLabel(
                                content: .text(order.financialStatus),
                                foregroundColor: .black,
                                backgroundColor: .yellow,
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
        }
    }
}


extension HistoryListView {
    
    @ViewBuilder
    private func headerView(
        title: String,
        titleBadge: String?,
        latency: String?
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let badge = titleBadge {
                    Image(systemName: badge)
                        .font(.system(size: KPIDimension.badgeFontSize, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(KPIDimension.badgeInnerPadding)
                        .background(Color(hex: ColorRGB.badge))
                        .clipShape(Circle())
                }
                Text(title)
                    .font(.system(
                        size: HeaderDimension.fontSize,
                        weight: .medium,
                        design: .rounded
                    ))
                    .foregroundColor(Color(hex: ColorRGB.title))
                if let latency = latency {
                    Rectangle()
                        .fill(Color(hex: ColorRGB.footerBackground))
                        .frame(width: 1, height: HeaderDimension.fontSize)
                    Text(latency)
                        .font(.system(size: HeaderDimension.fontSize, weight: .light))
                        .foregroundStyle(Color(hex: ColorRGB.latency))
                        .monospacedDigit()
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, HeaderDimension.hSpacing)
    }
}
