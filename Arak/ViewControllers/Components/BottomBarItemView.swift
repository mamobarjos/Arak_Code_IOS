//
//  BottomBarItemView.swift
//  Arak
//
//  Created by Osama Abu hdba on 19/02/2022.
//

import Foundation
import UIKit

class BottomBarItemView: ViewWithSetup {

    let stackView = UIStackView().then{
        $0.distribution(.fillEqually)
        $0.alignment(.fill)
        $0.preparedForAutolayout()
        $0.axis(.horizontal)
    }

    let phoneButton = UIButton().then {
        $0.setImage(UIImage(named: "Group 1425"), for: .normal)
    }

    let webButton = UIButton().then {
        $0.setImage(UIImage(named: "Group 1422"), for: .normal)
    }

    let locationButton = UIButton().then {
        $0.setImage(UIImage(named: "Group 1424"), for: .normal)
    }

    let whatsAppButton = UIButton().then {
        $0.setImage(UIImage(named: "Group 1423"), for: .normal)
    }

    var phoneAction: (() -> Void)?
    var webAction: (() -> Void)?
    var locationAction: (() -> Void)?
    var whatsAppAction: (() -> Void)?

    override func setup() {
        self.backgroundColor = .background
        self.dropShadow()

        self.layout.height(to: 90)
        addSubview(stackView)

        stackView.layout
            .leading(to: .superview, offset: 30)
            .trailing(to: .superview, offset: -30)
            .centerY(to: .superview)

        stackView.addingArrangedSubviews([
            phoneButton,
            webButton,
            locationButton,
            whatsAppButton
        ])

        [phoneButton, webButton, locationButton, whatsAppButton].forEach {
            $0.layout.height(to: 35).height(to: 35)
        }

        phoneButton.addTarget(self, action:#selector(handlePhoneTap), for: .touchUpInside)
        webButton.addTarget(self, action: #selector(handlewebTap), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(handlelocationTap), for: .touchUpInside)
        whatsAppButton.addTarget(self, action: #selector(handlewhatsAppTap), for: .touchUpInside)
    }

    @objc func handlePhoneTap() {
        self.phoneAction?()
    }

    @objc func handlewebTap() {
        self.webAction?()
    }

    @objc func handlelocationTap() {
        self.locationAction?()
    }

    @objc func handlewhatsAppTap() {
        self.whatsAppAction?()
    }
}
