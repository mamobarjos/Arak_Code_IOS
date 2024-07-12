//
//  ProductTableViewCell.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup() {
        productImageView.image = UIImage(named: "Summery Image")
        productImageView.contentMode = .scaleToFill
    }

    func customize(product: StoreProduct) {
        if let url = URL(string: product.storeProductsFile.first?.path ?? "") {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }
        titleLabel.text = product.name
        subTitleLabel.text = product.desc
        priceLabel.text = product.priceformated
    }

    func customize(product: RelatedProducts) {
        if let url = URL(string: product.storeProductFiles?.first?.path ?? "") {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }
        titleLabel.text = product.name
        subTitleLabel.text = product.desc
        priceLabel.text = product.priceformated
    }

    func customize(product: StubidRelatedProducts) {
      
        titleLabel.text = product.name
        subTitleLabel.text = ""
        priceLabel.text = product.priceformated
    }
}
