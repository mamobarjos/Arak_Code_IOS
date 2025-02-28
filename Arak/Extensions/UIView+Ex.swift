//
//  UIView+Ex.swift
//
//  Created by Abed Qassim on 10/10/20.
//

import UIKit

public enum AttributePosition {
    case top
    case bottom
    case left
    case right
    case all
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case none
}


@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    
    var frameWidth: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.size.height)
        }
    }
    
    var frameHeight: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: newValue)
        }
    }
}


// MARK: - UIScreen Properties
extension UIScreen {
    
    static var width: CGFloat {
        return main.bounds.width
    }
    
    static var height: CGFloat {
        return main.bounds.height
    }
}


// MARK: - Exposed Methods
extension UIView {
    
    func addRoundedCorners(position: AttributePosition = .all, cornerRadius: CGFloat) {
        
        switch position {
        case .top:
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        case .bottom:
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
        case .right:
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
        case .left:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
        case .topRight:
            layer.maskedCorners = [.layerMaxXMinYCorner]
            
        case .topLeft:
            layer.maskedCorners = [.layerMinXMinYCorner]
            
        case .bottomRight:
            layer.maskedCorners = [.layerMaxXMaxYCorner]
            
        case .bottomLeft:
            layer.maskedCorners = [.layerMinXMaxYCorner]
            
        default:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        layer.cornerRadius = cornerRadius
    }
    
    func addBorders(position: AttributePosition = .all, width: CGFloat, color: UIColor) {
        
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func addShadow(position: AttributePosition) {
        
        guard position != .none else {
            return
        }
        let offset = 4
        layer.masksToBounds = false
        layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        var shadowOffset: CGSize {
            switch position {
            case .top:
                return CGSize(width: 0, height: offset * -1)
            case .all:
                return CGSize.zero
            default:
                return CGSize(width: 0, height: offset)
            }
        }
        layer.shadowOffset = shadowOffset
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0
    }
}
enum TapGestureRecognizer: String {
    case mediaViewerAssociatedObjectKey = "MediaViewerAssociatedObjectKey_mediaViewer"
}

extension UIView {

    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = TapGestureRecognizer.mediaViewerAssociatedObjectKey.rawValue
    }

    fileprivate typealias Action = (() -> Void)?

    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }

    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
}
