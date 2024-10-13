//
//  NewHomeViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 18/07/2024.
//

import UIKit


/// `NewHomeViewController` handles the display and refresh of home data in a collection view.
class NewHomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    /// The collection view that displays home data.
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addAdsButton: UIButton!
    /// The view that contains the search functionality.
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    // MARK: - Properties
    
    /// Refresh control to handle pull-to-refresh actions.
    private let refreshControl = UIRefreshControl()
    
    /// ViewModel to handle data fetching and business logic.
    private var viewModel: NewHomeViewModel = NewHomeViewModel()
    
    /// Sections of the home data to be displayed in the collection view.
    private var sections: [HomeSection] = []
    
    /// Dispatch group to synchronize multiple asynchronous tasks.
    private var dispatchGroup: DispatchGroup?
    static var goToMyAds = false
    var notificationViewModel: NotificationViewModel = NotificationViewModel()
    private var electionFilter: (Gov:District?, Dis:District?) = (Gov: nil, Dis: nil)
    private var cartManager: CartManagerProtocol?
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartManager = CartManager()
        cartManager?.getCartCount()
        configureCollectionView()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl // iOS 10+
        searchTextField.placeholder = "Search videos,images and many more".localiz()
        getHomeData()
        
        if Helper.userType != Helper.UserType.GUEST.rawValue {
//            notificationViewModel.getNotificationsStatus { _ in }
        }
        notificationViewModel.getStaticLinks { _ in }
        
        if Helper.arakLinks?.isLive == false {
            addAdsButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NewHomeViewController.goToMyAds {
            NewHomeViewController.goToMyAds = false
            let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
            show(vc)
        }
    }
    
    // MARK: - Configuration Methods
    
    /// Configures the collection view with the necessary delegates, data sources, layout, and cell registrations.
    private func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(AdsCell.self)
        collectionView.register(FeaturedCell.self)
        collectionView.register(CategoriesCollectionViewCell.self)
        collectionView.register(HomeFilterCollectionViewCell.self)
        collectionView.register(ElectionCollectionViewCell.self)
        collectionView.register(HomeStoreCollectionViewCell.self)
        collectionView.register(UINib(nibName: TitleCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier)
        collectionView.register(UINib(nibName: AdsHomeFilterCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AdsHomeFilterCollectionReusableView.identifier)
        
    }
    
    /// Creates and returns the layout for the collection view.
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
         UICollectionViewCompositionalLayout { section, _ in
             switch self.sections[section] {
             case .banners: return .banner()
             case .randomProducts: return .mainCategories()
             case .ellection: return .ellectionSection()
//             case .ellectionBanner: return .banner()
             case .SpecialAds: return .sepecialAds()
             case .Ads: return .products()
             case .stores: return .stores()
             }
         }
     }
    
    // MARK: - Data Fetching Methods
    
    /// Fetches home data and reloads the collection view once all data is fetched.
    private func getHomeData() {
        showLoading()
        dispatchGroup = DispatchGroup()
        getEllection()
        getBanners()
        getRandomProducts()
        fetchFeaturedAds()
        getRandomStores()
        fetchAds()
        
        dispatchGroup?.notify(queue: .main) {
            self.stopLoading()
            self.sections = []
            
            if !self.viewModel.bannerList.isEmpty {
                self.sections.append(.banners(self.viewModel.bannerList))
            }
            
            
            if !(self.viewModel.ellectionData?.electedPeople?.isEmpty == true) {
                self.sections.append(.ellection(self.viewModel.ellectionData?.electedPeople ?? []))
            }
          
            
//            if !(self.viewModel.ellectionData?.banners?.data?.isEmpty ?? false) {
//                self.sections.append(.ellectionBanner(self.viewModel.ellectionData?.banners?.data ?? []))
//            }
            
            if !self.viewModel.featuredAdsList.isEmpty && Helper.arakLinks?.isLive == true {
                self.sections.append(.SpecialAds(self.viewModel.featuredAdsList))
            }
            
            if !self.viewModel.randomProducts.isEmpty {
                self.sections.append(.randomProducts(self.viewModel.randomProducts))
            }
            
            if !self.viewModel.adsList.isEmpty {
                self.sections.append(.Ads(Array(self.viewModel.adsList.prefix(4))))
            }
            
          
            if !self.viewModel.stores.isEmpty {
                self.sections.append(.stores(Array(self.viewModel.stores.prefix(4))))
            }
            
           
            self.dispatchGroup?.wait()
            self.collectionView.reloadData()
        }
    }
    
    /// Fetches banners and adds them to the sections array if not empty.
    private func getBanners() {
        dispatchGroup?.enter()
        self.viewModel.getBannerList(page: 1, compliation: { [weak self] error in
            self?.dispatchGroup?.leave()
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
        })
    }
    
    /// Fetches random products and adds them to the sections array if not empty.
    private func getRandomProducts() {
        dispatchGroup?.enter()
        viewModel.getRandomProductList {  [weak self] error in
            self?.dispatchGroup?.leave()
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
        }
    }
    
    /// Fetches featured ads and adds them to the sections array if not empty.
    private func fetchFeaturedAds() {
        dispatchGroup?.enter()
        viewModel.featuredList(page: 1, search: "") { [weak self] (error) in
            self?.dispatchGroup?.leave()
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
        }
    }
    
    /// Fetches ads of a specified type and adds them to the sections array if not empty.
    private func fetchAds() {
        dispatchGroup?.enter()
        viewModel.adsList(page: 1, search: "", adsType: nil) { [weak self](error) in
            self?.dispatchGroup?.leave()
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
        }
       
    }
    
    private func getEllection() {
        dispatchGroup?.enter()
        viewModel.getEllectionFilter {[weak self] (error) in
            if error != nil {
                self?.dispatchGroup?.leave()
                self?.showToast(message: error)
                return
            }
            
            self?.viewModel.getEllectionData(governorateId: self?.electionFilter.Gov?.id , districtId: self?.electionFilter.Dis?.id , compliation: { error in
                self?.dispatchGroup?.leave()
                
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
            })
        }
    }
    
    private func getRandomStores() {
        dispatchGroup?.enter()
        viewModel.getRandomStoresList {  [weak self] error in
            self?.dispatchGroup?.leave()
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
        }
    }
    
    
    // MARK: - Helper Methods
    
    /// Handles pull-to-refresh action.
    @objc private func didPullToRefresh(_ sender: Any) {
        getHomeData()
        refreshControl.endRefreshing()
    }

    func openExternalURL(_ urlString: String) {
        let vc = self.initViewControllerWith(identifier: WebViewViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! WebViewViewController
        vc.confige(title: "", path: urlString , processType: .Other, imageFirebasePath: "")
        self.show(vc)
        
//           if let url = URL(string: urlString) {
//               // Check if the URL can be opened
//               if UIApplication.shared.canOpenURL(url) {
//                   // Open the URL with default web browser
//                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
//               } else {
//                   // Handle the error if the URL cannot be opened
//                   print("Cannot open URL")
//               }
//           } else {
//               // Handle the error if the URL is invalid
//               print("Invalid URL")
//           }
       }
    
    // MARK: - Cell Creation Methods
    
    /// Creates and returns a configured `FeaturedCell` for a banner at the specified index path.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A configured `FeaturedCell` instance.
    func makeBanner(indexPath: IndexPath) -> FeaturedCell {
        let cell: FeaturedCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(bannerList: viewModel.bannerList) { [weak self] in
            let item = self?.viewModel.bannerList.first
            if item?.websiteURL == nil {
                let vc = self?.initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
                vc.confige(imageNames: [item?.path ?? ""])
                self?.show(vc)
            } else {
                self?.openExternalURL(item?.websiteURL ?? "https://www.google.com/?client=safari&channel=iphone_bm")
            }
        } playVideoBlock: {  [weak self] index in
            
            let item = self?.viewModel.bannerList[index]
            if item?.websiteURL == nil {
                let vc = self?.initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
                vc.confige(imageNames: [item?.path ?? ""])
                self?.show(vc)
            } else {
                self?.openExternalURL(item?.websiteURL ?? "https://www.google.com/?client=safari&channel=iphone_bm")
            }
        }
        cell.layoutIfNeeded()
        cell.featuredPagerView.reloadData()
        return cell
    }
    
    
    /// Creates and returns a configured `FeaturedCell` for a banner at the specified index path.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A configured `FeaturedCell` instance.
//    func makeEllectionBanner(indexPath: IndexPath) -> FeaturedCell {
//        let cell: FeaturedCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
//        cell.setup(bannerList: viewModel.ellectionData?.banners?.data ?? []) { [weak self] in
//            self?.showLoading()
//            self?.viewModel.getEllectionDetails(personId: self?.viewModel.ellectionData?.banners?.data?.first?.id ?? 0) { [weak self] error in
//                self?.stopLoading()
//                if error != nil {
//                    self?.showToast(message: error)
//                    return
//                }
//                
//                let vc = ElectionDetailsViewController.loadFromNib()
//                vc.electionPerson = self?.viewModel.ellectionPerson
//                self?.show(vc)
//            }
//        } playVideoBlock: {  [weak self] index in
//            if self?.viewModel.ellectionData?.banners?.data?.count == index {return}
//            self?.showLoading()
//            self?.viewModel.getEllectionDetails(personId: self?.viewModel.ellectionData?.banners?.data?[index].id ?? 0) { [weak self] error in
//                self?.stopLoading()
//                if error != nil {
//                    self?.showToast(message: error)
//                    return
//                }
//                
//                let vc = ElectionDetailsViewController.loadFromNib()
//                vc.electionPerson = self?.viewModel.ellectionPerson
//                self?.show(vc)
//            }
//        }
//        cell.layoutIfNeeded()
//        cell.featuredPagerView.reloadData()
//        return cell
//    }
    
    /// Creates and returns a configured `FeaturedCell` for a featured section at the specified index path.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A configured `FeaturedCell` instance.
    func makeFeatured(indexPath: IndexPath) -> FeaturedCell {
        let cell: FeaturedCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.layoutIfNeeded()
        cell.setup(featuredAdsList: viewModel.featuredAdsList, isFavorate: false) { [weak self] index in
            guard let self = self else { return }
            let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: self.viewModel.featuredAdsList, index: index), source: .Home)
            self.show(vc)
        } favorateBlock: { [weak self] index in
        } moreBlock: { [weak self] in
        }
        cell.featuredPagerView.reloadData()
        return cell
    }
    

    /// Creates and returns a configured `AdsCell` for an ad at the specified index path.
    /// - Parameters:
    ///   - ads: The list of advertisements to display.
    ///   - indexPath: The index path of the cell.
    /// - Returns: A configured `AdsCell` instance.
    func makeAdsCell(ads: [Adverisment], indexPath: IndexPath) -> AdsCell {
        let cell: AdsCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.photoImageView.image = nil
        cell.setup(indexItem: indexPath.row, isFavorate: false, ads: ads[indexPath.row]) { [weak self] in
            guard let self = self else { return }
            if ads[indexPath.row].adCategoryID == AdsTypes.video.rawValue {
                //                let detailVC = self.initViewControllerWith(identifier: DetailViewController.className, and: "") as! DetailViewController
                //                detailVC.confige(id: self.viewModel.adsList[indexPath.row].id)
                //                self.show(detailVC)
                
                let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
                vc.config(viewModel: StoryViewModel(adsList: self.viewModel.adsList, index: indexPath.row), source: .Home)
                self.show(vc)
                
            }else if ads[indexPath.row].adCategoryID == AdsTypes.store.rawValue {
//                    guard let self else {return}
                    let ad = self.viewModel.adsList[indexPath.item]
                    let vc = self.initViewControllerWith(identifier: StoreViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
                    vc.storeId = ad.storeId
                    self.show(vc)
            } else {
//                let detailVC = self.initViewControllerWith(identifier: DetailViewController.className, and: "") as! DetailViewController
//                detailVC.confige(id: self.viewModel.adsList[indexPath.row].id)
//                self.show(detailVC)
                
                let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
                vc.config(viewModel: StoryViewModel(adsList: self.viewModel.adsList, index: indexPath.row), source: .Home)
                self.show(vc)

            }
        } favorateBlock: { [weak self] in
        }
        return cell
    }
    
    /// Creates and returns a configured `HomeStoreCell` for an ad at the specified index path.
    /// - Parameters:
    ///   - ads: The list of advertisements to display.
    ///   - indexPath: The index path of the cell.
    /// - Returns: A configured `AdsCell` instance.
    func makeHomeStoreCell(stroe: [Store], indexPath: IndexPath) -> HomeStoreCollectionViewCell {
        let cell: HomeStoreCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setupCell(with: viewModel.stores[indexPath.item])
        cell.onButtonAction = { [weak self] in
            guard let self else {return}
            let store = self.viewModel.stores[indexPath.item]
            let vc = self.initViewControllerWith(identifier: StoreViewController.className, and: store.name ?? "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
            vc.storeId = store.id
            self.show(vc)
        }
        return cell
    }
    
    // MARK: - Actions
    
    /// Action method for the search button tap event.
    /// - Parameter sender: The button that initiated the action.
    @IBAction func searchButtonAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: SearchViewController.className, and: "") as! SearchViewController
        show(vc)
    }
    
    @IBAction func addAdsButtonAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AdsViewController.className, and: "") as! AdsViewController
        show(vc)
    }
    
}

