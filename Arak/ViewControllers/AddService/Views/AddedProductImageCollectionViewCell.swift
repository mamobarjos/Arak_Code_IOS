//
//  AddedProductImageCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu Hdba on 22/07/2024.
//

import UIKit

class AddedProductImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var onDeleteImage: ((UIImage) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteButtonAction(_ sender: Any) {
        onDeleteImage?(imageView.image ?? UIImage())
    }
}
