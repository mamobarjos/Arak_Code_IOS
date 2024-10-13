//
//  HomeStoreCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu Hdba on 21/08/2024.
//

import UIKit

class HomeStoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeDescLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var onButtonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setupCell(with store: Store) {
        storeImageView.image = nil
        storeDescLabel.text = ""
        storeDescLabel.text = ""
        
        if let storURL = URL(string: store.img ?? "") {
            storeImageView.kf.setImage(with: storURL, placeholder: UIImage(named: "Summery Image"))
        }

        storeDescLabel.text = store.desc
        storeNameLabel.text = store.name
        categoryNameLabel.text = Helper.appLanguage ?? "en" == "en" ? store.storeCategory?.name : store.storeCategory?.arName
    }
    
    @IBAction func cellButtonAction(_ sender: Any) {
        onButtonAction?()
    }
}
