//
//  PageControll.swift
//  Arak
//
//  Created by Osama Abu hdba on 21/02/2022.
//

import UIKit

class PageControl: ViewWithSetup {

    let containerStackView = UIStackView()
    var itemViews: [ItemView] = []

    var numberOfPages: Int = 3 {
        didSet {
            resetItems()
        }
    }

    var selectedIndex: Int = 0 {
        didSet {
            resetSeelctedItem()
        }
    }

    override func setup() {
        subviews {
            containerStackView
        }

        containerStackView.distribution = .equalCentering
        containerStackView.alignment = .center
        containerStackView.axis = .horizontal
        containerStackView.spacing = 6

        containerStackView.layout.fill(.superview)
        resetItems()
    }

    func resetItems() {
        itemViews.forEach {
            containerStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        itemViews = []

        (0..<numberOfPages).forEach {
            let newItemView = ItemView()
            newItemView.isSelected = selectedIndex == $0
            self.itemViews.append(newItemView)
            self.containerStackView.addingArrangedSubviews([newItemView])
        }
    }

    func resetSeelctedItem() {
        UIView.animate(withDuration: 0.3) {
            self.itemViews.enumerated().forEach {
                $0.element.isSelected = $0.offset == self.selectedIndex
            }
        }
    }
}


extension PageControl {
    class ItemView: ViewWithSetup {

        var isSelected: Bool = false {
            didSet {
                backgroundColor = isSelected ? .background : UIColor.background.withAlphaComponent(0.15)
            }
        }

        override func setup() {
            clipsToBounds = true
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.layout
                .width(to: 14)
                .height(to: 6)
        }

//        override var intrinsicContentSize: CGSize {
//            .init(width: 14, height: 6)
//        }
    }
}

