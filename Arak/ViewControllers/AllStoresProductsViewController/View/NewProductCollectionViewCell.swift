//
//  NewProductCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu Hdba on 20/07/2024.
//

import UIKit
import Cosmos
import Kingfisher

class NewProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var cosmosRateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setupCell(with storeProduct: StoreProduct, hideAddToCart: Bool) {
        imageView.contentMode = .scaleToFill
        imageView.getAlamofireImage(urlString: storeProduct.storeProductsFile.first?.path)
        productNameLabel.text = storeProduct.name
        priceLabel.text = storeProduct.priceformated 
        addToCartButton.isHidden = hideAddToCart
    }
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
        
    }
}
