//
//  CBTabBarButton.swift
//  BubbleTabBar
//
//  Created by Anton Skopin on 28/11/2018.
//  Copyright © 2018 cuberto. All rights reserved.
//

import UIKit

public class CBTabBarItem: UITabBarItem {
    @IBInspectable public var tintColor: UIColor?
    @IBInspectable public var rightToLeft:Bool = false
}

public class CBTabBarButton: UIControl {

    var rightToLeft:Bool = false
    private var _isSelected: Bool = false
    override public var isSelected: Bool {
        get {
            return _isSelected
        }
        set {
            guard newValue != _isSelected else {
                return
            }
            setSelected(newValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }

    init(item: UITabBarItem) {
        super.init(frame: .zero)
          let image = item.image
        tabImage = UIImageView(image: image?.withRenderingMode(.alwaysOriginal))
        defer {
            self.item = item
            configureSubviews()
        }
    }

    private var currentImage: UIImage? {
        var maybeImage: UIImage?
        if _isSelected {
                maybeImage = item?.selectedImage ?? item?.image
            } else {
                maybeImage = item?.image
            }
        guard let image = maybeImage else {
            return nil
        }
        return image.renderingMode == .automatic ? image.withRenderingMode(.alwaysOriginal) : image
    }

    public var item: UITabBarItem? {
        didSet {
            tabImage.image = currentImage?.withRenderingMode(.alwaysOriginal)
            tabLabel.text = item?.title?.localiz()
            if let tabItem = item as? CBTabBarItem {
                if let color = tabItem.tintColor {
                    tintColor = color
                }
                rightToLeft = tabItem.rightToLeft
            }
        }
    }

    override public var tintColor: UIColor! {
        didSet {
            if _isSelected {
              tabImage.tintColor = UIColor(named: "Secondary")
            }
            tabLabel.textColor = tintColor
            tabBg.backgroundColor = UIColor(named: "Pink")
        }
    }

    private var tabImage = UIImageView()
    private var tabLabel = UILabel()
    private var tabBg = UIView()

    private let bgHeight: CGFloat = 42.0
    private var csFoldedBgTrailing: NSLayoutConstraint!
    private var csUnfoldedBgTrailing: NSLayoutConstraint!
    private var csFoldedLblLeading: NSLayoutConstraint!
    private var csUnfoldedLblLeading: NSLayoutConstraint!

    private var foldedConstraints: [NSLayoutConstraint] {
        return [csFoldedLblLeading, csFoldedBgTrailing]
    }

    private var unfoldedConstraints: [NSLayoutConstraint] {
        return [csUnfoldedLblLeading, csUnfoldedBgTrailing]
    }


    private func configureSubviews() {
        tabImage.contentMode = .center
        tabImage.translatesAutoresizingMaskIntoConstraints = false
        tabLabel.translatesAutoresizingMaskIntoConstraints = false
        if let font = UIFont(name: "DroidArabicKufi-Bold", size: 14) {
            tabLabel.font = font
        } else {
            tabLabel.font = UIFont.systemFont(ofSize: 14)
        }
        tabLabel.adjustsFontSizeToFitWidth = true
        tabBg.translatesAutoresizingMaskIntoConstraints = false
        tabBg.isUserInteractionEnabled = false
        tabImage.setContentHuggingPriority(.required, for: .horizontal)
        tabImage.setContentHuggingPriority(.required, for: .vertical)
        tabImage.setContentCompressionResistancePriority(.required, for: .horizontal)
        tabImage.setContentCompressionResistancePriority(.required, for: .vertical)

        self.addSubview(tabBg)
        self.addSubview(tabLabel)
        self.addSubview(tabImage)

        tabBg.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tabBg.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tabBg.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tabBg.heightAnchor.constraint(equalToConstant: bgHeight).isActive = true
        
        if rightToLeft {
            tabImage.centerXAnchor.constraint(equalTo: tabBg.centerXAnchor).isActive = true
            tabImage.centerYAnchor.constraint(equalTo: tabBg.centerYAnchor).isActive = true
            tabLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15).isActive = true
            tabLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            tabLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            csFoldedLblLeading = tabLabel.leadingAnchor.constraint(equalTo: tabBg.trailingAnchor)
//            csUnfoldedLblLeading = tabLabel.leadingAnchor.constraint(equalTo: tabBg.trailingAnchor)
//            csFoldedBgTrailing = tabImage.trailingAnchor.constraint(equalTo: tabBg.leadingAnchor, constant: bgHeight/2.0)
//            csUnfoldedBgTrailing = tabImage.trailingAnchor.constraint(equalTo: tabBg.leadingAnchor, constant: bgHeight/2.0)
        } else {
            tabImage.centerXAnchor.constraint(equalTo: tabBg.centerXAnchor).isActive = true
            tabImage.centerYAnchor.constraint(equalTo: tabBg.centerYAnchor).isActive = true
            tabLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15).isActive = true
            tabLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            tabLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            csFoldedLblLeading = tabLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
//            csUnfoldedLblLeading = tabLabel.leadingAnchor.constraint(equalTo: tabImage.trailingAnchor, constant: bgHeight/4.0)
//            csFoldedBgTrailing = tabImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bgHeight/2.0)
//            csUnfoldedBgTrailing = tabLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bgHeight/2.0)
        }
        
        fold()
        setNeedsLayout()
    }

    private func fold(animationDuration duration: Double = 0.0) {
        self.tabImage.tintColor = .gray
        self.tabLabel.textColor = .gray
//        unfoldedConstraints.forEach{ $0.isActive = false }
//        foldedConstraints.forEach{ $0.isActive = true }
//        UIView.animate(withDuration: duration) {
//            self.tabBg.alpha = 0.0
//        }
//        UIView.animate(withDuration: duration * 0.4) {
//            self.tabLabel.alpha = 0.0
//        }
//        UIView.transition(with: tabImage, duration: duration, options: [.transitionCrossDissolve], animations: {
//
//        }, completion: nil)

    }

    private func unfold(animationDuration duration: Double = 0.0) {
        self.tabImage.tintColor = UIColor(named: "accentOrange")
        self.tabLabel.textColor = UIColor(named: "accentOrange")
//        foldedConstraints.forEach{ $0.isActive = false }
//        unfoldedConstraints.forEach{ $0.isActive = true }
//        UIView.animate(withDuration: duration) {
//            self.tabBg.alpha = 1.0
//        }
//        UIView.animate(withDuration: duration * 0.5, delay: duration * 0.5, options: [], animations: {
//            self.tabLabel.alpha = 1.0
//        }, completion: nil)
//        UIView.transition(with: tabImage, duration: duration, options: [.transitionCrossDissolve], animations: {
//            self.tabImage.tintColor = UIColor(named: "Secondary")
//        }, completion: nil)
    }

    public func setSelected(_ selected: Bool, animationDuration duration: Double = 0.0) {
        _isSelected = selected
         UIView.transition(with: tabImage, duration: 0.05, options: [.beginFromCurrentState], animations: {
            self.tabImage.image = self.currentImage
        }, completion: nil)
        if selected {
            unfold(animationDuration: duration)
        } else {
            fold(animationDuration: duration)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        tabBg.layer.cornerRadius = tabBg.bounds.height / 2.0
    }
}
