//
//  HomeFilterCollectionViewCell.swift
//  Arak
//
//  Created by Osama Abu Hdba on 06/07/2024.
//

import UIKit
protocol HomeFilterCollectionViewCellDelegate: AnyObject {
    func didtapChooseFilter(_ sender: HomeFilterCollectionViewCell, adsType: AdsTypes)
}
class HomeFilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterLable: UILabel!
    @IBOutlet weak var filterTextField: UITextField!
    
    weak var delegate: HomeFilterCollectionViewCellDelegate?
    
    private var filterPickerView = ToolbarPickerView()
    private var filter: [(AdsTypes, String)] = [(.all, "All".localiz()), (.image, "Images".localiz()), (.video, "Video".localiz()), (.videoWeb, "Video Web".localiz()), (.store, "Stores".localiz())]
    private var choosedFilter: AdsTypes = .all
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
        filterTextField.delegate = self
        filterTextField.inputView = filterPickerView
        filterTextField.inputAccessoryView = filterPickerView.toolbar
    }
}

extension HomeFilterCollectionViewCell: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {

    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
      return filter.count
  }

  @objc func didTapDone(toolbar: UIToolbar?) {
      filterTextField.resignFirstResponder()
      delegate?.didtapChooseFilter(self, adsType: choosedFilter)
  }

  // return string from picker
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

      return filter[row].1
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      titleLabel.text = filter[row].1
      choosedFilter = filter[row].0
  }
}

extension HomeFilterCollectionViewCell: UITextFieldDelegate {
    
}
