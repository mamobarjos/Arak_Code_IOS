//
//  HorizontalTagCollectionViewCell.swift
//  CARDIZERR
//
//  Created by Osama Abu Hdba on 11/02/2023.
//

import UIKit

class HorizontalTagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var mainCategoryImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!

    var tagIsSelected: Bool = false
    var onAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with item: TagItem ,animate: Bool) {
        mainCategoryImageView.layer.cornerRadius = 35
//        categoryNameLabel.textColor = .accent
//        mainCategoryImageView.contentMode = .scaleToFill
        categoryNameLabel.font = .font(for: .regular, size: 12)
        self.bringSubviewToFront(actionButton)
//        mainCategoryImageView.layer.borderWidth = 2
//        mainCategoryImageView.layer.borderColor = UIColor.accentOrange.cgColor
        updateStyle()
//        if animate {
//            let animations = [AnimationType.vector((CGVector(dx: 150, dy: 0))),
//                              AnimationType.zoom(scale: 0.6)]
//            UIView.animate(views: [self],
//                           animations: animations,
//                           duration: 2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.allowUserInteraction])
//        }
    }

    private func updateStyle() {
        if tagIsSelected {
            self.mainCategoryImageView.borderWidth = 2
            self.mainCategoryImageView.borderColor = .accentOrange
            self.categoryNameLabel.font = .font(for: .bold, size: 12)
        } else {
            self.mainCategoryImageView.borderWidth = 0
            self.mainCategoryImageView.borderColor = .clear
            self.categoryNameLabel.font = .font(for: .regular, size: 12)
        }
    }

    @IBAction func tapItemAction(_ sender: Any) {
        self.onAction?()
    }
}
