//
//  RankCell.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 05/07/2021.
//

import UIKit

class RankCell: UITableViewCell {
    @IBOutlet weak var rankTitleLabel: UILabel!
    @IBOutlet weak var revenueTitleLabel: UILabel!
    @IBOutlet weak var revenueNumberLabel: UILabel!
    @IBOutlet weak var webSiteTitleLabel: UILabel!
    @IBOutlet weak var webSiteNumberLabel: UILabel!
    @IBOutlet weak var imageViewTitleLabel: UILabel!
    @IBOutlet weak var imageViewNumberLabel: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoNumberLabel: UILabel!
    @IBOutlet weak var rankNumberLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    func setup(with user: User, rank: Int) {
        rankTitleLabel.text = "Ranking".localiz()
        revenueTitleLabel.text = "Total Revenue".localiz()
        revenueNumberLabel.text = "\(user.balanceTitle)"
        webSiteTitleLabel.text = "Web View".localiz()
        webSiteNumberLabel.text = "\(user.adsWebsiteViews ?? 0)"
        imageViewTitleLabel.text = "Image View".localiz()
        imageViewNumberLabel.text = "\(user.adsWebsiteViews ?? 0)"
        videoTitleLabel.text = "Video View".localiz()
        videoNumberLabel.text = "\(user.adsVideosViews ?? 0)"
        rankNumberLabel.text = "\(rank)"
//        countryLabel.text = user.country ?? ""
        nameLabel.text = user.fullname ?? ""
        photoImageView.getAlamofireImage(urlString: user.imgAvatar)
    }
}
