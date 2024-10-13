//
//  HomeViewController.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//
//

import UIKit
import Foundation
import AVKit
import Firebase

class HomeViewController: UIViewController {
  
    // MARK: - Outlets
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    // MARK: - Properties
    
    private let dispatchGroup = DispatchGroup()
    static var goToMyAds = false

    var viewModel: HomeViewModel = HomeViewModel()
    var detailViewModel: DetailViewModel = DetailViewModel()
    var notificationViewModel: NotificationViewModel = NotificationViewModel()
    
    private var refreshControl = UIRefreshControl()
    private var pageAds = 1
    private var pageFeatured = 1
    private var pageBanner = 1
    private var isFavorate: Bool = false
    private var screenType: StoryViewController.Source = .Home
    
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    private  let cellsPerRow = 2
  
    private var adsType: AdsTypes = .all
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.isHidden = screenType != .Home
        setupCollectionView()
        searchTextField.placeholder = "Search videos,images and many more".localiz()
        if Helper.userType != Helper.UserType.GUEST.rawValue {
            notificationViewModel.getNotificationsStatus { _ in }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
        dispatchGroup.enter()
        pageAds = 1
        pageFeatured = 1
        fetchAds(adsType: adsType)
        if screenType == .Home {
            viewModel.getRandomProductList { string in
            print(string)
        }
    }
        
        notificationViewModel.getStaticLinks { _ in }
        if screenType == .Home && Helper.userType != Helper.UserType.GUEST.rawValue  {
            dispatchGroup.enter()
            fetchFeaturedAds()
        }        
        dispatchGroup.notify(queue: .main) {
            self.adsCollectionView.reloadData()
        }
        
        if HomeViewController.goToMyAds {
            HomeViewController.goToMyAds = false
            let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
            show(vc)
        }
       
       
    }
    
  
    func config(screenType: StoryViewController.Source) {
        self.screenType = screenType
        self.isFavorate = screenType == .Favrate
    }
    
    
    @IBAction func Search(_ sender: Any) {
        let vc = initViewControllerWith(identifier: SearchViewController.className, and: "") as! SearchViewController
        show(vc)
    }
    
    // MARK: - Protected Methods
    
