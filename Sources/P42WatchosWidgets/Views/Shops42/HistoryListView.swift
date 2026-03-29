//
//  HistoryListView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 29/03/2026.
//

import SwiftUI
import P42Extensions


struct HistoryListItem: Identifiable {
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

struct HistoryListView: View {
    let historyList: [HistoryListItem]
    
    var body: some View {
        
        VStack {
            List{
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


