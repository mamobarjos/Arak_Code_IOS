//
//  ImageCell.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit
import FSPagerView
import AVKit
class ImageCell: FSPagerViewCell {

  typealias PlayVideoBlock = (String?) -> Void
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var playVideoButton: UIButton!

  private var path:String?
  private var playVideo: PlayVideoBlock?
  func setup(path: String?) {
    playVideoButton.isHidden = true
    self.path = path
   
    photoImageView.getAlamofireImage(urlString: path)
  }
  func setupVideo(path: String? ,  playVideo: PlayVideoBlock?) {
    self.playVideo = playVideo
    self.playVideoButton.isHidden = false
    self.path = path
    photoImageView.imageFromVideo(videoURL:  path)
  }
  @IBAction func PlayVideo(_ sender: Any) {
    self.playVideo?(path)
    
  }
}
