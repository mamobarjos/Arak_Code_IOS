//
//  UserStoreViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 20/07/2024.
//

import UIKit
import Cosmos

struct StoreUserService {
    let id: Int
    let image: String
    let title: String
}
class UserStoreViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storeTitleLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var rateLabel: UILabel!
    
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    var storeViewModel: StoreViewModel = StoreViewModel()
    private var storeUserService: [StoreUserService] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        if let userStore = Helper.store {
            fillUI(with: userStore)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: true)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserStoreServiceItemCollectionViewCell.self)
        
        storeUserService = [
            .init(id: 1, image: "Add_product", title: "Add Product".localiz()),
            .init(id: 2, image: "shopping-store", title: "label.My Store".localiz()),
//                            .init(id: 3, image: "Undelivered_requests", title: "Undelivered requests"),
//                            .init(id: 4, image: "Delivered_requests", title: "Delivered requests"),
//            .init(id: 5, image: "Statistics", title: "Statistics".localiz()),
            .init(id: 6, image: "My_product", title: "label.My Products".localiz())
        ]
        
    }
    

    private func fillUI(with store: Store) {
        coverImageView.kf.setImage(with: URL(string: store.cover ?? ""))
        storeImageView.kf.setImage(with: URL(string: store.img ?? ""))
        storeTitleLabel.text = store.name
        storeLocationLabel.text = store.locationName
        cosmosView.rating = Double(store.totalRates ?? 5) ?? 5
        rateLabel.text = "[\(store.totalRates?.rounded(toPlaces: 1) ?? 5)]"
    }
    
    
    @IBAction func backButtonaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addStoreImageAction(_ sender: Any) {
        
    }
}

extension UserStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        storeUserService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = storeUserService[indexPath.item]
        let cell: UserStoreServiceItemCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setupCell(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = storeUserService[indexPath.item]
        
        switch item.id {
        case 1 :
            let vc = initViewControllerWith(identifier: AddServiceViewController.className, and: "Add Product".localiz(), storyboardName: Storyboard.MainPhase.rawValue) as! AddServiceViewController
            show(vc)
            
        case 2:
            let vc = initViewControllerWith(identifier: StoreViewController.className, and: "label.Your Store".localiz(), storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
            vc.mode = .edit
            vc.storeType = .myStore
            show(vc)
        case 5:
            let vc = StatisticsViewController.loadFromNib()
            show(vc)
        case 6 :
            let vc = initViewControllerWith(identifier: StoreProductsViewController.className, and: "label.My Products".localiz(), storyboardName: Storyboard.MainPhase.rawValue) as! StoreProductsViewController
            vc.mode = .edit
            vc.storeId = -1
            show(vc)
        default :
            break
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 2) - 20, height: 140)
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
