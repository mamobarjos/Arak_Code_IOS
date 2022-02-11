//
//  MoreCell.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 11/07/2021.
//

import FSPagerView

class MoreCell: FSPagerViewCell {
    typealias MoreBlock = () -> Void
    
    @IBOutlet weak var moreButton: UIButton!

    private var moreBlock:MoreBlock?
    
    func setup(moreBlock:MoreBlock?) {
        moreButton.setTitle("More".localiz(), for: .normal)
        self.moreBlock = moreBlock
    }
    
    @IBAction func More(_ sender: Any) {
        moreBlock?()
    }
}
