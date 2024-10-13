//
//  BannerItemCollectionViewCell.swift
//  CARDIZERR
//
//  Created by Osama Abu Hdba on 03/04/2022.
//

import UIKit
import FSPagerView
//import SDWebImage
class BannerItemCollectionViewCell: FSPagerViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!

    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    weak var vc: HomeViewController?
    var onAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        [
            frontImageView,
            titleLabel,
            descriptionLable,
            actionButton
        ].forEach {
            $0?.isHidden = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func setupCell(with banner: String) {
        bannerImageView.kf.setImage(with: URL(string: banner))
//        titleLabel.text =""
    }

    @IBAction func bannerAction(_ sender: Any) {
        self.onAction?()
    }

    @IBAction func buttonAction(_ sender: Any) {

    }
}
