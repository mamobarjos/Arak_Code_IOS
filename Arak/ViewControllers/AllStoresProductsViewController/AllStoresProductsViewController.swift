//
//  AllStoresProductsViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 20/07/2024.
//

import UIKit

class AllStoresProductsViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchStoreTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var horizontalTagView: HorizontalTagView!
    
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    
    private var storesViewModel: StoresViewModel = StoresViewModel()
    private var storeViewModel: StoreViewModel = StoreViewModel()
    
    private var viewModel: HomeViewModel = HomeViewModel()
    
    var products: [StoreProduct] = [] {
        didSet {
            collectionView.reloadData()
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getProducts(storeId: 1)
        fetchStores()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewProductCollectionViewCell.self)
        
    }
    
    private func getProducts(storeId: Int) {
        storeViewModel.getStore(stroeId: storeId, complition: {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }
            self?.products = self?.storeViewModel.getStoreProduct() ?? []
            self?.products.append(contentsOf: self?.storeViewModel.getStoreProduct() ?? [])
        })
    }
    
    private func fetchStores(page: Int = 1 ,fillCategories: Bool = true) {
        self.showLoading()
        storesViewModel.getStores(page:page) { [weak self] error in
            defer {
                self?.stopLoading()
            }

            guard error == nil else {
                self?.showToast(message: error)
                return
            }
            if fillCategories {
                self?.horizontalTagView.items = []
                self?.horizontalTagView.items.append(.init(id: -1, imageURL: "", title: "action.All".localiz(), storeId: -1))
                self?.storesViewModel.getCategories().forEach({
                    self?.horizontalTagView.items.append(.init(id: $0.id, imageURL: "", title: Helper.appLanguage ?? "en" == "en" ? $0.name : $0.arName, storeId: $0.id))
                })
                self?.horizontalTagView.selectedItemID = -1
            }
        }
    }
    @IBAction func searchAction(_ sender: Any) {
            let vc = initViewControllerWith(identifier: SearchStoresViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! SearchStoresViewController
            show(vc)
    }
}

extension AllStoresProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = products[indexPath.item]
        let cell: NewProductCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setupCell(with: item, hideAddToCart: false)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 2) - 20, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
}
