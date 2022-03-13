//
//  CategoryCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import UIKit
import WWLayout

class CategoryCollectionViewCell: UICollectionViewCell {

    enum ContentStyle {
        case selected
        case regular
    }

    let titleLabel: UILabel = .init()
    let imageView: UIImageView = .init()

    let deviderView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        layer.cornerRadius =  20
        clipsToBounds = true
        titleLabel.font = .font(for: .regular, size: 18)
        titleLabel.textColor = .text
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .accentOrange
        imageView.contentMode = .scaleAspectFit
        //        imageView.tintColor = UIColor(named: "tintPrimary")
        imageView.contentMode = .scaleAspectFit
        update(style: .regular)
        setupLayout()
    }

    fileprivate func setupLayout() {
        backgroundColor = .background
        subviews {
            titleLabel
            imageView
            deviderView
        }

        titleLabel.layout
            .leading(to: .superview, offset: 15)
            .center(in: .superview, axis: .y)
        imageView.layout
            .center(in: .superview, axis: .y)
            .trailing(to: .superview, offset: -50)
        deviderView.layout
            .bottom(to: .superview)
            .leading(to: .superview)
            .trailing(to: .superview)
            .height(to: 1)
        layoutIfNeeded()
    }

    func update(style: ContentStyle) {
        switch style {
        case .regular:
            imageView.image = UIImage(named: "")
            imageView.tintColor = .clear

        case .selected:
            imageView.image = UIImage(named: "Check (1)")
            imageView.tintColor = .accentOrange
            backgroundColor = .background
        }
    }
}
