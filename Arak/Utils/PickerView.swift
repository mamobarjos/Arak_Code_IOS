//
//  PickerView.swift
//  Arak
//
//  Created by Osama Abu Hdba on 28/07/2024.
//

import UIKit

protocol CustomPickerViewDelegate: AnyObject {
    func didSelectItem(_ selectedItem: String)
}

class CustomPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate: CustomPickerViewDelegate?

    private let pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private let pickerData: [String]
    var selectedItem: String?
    init(pickerData: [String]) {
        self.pickerData = pickerData
        selectedItem = pickerData.first
        super.init(frame: .zero)
        
        setupPickerView()
        setupToolbar()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        addSubview(pickerView)
    }
    
    private func setupToolbar() {
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        addSubview(toolbar)
    }
    
    private func setupLayout() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: topAnchor),
            
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func dismissPicker() {
        guard let selectedItem = selectedItem else {return}
        delegate?.didSelectItem(selectedItem)
        self.removeFromSuperview()
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selectedItem = pickerData[row]
        return selectedItem
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = pickerData[row]
        self.selectedItem = selectedItem
    }
}
