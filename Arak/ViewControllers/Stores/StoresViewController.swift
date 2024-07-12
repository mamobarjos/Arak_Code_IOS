//
//  StoresViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

class StoresViewController: UIViewController {
    let tableView = UITableView()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var banarCollectionView: UICollectionView!

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchStoreTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var joinUsButton: UIButton!

    private var pageFeatured = 1
    private(set) var page = 1
    private(set) var categoryId = -1
    private let dispatchGroup = DispatchGroup()

    private var storesViewModel: StoresViewModel = StoresViewModel()
    private var viewModel: HomeViewModel = HomeViewModel()

    private var stores: [Store] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    lazy var tagsView = createTagsView()


    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        joinUsButton.setTitle("action.Add Your Store".localiz(), for: .normal)
        searchStoreTextField.text = "placeHolder.Search Stores".localiz()

        containerView.addSubview(tagsView)
        containerView.addSubview(tableView)
        tagsView.layout
            .top(.equal, to: searchView, edge: .bottom, offset: -5)
            .leading(to:.superview , offset: 10)
            .trailing(to: .superview, offset: -10)

        tableView.layout
            .top(.equal, to: tagsView, edge: .bottom, offset: 0)
            .leading(to:.superview)
            .trailing(to: .superview)
            .bottom(to: .safeArea)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.separatorColor = .clear
        tableView.contentInset.bottom = 150
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellClass: StroreTableViewCell.self)

        view.bringSubviewToFront(addButton)
        view.bringSubviewToFront(joinUsButton)
        setupCollectionView()
        scrollView.contentInset.bottom = 220

        tagsView.onItemSelection = {[weak self] item in
            self?.categoryId = item.id
            self?.page = 1
            self?.showLoading()
            self?.storesViewModel.canLoadMore = false
            self?.storesViewModel.getStoresByCategory(by: item.id) {[weak self] error in
                defer {
                    self?.stopLoading()
                }

                guard error == nil else {
                    self?.showToast(message: error)
                    return
                }
                self?.stores = self?.storesViewModel.getStores() ?? []
            }
        }
        fetchStores()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
        dispatchGroup.enter()
        pageFeatured = 1
        if Helper.currentUser?.hasStore == 1 {
            self.joinUsButton.isHidden = false
            self.addButton.isHidden = true
            return
        } else if Helper.store != nil {
            self.joinUsButton.isHidden = true
            self.addButton.isHidden = false
            return
        } else {
            self.joinUsButton.isHidden = false
            self.addButton.isHidden = true
        }

        dispatchGroup.notify(queue: .main) {
            self.banarCollectionView.reloadData()
        }

        if HomeViewController.goToMyAds {
            HomeViewController.goToMyAds = false
            let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
            show(vc)
        }
    }

    private func setupCollectionView() {
        banarCollectionView.contentInsetAdjustmentBehavior = .always
        banarCollectionView.delegate = self
        banarCollectionView.dataSource = self
//        setupRefershControl()
        banarCollectionView.register(FeaturedCell.self)
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
                self?.tagsView.items = []
                self?.tagsView.items.append(HorizontalTagsView.TagItem(id: -1, title: "action.All".localiz()))
                self?.storesViewModel.getCategories().forEach({
                    
                    self?.tagsView.items.append(.init(id: $0.id, title:Helper.appLanguage ?? "en" == "en" ? $0.name : $0.arName))
                    self?.fetchFeaturedAds()
                })
                self?.tagsView.selectedItemID = -1
            }
            self?.stores = self?.storesViewModel.getStores() ?? []
        }
    }

    private func fetchStoresByCategory(page: Int = 1) {
        self.showLoading()
        self.storesViewModel.getStoresByCategory(page: page, by: categoryId) {[weak self] error in
            defer {
                self?.stopLoading()
            }

            guard error == nil else {
                self?.showToast(message: error)
                return
            }
            self?.stores = self?.storesViewModel.getStores() ?? []
        }
    }

    private func fetchFeaturedAds() {
        self.banarCollectionView.reloadData()
    }

    private func createTagsView() -> HorizontalTagsView {
        let tagView = HorizontalTagsView()
        return tagView
    }

    private func openCreateService() {
        let vc = initViewControllerWith(identifier: AddServiceViewController.className, and: "Add Service", storyboardName: Storyboard.MainPhase.rawValue) as! AddServiceViewController
        show(vc)
    }

    @IBAction func addButtonAction(_ sender: Any) {
        openCreateService()
    }

    @IBAction func searchAction(_ sender: Any) {
            let vc = initViewControllerWith(identifier: SearchStoresViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! SearchStoresViewController
            show(vc)
    }
    
    @IBAction func joinButtonAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: SignUpStoreViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as! SignUpStoreViewController
        show(vc)
    }
}

extension StoresViewController: UITableViewDelegate, UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == storesViewModel.getStores().count - 1 && storesViewModel.canLoadMore {
            page += 1
            switch categoryId {
            case -1: fetchStores(page: page, fillCategories: false)
            default : fetchStoresByCategory(page: page)
            }
        }
    }
}

extension StoresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return makeFeatured(indexPath: indexPath, isBanner: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: banarCollectionView.bounds.width, height: 125)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }

    func openExternalURL(_ urlString: String) {
           if let url = URL(string: urlString) {
               // Check if the URL can be opened
               if UIApplication.shared.canOpenURL(url) {
                   // Open the URL with default web browser
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   // Handle the error if the URL cannot be opened
                   print("Cannot open URL")
               }
           } else {
               // Handle the error if the URL is invalid
               print("Invalid URL")
           }
       }
    func makeFeatured(indexPath:IndexPath,isBanner: Bool) -> FeaturedCell {
            let cell:FeaturedCell = banarCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(bannerList: storesViewModel.getBanners())
        cell.layoutIfNeeded()
        cell.learnMore = {[weak self] item in
            let vc = self?.initViewControllerWith(identifier: PopUpViewViewController.className, and: "", storyboardName: "Main") as! PopUpViewViewController
            vc.bannerDesc = item.description
            vc.bannerTitle = item.title
            self?.present(vc, modalPresentationStyle: .pageSheet)
        }
        
        cell.showDetails = {[weak self] item in
            if item.websiteurl == nil {
                let vc = self?.initViewControllerWith(identifier: StoreViewController.className, and: item.title ?? "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
                vc.storeId = item.id
                self?.show(vc)
            } else {
                self?.openExternalURL(item.websiteurl ?? "https://www.google.com/?client=safari&channel=iphone_bm")
            }
        }
        
        return cell
       
    }

}
