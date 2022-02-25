//
//  FeaturedCell.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import UIKit
import FSPagerView

protocol FeaturedCelldelegate: AnyObject {
    func displayedCellIndex(index: Int)
}

class FeaturedCell: UICollectionViewCell {
    
    typealias PlayVideoBlock = (Int) -> Void
    typealias FavorateBlock = (Int) -> Void
    typealias MoreBlock = () -> Void

    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var featuredPagerView: FSPagerView!
    
    private var featuredAdsList: [Adverisment] = [] {
        didSet {
            self.featuredPagerView.reloadData()
        }
    }
    private var bannerList: [AdBanner] = []
    private var playVideoBlock:PlayVideoBlock?
    private var favorateBlock:FavorateBlock?
    private var moreBlock:MoreBlock?

    private var isFavorate: Bool = false
    var isBanner: Bool = false
    weak var delegate: FeaturedCelldelegate?
        
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerList = []
        featuredAdsList = []
        isFavorate = false
        isBanner = false
        pageControl.numberOfPages = 0
        featuredPagerView.reloadData()
    }

    func setup(bannerList: [AdBanner]) {
        self.bannerList = bannerList
        isBanner = true
        pageControl.numberOfPages = bannerList.count
        featuredPagerView.isInfinite = true
        featuredPagerView.automaticSlidingInterval = 5
        self.setupSlider()
    }

    func setup(featuredAdsList: [Adverisment],isFavorate: Bool,playVideoBlock:PlayVideoBlock?,favorateBlock:FavorateBlock?,moreBlock:MoreBlock?) {
        self.featuredAdsList = featuredAdsList
        self.playVideoBlock = playVideoBlock
        self.moreBlock = moreBlock
        self.isFavorate = isFavorate
        self.favorateBlock = favorateBlock
        pageControl.numberOfPages = featuredAdsList.count
        self.setupSlider()
    }
    
    func setup(bannerList: [AdBanner],moreBlock:MoreBlock?,playVideoBlock:PlayVideoBlock?) {
        isBanner = true
        self.moreBlock = moreBlock
        self.bannerList = bannerList
        self.playVideoBlock = playVideoBlock
        pageControl.numberOfPages = bannerList.count
        self.setupSlider()
        featuredPagerView.isInfinite = true
    }
    
    private func setupSlider() {
        let nib = UINib(nibName: AdsCell.className, bundle: Bundle.main)
        featuredPagerView.register(nib, forCellWithReuseIdentifier: "cell")
        let moreNib = UINib(nibName: MoreCell.className, bundle: Bundle.main)
        featuredPagerView.register(moreNib, forCellWithReuseIdentifier: "moreCell")
        featuredPagerView.automaticSlidingInterval = isBanner ? 3 : 0
        featuredPagerView.transformer = FSPagerViewTransformer(type: .linear)
        featuredPagerView.delegate = self
        featuredPagerView.dataSource = self
        pageControl.hidesForSinglePage = true
        pageControl.isHidden = isBanner ?  bannerList.count <= 1  : featuredAdsList.count <= 1
        //featuredPagerView.itemSize = CGSize(width: contentView.frameWidth, height: contentView.frameHeight)
        
        featuredPagerView.reloadData()
    }
    
    func updateFavorate(index:Int,isFavorate: Bool) {
        featuredAdsList[index].isFav = isFavorate
        featuredPagerView.reloadData()
    }
}
extension FeaturedCell : FSPagerViewDelegate ,  FSPagerViewDataSource {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if isBanner {
            if index == bannerList.count {
                guard let cell: MoreCell = featuredPagerView.dequeueReusableCell(withReuseIdentifier: "moreCell", at: index) as? MoreCell else {
                    return FSPagerViewCell()
                }
                cell.setup { [weak self] in
                    self?.moreBlock?()
                }
                return cell
            }
            guard let cell: AdsCell = featuredPagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? AdsCell else {
                return FSPagerViewCell()
            }
            cell.setupBanner(path: bannerList[index].path ?? "")
            
            return cell
        }
        
        if index == featuredAdsList.count {
            guard let cell: MoreCell = featuredPagerView.dequeueReusableCell(withReuseIdentifier: "moreCell", at: index) as? MoreCell else {
                return FSPagerViewCell()
            }
            cell.setup { [weak self] in
                self?.moreBlock?()
            }
            return cell
        }
        guard let cell: AdsCell = featuredPagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? AdsCell else {
            return FSPagerViewCell()
        }
        cell.setup(indexItem: index, isFavorate: isFavorate, ads: featuredAdsList[index]) {  [weak self] in
            self?.playVideoBlock?(index)
        } favorateBlock: {  [weak self] in
            self?.favorateBlock?(index)
            
        }
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if index == featuredAdsList.count {
            self.moreBlock?()
        } else if isBanner && index == bannerList.count {
            self.moreBlock?()
        } else {
            self.playVideoBlock?(index)
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        self.pageControl.currentPage = index
        self.delegate?.displayedCellIndex(index: index)
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if isBanner {
            return self.bannerList.count
        }
        return self.featuredAdsList.count + 1
    }
    
}
