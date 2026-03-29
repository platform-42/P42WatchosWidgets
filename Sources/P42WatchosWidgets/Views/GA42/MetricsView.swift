//
//  MetricsView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 19/03/2026.
//

import SwiftUI
import Foundation


@available(iOS 15.0.0, *)
public struct MetricsView: View {
    
    public let title: String
    public let propertyName: String
    
    public let todayValue: String
    public let todayLabel: String
    public let todayState: WidgetState
    
    public let yesterdayValue: String
    public let yesterdayLabel: String
    public let yesterdayState: WidgetState
    
    public let averageValue: String
    public let averageLabel: String
    
    public let latency: String?
    
    public init(
        title: String,
        propertyName: String,
        todayValue: String,
        todayLabel: String = "Today",
        todayState: WidgetState = .neutral,
        yesterdayValue: String,
        yesterdayLabel: String = "Yesterday",
        yesterdayState: WidgetState = .neutral,
        averageValue: String,
        averageLabel: String = "Average",
        latency: String? = nil
    ) {
        self.title = title
        self.propertyName = propertyName
        self.todayValue = todayValue
        self.todayLabel = todayLabel
        self.todayState = todayState
        self.yesterdayValue = yesterdayValue
        self.yesterdayLabel = yesterdayLabel
        self.yesterdayState = yesterdayState
        self.averageValue = averageValue
        self.averageLabel = averageLabel
        self.latency = latency
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: HeaderDimension.fontSize, weight: .medium, design: .rounded))
//                    .foregroundColor(Color(hex: 0x89CFF0))
                    .foregroundColor(Color(hex: 0x3BDDEC))
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
            dashboardRow(
                value: todayValue,
                label: todayLabel,
                showArrow: true,
                state: todayState
            )
            dashboardRow(
                value: yesterdayValue,
                label: yesterdayLabel,
                showArrow: true,
                state: yesterdayState
            )
            dashboardRow(
                value: averageValue,
                label: averageLabel,
                showArrow: false,
                state: .neutral
            )
            HStack {
                Spacer()
                Text(propertyName)
                    .font(.system(size: FooterDimension.fontSize, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.horizontal, FooterDimension.hSpacing)
                    .padding(.vertical, FooterDimension.vSpacing)
                    .background(
                        RoundedRectangle(cornerRadius: FooterDimension.cornerRadius)
                            .fill(Color(hex: WidgetStatusColor.warning.rawValue))
                    )
                Spacer()
            }
        }
        .padding(.vertical)
    }
}


@available(iOS 15.0.0, *)
extension MetricsView {
    
    private func dashboardRow(
        value: String,
        label: String,
        showArrow: Bool,
        state: WidgetState
    ) -> some View {
        HStack(spacing: 0) {
            statusBadge(
                showArrow: showArrow,
                state: state
            )
            Spacer(minLength: 8)
            Text(value)
                .font(.system(size: MetricsDimension.valueFontSize, weight: .bold))
                .monospacedDigit()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 8)
            
            Text(label)
                .font(.system(size: MetricsDimension.labelFontSize, weight: .bold, design: .rounded))
                .textCase(.uppercase)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: MetricsDimension.cornerRadiusRow)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.28),
                            Color.gray.opacity(0.12)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: MetricsDimension.cornerRadiusRow)
                        .fill(
                            semanticCellOverlay(
                                state: state,
                                enabled: showArrow
                            )
                        )
                )
        )
    }
}


@available(iOS 15.0.0, *)
extension MetricsView {
    
    @ViewBuilder
    private func statusBadge(
        showArrow: Bool,
        state: WidgetState,
    ) -> some View {
        let widgetState = showArrow ? state : .neutral
        let widgetColor: Color = showArrow ? Widget.stateFieldColor(widgetState) : Color(hex: WidgetColor.blue)
        let widgetImage: String = showArrow ? Widget.stateFieldImage(state) : "chart.bar.xaxis"
        ZStack {
            Circle()
                .fill(arrowBadgeBackground(state: widgetState))
                .frame(width: MetricsDimension.iconSize, height: MetricsDimension.iconSize)
            
            Image(systemName: widgetImage)
                .foregroundColor(widgetColor)
                .font(.system(size: MetricsDimension.iconFontSize, weight: .bold))
        }
    }
    
    private func arrowBadgeBackground(state: WidgetState) -> RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [
                Widget.stateFieldColor(state).opacity(0.30),
                Color.gray.opacity(0.15)
            ]),
            center: .center,
            startRadius: 2,
            endRadius: 16
        )
    }
    
    private func clockBadgeBackground() -> RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [
                Color(hex: WidgetStatusColor.warning.rawValue).opacity(0.25),
                Color.gray.opacity(0.15)
            ]),
            center: .center,
            startRadius: 2,
            endRadius: 16
        )
    }
    
    private func semanticCellOverlay(state: WidgetState, enabled: Bool) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                enabled ? Widget.stateFieldColor(state).opacity(0.18) : Color.clear,
                Color.clear
            ]),
            startPoint: .topLeading,
            endPoint: .center
        )
    }
}
