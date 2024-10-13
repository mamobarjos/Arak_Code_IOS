//
//  NotificationCell.swift
//  Arak
//
//  Created by Abed Qassim on 15/06/2021.
//

import UIKit
import ExpandableLabel

class NotificationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 1, green: 0.9411764706, blue: 0.8, alpha: 1) : .clear
        }
    }
    func setup(notification: NotificationModel) {
        titleLabel.text = "\(notification.title ?? "")"
        descLabel.text =  notification.description ?? ""
        self.contentView.backgroundColor = notification.isRead == true ? #colorLiteral(red: 1, green: 0.9411764706, blue: 0.8, alpha: 1) : .clear
        timeLabel.text = notification.createdAt?.convertTime(fromFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormatter: "yyyy-MM-dd hh:mm a")
    }
    

}