    @IBAction func NewAdd(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AdsViewController.className, and: "") as! AdsViewController
        show(vc)
    }
    
    private func fetchAds(adsType: AdsTypes) {
        if screenType == .Favrate {
            title = "Favorite".localiz()
            showLoading()
            viewModel.getFavorateList(page: pageAds, search: "") { [weak self] (error) in
                defer {
                    self?.stopLoading()
                }
                
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
                self?.adsCollectionView.reloadData()
            }
        } else if screenType == .History {
            title = "History".localiz()
            showLoading()
            viewModel.getHistory(page: pageAds, search: "") { [weak self] (error) in
                defer {
                    self?.stopLoading()
                }
                
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
                self?.adsCollectionView.reloadData()
            }
        }  else {
            showLoading()
            viewModel.adsList(page: pageAds, search: "", adsType: adsType) { [weak self] (error) in
                self?.dispatchGroup.leave()   // <<---
                defer {
                    self?.stopLoading()
                }
                
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
            }
        }
        
    }
    
    private func fetchFeaturedAds() {
        showLoading()
        viewModel.featuredList(page: pageFeatured, search: "") { [weak self] (error) in
            self?.dispatchGroup.leave()   // <<---
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
        }
    }
    
    
    
    private func setupCollectionView() {
        adsCollectionView.contentInsetAdjustmentBehavior = .always
        setupRefershControl()
        adsCollectionView.register(AdsCell.self)
        adsCollectionView.register(FeaturedCell.self)
        adsCollectionView.register(CategoriesCollectionViewCell.self)
        adsCollectionView.register(HomeFilterCollectionViewCell.self)
    }
    
    private func setupRefershControl() {
        //        if #available(iOS 10.0, *) {
        //            adsCollectionView.refreshControl = refreshControl
        //        } else {
        //            adsCollectionView.addSubview(refreshControl)
        //        }
        //        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        refreshControl.endRefreshing()
        adsType = .all
        pageAds = 1
        pageFeatured = 1
        fetchFeaturedAds()
        fetchAds(adsType: adsType)
    }
    
    
}
extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = viewModel.itemCount
        if screenType == .Home {
            count += 1
        }
       
        if viewModel.itemFeaturedCount > 0 {
            count += 1
        }
        if viewModel.itemBannerCount > 0 && screenType == .Home {
            count += 1
        }
        
        if viewModel.randomProducts.isEmpty == false && screenType == .Home {
            count += 1
        }
        
        count == 0 ?  self.adsCollectionView.setEmptyView(onClickButton: {
            self.fetchAds(adsType: self.adsType)
        }) : self.adsCollectionView.restore()
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.itemBannerCount > 0 {
            if viewModel.itemFeaturedCount > 0 {
                if indexPath.row == 0 {
                    return makeFeatured(indexPath: indexPath,isBanner: true)
                } else if indexPath.row == 1 && viewModel.randomProducts.isEmpty == false {
                    let cell: CategoriesCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.horizontalTagView.setupCategories(products: viewModel.randomProducts)
                    cell.delegate = self
                    return cell
                } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 2 : 1) {
                    return makeFeatured(indexPath: indexPath,isBanner: false)
                } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 3 : 2){
                    let cell: HomeFilterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.delegate = self
                    return cell
                }
                let index = IndexPath(row: indexPath.row - (viewModel.randomProducts.isEmpty == false ? 4 : 3), section: indexPath.section)
                return makeAdsCell(indexPath: index)
            } else {
                if indexPath.row == 0 {
                    return makeFeatured(indexPath: indexPath,isBanner: true)
                } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 2 : 1){
                    let cell: HomeFilterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.delegate = self
                    return cell
                }
                let index = IndexPath(row: indexPath.row - (viewModel.randomProducts.isEmpty == false ? 3 : 2), section: indexPath.section)
                return makeAdsCell(indexPath: index)
            }
        } else if viewModel.itemFeaturedCount > 0  {
            if indexPath.row == 0 {
                return makeFeatured(indexPath: indexPath,isBanner: false)
            } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 2 : 1){
                let cell: HomeFilterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                return cell
            }
            let index = IndexPath(row: indexPath.row - (viewModel.randomProducts.isEmpty == false ? 3 : 2), section: indexPath.section)
            return makeAdsCell(indexPath: index)
        }
        return makeAdsCell(indexPath: indexPath)
    }
    
    func makeFeatured(indexPath:IndexPath,isBanner: Bool) -> FeaturedCell {
        if isBanner {
            let cell:FeaturedCell = adsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setup(bannerList: viewModel.getAllBanner()) { [weak self] in
                if isBanner {
                    if indexPath.row == self?.viewModel.getAllBanner().count {
                        let vc = self?.initViewControllerWith(identifier: BannerViewController.className, and: "") as! BannerViewController
                        vc.confige(adsType: .Banner)
                        self?.show(vc)
                    } else {
                        let vc = self?.initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
                        vc.confige(imageNames: [self?.viewModel.itemBanner(at: indexPath.row)?.path ?? ""])
                        self?.show(vc)
                    }
                   
                } else {
                    let vc = self?.initViewControllerWith(identifier: BannerViewController.className, and: "") as! BannerViewController
                    vc.confige(adsType: .Featured)
                    self?.show(vc)
                }
            } playVideoBlock: {  [weak self] index in
                let vc = self?.initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
                vc.confige(imageNames: [self?.viewModel.itemBanner(at: index)?.path ?? ""])
                self?.show(vc)
            }
            cell.layoutIfNeeded()
            
            cell.featuredPagerView.reloadData()
            return cell
        }
        let cell:FeaturedCell = adsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.layoutIfNeeded()
        cell.setup(featuredAdsList: viewModel.getAllFeatured(), isFavorate: isFavorate) { [weak self] index in
            guard let self = self else { return }
            if self.screenType == .Favrate || self.screenType == .History {
                let detailVC = self.initViewControllerWith(identifier: DetailViewController.className, and: "") as! DetailViewController
                detailVC.confige(id: self.viewModel.item(at: indexPath.row)?.id ?? -1)
                self.show(detailVC)
                return
            }
            let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: self.viewModel.getAllFeatured(), index: index), source: self.isFavorate ? .Favrate : .Home)
            self.show(vc)
        } favorateBlock: { [weak self] index   in 
            guard let self = self else { return }
            self.addToFavorate(id: self.viewModel.getAllFeatured()[index].id ?? -1, index: index, complation: { [weak self] value in
                if value {
                    cell.updateFavorate(index: index, isFavorate: !(self?.viewModel.getAllFeatured()[index].isFav ?? false))
                    self?.pageAds = 0
                    self?.fetchAds(adsType: self?.adsType ?? .all)
                }
            })
        } moreBlock: { [weak self] in
            if isBanner {
                let vc = self?.initViewControllerWith(identifier: BannerViewController.className, and: "") as! BannerViewController
                vc.confige(adsType: .Banner)
                self?.show(vc)
            } else {
                let vc = self?.initViewControllerWith(identifier: BannerViewController.className, and: "") as! BannerViewController
                vc.confige(adsType: .Featured)
                self?.show(vc)
            }
        }
        cell.featuredPagerView.reloadData()
        return cell
    }
    
    func addToFavorate(id: Int,index: Int,complation: @escaping (Bool) -> Void) {
        showLoading()
        self.detailViewModel.favorite(id: id) { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                complation(false)
                return
            }
            complation(true)
        }
    }
    
    func makeAdsCell(indexPath: IndexPath) -> AdsCell  {
        let cell:AdsCell = adsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.photoImageView.image = nil
        
        if let ads = viewModel.item(at: indexPath.row) {
            cell.setup(indexItem: indexPath.row, isFavorate: isFavorate,ads: ads) {  [weak self] in
                guard let self = self else { return }
                if self.screenType == .Favrate || self.screenType == .History {
                    let detailVC = self.initViewControllerWith(identifier: DetailViewController.className, and: "") as! DetailViewController
                    detailVC.confige(id: self.viewModel.item(at: indexPath.row)?.id ?? -1)
                    self.show(detailVC)
                    return
                }
                let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
                vc.config(viewModel: StoryViewModel(adsList: self.viewModel.getAll(), index: indexPath.row), source: self.isFavorate ? .Favrate : .Home)
                self.show(vc)
            }  favorateBlock: { [weak self] in
                guard let self = self else { return }
                self.addToFavorate(id: self.viewModel.getAll()[indexPath.row].id ?? -1 ,index: indexPath.row, complation: { [weak self] value in
                    if value {
                        self?.viewModel.updateAdsFavorate(index:  indexPath.row)
                        self?.pageAds = 0
                        self?.fetchAds(adsType: self?.adsType ?? .all)
                    }
                })
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if screenType == .Favrate || screenType == .History {
            let detailVC = self.initViewControllerWith(identifier: DetailViewController.className, and: "") as! DetailViewController
            detailVC.confige(id: viewModel.item(at: indexPath.row)?.id ?? -1)
            self.show(detailVC)
            return
        }
        if (viewModel.itemBannerCount > 0 && screenType == .Home) && viewModel.itemFeaturedCount > 0  {
            if indexPath.row == 0 {
                let vc = initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
                vc.confige(imageNames: [viewModel.itemBanner(at: indexPath.row)?.path ?? ""])
                show(vc)
            } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 2 : 1) {
                let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
                vc.config(viewModel: StoryViewModel(adsList: viewModel.getAllFeatured(), index: 0), source: .Home)
                show(vc)
            }
            let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: viewModel.getAll(), index: indexPath.row - (viewModel.randomProducts.isEmpty == false ? 3 : 2)), source: screenType)
            show(vc)
        } else if viewModel.itemFeaturedCount > 0  {
            if indexPath.row == 0 {
                let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
                vc.config(viewModel: StoryViewModel(adsList: viewModel.getAllFeatured(), index: indexPath.row), source: screenType)
                show(vc)
            }
            let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: viewModel.getAll(), index: indexPath.row - (viewModel.randomProducts.isEmpty == false ? 2 : 1)), source: screenType)
            show(vc)
        } else {
            let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: viewModel.getAll(), index: indexPath.row), source: screenType)
            show(vc)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.itemBannerCount > 0 {
            if viewModel.itemFeaturedCount > 0 {
                if indexPath.row == 0 {
                    let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                    let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                    return CGSize(width: itemWidth, height: 125)
                } else if indexPath.row == 1 && viewModel.randomProducts.isEmpty == false {
                    let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                    let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                    return CGSize(width: itemWidth, height: 100)
                    
                } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 2 : 1) {
                    let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                    let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                    return CGSize(width: itemWidth, height: 220)
                    
                } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 3 : 2) {
                   let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                   let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                   return CGSize(width: itemWidth, height: 50)
               }
                
                let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
                let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
                return CGSize(width: itemWidth, height: 200)
            } else {
                if indexPath.row == 0 {
                    let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                    let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                    return CGSize(width: itemWidth, height: 125)
                    
                } else if indexPath.row == 1 && viewModel.randomProducts.isEmpty == false {
                    let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                    let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                    return CGSize(width: itemWidth, height: 100)
                }
                
                else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 2 : 1) {
                   let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                   let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                   return CGSize(width: itemWidth, height: 50)
               }
                
                let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
                let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
                return CGSize(width: itemWidth, height: 200)
            }
        } else if viewModel.itemFeaturedCount > 0  {
            
            if indexPath.row == 0 && viewModel.randomProducts.isEmpty == false{
                let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                return CGSize(width: itemWidth, height: 100)
            } else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 1 : 0 ) {
                let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                return CGSize(width: itemWidth, height: 220)
            }
            
            else if indexPath.row == (viewModel.randomProducts.isEmpty == false ? 2 : 1) {
               let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
               let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
               return CGSize(width: itemWidth, height: 50)
           }
            
            let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            return CGSize(width: itemWidth, height: 200)
        }
        
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.hasMore && viewModel.itemCount - 1 == indexPath.row {
            pageAds += 1
            dispatchGroup.enter()
            fetchAds(adsType: self.adsType)
        }
    }
    
}

extension HomeViewController: CategoriesCollectionViewCellDelegate {
    func didUserTapOnItem(item: TagItem) {
        let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
        vc.storeId = item.storeId
        vc.storeName = item.title
        vc.productId = item.id
        show(vc)
    }
}

extension HomeViewController: HomeFilterCollectionViewCellDelegate {
    func didtapChooseFilter(_ sender: HomeFilterCollectionViewCell, adsType: AdsTypes) {
        self.adsType = adsType
        pageAds = 1
        dispatchGroup.enter()
        fetchAds(adsType: adsType)
        dispatchGroup.notify(queue: .main) {
            self.adsCollectionView.reloadData()
        }
    }
}

