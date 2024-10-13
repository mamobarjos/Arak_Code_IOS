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
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var cosmosRateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var containerCiew: UIView!
    
    private var cartManager: CartManagerProtocol?
    
    var onDeleteButtonAction: (() -> Void)?
    var product: ArakProduct?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setupCell(with storeProduct: StoreProduct, hideAddToCart: Bool) {
        deleteButton.isHidden = true
        storeNameLabel.text = storeProduct.desc
        imageView.contentMode = .scaleToFill
        imageView.getAlamofireImage(urlString: storeProduct.storeProductsFile.first?.path)
        productNameLabel.text = storeProduct.name
        priceLabel.text = storeProduct.priceformated 
        addToCartButton.isHidden = hideAddToCart
        storeNameLabel.isHidden = false
        priceLabel.text = storeProduct.priceformated
        salePriceLabel.text = (storeProduct.salePrice ?? "") + " " + (Helper.currencyCode ?? "JOD")
        ratingLabel.text = "[\(storeProduct.totalRates?.rounded(toPlaces: 1) ?? 5.0)]"
        cosmosView.rating = Double(storeProduct.totalRates ?? 5) ?? 5
        
        priceLabel.textColor = .lightGray
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.lightGray
        ]

        let attributedText = NSAttributedString(string: priceLabel.text ?? "", attributes: strokeTextAttributes)
        priceLabel.attributedText = attributedText
        
        priceLabel.isHidden = storeProduct.price == storeProduct.salePrice
    }
    
    public func setupCell(with storeProduct: ArakProduct, hideAddToCart: Bool) {
        deleteButton.isHidden = true
        self.product = storeProduct
//        cartManager = CartManager()
//        if cartManager?.isProductInCart(withId: storeProduct.id ?? 0, size: storeProduct.selectedSize, color: storeProduct.selectedColor) == true {
//            addToCartButton.tintColor = .lightGray
////            addToCartButton.isUserInteractionEnabled = false
//        } else {
//            addToCartButton.tintColor = .accentOrange
////            addToCartButton.isUserInteractionEnabled = true
//        }
        
        self.cornerRadius = 16
        containerCiew.cornerRadius = 16
        containerCiew.clipsToBounds = true
        containerCiew.backgroundColor = .background
        containerCiew.borderWidth = 1
        containerCiew.borderColor = .lightGray.withAlphaComponent(0.75)
//        self.dropShadow(offSet: .init(width: 0.1, height: 0.5),radius: 16)
//        containerCiew.dropShadow(offSet: .init(width: 0.1, height: 0.5),radius: 16)
        storeNameLabel.text = storeProduct.name
        imageView.contentMode = .scaleToFill
        imageView.getAlamofireImage(urlString: storeProduct.images?.first?.src)
        productNameLabel.text = storeProduct.name
        productNameLabel.numberOfLines = 2
        priceLabel.text = (storeProduct.price ?? "") + " " + (Helper.currencyCode ?? "JOD")
        addToCartButton.isHidden = hideAddToCart
        storeNameLabel.isHidden = true
        priceLabel.text = (storeProduct.price ?? "") + " " + (Helper.currencyCode ?? "JOD")
        salePriceLabel.text = (storeProduct.price ?? "") + " " + (Helper.currencyCode ?? "JOD")
        ratingLabel.text = "[\(storeProduct.averageRating ?? "5.0")]"
        cosmosView.rating = Double(storeProduct.averageRating ?? "5") ?? 5
        priceLabel.textColor = .lightGray
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.lightGray
        ]

        priceLabel.isHidden = true
        let attributedText = NSAttributedString(string: priceLabel.text ?? "", attributes: strokeTextAttributes)
        priceLabel.attributedText = attributedText
        
//        priceLabel.isHidden = storeProduct.price == storeProduct.salePrice
    }
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
//        cartManager = CartManager()
//        guard let product else {return}
//        if cartManager?.isProductInCart(withId: product.id ?? 0, size: product.selectedSize, color: product.selectedColor) == true {
//            cartManager?.deleteProduct(product, size: product.selectedSize, color: product.selectedColor)
//        } else {
//            cartManager?.addProduct(product, size: product.selectedSize, color: product.selectedColor)
//        }
        
        
        
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        onDeleteButtonAction?()
    }
}
