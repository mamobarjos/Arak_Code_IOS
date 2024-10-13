//
//  CustomCell.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 11/07/2021.
//

import UIKit

class CustomCell: UICollectionViewCell {
    typealias CustomBlock = () -> Void
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    
    private var customBlock:CustomBlock?
    
    override func awakeFromNib() {
        self.addShadow(position: .bottom)
//        contentView.addShadow(position: .all)
//        customView.addShadow(position: .all)
//        customView.borderWidth = 1
//        customView.borderColor = .lightGray
        customLabel.text = "Custom".localiz()
        customLabel.font = .font(for: .bold, size: 18)
    }
    
    func setup(customBlock:CustomBlock?)  {
        self.customBlock = customBlock
    }
    
    @IBAction func Add(_ sender: Any) {
        customBlock?()
    }
}