// MARK: - UICollectionView Methods
extension NewHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print(sections.count)
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .banners:
            return 1
        case .randomProducts:
            return 1
        case .ellection:
            return 1
//        case .ellectionBanner:
//            return 1
        case .SpecialAds:
            return 1
        case .Ads:
            return sections[section].numberOfItems
        case .stores:
            return sections[section].numberOfItems
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .banners(let banners):
            return makeBanner(indexPath: indexPath)

        case .randomProducts(let products):
            let cell: CategoriesCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.horizontalTagView.setupCategories(products: products)
            cell.delegate = self
            return cell
        case .ellection(let candidates):
            let cell: ElectionCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.electionCollectionView.setupCategories(products: candidates)
            cell.delegate = self
            return cell
//        case .ellectionBanner(let banners):
//            return makeEllectionBanner(indexPath: indexPath)
        case .SpecialAds(_):
            return makeFeatured(indexPath: indexPath)
        case .Ads(let ads):
            return makeAdsCell(ads: ads, indexPath: indexPath)
        case .stores(let stores):
            return makeHomeStoreCell(stroe: stores, indexPath: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch section {
        case .banners(_):
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
            view.filterButton.isHidden = true
            return view
        case .randomProducts(_):
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
            view.filterButton.isHidden = true
            return view
    
        case .ellection(_):
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
            view.vc = self
            view.delegate = self
            view.filter = viewModel.ellectionFilters
            view.titleLabel.text = "Election Candidates".localiz()
            view.seeAllButton.isHidden = true
            view.filterButton.isHidden = false
            view.onFilterAction = {
                
            }
            return view
            
//        case .ellectionBanner:
//            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
//            view.filterButton.isHidden = true
//            return view
//            
        case .SpecialAds(_):
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
            view.titleLabel.text = "Featured ads".localiz()
            view.seeAllButton.isHidden = false
            view.filterButton.isHidden = true
            view.onSeeAllAction = { [weak self] in
                let vc = self?.initViewControllerWith(identifier: FavoriteViewController.className, and: "Featured ads".localiz(), storyboardName: Storyboard.Main.rawValue) as! FavoriteViewController
                vc.source = .comeFromHome(isAds: false)
                self?.show(vc)
            }
            return view
    
        case .Ads(_):
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
            view.titleLabel.text = "Regular ads".localiz()
            view.seeAllButton.isHidden = false
            view.filterButton.isHidden = true
            view.onSeeAllAction = { [weak self] in
                let vc = self?.initViewControllerWith(identifier: FavoriteViewController.className, and: "Regular ads".localiz(), storyboardName: Storyboard.Main.rawValue) as! FavoriteViewController
                vc.source = .comeFromHome(isAds: true)
                self?.show(vc)
            }
            return view
            
        case .stores:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
            view.titleLabel.text = "Suggestions Of Stores".localiz()
            view.seeAllButton.isHidden = false
            view.filterButton.isHidden = true
            view.onSeeAllAction = { [weak self] in
                if let tabBarController =  self?.tabBarController as? BubbleTabBarController {
                    tabBarController.selectedIndex = 2
                }
            }
            return view
        }
    }
}

extension NewHomeViewController: CategoriesCollectionViewCellDelegate {
    func didUserTapOnItem(item: TagItem) {
        let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
        vc.storeId = item.storeId
        vc.storeName = item.title
        vc.productId = item.id
        show(vc)
    }
}

extension NewHomeViewController: ElectionCollectionViewCellDelegate {
    func didUserTapOnCandidateItem(item: TagItem) {
        showLoading()
        viewModel.getEllectionDetails(personId: item.id) { [weak self] error in
            self?.stopLoading()
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            let vc = ElectionDetailsViewController.loadFromNib()
            vc.electionPerson = self?.viewModel.ellectionPerson
            self?.show(vc)
        }
       
    }
}

extension NewHomeViewController: TitleCollectionReusableViewDelegate {
    func didUserSelectFilteElection(governorate: District, district: District) {
        self.electionFilter = (Gov: governorate, Dis: district)
        self.getHomeData()
    }
}
