//
//  CategoryCollectionViewCell.swift
//  kees new kees
//
//  Created by Reham Khalil on 18/02/2024.
//

import UIKit
import Kingfisher

class MainCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!

   var category: StoreCategory?
    
    var onAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWeekAndDayCell(_ title : String){
        titleLabel.text = title
    }
    
    public func setupCell(category: StoreCategory){
        self.category = category
        titleLabel.text = category.name
        productImageView.getAlamofireImage(urlString: category.iconUrl ?? "")
        
        if category.selected {
            containerView.borderWidth = 3
            containerView.borderColor = .accentOrange
        } else {
            containerView.borderWidth = 1
            containerView.borderColor = .lightGray
        }
    }
    
    
    @IBAction func cellButtonAction(_ sender: Any) {
        onAction?()
    }
}
