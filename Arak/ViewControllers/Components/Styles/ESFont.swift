//
//  ESFont.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

enum ESFontStyle: String {
    case extraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black
}

struct ESFont: Equatable {
    let style: ESFontStyle
    let size: CGFloat

    init(style: ESFontStyle, size: CGFloat) {
        self.style = style
        self.size = size
    }

    var name: String {
        switch style {
        case .extraLight:
            return "DroidArabicKufi-Bold"
        case .light:
            return "DroidArabicKufi-Bold"
        case .regular:
            return "DroidArabicKufi"
        case .medium:
            return "DroidArabicKufi-Bold"
        case .semiBold:
            return "DroidArabicKufi-Bold"
        case .bold:
            return "DroidArabicKufi-Bold"
        case .extraBold:
            return "DroidArabicKufi-Bold"
        case .black:
            return "DroidArabicKufi-Bold"
        }
    }

    var font: UIFont {
        UIFont(name: name, size: size)!
    }
}

extension UIFont {
    class func font(for style: ESFontStyle, size: CGFloat) -> UIFont {
        ESFont(style: style, size: size).font
    }
}
