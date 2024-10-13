//
//  AdsHomeFilterCollectionReusableView.swift
//  Arak
//
//  Created by Osama Abu Hdba on 03/08/2024.
//

import UIKit

protocol AdsHomeFilterCollectionReusableViewDelegate: AnyObject {
    func didtapChooseFilter(_ sender: AdsHomeFilterCollectionReusableView, adsType: AdCategory)
}

class AdsHomeFilterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var filterLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    
    weak var delegate: AdsHomeFilterCollectionReusableViewDelegate?
    
    private var filterPickerView = ToolbarPickerView()
    public var filter: [AdCategory] = []
    private var choosedFilter: AdCategory?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterLable.text = "Filter Ads".localiz()
        titleLabel.text = "All".localiz()
        setupPickerView()
    }

    private func setupPickerView() {
        filterPickerView.toolbarDelegate = self
        filterPickerView.dataSource = self
        filterPickerView.delegate = self
        filterTextField.tintColor = .clear
//        filterTextField.delegate = self
        filterTextField.inputView = filterPickerView
        filterTextField.inputAccessoryView = filterPickerView.toolbar
    }
}

extension AdsHomeFilterCollectionReusableView: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {

    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
      return filter.count
  }

  @objc func didTapDone(toolbar: UIToolbar?) {
      filterTextField.resignFirstResponder()
      guard let choosedFilter else {return}
      delegate?.didtapChooseFilter(self, adsType: choosedFilter)
  }

  // return string from picker
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

      return Helper.appLanguage == "en" ? filter[row].nameEn : filter[row].nameAr
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      titleLabel.text = Helper.appLanguage == "en" ? filter[row].nameEn : filter[row].nameAr
      choosedFilter = filter[row]
  }
}
