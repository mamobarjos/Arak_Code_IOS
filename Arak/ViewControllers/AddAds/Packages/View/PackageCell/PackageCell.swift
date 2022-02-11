//
//  PackageCell.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit

class PackageCell: UICollectionViewCell {
  @IBOutlet weak var reachLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var imageLabel: UILabel!
  @IBOutlet weak var secoundsLabel: UILabel!
  @IBOutlet weak var imageGroupView: UIView!

  func setup(package: Package) {
    self.addShadow(position: .bottom)
    reachLabel.text = "\(package.reach ?? "0") \("Reach".localiz())"
    priceLabel.text = "\(package.price ?? 0) \("JOD".localiz())"
    secoundsLabel.text = String.init(format: "Up To %@ Secounds".localiz(), arguments: [package.seconds ?? ""])
    imageLabel.text = package.imageTitle
    imageGroupView.isHidden = package.isVideo
  }
}
