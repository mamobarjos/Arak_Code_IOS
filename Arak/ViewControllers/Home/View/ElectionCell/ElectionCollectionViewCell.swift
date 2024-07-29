//
//  ElectionCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu Hdba on 28/07/2024.
//

import UIKit

protocol ElectionCollectionViewCellDelegate: AnyObject {
    func didUserTapOnCandidateItem(item: TagItem)
}

class ElectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var electionCollectionView: ElectionCollectionView!
    weak var delegate: ElectionCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        electionCollectionView.delegate = self
        
        // Initialization code
    }

}

extension ElectionCollectionViewCell: HorizontalTagViewDelegate {
    func didTapItem(item: TagItem) {
        self.delegate?.didUserTapOnCandidateItem(item: item)
    }
}

