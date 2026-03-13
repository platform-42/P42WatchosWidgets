import SwiftUI
import Foundation


public enum BadgedLabelContent {
    case text(String)
    case systemImage(name: String)
}

enum WidgetColor {
    static let antracite: Int = 0x21262B
    static let blue: Int = 0x3A7BD5
    static let darkBlue: Int = 0x1E3564
}

enum HeaderDimension {
    static let fontSize: CGFloat = 14
    static let cornerRadius: CGFloat = 6
    static let hSpacing: CGFloat = 6
    static let vSpacing: CGFloat = 2
}

enum FooterDimension {
    static let fontSize: CGFloat = 10
    static let cornerRadius: CGFloat = 4
    static let hSpacing: CGFloat = 6
    static let vSpacing: CGFloat = 4
}

enum MetricsDimension {
    static let iconSize: CGFloat = 28
    static let iconFontSize: CGFloat = 14
    static let valueFontSize: CGFloat = 26
    static let labelFontSize: CGFloat = 12
    static let cornerRadiusRow: CGFloat = 12
}

enum FunnelDimension {
    static let iconSize: CGFloat = 28
    static let iconFontSize: CGFloat = 14
    static let valueFontSize: CGFloat = 26
    static let percentFontSize: CGFloat = 14
    static let labelFontSize: CGFloat = 12
    static let cornerRadiusRow: CGFloat = 12
}


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



public struct HeaderView: View {
    
    let connectionColor: Color
    let title: String
    let background: Color
    let font: Font
    let labelColor: Color
    let iconSize: CGFloat
    let infoText: String?
    
    public init(
        connectionColor: Color,
        title: String,
        background: Color = .blue,
        font: Font = .headline,
        labelColor: Color = .white,
        iconSize: CGFloat = 16,
        infoText: String? = nil
    ) {
        self.connectionColor = connectionColor
        self.title = title
        self.background = background
        self.font = font
        self.labelColor = labelColor
        self.iconSize = iconSize
        self.infoText = infoText
    }
    
    @State private var showInfo = false
    
    public var body: some View {
        ZStack {
            titleView
            contentRow
        }
        .frame(maxWidth: .infinity)
        .background(background)
    }
}


private extension HeaderView {
    
    var titleView: some View {
        Text(title.capitalized)
            .font(font)
            .fontWeight(.semibold)
            .foregroundColor(labelColor)
            .padding(.vertical, 4)
    }
    
    var contentRow: some View {
        HStack {
            statusIndicator
            Spacer()
            infoButton
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 15)
    }
    
    var statusIndicator: some View {
        Image(systemName: "circlebadge.fill")
            .foregroundColor(connectionColor)
            .font(.system(size: iconSize))
    }
    
    @ViewBuilder
    var infoButton: some View {
        if let _ = infoText {
            Button {
                showInfo.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(Widget.stateFieldColor(.neutral))
                    .font(.system(size: iconSize))
            }
            .buttonStyle(.plain)
        }
    }
}


public struct NumberAndStatView: View {
    var period: String
    var periodColor: Color
    var primaryValue: String
    var primaryColor: Color
    var secondaryLabel: String?
    var secondaryValue: String
    var widgetStatus: WidgetStatus
    
    public init(period: String,
                periodColor: Color = .secondary,
                primaryValue: String,
                primaryColor: Color,
                secondaryLabel: String? = nil,
                secondaryValue: String,
                widgetStatus: WidgetStatus) {
        self.period = period
        self.periodColor = periodColor
        self.primaryValue = primaryValue
        self.primaryColor = primaryColor
        self.secondaryLabel = secondaryLabel
        self.secondaryValue = secondaryValue
        self.widgetStatus = widgetStatus
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Divider()
            Text(period.capitalized)
                .foregroundColor(periodColor)
            Divider()
            Text(primaryValue)
                .foregroundColor(primaryColor)
                .font(.largeTitle)
            HStack {
                if let label = secondaryLabel {
                    Text(label)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                }
                BadgedLabel(
                    content: .text(String(secondaryValue)),
                    foregroundColor: Widget.statusFieldColor(widgetStatus),
                    font: .caption2,
                    backgroundColor: Widget.statusFieldBackgroundColor(widgetStatus),
                    padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
                )
            }
            Divider()
        }
    }
}


