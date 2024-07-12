//
//  ImageCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu hdba on 20/03/2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func setup(productFile: StoreProductFile) {
        imageView.contentMode = .scaleToFill
        if let url = URL(string: productFile.path ?? "") {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }

    }
}
