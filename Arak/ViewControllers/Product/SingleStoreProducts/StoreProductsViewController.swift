//
//  StoreProductsViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import UIKit

class StoreProductsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = StoreViewModel()
    
    private let inset: CGFloat = 5
    private let minimumLineSpacing: CGFloat = 0
    private let minimumInteritemSpacing: CGFloat = 0
    
    private(set) var page = 1
    public var storeId: Int?
    public var mode: StoreMode = .add
    public var categoryId: Int?
    var products: [StoreProduct] = [] {
        didSet {
            if products.isEmpty {
                if collectionView == nil {return}
                collectionView.setEmptyView {
                    self.fetchDataIfNedded(page: 1)
                }
            } else {
                if collectionView == nil {return}
                collectionView.restore()
            }
        }
    }
    
    var selectedProduct: StoreProduct?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hiddenNavigation(isHidden: false)
        fetchDataIfNedded()
    }

    private func fetchDataIfNedded(page: Int = 1) {
        guard let storeId = storeId else {
            return
        }
        
        if products.isEmpty == false {
            collectionView.reloadData()
            return
        }
        
        self.showLoading()
//         if categoryId != nil {
//             viewModel.getStoreProductsByCategory(categoryId: categoryId ?? 1, page: page) {[weak self] error in
//                 defer {
//                     self?.stopLoading()
//                 }
//
//                 if let error = error {
//                     self?.showToast(message: error)
//                 }
//
//                 self?.products = self?.viewModel.getProducts() ?? []
//                 self?.collectionView.reloadData()
//             }
//            return
//        }

        if mode == .edit {
            viewModel.getUserProducts( page: page) {[weak self] error in
                defer {
                    self?.stopLoading()
                }

                if let error = error {
                    self?.showToast(message: error)
                }

                self?.products = self?.viewModel.getProducts() ?? []
                self?.collectionView.reloadData()
            }
        } else {
            viewModel.getStoreProducts(storeId: storeId, page: page) {[weak self] error in
                defer {
                    self?.stopLoading()
                }

                if let error = error {
                    self?.showToast(message: error)
                }

                self?.products = self?.viewModel.getProducts() ?? []
                self?.collectionView.reloadData()
            }
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewProductCollectionViewCell.self)
        
    }
}

extension StoreProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = products[indexPath.item]
        let cell: NewProductCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setupCell(with: item, hideAddToCart: true)
        if mode == .edit {
            cell.deleteButton.isHidden = false
        } else {
            cell.deleteButton.isHidden = true
        }
        
        cell.onDeleteButtonAction = { [weak self] in
            self?.showLoading()
            self?.viewModel.deleteProduct(productID: item.id ?? 0) { error in
                defer {
                    self?.stopLoading()
                }
                
                if error != nil {
                    self?.showToast(message: error)
                   
                    return
                }
                self?.products.removeAll()
                self?.showToast(message: "Product deleted successfully".localiz())
                self?.fetchDataIfNedded()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if mode == .edit {
            selectedProduct = product
            let openProductVC = initViewControllerWith(identifier: OpenProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! OpenProductViewController
            openProductVC.productName = product.name
            openProductVC.imageUrl = product.storeProductsFile.first?.path
            openProductVC.delegate = self
            self.present(openProductVC, animated: true)
            
        } else {
            selectedProduct = product
            let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
            vc.productId = product.id
            vc.storeId = storeId
            vc.storeName = "Your Store"
            show(vc)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 2) - 10, height: 260)
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


//extension StoreProductsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return products.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:ProductTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        let product = products[indexPath.row]
//        cell.customize(product: product)
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let product = products[indexPath.row]
//        if mode == .edit {
//            let vc = initViewControllerWith(identifier: AddServiceViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! AddServiceViewController
//            vc.mode = .edit
////            vc.relatedProduct = product
//            show(vc)
//        } else {
//            let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
//            vc.storeId = storeId
//            vc.storeName = "Your Store"
//            show(vc)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == viewModel.getProducts().count - 1 && viewModel.canLoadMore {
//            page += 1
//            fetchDataIfNedded(page: page)
//        }
//    }
//}

extension StoreProductsViewController: OpenProductViewControllerDelegate {
    func didUserTapViewProduct(_ sender: OpenProductViewController) {
        sender.dismissViewController()
        let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
        if storeId == nil || storeId == -1 {
            vc.storeId = selectedProduct?.store?.id
        } else {
            vc.storeId = storeId
        }
       
        vc.productId = selectedProduct?.id
        vc.storeName = "Your Store"
        show(vc)
    }
    
    func didUserTapEditProduct(_ sender: OpenProductViewController) {
        sender.dismissViewController()
        let vc = initViewControllerWith(identifier: AddServiceViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! AddServiceViewController
        vc.mode = .edit
        vc.product = selectedProduct
        show(vc)
    }
    
    
}
