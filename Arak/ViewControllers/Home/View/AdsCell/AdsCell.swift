//
//  AdsCell.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import UIKit
import FSPagerView
import AVKit
import Player
class AdsCell: FSPagerViewCell {
    typealias PlayVideo = () -> Void
    typealias FavorateBlock = () -> Void
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var gradiantImageView: UIImageView!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var favorateButton: UIButton!
    @IBOutlet weak var timerImageView: UIImageView!
    
    private var playVideo: PlayVideo?
    private var favorateBlock: FavorateBlock?
    var learnMoreBlock: FavorateBlock?
    private var  player = Player()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoImageView.sd_cancelCurrentImageLoad()
        titleLabel.text = ""
        timeCountLabel.text = ""
        typeLabel.text = ""
        
    }
    
    func setupBanner(path: String) {
        learnMoreButton.isHidden = false
        learnMoreButton.setTitle("Learn More".localiz(), for: .normal)
        titleLabel.isHidden = true
        timeCountLabel.isHidden = true
        favorateButton.isHidden = true
        typeView.isHidden = true
        timerImageView.isHidden = true
        gradiantImageView.isHidden = true
        photoImageView.getAlamofireImage(urlString: path)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        
    }
    func setup(indexItem: Int,isFavorate: Bool,ads: Adverisment,playVideo: PlayVideo?,favorateBlock:FavorateBlock?) {
        learnMoreButton.isHidden = true
        typeView.isHidden = false
        timerImageView.isHidden = false
        gradiantImageView.isHidden = false
        timeCountLabel.isHidden = false
        self.playVideo = playVideo
        self.favorateBlock = favorateBlock
        titleLabel.text = ads.title ?? ""
        favorateButton.isHidden = true //!isFavorate to enable favorate if you want
        favorateButton.setImage(ads.isFav || isFavorate ? #imageLiteral(resourceName: "Icon awesome-heart") : #imageLiteral(resourceName: "Icon awesome-heart-1"), for: .normal)
        let path = ads.adImages?.first?.path ?? ""
        if ads.adCategoryID == AdsTypes.image.rawValue {
            photoImageView.getAlamofireImage(urlString: path)
            typeLabel.text = "Image".localiz()
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(ads.duration ?? "5") ?? 5)
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
            
            if m == 0 && h == 0 && s == 0 {
                timeCountTitle = timeCountTitle + ("\(0) " + "s".localiz())
            }
            timeCountLabel.text = timeCountTitle
        }else if ads.adCategoryID == AdsTypes.video.rawValue {
            photoImageView.getAlamofireImage(urlString: ads.thumbUrl)
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(ads.duration ?? "5") ?? 5)
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
            
            if m == 0 && h == 0 && s == 0 {
                timeCountTitle = timeCountTitle + ("\(0) " + "s".localiz())
            }
            timeCountLabel.text = timeCountTitle
            photoImageView.addTapGestureRecognizer {
                self.playVideo?()
            }
            
            typeLabel.text = "Video".localiz()
        } else if ads.adCategoryID == AdsTypes.videoWeb.rawValue {
            photoImageView.getAlamofireImage(urlString: path)
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(ads.duration ?? "5") ?? 5)
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
            
            if m == 0 && h == 0 && s == 0 {
                timeCountTitle = timeCountTitle + ("\(0) " + "s".localiz())
            }
            
            timeCountLabel.text = timeCountTitle
            typeLabel.text = "Website".localiz()
            titleLabel.text = ads.title ?? ""
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func Favorate(_ sender: Any) {
        favorateBlock?()
    }
    
    @IBAction func learnMoreButtonAction(_ sender: Any) {
        learnMoreBlock?()
    }
}
