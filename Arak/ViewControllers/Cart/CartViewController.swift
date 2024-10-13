//
//  CartViewController.swift
//  Rayhan
//
//  Created by Reham Khalil on 26/06/2024.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var specialNotesLabel: UILabel!
    @IBOutlet weak var paymentSummeryLabel: UILabel!
    @IBOutlet weak var cartTotalLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    @IBOutlet weak var specialNotesTextView: UITextView!
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    
    @IBOutlet weak var discountStackView: UIStackView!
    
    private var cartManager: CartManagerProtocol?
    
    var arakProducts: [ArakProduct] = [] {
        didSet {
            if arakProducts.isEmpty {
                tableView.setEmptyView(title: "Your Cart is empty".localiz(), onClickButton: {})
                self.tableView.reloadData()
                self.tableViewHeight.constant = self.view.frameWidth
                specialNotesTextView.isHidden = true
                specialNotesLabel.isHidden = true
                totalAmountLabel.isHidden = true
                placeOrderButton.isHidden = true
                paymentSummeryLabel.isHidden = true
                cartTotalLabel.isHidden = true
                subTotalPrice.isHidden = true
                deliveryPrice.isHidden = true
                discountPrice.isHidden = true
                totalPrice.isHidden = true
                return
            }
            
            tableView.restore()
            self.tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart".localiz()
        specialNotesLabel.text = "Special note".localiz()
        paymentSummeryLabel.text = "Payment summary".localiz()
        cartTotalLabel.text = "Cart total".localiz()
        totalAmountLabel.text = "Total amount".localiz()
        placeOrderButton.setTitle("Place order".localiz(), for: .normal)
        setupTableView()
        cartManager = CartManager()
        
        arakProducts = cartManager?.getCartProducts() ?? []
        fillCartData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: .cartUpdated, object: nil)
        
        specialNotesTextView.delegate = self
        specialNotesTextView.text = "Add your notes here".localiz()
        specialNotesTextView.textAlignment = Helper.appLanguage == "en" ? .left : .right
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func updateCartBadge(_ notification: Notification) {
        arakProducts = cartManager?.getCartProducts() ?? []
        fillCartData()
        
    }
    
    private func fillCartData() {
        let totalPrice = cartManager?.getCartProducts().reduce(0.0) { partialResult, product in
            let price = Double(product.price ?? "0.0") ?? 0.0
            return partialResult + (price * Double(product.quantity ?? 0))
        }
        
        if Helper.appLanguage != "en" {
            subTotalPrice.textAlignment = .left
            self.totalPrice.textAlignment = .left
        }
        subTotalPrice.text = String(format: "%.2f", totalPrice ?? 0) + " " + (Helper.currencyCode ?? "JD")
        self.totalPrice.text = String(format: "%.2f", totalPrice ?? 0) + " " + (Helper.currencyCode ?? "JD")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self)
    }
    
    @IBAction func buyButton(_ sender: Any) {
        if arakProducts.isEmpty == false {
            let vc = OrderAddressViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true )
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let product = arakProducts[indexPath.item]
        cell.setupCell(product: product)
        
        cell.plusButtonAction = {
            [weak self] in
            self?.cartManager?.increaseProductQuantity(product: product, variant: product.selectedVariant)
        }
        
        cell.minusButtonAction = {
            [weak self] in
            self?.cartManager?.decreaseProductQuantity(product: product, variant: product.selectedVariant)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arakProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
    }
}

extension CartViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add your notes here".localiz() {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "Add your notes here".localiz()
            textView.textColor = .lightGray
        }
    }
}
