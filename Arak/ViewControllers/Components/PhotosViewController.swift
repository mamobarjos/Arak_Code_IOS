//
//  PhotosViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 20/03/2022.
//

import UIKit
import Kingfisher
import DTPhotoViewerController

private let kCollectionViewCellIdentifier = "Cell"
private let kNumberOfRows: Int = 3
private let kRowSpacing: CGFloat = 5
private let kColumnSpacing: CGFloat = 5

class PhotoViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    public var imagesFile: [StoreProductFile] = [] {
        didSet {
//            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCellIdentifier)
        collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem?.tintColor = .white
        self.hiddenNavigation(isHidden: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesFile.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellIdentifier, for: indexPath) as! CollectionViewCell
        if let url = URL(string: imagesFile[indexPath.item].path ?? "") {
            cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }
//        let item = imagesFile[indexPath.item]
//        cell.setup(productFile: item)
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width - 10, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }
}

extension PhotoViewController: DTPhotoViewerControllerDataSource {
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = self.collectionView?.cellForItem(at: indexPath) as? CollectionViewCell {
            return cell.imageView
        }

        return nil
    }

    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return imagesFile.count
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
         // You need to implement this method usually when using custom DTPhotoCollectionViewCell and configure each photo differently.
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        if let url = URL(string: imagesFile[index].path ?? "") {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }

    }


}
public class CollectionViewCell: UICollectionViewCell {
    public private(set) var imageView: UIImageView!

    weak var delegate: DTPhotoCollectionViewCellDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.clear
        contentView.addSubview(imageView)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        let margin = CGFloat(5)
        imageView.frame = CGRect(x: margin, y: margin, width: bounds.size.width - 2 * margin, height: bounds.size.height - 2 * margin)
    }
}
