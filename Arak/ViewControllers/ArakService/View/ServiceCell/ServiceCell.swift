//
//  ServiceCell.swift
//  Arak
//
//  Created by Abed Qassim on 13/06/2021.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serviceImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        serviceImageView.image = nil
        descriptionLabel.text = ""
        titleLabel.text = ""
    }

    func setup(service: Service) {
        titleLabel.text = service.titleTitle
        serviceImageView.getAlamofireImage(urlString: service.img)
        descriptionLabel.text = service.descTitle
    }
    
}
