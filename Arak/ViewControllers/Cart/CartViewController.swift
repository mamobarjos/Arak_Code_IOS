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
    
    
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    
    @IBOutlet weak var discountStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "Cart"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self)
    }

    @IBAction func buyButton(_ sender: Any) {
        let vc = SuccessOrderViewController.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true )
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        cell.setupCell(product: (cartItem[indexPath.item]))
        cell.plusButtonAction = {
            [weak self] in
            
        }
        
        cell.minusButtonAction = {
            [weak self] in
        }
        
        cell.deleteButtonAction = {
            [weak self] in
            
    }
    return cell
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
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
