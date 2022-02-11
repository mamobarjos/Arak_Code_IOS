//
//  TransactionCell.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import UIKit

class TransactionCell: UITableViewCell {

  @IBOutlet weak var trasnactionOperationImageView: UIImageView!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var transactionTypeImageView: UIImageView!

  func setup(transaction: Transaction) {
    contentView.backgroundColor  = transaction.transactionType == .income  ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1012641957) : .clear
    transactionTypeImageView.image = transaction.transactionType == .income ? #imageLiteral(resourceName: "UP") : #imageLiteral(resourceName: "DOWN")
    trasnactionOperationImageView.image = transaction.transactionType == .income ? #imageLiteral(resourceName: "+") : #imageLiteral(resourceName: "-")
    titleLabel.text = transaction.desc ?? ""
    dateLabel.text = transaction.createdAt?.convertTime(fromFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", toFormatter: "dd/MM/yyyy")
    valueLabel.text = transaction.valueAmountTitle
  }
}
