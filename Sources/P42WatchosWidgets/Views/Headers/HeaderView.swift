//
//  HeaderView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 29/03/2026.
//
import SwiftUI


struct HeaderView: View {
    let title: String
    let titleBadge: String?
    let latency: String?

    var body: some View {
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
