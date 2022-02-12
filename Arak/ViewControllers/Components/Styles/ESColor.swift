//
//  ESColor.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

enum ESColor: String {
    case background
    case backgroundSecondary

    case accentSecondary
    case accent
    case accentOrange

    case text
    case textSecondary
    case textTertiary

    case messageError
    case messingData
    case messageSuccess

    case buttonBackGround
    case backgoundSecoundary1
    case cellBackground

    case shadow
    var color: UIColor {
        UIColor(named: self.rawValue) ?? .accentOrange
    }
}

extension UIColor {
    static var background: UIColor { ESColor.background.color }
    static var backgroundSecondary: UIColor { ESColor.backgroundSecondary.color }

    static var accentSecondary: UIColor { ESColor.accentSecondary.color }
    static var accent: UIColor { ESColor.accent.color }
    static var accentOrange: UIColor { ESColor.accentOrange.color }

    static var text: UIColor { ESColor.text.color }
    static var textSecondary: UIColor { ESColor.textSecondary.color }
    static var textTertiary: UIColor { ESColor.textTertiary.color }

    static var messageError: UIColor { ESColor.messageError.color }
    static var messingData: UIColor {ESColor.messingData.color}
    static var messageSuccess: UIColor { ESColor.messageSuccess.color }

    static var shadow: UIColor { ESColor.shadow.color }

    static var buttonBackGround: UIColor {ESColor.buttonBackGround.color}

    static var backgoundSecoundary1: UIColor {ESColor.backgoundSecoundary1.color}
    static var cellBackground: UIColor {ESColor.cellBackground.color}

}
