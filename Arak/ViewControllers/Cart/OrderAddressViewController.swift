//
//  OrderAddressViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 30/08/2024.
//

import UIKit
import DropDown

class OrderAddressViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var phoneNumbertextField: UITextField!
    @IBOutlet weak var phoneExtentionLabel: UILabel!
    @IBOutlet weak var choosePaymentMethodLabel: UILabel!
    @IBOutlet weak var choosePaymentMethodButton: UIButton!
    @IBOutlet weak var choosePaymentMethodStackView: UIStackView!
    @IBOutlet weak var choosePaymentMethodContainerView: UIView!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    private var cartManager: CartManagerProtocol?
    private var storeViewModel = CreateStoreViewModel()
    private var countryPickerView = ToolbarPickerView()
    private var cityPickerView = ToolbarPickerView()
    let walletsDropDown = DropDown()
    private var walletsType = ["WALLET","CARD"]
    private var paymentMethodsTitle = ["Arak Wallet","Card"]
    
    private var selectedWalletType: String = ""
    
    var countryId = -1
    var cityId = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shipping Details".localiz()
        setupPickerView()
        getCountry()
        setupDropDown()
        postCodeTextField.keyboardType = .numberPad
//        phoneNumbertextField.maxLength
        localization()
    }
    
    private func setupPickerView() {
        countryTextField.inputView = countryPickerView
        countryTextField.delegate = self
        countryPickerView.toolbarDelegate = self
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryTextField.inputAccessoryView = countryPickerView.toolbar
        
        cityTextField.inputView = cityPickerView
        cityTextField.delegate = self
        cityPickerView.toolbarDelegate = self
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        cityTextField.inputAccessoryView = cityPickerView.toolbar
    }
    
    private func localization() {
        firstNameTextField.placeholder = "First Name".localiz()
        lastNameTextField.placeholder = "Last Name".localiz()
        addressTextField.placeholder = "Address".localiz()
        countryTextField.placeholder = "Country".localiz()
        cityTextField.placeholder = "City".localiz()
        postCodeTextField.placeholder = "Post code".localiz()
        phoneNumbertextField.placeholder = "Phone Number".localiz()
        choosePaymentMethodLabel.text = "Choose Payment Method:".localiz()
        choosePaymentMethodButton.setTitle("", for: .normal)
        placeOrderButton.setTitle("Place order".localiz(), for: .normal)
        
    }
    
    private func getCity() {
        storeViewModel.getCity(by: countryId) {[weak self] _ in
            guard let self else { return }
            self.cityTextField.text = storeViewModel.cityList.first(where: {$0.id ?? 1 == Helper.currentUser?.cityID})?.name
            self.cityPickerView.reloadAllComponents()
        }
    }
    
    private func getCountry() {
        storeViewModel.getCountry { [weak self] _ in
            guard let self else {return}
          countryTextField.text = storeViewModel.countryList.first(where: {$0.id ?? 1 == Helper.currentUser?.countryID})?.name
            phoneExtentionLabel.text = storeViewModel.countryList.first(where: {$0.id ?? 1 == Helper.currentUser?.countryID})?.countryCode
            countryId = storeViewModel.countryList.first?.id ?? 1
            self.countryPickerView.reloadAllComponents()
            getCity()
      }
    }
    
    func setupDropDown() {
        [choosePaymentMethodContainerView, choosePaymentMethodButton].forEach({ view in
            view.addTapGestureRecognizer {
                [weak self] in
                self?.walletsDropDown.show()
            }
        })
        
//        choosePaymentMethodButton.setTitle( walletsType.first, for: .normal)

        Helper.setupDropDown(dropDownBtn: self.choosePaymentMethodContainerView, dropDown: walletsDropDown, stringsArr: walletsType) {[weak self] index, item in
            guard let self else {return}
            self.selectedWalletType = item
            choosePaymentMethodButton.setTitle( item, for: .normal)
        }
    }

    private func validateContent() -> CreateOrderForm?{
        if firstNameTextField.text?.isEmpty == true {
            self.showToast(message: "error.Please Enter First Name".localiz())
            return nil
        }
        
        if lastNameTextField.text?.isEmpty == true {
            self.showToast(message: "error.Please Enter Last Name".localiz())
            return nil
        }
        
        if addressTextField.text?.isEmpty == true {
            self.showToast(message: "error.Please Enter address".localiz())
            return nil
        }
        
//        if postCodeTextField.text?.isEmpty == true {
//            self.showToast(message: "error.Please Enter Post Code".localiz())
//            return nil
//        }
        
        if phoneNumbertextField.text?.isEmpty == true {
            self.showToast(message: "error.Please Enter Phone Number".localiz())
            return nil
        }
        
        if selectedWalletType.isEmpty == true {
            self.showToast(message: "error.Please Chooose Payment Type".localiz())
            return nil
        }
        
        var validPhone = phoneNumbertextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        validPhone = (phoneExtentionLabel.text ?? "+962") + validPhone
        cartManager = CartManager()
        let cart = cartManager?.getCartProducts()
        let items: [LineItem] = cart?.map({LineItem(productID: $0.id ?? 0, quantity: $0.quantity ?? 0, variantId: $0.selectedVariant?.id ?? 0)}) ?? []
        let form: CreateOrderForm  = .init(
            paymentType: selectedWalletType,
            paymentMethod: selectedWalletType,
            paymentMethodTitle: (selectedWalletType == "WALLET" ? paymentMethodsTitle.first : paymentMethodsTitle.last) ?? "",
            setPaid: true,
            billing: .init(
                firstName: firstNameTextField.text ?? "",
                lastName: lastNameTextField.text ?? "",
                address1: addressTextField.text ?? "",
                city: cityTextField.text ?? "",
                state: "CA",
//                postcode: postCodeTextField.text ?? "",
                country: countryTextField.text ?? "",
                phone: validPhone),
            shipping: .init(
                firstName: firstNameTextField.text ?? "",
                lastName: lastNameTextField.text ?? "",
                address1: addressTextField.text ?? "",
                city: cityTextField.text ?? "",
                state: "CA",
//                postcode: postCodeTextField.text ?? "",
                country: countryTextField.text ?? ""),
            lineItems: items)
        
        debugPrint(form)
        return form
    }
    
    private func openPaymnetGateWay(url: String) {
        let vc = PaymentWebViewController.loadFromNib()
        vc.delegate = self
        if let url = URL(string: url) {
            vc.url = url
            self.presentWithNavigation(vc, modalPresentationStyle: .overFullScreen)
        }
       
    }
    
    @IBAction func placeOrderButtonAction(_ sender: Any) {
        guard let content = validateContent() else {return}
        showLoading()
        Network.shared.request(request: StoresRout.createOrder(form: content), decodable: PlaceOrderModel.self) { [weak self] response, error in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            if content.paymentMethod == "WALLET" {
                self?.cartManager?.clearCart()
                let vc = SuccessOrderViewController.loadFromNib()
                self?.show(vc)
            } else {
                self?.openPaymnetGateWay(url: response?.data?.checkoutUrl ?? "")
            }
        }
    }
}

