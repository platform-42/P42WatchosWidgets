//
//  FunnelView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 19/03/2026.
//
import SwiftUI
import Foundation


@available(iOS 15.0.0, *)
public struct FunnelItem: Identifiable {
    public let id = UUID()
    public let label: String
    public let percentage: Double   // 0...100
    public let icon: Image
    public let iconColor: Color
    
    public init(
        label: String,
        percentage: Double,
        icon: Image,
        iconColor: Color
    ) {
        self.label = label
        self.percentage = percentage
        self.icon = icon
        self.iconColor = iconColor
    }
}


@available(iOS 15.0.0, *)
public struct FunnelView: View {
    
    public let title: String
    public let propertyName: String
    public let funnelItems: [FunnelItem]
    public let latency: String?

    public init(
        title: String,
        propertyName: String,
        funnelItems: [FunnelItem] = [],
        latency: String? = nil
    ) {
        self.title = title
        self.propertyName = propertyName
        self.funnelItems = funnelItems
        self.latency = latency
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: HeaderDimension.fontSize, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: ColorRGB.title))
                    .padding(.horizontal, HeaderDimension.hSpacing)
                    .padding(.vertical, HeaderDimension.vSpacing)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                if let latency = latency {
                    Rectangle()
                        .fill(Widget.stateFieldColor(.neutral).opacity(0.5))
                        .frame(width: 1, height: HeaderDimension.fontSize)
                    Text(latency)
                        .font(.system(size: HeaderDimension.fontSize, weight: .light))
                        .foregroundStyle(Widget.stateFieldColor(.neutral))
                        .monospacedDigit()
                }
                Spacer()
            }
            ForEach(funnelItems) { item in
                dashboardRow(funnelItem: item)
            }
            FooterView(footer: propertyName)
        }
        .padding(.vertical)
    }
}


@available(iOS 15.0.0, *)
extension FunnelView {
    
    private func dashboardRow(
        funnelItem: FunnelItem
    ) -> some View {
        HStack(spacing: 0) {
            deviceBadge(
                icon: funnelItem.icon,
                iconColor: funnelItem.iconColor
            )
            Spacer(minLength: 8)
            Text(
                funnelItem.percentage
                    .formatted(.number.precision(.fractionLength(0)))
            )
            .font(.system(size: FunnelDimension.valueFontSize, weight: .semibold))
            .monospacedDigit()
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 2)
            
            Text("% " + funnelItem.label)
                .font(.system(size: FunnelDimension.labelFontSize, weight: .bold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 2)
            
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            GeometryReader { geo in
                funnelItem.iconColor.opacity(0.90)
                    .frame(
                        width: geo.size.width * CGFloat(funnelItem.percentage / 100),
                        alignment: .leading
                    )
                    .mask(
                        RoundedRectangle(
                            cornerRadius: FunnelDimension.cornerRadiusRow,
                            style: .continuous
                        )
                        .frame(height: geo.size.height)
                    )
            }
        )
        .background(baseRowGradient)
        .clipShape(
            RoundedRectangle(
                cornerRadius: FunnelDimension.cornerRadiusRow,
                style: .continuous
            )
        )
    }
}


@available(iOS 15.0.0, *)
extension FunnelView {
    
    private var baseRowGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.gray.opacity(0.20),
                Color.black.opacity(0.25)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    @ViewBuilder
    private func deviceBadge(
        icon: Image,
        iconColor: Color
    ) -> some View {
        ZStack {
            Circle()
                .fill(Color(hex: WidgetColor.darkBlue))
                .frame(width: FunnelDimension.iconSize, height: FunnelDimension.iconSize)
            icon
                .foregroundColor(.white)
                .font(.system(size: MetricsDimension.iconFontSize, weight: .bold))
        }
    }
    
}
