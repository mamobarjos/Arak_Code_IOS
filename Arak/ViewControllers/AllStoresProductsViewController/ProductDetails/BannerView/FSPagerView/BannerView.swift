//
//  BannerView.swift
//  CARDIZERR
//
//  Created by Osama Abu Hdba on 11/02/2023.
//

import UIKit
import FSPagerView

class BannerView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pagerControl: UIPageControl!
    @IBOutlet weak var pagerView: FSPagerView!

    public var bannerArray: [String] = [] {
        didSet {
            pagerView.reloadData()
            setupPagerController()
        }
    }
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init? (coder Decoder: NSCoder) {
        super.init(coder: Decoder)
        setup()
    }

    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

// MARK: - Private Functions
    private func setup() {
        setupUI()
        setupPagerView()
    }

    private func setupUI() {
        // Load the container view from the nib file
        Bundle.main.loadNibNamed(BannerView.className, owner: self, options: nil)
        addSubview(containerView)

        // Set up constraints for the container view
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setupPagerView() {
        let nib = UINib(nibName: BannerItemCollectionViewCell.className, bundle: nil)
        pagerView.register(nib, forCellWithReuseIdentifier: "cell")
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.automaticSlidingInterval = 4
        pagerView.isInfinite = true 
        pagerView.delegate = self
        pagerView.dataSource = self
        setupPagerController()
    }

    private func setupPagerController() {
        pagerControl.numberOfPages = 3
        pagerControl.currentPageIndicatorTintColor = .accentOrange
        pagerControl.pageIndicatorTintColor = .accentOrange.withAlphaComponent(0.5)

    }

}

extension BannerView:FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        bannerArray.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if let cell: BannerItemCollectionViewCell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? BannerItemCollectionViewCell{
//            let banner = bannerArray[index]
////            cell.setupCell(with: banner)
//            cell.onAction = { [weak self] in
//
//            }
//            cell.bannerImageView.image = UIImage(named: "banner")
            cell.cornerRadius = 16
            cell.setupCell(with: bannerArray[index])
            cell.contentView.layer.shadowColor = UIColor.clear.cgColor
            return cell
        }
        return FSPagerViewCell()
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        print(index)
    }

    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pagerView.tag = index
        self.pagerControl.currentPage = index
    }

    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.pagerControl.currentPage = pagerView.tag
    }
}
