//
//  PrimaryActionButton.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import UIKit

class PrimaryActionButton: UIButton {

    enum Style {
        case rounded
        case halfRounded // :)
    }

    let style: Style
    let title: String
    var action: (() -> Void)?

    init(style: Style = .halfRounded, title: String) {
        self.style = style
        self.title = title
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setup() {
        tintColor = .accentOrange
        backgroundColor = .accentOrange
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .font(for: .bold, size: 18)
        setTitle(title, for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(holdDown(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(holdRelease(_:)), for: .touchUpOutside)
    }

    @objc func handleTap(_ sender: UIButton!) {
        backgroundColor = .accentOrange
        alpha = 1
        self.action?()
    }

    @objc func holdDown(_ sender:UIButton) {
        alpha = 0.7
    }

    @objc func holdRelease(_ sender:UIButton) {
        alpha = 1
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if style == .rounded { self.layer.cornerRadius = bounds.height / 2 } else {
            self.layer.cornerRadius = 15
        }
    }

    override var intrinsicContentSize: CGSize {
        .init(width: super.intrinsicContentSize.width, height: 55)
    }
}

