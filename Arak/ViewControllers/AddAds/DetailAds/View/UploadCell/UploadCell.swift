//
//  UploadCell.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit
import FSPagerView
import Photos

class UploadCell: FSPagerViewCell {
  enum Action {
    case upload
    case play
    case delete
  }
  enum MediaType {
    case video
    case image
    case empty
  }
  typealias ActionBlock = ((Action)-> ())

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var uploadImageView: UIImageView!
  @IBOutlet weak var uploadButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!

  private var actionBlock: ActionBlock?

  func setup(type:MediaType , title:String , path:UIImage? ,actionBlock: ActionBlock?) {
    self.actionBlock = actionBlock
    if type == .empty {
      photoImageView.image = #imageLiteral(resourceName: "border")
      photoImageView.isHidden = false
      uploadButton.isHidden = false
      uploadImageView.isHidden = false
      deleteButton.isHidden = true
      uploadButton.setTitle(title.localiz(), for: .normal)
    }else {
      uploadButton.isHidden = true
      uploadImageView.isHidden = true
      deleteButton.isHidden = false
      photoImageView.image = path
    }
    uploadButton.removeShadow()
  }

  

  func setupVideo(type:MediaType , path:URL?,actionBlock: ActionBlock?) {
    self.actionBlock = actionBlock
    if type == .empty {
      photoImageView.image = #imageLiteral(resourceName: "border")
      photoImageView.isHidden = false
      uploadButton.isHidden = false
      uploadImageView.isHidden = false
      deleteButton.isHidden = true
    } else if type != .video {
      uploadButton.isHidden = true
      uploadImageView.isHidden = true
      photoImageView.getAlamofireImage(urlString: path?.absoluteString)
      deleteButton.isHidden = false
    }else {
      uploadButton.isHidden = true
      uploadImageView.isHidden = true
      photoImageView.addTapGestureRecognizer {
        self.actionBlock?(.play)
      }
      photoImageView.imageFromVideo(videoURL:path?.absoluteString)
      deleteButton.isHidden = false
    }
  }

  @IBAction func Delete(_ sender: Any) {
    actionBlock?(.delete)
  }
  
  @IBAction func Upload(_ sender: Any) {
    actionBlock?(.upload)
  }
  

}
