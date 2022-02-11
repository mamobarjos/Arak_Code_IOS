//
//  AdsDetailCell.swift
//  Arak
//
//  Created by Abed Qassim on 10/06/2021.
//

import UIKit

protocol AdsDetailViewDelegate {
  func toggleSection(header: AdsDetailCell, section: Int)
}

class AdsDetailCell: UITableViewCell {
  @IBOutlet weak var adsTypeLabel: UILabel!
  @IBOutlet weak var adsTypeValueLabel: UILabel!
  @IBOutlet weak var reachLabel: UILabel!
  @IBOutlet weak var reachValueLabel: UILabel!
  @IBOutlet weak var totalReachValueLabel: UILabel!

  @IBOutlet weak var numberValueLabel: UILabel!
  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var timeValueLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var priceValueLabel: UILabel!

  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusView: UIView!
  @IBOutlet weak var detailView: UIView!
  
  var section: Int = 0
  var delegate: AdsDetailViewDelegate?

  static var nib:UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
    
    func setup(ads: Adverisment?) {
        guard let ads = ads else {
            return
        }
        titleLabel.text = ads.title ?? ""
        dateLabel.text = ads.createdAt?.convertTime(fromFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormatter: "dd/MM/yyyy")

        statusLabel.text = ads.statusTitle
        statusView.backgroundColor = ads.statusColor
        adsTypeLabel.text = "Ads Type".localiz()
        if ads.adCategoryID == AdsTypes.image.rawValue {
            adsTypeValueLabel.text = "Image ads".localiz()
            numberValueLabel.text = ads.package?.imageTitle
            iconImageView.image = #imageLiteral(resourceName: "picture")
        } else if ads.adCategoryID == AdsTypes.video.rawValue {
            adsTypeValueLabel.text = "Video ads".localiz()
            numberValueLabel.text = "\(1) \("Video".localiz())"
            iconImageView.image = #imageLiteral(resourceName: "video")
        } else if ads.adCategoryID == AdsTypes.videoWeb.rawValue {
            adsTypeValueLabel.text = "Website ads".localiz()
            numberValueLabel.text = "\(ads.package?.noOfImgs ?? 1) \("Website".localiz())"
            iconImageView.image = #imageLiteral(resourceName: "world-wide-web")
        }
        reachLabel.text = "Reach".localiz()
        reachValueLabel.text = "\(ads.views ?? 0)"
        totalReachValueLabel.text = ads.package?.reach ?? ""
        numberLabel.text = "Number".localiz()
        timeLabel.text = "Time".localiz()
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: (Int(ads.package?.seconds ?? "1") ?? 1))
        var timeCountTitle = ""
        if h > 0 {
            timeCountTitle = "\(h) " + "h".localiz()
        }
        if m > 0 {
            timeCountTitle = timeCountTitle + ("\(m) " + "m".localiz())
        }
        if s > 0 {
            timeCountTitle = timeCountTitle + ("\(s) " + "s".localiz())
        }
        timeValueLabel.text = timeCountTitle
        priceLabel.text = "Price".localiz()
        priceValueLabel.text =  "\(ads.package?.price ?? 0) \("JOD".localiz())"
        totalPriceLabel.text = ""
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
  static var identifier: String {
    return String(describing: self)
  }

  @IBAction func HeaderTapped(_ sender: Any) {
    delegate?.toggleSection(header: self, section: section)
  }

}
