//
//  StoresViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

class StoresViewController: UIViewController {

    @IBOutlet weak var banarCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var joinUsButton: UIButton!
    private var pageFeatured = 1
    private  let dispatchGroup = DispatchGroup()
    
    var viewModel: HomeViewModel = HomeViewModel()
    lazy var tagsView = createTagsView()
    let tableView = UITableView()

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tagsView)
        view.addSubview(tableView)

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

        tableView.register(cellClass: StroreTableViewCell.self)

        view.bringSubviewToFront(addButton)
        view.bringSubviewToFront(joinUsButton)
        setupCollectionView()
        searchTextField.placeholder = "Search videos,images and many more".localiz()

//        tagsView.onItemSelection = { item in
//            guard let categoryIndex = (self.categories.firstIndex { $0.id == item.id }) else {
//                return
//            }
        tagsView.items = [HorizontalTagsView.TagItem(id: 1, title: "Car"), HorizontalTagsView.TagItem(id: 2, title: "Food"), HorizontalTagsView.TagItem(id: 3, title: "Car"), HorizontalTagsView.TagItem(id: 4, title: "Car")]
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
    }
    @IBAction func joinButtonAction(_ sender: Any) {
    }
}

extension StoresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cellClass: StroreTableViewCell.self, for: indexPath)
        return cell
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