extension OrderAddressViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == cityTextField {
      cityPickerView.reloadAllComponents()
    } else if textField == countryTextField {
      countryPickerView.reloadAllComponents()
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension OrderAddressViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return storeViewModel.countryList.count
        } else if pickerView == cityPickerView {
            return storeViewModel.cityList.count
        }
        return 0
    }
    
    @objc func didTapDone(toolbar: UIToolbar?) {
       if countryPickerView.toolbar == toolbar {
            if (countryTextField.text ?? "").isEmpty {
                if !storeViewModel.countryList.isEmpty {
                    countryTextField.text = storeViewModel.countryList[0].name
                    phoneExtentionLabel.text = storeViewModel.countryList[0].countryCode

                    self.countryId = storeViewModel.countryList[0].id ?? -1
                    self.cityTextField.text = ""
                    self.cityId = -1
                    self.getCity()
                }
            }
        } else if cityPickerView.toolbar == toolbar {
            if (cityTextField.text ?? "").isEmpty {
                if !storeViewModel.cityList.isEmpty {
                    cityTextField.text = storeViewModel.cityList[0].name
                    cityId = storeViewModel.cityList[0].id ?? -1
                }
            }
        }
        countryTextField.endEditing(true)
        cityTextField.endEditing(true)
    }
    
    // return string from picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView {
            return storeViewModel.cityList[row].name
        } else if pickerView == countryPickerView {
            return storeViewModel.countryList[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if countryPickerView == pickerView {
            if !storeViewModel.countryList.isEmpty {
                countryTextField.text = storeViewModel.countryList[row].name
                phoneExtentionLabel.text = storeViewModel.countryList[row].countryCode
                cityTextField.text = ""
                self.countryId = storeViewModel.countryList[row].id ?? -1
                self.cityId = -1
                self.getCity()
            }
        } else if cityPickerView == pickerView {
            if !storeViewModel.cityList.isEmpty {
                cityTextField.text = storeViewModel.cityList[row].name
                cityId = storeViewModel.cityList[row].id ?? -1
            }
        }
    }
}

