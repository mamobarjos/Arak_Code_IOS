//
//  CartTableViewCell.swift
//  Rayhan
//
//  Created by Reham Khalil on 26/06/2024.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandlabel: UILabel!
    @IBOutlet weak var plusButton: UIImageView!
    @IBOutlet weak var minusButton: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var offerPricelabel: UILabel!
    
    var quantity = 0
    
    public var plusButtonAction: (() -> Void)?
    public var minusButtonAction: (() -> Void)?
    public var deleteButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let offerPrice = "1000,000 JD"
            offerPricelabel.setStrikethroughText(offerPrice, color: UIColor(hex: "#FF6E2E"))    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func setupCell(product: String) {
//        productImageView.kf.setImage(with: URL(string: product.image ?? ""))
//        titleLabel.text = product.title
//        priceLabel.text = product.unitPrice
//        brandlabel.text = product.categoryName
//        if let quantity = product.quantity {
//            quantityLabel.text = String(quantity)
//        }
        
        // Set the offer price with strikethrough and custom color
//        let offerPrice = "1000,000JD" 
//            offerPricelabel.setStrikethroughText(offerPrice, color: UIColor(hex: "#FF6E2E"))
        
    }
}

extension UILabel {
    func setStrikethroughText(_ text: String, color: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: color,
            .foregroundColor: color
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedString
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
