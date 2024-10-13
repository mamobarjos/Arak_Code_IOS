//
//  AdsTypeCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu Hdba on 26/08/2024.
//

import UIKit

class AdsTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    
    var onButtonAction: (() -> Void)?
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
  override func awakeFromNib() {
        super.awakeFromNib()
  }


    func configeUI(adCategory: AdCategory?) {
//        parentView.addShadow(position: .bottom)
        titleLabel.text = adCategory?.categoryTitle
        titleLabel.font = .font(for: .bold, size: 18)
//        titleLabel.textAligment()
        let path = "adCategory?.img"
        //        if let string2 = path?.replacingOccurrences(of: "\\", with: ""){
        //            print(string2)
        if adCategory?.id == 1{
            photoImageView.image = UIImage(named: "ImageAds")
        }
        if adCategory?.id == 2{
            photoImageView.image = UIImage(named: "VideoAds")
        }
        if adCategory?.id == 3{
            photoImageView.image = UIImage(named: "WebsiteAds")
        }
        if adCategory?.id == 4{
            photoImageView.image = UIImage(named: "creat_store_ad")
        }
        // photoImageView.getAlamofireImage(urlString: string2)
        }
//    }

    @IBAction func buttonAction(_ sender: Any) {
        onButtonAction?()
    }
}