extension OrderAddressViewController: WebViewControllerDelegate {
    func didFinishWithPayment(get url: String, status: PaymentWebViewController.PaymentStatus) {
        switch status {
        case .Success:
            cartManager?.clearCart()
            let vc = SuccessOrderViewController.loadFromNib()
            self.show(vc)
        case .Failed:
            break
        }
    }
}


// MARK: - Order
struct CreateOrderForm: Codable {
    let paymentType: String
    let paymentMethod: String
    let paymentMethodTitle: String
    let setPaid: Bool
    let billing: Billing
    let shipping: Shipping
    let lineItems: [LineItem]

    enum CodingKeys: String, CodingKey {
        case paymentMethod = "payment_method"
        case paymentMethodTitle = "payment_method_title"
        case setPaid = "set_paid"
        case billing, shipping
        case lineItems = "line_items"
        case paymentType = "payment_type"
    }
}

// MARK: - Billing
struct Billing: Codable {
    let firstName: String
    let lastName: String
    let address1: String
    let city: String
    let state: String
//    let postcode: String
    let country: String
    let phone: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case address1 = "address_1"
        case city, state, country, phone
    }
}

// MARK: - Shipping
struct Shipping: Codable {
    let firstName: String
    let lastName: String
    let address1: String
    let city: String
    let state: String
//    let postcode: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case address1 = "address_1"
        case city, state, country
    }
}

// MARK: - LineItem
struct LineItem: Codable {
    let productID: Int
    let quantity: Int
    let variantId: Int

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case quantity
        case variantId = "variation_id"
    }
}


//{
//    "line_items": [
//        {
//            "quantity": 1,
//            "product_id": 188,
//            "variation_id": 191
//        }
//    ],
//    "set_paid": true,
//    "shipping": {
//        "city": "عمان",
//        "country": "الأردن",
//        "address_1": "cvvvv",
//        "last_name": "hujjbhvf",
//        "postcode": "765776",
//        "state": "CA",
//        "first_name": "ghgg"
//    },
//   
//    "billing": {
//        "phone": "+962796951946",
//        "city": "عمان",
//        "country": "الأردن",
//        "address_1": "cvvvv",
//        "postcode": "765776",
//        "last_name": "hujjbhvf",
//        "state": "CA",
//        "first_name": "ghgg"
//    },
//    "payment_method": "CARD",
//    "payment_method_title": "CARD",
//}
//
//
//{
//  "payment_type": "CARD",
//  "payment_method": "CARD",
//  "payment_method_title": "Credit Card",
//  "set_paid": true,
//  "billing": {
//    "first_name": "John",
//    "last_name": "Doe",
//    "address_1": "123 Main St",
//    "city": "Anytown",
//    "state": "CA",
//    "postcode": "90210",
//    "country": "US",
//    "phone": "+96279557234"
//  },
//  "shipping": {
//    "first_name": "John",
//    "last_name": "Doe",
//    "address_1": "123 Main St",
//    "city": "Anytown",
//    "state": "CA",
//    "postcode": "90210",
//    "country": "US"
//  },
//  "line_items": [
//    {
//      "product_id": 234,
//      "quantity": 2,
//      "variation_id": 239
//    }
//  ]
//}
