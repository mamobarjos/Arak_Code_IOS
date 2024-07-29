//
//  TitleCollectionReusableView.swift
//  Arak
//
//  Created by Osama Abu Hdba on 22/02/2023.
//

import UIKit

class TitleCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    private var filterPickerView = ToolbarPickerView()
    private var filter: [(AdsTypes, String)] = [(.all, "All".localiz()), (.image, "One".localiz())]
    weak var vc: UIViewController?
    var onSeeAllAction: (() -> Void)?
    var onFilterAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDefaults()
        
    }

    private func setupDefaults() {
        filterButton.isHidden = true
        titleLabel.font = .font(for: .bold, size: 18)
        seeAllButton.setTitle("See more".localiz(), for: .normal)
        seeAllButton.titleLabel?.font = .font(for: .bold, size: 14)

    }
    
    @objc func showPicker() {
        guard let vc = vc else {return}
            let pickerData = ["All", "Option 1"]
            let customPicker = CustomPickerView(pickerData: pickerData)
            customPicker.delegate = self
            customPicker.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(customPicker)
            
            NSLayoutConstraint.activate([
                customPicker.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                customPicker.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
                customPicker.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
            ])
        }
    
    @IBAction func seeAllButtonAction(_ sender: Any) {
        onSeeAllAction?()
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        showPicker()
    }
}

extension TitleCollectionReusableView: CustomPickerViewDelegate {
    func didSelectItem(_ selectedItem: String) {
            print("Selected Item: \(selectedItem)")
            // Perform any action with the selected item
        }
}
