//
//  UIView+Extensions.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

extension UIView {
    func dropShadow(color: UIColor = .black,
                    opacity: Float = 0.16,
                    offSet: CGSize = .zero,
                    radius: CGFloat = 7) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
}

@resultBuilder public struct SubviewsBuilder {
    public static func buildBlock(_ content: UIView...) -> [UIView] {
        return content
    }
}

extension UIStackView {

    func reverseSubviewsZIndex(setNeedsLayout: Bool = true) {
        let stackedViews = self.arrangedSubviews

        stackedViews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stackedViews.reversed().forEach(addSubview(_:))
        stackedViews.reversed().forEach(addArrangedSubview(_:))

        if setNeedsLayout {
            stackedViews.forEach { $0.setNeedsLayout() }
        }
    }

    @discardableResult
    func arrangedSubviews(@SubviewsBuilder content: () -> [UIView]) -> UIStackView {
        for subview in content() {
            addArrangedSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        return self
    }
    @discardableResult
    func alignment(_ alignment: Alignment) -> UIStackView {
        self.alignment = alignment
        return self
    }
    @discardableResult
    func distribution(_ distribution: Distribution) -> UIStackView {
        self.distribution = distribution
        return self
    }
    @discardableResult
    func spacing(_ spacing: CGFloat) -> UIStackView {
        self.spacing = spacing
        return self
    }
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        self.axis = axis
        return self
    }
    @discardableResult
    func addingArrangedSubviews(_ arrangedSubviews: [UIView]) -> UIStackView {
        arrangedSubviews.forEach {
            self.addArrangedSubview($0)
        }
        return self
    }
    @discardableResult
    func preparedForAutolayout() -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension UIView {
    func subviews(@SubviewsBuilder content: () -> [UIView]) {
        for view in content() {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension UIViewController {
    var isInModal: Bool {
        if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
