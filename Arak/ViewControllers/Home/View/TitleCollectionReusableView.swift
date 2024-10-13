//
//  TitleCollectionReusableView.swift
//  Arak
//
//  Created by Osama Abu Hdba on 22/02/2023.
//

import UIKit

protocol TitleCollectionReusableViewDelegate: AnyObject {
    func didUserSelectFilteElection(governorate: District, district: District)
}

class TitleCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    private var filterPickerView = ToolbarPickerView()
    public var filter: EllectionFilters?
    weak var delegate: TitleCollectionReusableViewDelegate?
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
        guard let vc else {return}
        var governorates: [District] = filter?.governorates ?? []
        let districts: [District] = filter?.districts ?? []
        governorates.insert(District(id: nil, name: "All", nameAr: "الكل"), at: 0)
        if governorates.isEmpty {return}
        let customPicker = CustomPickerView(governorate: governorates, districts:[] )
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
    func didSelectItem(governorate: District, district: District) {
        print("Selected Item: \(governorate), \(district)")
        delegate?.didUserSelectFilteElection(governorate: governorate, district: district)
    }
}
