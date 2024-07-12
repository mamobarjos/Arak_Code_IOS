//
//  CategoriesCollectionViewCell.swift
//  CARDIZERR
//
//  Created by Osama Abu Hdba on 22/02/2023.
//

import UIKit

protocol CategoriesCollectionViewCellDelegate: AnyObject {
    func didUserTapOnItem(item: TagItem)
}

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var horizontalTagView: HorizontalTagView!

    weak var delegate: CategoriesCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        horizontalTagView.delegate = self
    }
}

extension CategoriesCollectionViewCell: HorizontalTagViewDelegate {
    func didTapItem(item: TagItem) {
        self.delegate?.didUserTapOnItem(item: item)
    }
}
