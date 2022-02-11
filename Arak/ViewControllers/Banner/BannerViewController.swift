//
//  BannerViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 11/07/2021.
//

import UIKit

class BannerViewController: UIViewController {
    enum AdsType {
        case Banner
        case Featured
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = HomeViewModel()
    private var pageFeatured = 1
    private var pageBanner = 1
    private var adsType:AdsType = .Banner
    private let inset: CGFloat = 10
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10
    private  let cellsPerRow = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        collectionView.register(AdsCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
    
    private func fetchData() {
        if adsType == .Banner {
            title = "Banners".localiz()

            fetchBannerAds()
        } else {
            title = "Featured".localiz()
            fetchFeaturedAds()
        }
    }
    
    func confige(adsType: AdsType) {
        self.adsType = adsType
    }
    
    private func fetchBannerAds() {
        showLoading()
        viewModel.getBannerList(page: pageBanner, search: "") { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            self?.collectionView.reloadData()
        }
    }
    private func fetchFeaturedAds() {
        showLoading()
        viewModel.featuredList(page: pageFeatured, search: "") { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            self?.collectionView.reloadData()
        }
    }
    
}
extension BannerViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AdsCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        if adsType == .Banner {
            cell.setupBanner(path: viewModel.itemBanner(at: indexPath.row)?.path ?? "")
        } else {
            cell.setupBanner(path: viewModel.itemFeatured(at: indexPath.row)?.adImages?.first?.path ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if adsType == .Banner {
            viewModel.itemBannerCount == 0 ?  self.collectionView.setEmptyView(onClickButton: {
                self.fetchData()
            }) : self.collectionView.restore()
            return viewModel.itemBannerCount
        }
        viewModel.itemFeaturedCount == 0 ?  self.collectionView.setEmptyView(onClickButton: {
            self.fetchData()
        }) : self.collectionView.restore()
        return viewModel.itemFeaturedCount
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if  adsType == .Featured  && indexPath.row  == viewModel.itemFeaturedCount - 1 && viewModel.hasMoreFeaturedAds {
            pageFeatured += 1
            fetchData()
        } else if  adsType == .Banner  && indexPath.row  == viewModel.itemBannerCount - 1 && viewModel.hasMoreBannerAds {
            pageBanner += 1
            fetchData()
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
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing
        if adsType == .Banner {
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
            return CGSize(width: itemWidth, height: 125)
        }
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(1)).rounded(.down)
        return CGSize(width: itemWidth, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if adsType == .Banner {
            let vc = self.initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
            vc.confige(imageNames: [self.viewModel.itemBanner(at: indexPath.row)?.path ?? ""])
            self.show(vc)
        } else {
            let vc = self.initViewControllerWith(identifier: StoryViewController.className, and: "") as! StoryViewController
            vc.config(viewModel: StoryViewModel(adsList: self.viewModel.getAllFeatured(), index: indexPath.row), source: .Home)
            self.show(vc)
        }
    }
}
