//
//  StroreTableViewCell.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit
import Cosmos
import Kingfisher

class StroreTableViewCell: UITableViewCell {

    let containerView = UIView().then {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = UIColor.textSecondary.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let containerStackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 5
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.preparedForAutolayout()
    }

    let imageContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let bannerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
//        $0.image = UIImage(named: "")
//        $0.backgroundColor = .buttonBackGround
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let storeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 35
        $0.clipsToBounds = true
        $0.image = UIImage(named: "You")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let titleLabel = UILabel().then {
        $0.text = "Osama Store"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .text
        $0.font = .font(for: .regular, size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }


    let titlesStackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 5
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let descriptionLabel = UILabel().then {
        $0.text = "Osama Desc"
        $0.numberOfLines = 0
        $0.textAlignment = .right
        $0.textColor = .text
        $0.font = .font(for: .regular, size: 11)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let cosmosView = ConsmosItemView()


    var onCellTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setup()
     }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }


    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func setup() {

        contentView.backgroundColor = .background
//        contentView.layer.cornerRadius = 20
//        contentView.dropShadow()

        contentView.addSubview(containerView)
        containerView.addSubview(imageContainerView)
        containerView.addSubview(containerStackView)

        imageContainerView.addSubview(bannerImageView)
        imageContainerView.addSubview(storeImageView)
        imageContainerView.addSubview(titleLabel)

        containerStackView.arrangedSubviews {
            descriptionLabel
            cosmosView
        }


//        titlesStackView.layout
//            .leading(to: .superview)
//            .top(to: .superview)
//            .bottom(to: .superview)


        setupConstraints()

    }

    private func setupConstraints() {
        let containerViewMarginGuide = containerView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            imageContainerView.leadingAnchor.constraint(equalTo: containerViewMarginGuide.leadingAnchor),
            imageContainerView.topAnchor.constraint(equalTo: containerViewMarginGuide.topAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: containerViewMarginGuide.trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: 170),

            bannerImageView.leadingAnchor.constraint(
                equalTo: imageContainerView.layoutMarginsGuide.leadingAnchor, constant: 0),
            bannerImageView.topAnchor.constraint(
                equalTo: imageContainerView.layoutMarginsGuide.topAnchor, constant: 0),
            bannerImageView.trailingAnchor.constraint(
                equalTo: imageContainerView.layoutMarginsGuide.trailingAnchor, constant: -0),
            bannerImageView.bottomAnchor.constraint(
                equalTo: titleLabel.layoutMarginsGuide.bottomAnchor, constant: -0),
            bannerImageView.heightAnchor.constraint(equalToConstant: 125),

            storeImageView.leadingAnchor.constraint(
                equalTo: imageContainerView.layoutMarginsGuide.leadingAnchor, constant: 15),
            storeImageView.bottomAnchor.constraint(
                equalTo: imageContainerView.layoutMarginsGuide.bottomAnchor),
            storeImageView.heightAnchor.constraint(equalToConstant: 70),
            storeImageView.widthAnchor.constraint(equalToConstant: 70),

            titleLabel.topAnchor.constraint(
                equalTo: bannerImageView.bottomAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(
                equalTo: imageContainerView.layoutMarginsGuide.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(
                equalTo: imageContainerView.layoutMarginsGuide.bottomAnchor, constant: 0),

            containerStackView.leadingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15),
            containerStackView.topAnchor.constraint(
                equalTo: imageContainerView.bottomAnchor, constant: -5),
            containerStackView.trailingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -20),
            containerStackView.bottomAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -10),

        ])
    }

    func custumizeCell(store: Store) {
        cosmosView.cosmosView.rating = 0
        bannerImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""

        if let bannerURL = URL(string:store.cover ?? "") {
            bannerImageView.kf.setImage(with: bannerURL, placeholder: UIImage(named: "Summery Image"))
        }

        if let storURL = URL(string: store.img ?? "") {
            storeImageView.kf.setImage(with: storURL, placeholder: UIImage(named: "Summery Image"))
        }

        titleLabel.text = store.name
        descriptionLabel.text = Helper.appLanguage ?? "en" == "en" ? store.storeCategory.name : store.storeCategory.arName
        cosmosView.cosmosView.rating = store.totalRates ?? 0
        cosmosView.rateLabel.text = "(\(store.totalRates ?? 0))"
    }

    func custumizeCell(store: TestSearchModel) {
        cosmosView.cosmosView.rating = 0
        bannerImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""

        if let bannerURL = URL(string:store.cover ?? "") {
            bannerImageView.kf.setImage(with: bannerURL, placeholder: UIImage(named: "Summery Image"))
        }

        if let storURL = URL(string: store.img ?? "") {
            storeImageView.kf.setImage(with: storURL, placeholder: UIImage(named: "Summery Image"))
        }

        titleLabel.text = store.name
        descriptionLabel.text = "Electroics"
        cosmosView.cosmosView.rating = store.totalRates ?? 0
        cosmosView.rateLabel.text = "(\(store.totalRates ?? 0))"
    }
}

class ConsmosItemView: ViewWithSetup {
    let cosmosView = CosmosView().then {
        $0.rating = 3
        $0.settings.fillMode = .full
        $0.settings.starSize = 16
        $0.settings.starMargin = 4
        $0.settings.filledColor = .accentOrange
        $0.settings.filledBorderColor = .accentOrange
        $0.settings.filledImage = UIImage(named: "Icon awesome-star")
        $0.settings.emptyImage = UIImage(named: "Icon awesome-star-2")
        $0.settings.updateOnTouch = false
    }

    var rateLabel = UILabel().then {
        $0.text = "(3.0)"
        $0.textColor = .text
        $0.font = .font(for: .regular, size: 10)
    }

    override func setup() {
        self.layout.height(to: 20)
        subviews {
            cosmosView
            rateLabel
        }

        cosmosView.layout
            .trailing(to: .superview, offset: 3)
            .top(to: .superview)
            .bottom(to: .superview)
//            .centerX(to: .superview)
            .width(to: 100)

        rateLabel.layout
            .trailing(.equal, to: cosmosView, edge: .leading, offset: -5)
            .top(to: .superview)
            .bottom(to: .superview)
//            .centerX(to: .superview)

    }
}

