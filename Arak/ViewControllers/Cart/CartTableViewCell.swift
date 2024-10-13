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

    public func setupCell(product: ArakProduct) {
        titleLabel.text = product.name
        let totalPrice  = ((Double(product.price ?? "0.0") ?? 0.0))
        priceLabel.text = String(format: "%.2f", totalPrice) + " " + (Helper.currencyCode ?? "JD")
        brandlabel.text = (product.selectedVariant?.name ?? "")
        productImageView.getAlamofireImage(urlString: product.images?.map({$0.src ?? ""}).first )
        quantityLabel.text = "\(product.quantity ?? 1)"
        offerPricelabel.isHidden = true
        
        
        if product.quantity == 1 {
            minusButton.image = UIImage(systemName: "trash")
            minusButton.tintColor = .accentOrange
            minusButton.contentMode = .scaleAspectFit
        } else {
            minusButton.image = UIImage(named: "minus")
            minusButton.contentMode = .center
        }
        plusButton.addTapGestureRecognizer { [weak self] in
            self?.plusButtonAction?()
        }
        
        minusButton.addTapGestureRecognizer { [weak self] in
            self?.minusButtonAction?()
        }
        
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
