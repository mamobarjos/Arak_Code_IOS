//
//  SearchStoresViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 26/02/2022.
//

import UIKit

class SearchStoresViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    fileprivate(set) var query: String = "" {
        didSet {
            self.queryDidChange()
        }
    }

    fileprivate(set) var stores: [Store] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    var viewModel = StoresViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.placeholder = "placeHolder.Search Stores".localiz()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.separatorColor = .clear
        tableView.contentInset.bottom = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellClass: StroreTableViewCell.self)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hiddenNavigation(isHidden: false)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.query = searchTextField.text ?? ""
        print("Search text is \(searchTextField.text ?? "")")

    }

    func performSearchIfNeeded(){
        if !query.isEmpty {
            self.showLoading()
            viewModel.searchStores(query: self.query, compliation: {
                [weak self] error in
                    defer {
                        self?.stopLoading()
                    }

                    guard error == nil else {
                        self?.showToast(message: error)
                        return
                    }

                self?.stores = self?.viewModel.getSearchedStores() ?? []
            })
        }
    }

    func queryDidChange(){
        if self.query.count >= 3 {
            self.performSearchIfNeeded()
            tableView.isHidden = false
            self.view.layoutIfNeeded()
        } else if self.query.count == 0 {
            tableView.reloadData()
        }
    }

    @IBAction func searchAction(_ sender: Any) {
        performSearchIfNeeded()
    }
}

extension SearchStoresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cellClass: StroreTableViewCell.self, for: indexPath)
        let store = stores[indexPath.row]
        cell.custumizeCell(store: store)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = stores[indexPath.row]
        let vc = initViewControllerWith(identifier: StoreViewController.className, and: store.name ?? "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
        vc.storeId = store.id
        show(vc)
    }
}
