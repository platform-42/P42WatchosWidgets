//
//  FooterView.swift
//  P42WatchosWidgets
//
//  Created by Diederick de Buck on 29/03/2026.
//

import SwiftUI


struct FooterView: View {
    let footer: String

    var body: some View {
        HStack {
            Spacer()
            Text(footer)
                .font(.system(size: FooterDimension.fontSize, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.horizontal, FooterDimension.hSpacing)
                .padding(.vertical, FooterDimension.vSpacing)
                .background(
                    RoundedRectangle(cornerRadius: FooterDimension.cornerRadius)
                        .fill(Color(hex: ColorRGB.footerBackground))
                )
            Spacer()
        }
    }
}
