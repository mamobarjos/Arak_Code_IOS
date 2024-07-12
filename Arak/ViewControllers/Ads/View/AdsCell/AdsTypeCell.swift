//
//  AdsCell.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import UIKit
class AdsTypeCell: UITableViewCell {

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var parentView: UIView!

    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
  override func awakeFromNib() {
        super.awakeFromNib()
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configeUI(adCategory: AdsCategory?) {
        parentView.addShadow(position: .bottom)
        titleLabel.text = adCategory?.categoryTitle
        titleLabel.textAligment()
        let path = adCategory?.img
        if let string2 = path?.replacingOccurrences(of: "\\", with: ""){
            print(string2)
            if adCategory?.id == 1{
                photoImageView.image = UIImage(named: "ImageAds")
            }
            if adCategory?.id == 2{
                photoImageView.image = UIImage(named: "VideoAds")
            }
            if adCategory?.id == 3{
                photoImageView.image = UIImage(named: "WebsiteAds")
            }
            // photoImageView.getAlamofireImage(urlString: string2)
        }
    }

}
