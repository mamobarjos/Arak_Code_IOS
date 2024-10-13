//
//  ProductTableViewCell.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit
import Kingfisher
import Cosmos

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
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
        productImageView.image = UIImage(named: "Summery Image")
        if let url = URL(string: product.storeProductsFile.first?.path ?? "") {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }
        titleLabel.text = product.name
        subTitleLabel.text = product.desc
        priceLabel.text = product.priceformated
        salePriceLabel.text = (product.salePrice ?? "") + " " + (Helper.currencyCode ?? "JOD")
        ratingLabel.text = "[\(product.totalRates?.rounded(toPlaces: 1) ?? 5.0)]"
        cosmosView.rating = Double(product.totalRates ?? 5) ?? 5
        priceLabel.textColor = .lightGray
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.lightGray
        ]

        let attributedText = NSAttributedString(string: priceLabel.text ?? "", attributes: strokeTextAttributes)
        priceLabel.attributedText = attributedText
        
        priceLabel.isHidden = product.price == product.salePrice
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
