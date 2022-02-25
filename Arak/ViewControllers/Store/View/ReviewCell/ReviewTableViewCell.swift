//
//  ReviewTableViewCell.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var ReviewerImage: UIImageView!
    @IBOutlet weak var titaleLabel: UILabel!
    @IBOutlet weak var cosmosContainerView: UIView!
    @IBOutlet weak var descLabel: UILabel!

    let cosmosView = CosmosView().then {
        $0.rating = 3
        $0.settings.fillMode = .full
        $0.settings.starSize = 16
        $0.settings.starMargin = 4
        $0.settings.filledColor = .accentOrange
        $0.settings.filledBorderColor = .accentOrange
        $0.settings.filledImage = UIImage(named: "Icon awesome-star")
        $0.settings.emptyImage = UIImage(named: "Icon awesome-star-2")
        $0.settings.updateOnTouch = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup() {
        cosmosContainerView.addSubview(cosmosView)
        cosmosView.layout
            .leading(to: .superview)
            .top(to: .superview)
            .bottom(to: .superview)

        ReviewerImage.image = UIImage(named: "You")
    }
    
}
