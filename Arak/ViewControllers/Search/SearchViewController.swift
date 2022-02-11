//
//  SearchViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 08/07/2021.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    // MARK: - Properties
    
    
    var viewModel: HomeViewModel = HomeViewModel()
    var detailViewModel: DetailViewModel = DetailViewModel()
    private var refreshControl = UIRefreshControl()
    private var pageAds = 1
    private var pageFeatured = 1
    
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    private  let cellsPerRow = 2
    private var isFavorate: Bool = false
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.placeholder = "Search videos,images and many more".localiz()
        title = "Search".localiz()
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        setupCollectionView()
        //fetchAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hiddenNavigation(isHidden: false)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            if let search = searchTextField.text , !search.isEmpty {
                pageAds = 1
                fetchAds()
            }
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Protected Methods

    private func fetchAds() {
        showLoading()
        viewModel.searchList(page: pageAds, search: searchTextField.text ?? "") { [weak self] (error) in
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
    
    
    private func setupCollectionView() {
        adsCollectionView.contentInsetAdjustmentBehavior = .always
        setupRefershControl()
        adsCollectionView.register(AdsCell.self)
        adsCollectionView.register(FeaturedCell.self)
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
        fetchAds()
    }
    
    
}
extension SearchViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = viewModel.itemCount
        if viewModel.itemFeaturedCount > 0 {
            count += 1
        }
        count == 0 && (searchTextField.text?.isEmpty ?? false == false) ?  self.adsCollectionView.setEmptyView(onClickButton: {
            self.fetchAds()
        }) : self.adsCollectionView.restore()
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.itemFeaturedCount > 0  {
            if indexPath.row == 0 {
                return makeFeatured(indexPath: indexPath,isBanner: false)
            }
            let index = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            return makeAdsCell(indexPath: index)
        }
        return makeAdsCell(indexPath: indexPath)
    }
    
    func makeFeatured(indexPath:IndexPath,isBanner: Bool) -> FeaturedCell {
        if isBanner {
            let cell:FeaturedCell = adsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.layoutIfNeeded()
            return cell
        }
        let cell:FeaturedCell = adsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.layoutIfNeeded()
        cell.setup(featuredAdsList: viewModel.getAllFeatured(), isFavorate: isFavorate) { [weak self] index in
            guard let self = self else { return }
            let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: self.viewModel.getAllFeatured(), index: index), source: .Home)
            self.show(vc)
        } favorateBlock: { [weak self] index   in
            guard let self = self else { return }
            self.addToFavorate(id: self.viewModel.getAllFeatured()[index].id ?? -1, isFavorate: (self.viewModel.getAllFeatured()[index].isFav), index: index, complation: { [weak self] value in
                if value {
                    cell.updateFavorate(index: index, isFavorate: !(self?.viewModel.getAllFeatured()[index].isFav ?? false))
                    self?.pageAds = 0
                    self?.fetchAds()
                }
            })
        } moreBlock: {
            if isBanner {
                
            } else {
                
            }
        }
        cell.featuredPagerView.reloadData()
        return cell
    }
    
    func addToFavorate(id: Int,isFavorate: Bool,index: Int,complation: @escaping (Bool) -> Void) {
        showLoading()
        self.detailViewModel.favorite(id: id, isFavorate: isFavorate) { [weak self] (error) in
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
        if let ads = viewModel.item(at: indexPath.row) {
            cell.setup(indexItem: indexPath.row, isFavorate: isFavorate,ads: ads) {  [weak self] in
                guard let self = self else { return }
                let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
                vc.config(viewModel: StoryViewModel(adsList: self.viewModel.getAll(), index: indexPath.row), source: .Home)
                self.show(vc)
            }  favorateBlock: { [weak self] in
                guard let self = self else { return }
                self.addToFavorate(id: self.viewModel.getAll()[indexPath.row].id ?? -1, isFavorate: self.viewModel.getAll()[indexPath.row].isFav ,index: indexPath.row, complation: { [weak self] value in
                    if value {
                        self?.viewModel.updateAdsFavorate(index:  indexPath.row)
                        self?.pageAds = 0
                        self?.fetchAds()
                    }
                })
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.itemFeaturedCount > 0  {
            if indexPath.row == 0 {
                let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
                vc.config(viewModel: StoryViewModel(adsList: viewModel.getAllFeatured(), index: indexPath.row), source: .Home)
                show(vc)
            }
            let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: viewModel.getAll(), index: indexPath.row - 1), source: .Home)
            show(vc)
        } else {
            let vc = initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: viewModel.getAll(), index: indexPath.row), source: .Home)
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
        if  viewModel.itemFeaturedCount > 0 {
            if indexPath.row == 0 {
                let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
                let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
                return CGSize(width: itemWidth, height: 220)
            } else {
                let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
                let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
                return CGSize(width: itemWidth, height: 200)
            }
        }
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.hasMore && viewModel.itemCount - 1 == indexPath.row  {
            pageAds += 1
            fetchAds()
        }
    }
    
}
