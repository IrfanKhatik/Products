//
//  UIStyles.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import Foundation
import SwiftUI

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
            ModifiedContent(content: self, modifier: style)
        }
}

struct PrimaryTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .dark ? .primary : .gray)
            .font(.custom(Fonts.kFontTitleName,
                          size: Fonts.kFontTitleSize,
                          relativeTo: .headline))
            .minimumScaleFactor(0.5)
    }
}

struct SecondaryTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .font(.custom(Fonts.kFontTitleName,
                          size: Fonts.kFontTitleSize,
                          relativeTo: .headline))
            .minimumScaleFactor(0.5)
    }
}
