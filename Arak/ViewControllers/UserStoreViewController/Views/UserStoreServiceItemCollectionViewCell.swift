//
//  UserStoreServiceItemCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu Hdba on 21/07/2024.
//

import UIKit

class UserStoreServiceItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var serviceContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    

    public func setupCell(with item: StoreUserService) {
        if item.id == 2 {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .center
        }
        serviceContainerView.backgroundColor = .background
        serviceContainerView.layer.cornerRadius = 19
        serviceContainerView.dropShadow(color: .lightGray, opacity: 0.16, offSet: CGSize(width: 0, height: 3), radius: 3)
        imageView.image = UIImage(named: item.image)
        serviceLabel.text = item.title
        serviceLabel.font = .font(for: .bold, size: 14)
    }
}
