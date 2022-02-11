//
//  ImageSliderViewController.swift
//  Joyin
//
//  Created by Abed Qassim on 24/04/2021.
//

import UIKit
import FSPagerView
import AVKit

class ImageSliderViewController: UIViewController {
  @IBOutlet weak var sliderPagerView: FSPagerView!{
    didSet {
        self.sliderPagerView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        self.sliderPagerView.itemSize = FSPagerView.automaticSize
      sliderPagerView.delegate = self
      sliderPagerView.dataSource = self
    }
}
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var pageControl: FSPageControl!{
    didSet {
        self.pageControl.numberOfPages = imageNames?.count ?? 0
        self.pageControl.contentHorizontalAlignment = .center
        self.pageControl.isHidden = imageNames?.count ?? 0 <= 1
    }
  }
  private var imageNames:[String]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .black
      sliderPagerView.backgroundColor = .black
      let imageBack = UIImage(named: "X")?.imageFlippedForRightToLeftLayoutDirection()
      backButton.setImage(imageBack, for: .normal)
      backButton.tintColor = .white
      setupSlider()
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hiddenNavigation(isHidden: true)

  }
  @IBAction func Back(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  private func setupSlider() {

    let nib = UINib(nibName:  ImageCell.className, bundle: Bundle.main)
    sliderPagerView.register(nib, forCellWithReuseIdentifier: "cell")
    sliderPagerView.automaticSlidingInterval = 0
    sliderPagerView.transformer = FSPagerViewTransformer(type: .linear)
    sliderPagerView.delegate = self
    sliderPagerView.dataSource = self
    pageControl.hidesForSinglePage = true
    sliderPagerView.itemSize = CGSize(width: view.frameWidth, height: view.frameHeight)
   
    self.pageControl.isHidden = imageNames?.count ?? 0 <= 1
    pageControl.numberOfPages = imageNames?.count ?? 0
  }

  func confige(imageNames:[String]) {
    self.imageNames = imageNames
  }
}
extension ImageSliderViewController: FSPagerViewDataSource,FSPagerViewDelegate {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return imageNames?.count ?? 0
  }

  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? ImageCell else {
      return FSPagerViewCell()
    }
    if imageNames?[index].isVideo() ?? false {
      cell.photoImageView.contentMode = .scaleAspectFit
      cell.photoImageView.imageFromVideo(videoURL: imageNames?[index])
      cell.playVideoButton.isHidden = false
    } else {
      cell.photoImageView.contentMode = .scaleAspectFit
      cell.photoImageView.getAlamofireImage(urlString: imageNames?[index])
      cell.playVideoButton.isHidden = true
    }
    cell.photoImageView.isPinchable = true
    return cell
  }

  func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
          self.pageControl.currentPage = targetIndex
  }

  func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
   self.pageControl.currentPage = pagerView.currentIndex
  }


}
extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
