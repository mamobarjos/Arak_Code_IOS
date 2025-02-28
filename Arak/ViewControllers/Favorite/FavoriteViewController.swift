//
//  FavoriteViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 24/07/2024.
//

import UIKit

class FavoriteViewController: UIViewController, UITextFieldDelegate {
    enum Source: Equatable {
        case comeFromHome(isAds: Bool)
        case Favrate
        case History
    }
    
    // MARK: - Outlets
    @IBOutlet weak var adsCollectionView: UICollectionView!
    // MARK: - Properties
    
    
    var viewModel: NewHomeViewModel = NewHomeViewModel()
    var detailViewModel: DetailViewModel = DetailViewModel()
    
    public var source: Source = .Favrate
    private var refreshControl = UIRefreshControl()
    private var pageAds = 1
    private var pageFeatured = 1
    
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    private  let cellsPerRow = 2
    private var isFavorate: Bool = false
    private var adsType: AdCategory?
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchAds(source: source)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hiddenNavigation(isHidden: false)
        
    }
    
    
    // MARK: - Protected Methods
    
    private func fetchAds(source: Source) {
        showLoading()
        switch source {
        case .Favrate:
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
        case .History:
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
        case .comeFromHome(isAds: let isAds):
            if isAds {
                
                viewModel.getAdsCategory {[weak self] error in
                    
                    if error != nil {
                        self?.showToast(message: error)
                        return
                    }
//                    if self?.adsType == nil {
//                        self?.adsType = self?.viewModel.adCategory.first
//                    }
                    self?.viewModel.adsList(page: 1, search: "", adsType: self?.adsType?.id) { (error) in
                        defer {
                            self?.stopLoading()
                        }
                        
                        if error != nil {
                            self?.showToast(message: error)
                            return
                        }
                        
                        self?.adsCollectionView.reloadData()
                    }
                }
            } else {
                viewModel.featuredList(page: pageAds, search: "") { [weak self] (error) in
                    defer {
                        self?.stopLoading()
                    }
                    
                    if error != nil {
                        self?.showToast(message: error)
                        return
                    }
                    self?.adsCollectionView.reloadData()
                }
            }
        }
    }
    
    
    private func setupCollectionView() {
        adsCollectionView.contentInsetAdjustmentBehavior = .always
        setupRefershControl()
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        adsCollectionView.register(AdsCell.self)
        adsCollectionView.register(FeaturedCell.self)
        adsCollectionView.register(UINib(nibName: AdsHomeFilterCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AdsHomeFilterCollectionReusableView.identifier)
    }
    
    private func setupRefershControl() {
        if #available(iOS 10.0, *) {
            adsCollectionView.refreshControl = refreshControl
        } else {
            adsCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        refreshControl.endRefreshing()
        pageAds = 1
        fetchAds(source: source)
    }
    
    func makeAdsCell(ads: [Adverisment], indexPath: IndexPath) -> AdsCell {
        let cell: AdsCell = adsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.photoImageView.image = nil
        cell.setup(indexItem: indexPath.row, isFavorate: true, ads: ads[indexPath.row]) { [weak self] in
            guard let self = self else { return }
            if ads[indexPath.row].adCategoryID == AdsTypes.store.rawValue {
                let ad = self.viewModel.adsList[indexPath.item]
                let vc = self.initViewControllerWith(identifier: StoreViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
                vc.storeId = ad.storeId
                self.show(vc)
                return
            }
            
            let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: source == .comeFromHome(isAds: false) ? self.viewModel.featuredAdsList : self.viewModel.adsList, index: indexPath.row), source: .Home)
            self.show(vc)
            
//
        } favorateBlock: { [weak self]  in
            guard let self = self else { return }
            self.addToFavorate(id: ads[indexPath.row].id ?? -1, isFavorate: (ads[indexPath.row].isFav ?? false), index: indexPath.row, complation: { [weak self] value in
                if value {
                    self?.pageAds = 1
                    self?.fetchAds(source: self?.source ?? .Favrate)
                }
            }
            )}
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if source == .comeFromHome(isAds: false) {
            return viewModel.featuredAdsList.count
        }
        return viewModel.adsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if source == .comeFromHome(isAds: false) {
            return makeAdsCell(ads: viewModel.featuredAdsList, indexPath: indexPath)
        }
        return makeAdsCell(ads: viewModel.adsList, indexPath: indexPath)
    }
    
    
    func addToFavorate(id: Int,isFavorate: Bool,index: Int,complation: @escaping (Bool) -> Void) {
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
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
        vc.config(viewModel: StoryViewModel(adsList: source == .comeFromHome(isAds: false) ? viewModel.featuredAdsList : viewModel.adsList, index: indexPath.item), source: source == .Favrate ? .Favrate : .History)
            show(vc)
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
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.hasMore && viewModel.itemCount - 1 == indexPath.row  {
//            pageAds += 1
//            fetchAds(source: source)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionHeader {
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AdsHomeFilterCollectionReusableView", for: indexPath) as! AdsHomeFilterCollectionReusableView
               
               // Configure your header view
               headerView.filter = viewModel.adCategory
               headerView.delegate = self
               return headerView
           }
           return UICollectionReusableView()
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if source == .comeFromHome(isAds: true) {
            return CGSize(width: collectionView.frame.width - 30, height: 100) // Adjust height as needed
        } else {
            return CGSize(width: collectionView.frame.width - 30, height: 0) // Adjust height as needed
        }
          
       }
    
}

extension FavoriteViewController: AdsHomeFilterCollectionReusableViewDelegate {
    func didtapChooseFilter(_ sender: AdsHomeFilterCollectionReusableView, adsType: AdCategory) {
        self.adsType = adsType
        fetchAds(source: source)
    }
}
