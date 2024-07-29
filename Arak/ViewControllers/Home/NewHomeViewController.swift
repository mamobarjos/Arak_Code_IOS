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
    
    /// The view that contains the search functionality.
    @IBOutlet weak var searchView: UIView!
    
    // MARK: - Properties
    
    /// Refresh control to handle pull-to-refresh actions.
    private let refreshControl = UIRefreshControl()
    
    /// ViewModel to handle data fetching and business logic.
    private var viewModel: NewHomeViewModel = NewHomeViewModel()
    
    /// Sections of the home data to be displayed in the collection view.
    private var sections: [HomeSection] = []
    
    /// Dispatch group to synchronize multiple asynchronous tasks.
    private var dispatchGroup: DispatchGroup?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl // iOS 10+
        getHomeData()
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
        collectionView.register(UINib(nibName: TitleCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier)
        
    }
    
    /// Creates and returns the layout for the collection view.
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
         UICollectionViewCompositionalLayout { section, _ in
             switch self.sections[section] {
             case .banners: return .banner()
             case .randomProducts: return .mainCategories()
             case .ellection: return .ellectionSection()
             case .SpecialAds: return .sepecialAds()
             case .Ads: return .products()
             }
         }
     }
    
    // MARK: - Data Fetching Methods
    
    /// Fetches home data and reloads the collection view once all data is fetched.
    private func getHomeData() {
        showLoading()
        dispatchGroup = DispatchGroup()
        getBanners()
        getRandomProducts()
        fetchFeaturedAds()
        fetchAds(adsType: .all)
        
        dispatchGroup?.notify(queue: .main) {
            self.stopLoading()
            self.sections = []
            if !self.viewModel.bannerList.isEmpty {
                self.sections.append(.banners(self.viewModel.bannerList))
            }
            
            if !self.viewModel.randomProducts.isEmpty {
                // TODO: - Rmove this code
                var products: [RelatedProducts]  = []
                products.append(contentsOf: self.viewModel.randomProducts)
                products.append(contentsOf: self.viewModel.randomProducts)
                products.append(contentsOf: self.viewModel.randomProducts)
                products.append(contentsOf: self.viewModel.randomProducts)
                products.append(contentsOf: self.viewModel.randomProducts)
                self.sections.append(.ellection((products)))
                self.sections.append(.banners(self.viewModel.bannerList))
            }
            
            if !self.viewModel.featuredAdsList.isEmpty {
                self.sections.append(.SpecialAds(self.viewModel.featuredAdsList))
            }
            
            if !self.viewModel.randomProducts.isEmpty {
                self.sections.append(.randomProducts(self.viewModel.randomProducts))
            }
            
            if !self.viewModel.adsList.isEmpty {
                self.sections.append(.Ads(self.viewModel.adsList))
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
    private func fetchAds(adsType: AdsTypes) {
        dispatchGroup?.enter()
        viewModel.adsList(page: 1, search: "", adsType: adsType) { [weak self] (error) in
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

    // MARK: - Cell Creation Methods
    
    /// Creates and returns a configured `FeaturedCell` for a banner at the specified index path.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A configured `FeaturedCell` instance.
    func makeBanner(indexPath: IndexPath) -> FeaturedCell {
        let cell: FeaturedCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(bannerList: viewModel.bannerList) { [weak self] in
            let vc = self?.initViewControllerWith(identifier: BannerViewController.className, and: "") as! BannerViewController
            vc.confige(adsType: .Banner)
            self?.show(vc)
        } playVideoBlock: {  [weak self] index in
            let vc = self?.initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
            vc.confige(imageNames: [self?.viewModel.bannerList[index].path ?? ""])
            self?.show(vc)
        }
        cell.layoutIfNeeded()
        cell.featuredPagerView.reloadData()
        return cell
    }
    
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
            let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: self.viewModel.adsList, index: indexPath.row), source: .Home)
            self.show(vc)
        } favorateBlock: { [weak self] in
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
        case .SpecialAds:
            return 1
        case .Ads:
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
        case .SpecialAds(_):
            return makeFeatured(indexPath: indexPath)
        case .Ads(let ads):
            return makeAdsCell(ads: ads, indexPath: indexPath)
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
            view.titleLabel.text = "Election Candidates".localiz()
            view.seeAllButton.isHidden = true
            view.filterButton.isHidden = false
            view.onFilterAction = {
                
            }
            return view
            
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
            view.filterButton.isHidden = true
            view.seeAllButton.isHidden = false
            view.onSeeAllAction = { [weak self] in
                let vc = self?.initViewControllerWith(identifier: FavoriteViewController.className, and: "Regular ads".localiz(), storyboardName: Storyboard.Main.rawValue) as! FavoriteViewController
                vc.source = .comeFromHome(isAds: true)
                self?.show(vc)
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
        let vc = ElectionDetailsViewController.loadFromNib()
        self.show(vc)
    }
}
