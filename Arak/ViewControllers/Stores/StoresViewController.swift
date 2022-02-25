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

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var joinUsButton: UIButton!

    private var pageFeatured = 1
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
        tableView.contentInset.bottom = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellClass: StroreTableViewCell.self)

        view.bringSubviewToFront(addButton)
        view.bringSubviewToFront(joinUsButton)
        setupCollectionView()
        scrollView.contentInset.bottom = 220

//        searchTextField.placeholder = "Search videos,images and many more".localiz()


        tagsView.onItemSelection = {[weak self] item in

            if item.id == -1 { // get all stores
                self?.storesViewModel.getStores { [weak self] error in
                    defer {
                        self?.stopLoading()
                    }

                    guard error == nil else {
                        self?.showToast(message: error)
                        return
                    }
                    self?.stores = self?.storesViewModel.getStores() ?? []
                }
                return
            }

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

        self.showLoading()
        storesViewModel.getStores { [weak self] error in
            defer {
                self?.stopLoading()
            }

            guard error == nil else {
                self?.showToast(message: error)
                return
            }
            self?.tagsView.items.append(HorizontalTagsView.TagItem(id: -1, title: "All"))
            self?.storesViewModel.getCategories().forEach({
                self?.tagsView.items.append(.init(id: $0.id, title: $0.name))
            })
            self?.tagsView.selectedItemID = -1
            self?.stores = self?.storesViewModel.getStores() ?? []
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
        dispatchGroup.enter()
        pageFeatured = 1
        fetchFeaturedAds()

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

    private func fetchFeaturedAds() {
        showLoading()
        viewModel.getBannerList(page: pageFeatured, search: "") { [weak self] (error) in
            self?.dispatchGroup.leave()   // <<---
            defer {
                self?.stopLoading()
                self?.banarCollectionView.reloadData()
            }

            if error != nil {
                self?.showToast(message: error)
                return
            }
        }
    }

    private func createTagsView() -> HorizontalTagsView {
        let tagView = HorizontalTagsView()
        return tagView
    }

    @IBAction func addButtonAction(_ sender: Any) {
        self.showToast(message: "WIll be Implemented later 😎")
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

    func makeFeatured(indexPath:IndexPath,isBanner: Bool) -> FeaturedCell {
            let cell:FeaturedCell = banarCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(bannerList: viewModel.getAllBanner())
        cell.layoutIfNeeded()
        return cell

    }

}
