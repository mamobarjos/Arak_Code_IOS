//
//  ToolbarPickerView.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation
import UIKit
protocol ToolbarPickerViewDelegate: AnyObject {
    func didTapDone(toolbar: UIToolbar?)
}

class ToolbarPickerView: UIPickerView {

    public var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
      let doneButton = UIBarButtonItem(title: "Done".localiz(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolbar = toolBar
    }

    @objc func doneTapped() {
        toolbarDelegate?.didTapDone(toolbar: toolbar)
    }
}
