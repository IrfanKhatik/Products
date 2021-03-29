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

// Title TextStyle
struct ProductTitleTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .dark ? .primary : .gray)
            .font(.custom(Fonts.kDefaultFontName,
                          size: Fonts.kFontTitleSize,
                          relativeTo: .caption))
            .minimumScaleFactor(0.5)
    }
}

// Description TextStyle
struct ProductDesciptionTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .font(.custom(Fonts.kDefaultFontName,
                          size: Fonts.kFontDescSize,
                          relativeTo: .body))
            .minimumScaleFactor(0.5)
    }
}
