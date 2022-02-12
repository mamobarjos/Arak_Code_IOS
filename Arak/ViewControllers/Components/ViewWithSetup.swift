//
//  ViewWithSetup.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

class ViewWithSetup: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {

    }
}
