//
//  CategoryCollectionViewCell.swift
//  kees new kees
//
//  Created by Reham Khalil on 18/02/2024.
//

import UIKit
import Kingfisher

class MainCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWeekAndDayCell(_ title : String){
        titleLabel.text = title
    }
    
//    public func setupCell(product: CategoryList){
//        titleLabel.text = product.title
//        if let imageUrlString = product.image?.first, let imageUrl = URL(string: imageUrlString) {
//                productImageView.kf.setImage(with: imageUrl)
//        }
//    }
    
    
}
