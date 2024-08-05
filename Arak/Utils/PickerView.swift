//
//  PickerView.swift
//  Arak
//
//  Created by Osama Abu Hdba on 28/07/2024.
//

import UIKit

protocol CustomPickerViewDelegate: AnyObject {
    func didSelectItem(governorate: District, district: District)
}

class CustomPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate: CustomPickerViewDelegate?

    private let pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private let governorates: [District]
    private let districts: [District]
    var selectedItem: (District, District)?
    
    private let titleLabel1 = UILabel()
    private let titleLabel2 = UILabel()
    
    init(governorate: [District], districts: [District]) {
        self.governorates = governorate
        self.districts = districts
        selectedItem = (governorate.first!, governorate.first!)
        super.init(frame: .zero)
        
        setupPickerView()
        setupToolbar()
        setupTitleLabels()
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
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .plain, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        addSubview(toolbar)
    }
    
    private func setupTitleLabels() {
        titleLabel1.text = "Governorates".localiz()
        titleLabel1.textAlignment = .center
        titleLabel2.text = "Districts".localiz()
        titleLabel2.textAlignment = .center
        titleLabel1.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel2.font = .systemFont(ofSize: 20, weight: .bold)
        toolbar.backgroundColor = .white
        titleLabel1.backgroundColor = .white
        titleLabel2.backgroundColor = .white
        addSubview(titleLabel1)
//        addSubview(titleLabel2)
    }
    
    private func setupLayout() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: topAnchor),
            
            titleLabel1.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel1.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel1.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            titleLabel1.heightAnchor.constraint(equalToConstant: 30),
            
//            titleLabel2.leadingAnchor.constraint(equalTo: centerXAnchor),
//            titleLabel2.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleLabel2.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
//            titleLabel2.heightAnchor.constraint(equalToConstant: 30),
//            
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func dismissPicker() {
        guard let selectedItem = selectedItem else { return }
        delegate?.didSelectItem(governorate: selectedItem.0, district: selectedItem.1)
        self.removeFromSuperview()
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return governorates.count
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (Helper.appLanguage == "en" ? governorates[row].name : governorates[row].nameAr)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem?.0 = governorates[row]
//        if component == 0 {
//           
//        } else {
//            selectedItem?.1 = districts[row]
//        }
    }
}