public struct NumberAndStateView: View {
    let period: String
    let periodColor: Color
    let primaryValue: String
    let primaryColor: Color
    let primaryAnnotation: String?
    let primaryAnnotationColor: Color?
    let secondaryValue: String
    let secondaryColor: Color
    let widgetState: WidgetState
    
    public init(
        period: String,
        periodColor: Color = .secondary,
        primaryValue: String,
        primaryColor: Color,
        primaryAnnotation: String? = nil,
        primaryAnnotationColor: Color? = .secondary,
        secondaryValue: String,
        secondaryColor: Color,
        widgetState: WidgetState
    ) {
        self.period = period
        self.periodColor = periodColor
        self.primaryValue = primaryValue
        self.primaryColor = primaryColor
        self.primaryAnnotation = primaryAnnotation
        self.primaryAnnotationColor = primaryAnnotationColor
        self.secondaryValue = secondaryValue
        self.secondaryColor = secondaryColor
        self.widgetState = widgetState
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Divider()
            Text(period.capitalized)
                .foregroundColor(periodColor)
            Divider()
            HStack(alignment: .firstTextBaseline) {
                Text(primaryValue)
                    .font(.largeTitle)
                    .foregroundColor(primaryColor)
                if let annotation = primaryAnnotation {
                    Text(annotation)
                        .font(.caption)
                        .foregroundColor(primaryAnnotationColor)
                }
            }
            HStack {
                if widgetState != .none {
                    Image(systemName: Widget.stateFieldImage(widgetState))
                        .foregroundColor(Widget.stateFieldColor(widgetState))
                        .padding(.horizontal, 4)
                }
                Text(secondaryValue)
                    .foregroundColor(secondaryColor)
                    .padding(.horizontal, 4)
            }
            Divider()
        }
    }
}


public struct FooterView<LastUpdateView: View>: View {
    let topic: String
    let topicColor: Color?
    let font: Font
    let lastUpdateView: LastUpdateView?
    
    public init(
        topic: String,
        topicColor: Color? = .primary,
        font: Font = .footnote,
        @ViewBuilder lastUpdateView: () -> LastUpdateView?
    ) {
        self.topic = topic
        self.topicColor = topicColor
        self.font = font
        self.lastUpdateView = lastUpdateView()
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Text(topic)
                .font(font)
                .fontWeight(.light)
                .foregroundColor(topicColor)
            
            if let lastUpdateView {
                lastUpdateView
            }
        }
    }
}


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
                    .foregroundColor(Color(hex: WidgetColor.blue))
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
                    .foregroundColor(Color(hex: WidgetColor.blue))
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


public struct BadgedLabel: View {
    
    let content: BadgedLabelContent
    let foregroundColor: Color
    let font: Font
    let backgroundColor: Color
    let padding: EdgeInsets
    
    public init(
        content: BadgedLabelContent,
        foregroundColor: Color = .white,
        font: Font = .caption2,
        backgroundColor: Color = .blue,
        padding: EdgeInsets = EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
    ) {
        self.content = content
        self.foregroundColor = foregroundColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.padding = padding
    }
    
    public var body: some View {
        label
            .padding(padding)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
    
    @ViewBuilder
    private var label: some View {
        switch content {
        case .text(let value):
            Text(value)
                .font(font)
                .foregroundColor(foregroundColor)
            
        case .systemImage(let name):
            Image(systemName: name)
                .font(font)
                .foregroundColor(foregroundColor)
        }
    }
}
