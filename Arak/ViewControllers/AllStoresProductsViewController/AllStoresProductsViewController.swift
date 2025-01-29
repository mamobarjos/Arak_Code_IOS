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
    
    @IBOutlet weak var productsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var horizontalTagView: HorizontalTagView!
    
    private let inset: CGFloat = 0
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    private var pageFeatured = 1
//    private var storesViewModel: StoresViewModel = StoresViewModel()
//    private var storeViewModel: StoreViewModel = StoreViewModel()
    
    private var viewModel: ArakStoreViewModel = ArakStoreViewModel()
    private(set) var categoryId = -1 {
        didSet {
            pageFeatured = 1
        }
    }
    var products: [ArakProduct] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    deinit {
          NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: .cartUpdated, object: nil)
        setupCollectionView()
        getProducts()
        productsLabel.text = "Products".localiz()
        horizontalTagView.delegate = self
        getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        stopLoading()
    }

    @objc func updateCartBadge(_ notification: Notification) {
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewProductCollectionViewCell.self)
        
    }
    
    private func getCategories() {
        viewModel.getStoreProductsCategories { [weak self] error in
            defer {
                self?.stopLoading()
            }
            
            guard error == nil else {
                self?.showToast(message: error)
                return
            }
           
            self?.horizontalTagView.items = []
            self?.horizontalTagView.items.append(.init(id: -1, imageURL: "", title: "action.All".localiz(), storeId: -1))
            self?.viewModel.getcategories().forEach({
                self?.horizontalTagView.items.append(.init(id: $0.id ?? 0, imageURL: $0.image?.src ?? "", title: $0.name ?? "", storeId: $0.id ?? 0))
            })
            self?.horizontalTagView.selectedItemID = -1
        }
        
    }
    
    private func getProducts() {
        showLoading()
        viewModel.getStoreProducts(by: categoryId, page: pageFeatured) { [weak self] error in
                defer {
                    self?.stopLoading()
                }

                if let error = error {
                    self?.showToast(message: error)
                }
            
                self?.products = self?.viewModel.getProducts() ?? []
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
        cell.setupCell(with: item, hideAddToCart: true)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       showLoading()
        let vc = initViewControllerWith(identifier: ProductDetailsViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductDetailsViewController
        vc.products = products[indexPath.item]
//        vc.productId = product.id
//        vc.storeId = storeId
//        vc.storeName = "Your Store"
        show(vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 2) - 5, height: 260)
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == products.count - 1 && viewModel.hasMoreProducts {
            pageFeatured += 1
            getProducts()
        }
    }
}

extension AllStoresProductsViewController: HorizontalTagViewDelegate {
    func didTapItem(item: TagItem) {
        self.categoryId = item.id
        getProducts()
    }
}
