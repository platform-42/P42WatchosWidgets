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



@available(iOS 15.0.0, *)
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
