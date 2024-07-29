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
    
    @IBOutlet weak var specialAdsLogo: UIImageView!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var categorylabel: UILabel!
    //    @IBOutlet weak var gradiantImageView: UIImageView!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var typeView: UIView!
//    @IBOutlet weak var timeCountLabel: UILabel!
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var favorateButton: UIButton!
//    @IBOutlet weak var timerImageView: UIImageView!
    
    private var playVideo: PlayVideo?
    private var favorateBlock: FavorateBlock?
    var learnMoreBlock: FavorateBlock?
    private var  player = Player()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoImageView.sd_cancelCurrentImageLoad()
//        titleLabel.text = ""
//        timeCountLabel.text = ""
        typeLabel.text = ""
        categoryContainerView.isHidden = true
        specialAdsLogo.isHidden = true
        
    }
    
    func setupBanner(path: String) {
        categoryContainerView.isHidden = true
        specialAdsLogo.isHidden = true
        learnMoreButton.isHidden = false
        learnMoreButton.setTitle("Learn More".localiz(), for: .normal)
//        titleLabel.isHidden = true
//        timeCountLabel.isHidden = true
        favorateButton.isHidden = true
        typeView.isHidden = true
//        timerImageView.isHidden = true
//        gradiantImageView.isHidden = true
        photoImageView.getAlamofireImage(urlString: path)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        
    }
    func setup(indexItem: Int,isFavorate: Bool,ads: Adverisment, isSpecial: Bool = false,playVideo: PlayVideo?,favorateBlock:FavorateBlock?) {
        if isSpecial {
            specialAdsLogo.isHidden = false
            categoryContainerView.isHidden = true
            typeView.isHidden = true
            photoImageView.layer.cornerRadius = 0
        } else {
            specialAdsLogo.isHidden = true
            categoryContainerView.isHidden = false
            typeView.isHidden = false
            photoImageView.layer.cornerRadius = 7
        }
        
        learnMoreButton.isHidden = true
       
       
        categorylabel.text = "Electric"
        self.playVideo = playVideo
        self.favorateBlock = favorateBlock
//        titleLabel.text = ads.title ?? ""
        favorateButton.isHidden = !isFavorate
        favorateButton.setImage(ads.isFav ? #imageLiteral(resourceName: "Icon awesome-heart") : #imageLiteral(resourceName: "Icon awesome-heart-1"), for: .normal)
        let path = ads.adImages?.first?.path ?? ""
        if ads.adCategoryID == AdsTypes.image.rawValue {
            photoImageView.getAlamofireImage(urlString: path)
            typeLabel.text = "Image".localiz()
//            timeCountLabel.text = timeCountTitle
        }else if ads.adCategoryID == AdsTypes.video.rawValue {
            photoImageView.getAlamofireImage(urlString: ads.thumbUrl)
//            timeCountLabel.text = timeCountTitle
            photoImageView.addTapGestureRecognizer {
                self.playVideo?()
            }
            
            typeLabel.text = "Video".localiz()
        } else if ads.adCategoryID == AdsTypes.videoWeb.rawValue {
            photoImageView.getAlamofireImage(urlString: path)
//            timeCountLabel.text = timeCountTitle
            typeLabel.text = "Website".localiz()
//            titleLabel.text = ads.title ?? ""
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
