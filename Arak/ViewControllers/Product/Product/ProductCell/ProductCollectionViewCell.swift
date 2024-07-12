//
//  ProductCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu hdba on 20/02/2022.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func setup(product: RelatedProducts) {
        self.productImageView.backgroundColor = #colorLiteral(red: 0.1402117312, green: 0.2012455165, blue: 0.4366841316, alpha: 1)
        productImageView.image = UIImage(named: "Summery Image")
        if let url = URL(string: product.storeProductFiles?.first?.path ?? "") {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }
        self.productLabel.text = product.name
        self.shopNameLabel.text = product.name
        self.priceLabel.text = "$\(product.price ?? 0)"
    }
  }
