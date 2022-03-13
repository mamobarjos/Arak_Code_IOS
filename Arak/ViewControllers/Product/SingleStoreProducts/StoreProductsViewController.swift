//
//  StoreProductsViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import UIKit

class StoreProductsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var viewModel = StoreViewModel()
    private(set) var page = 1
    var storeId: Int?

    var products: [RelatedProducts] = [] {
        didSet {
            tableView.reloadData()
            if products.isEmpty {
                tableView.setEmptyView {
                    self.fetchDataIfNedded(page: 1)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.hiddenNavigation(isHidden: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataIfNedded()
    }

    private func fetchDataIfNedded(page: Int = 1) {
        guard let storeId = storeId else {
            return
        }
        self.showLoading()
        viewModel.getStoreProducts(storeId: storeId, page: page) {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }

            self?.products = self?.viewModel.getProducts() ?? []
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.register(ProductTableViewCell.self)
        tableView.separatorColor = .clear
    }
}

extension StoreProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProductTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let product = products[indexPath.row]
        cell.customize(product: product)
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getProducts().count - 1 && viewModel.canLoadMore {
            page += 1
            fetchDataIfNedded(page: page)
        }
    }
}
