//
//  ProductContentView.swift
//  Arak
//
//  Created by Osama Abu hdba on 13/02/2022.
//

import UIKit
import FSPagerView
import Cosmos

protocol ProductContentViewDelegate: AnyObject {
    func userDidTapFavIcon(id: String)
    func userDidTapShare(id: String)
}

class ProductContentView: UIView {
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var editedCosmosView: CosmosView!
    @IBOutlet weak var relatedProductCollectionView: UICollectionView!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var rateTextView: UITextView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    @IBAction func shareAction(_ sender: Any) {

    }
    @IBAction func favAction(_ sender: Any) {

    }
    @IBAction func backAction(_ sender: Any) {

    }
    @IBAction func submitButton(_ sender: Any) {

    }

     func setup() {
        guard let view = self.loadViewFromNip(nipName: "ProductContentView") else {return}
        view.frame = self.bounds
        self.addSubview(view)
//         productsTableView.delegate = self
//         productsTableView.dataSource = self
//         productsTableView.rowHeight = UITableView.automaticDimension
//         productsTableView.estimatedRowHeight = 150
//         productsTableView.register(ProductTableViewCell.self)
//         productsTableView.separatorColor = .clear
//
         reviewsTableView.delegate = self
         reviewsTableView.dataSource = self
         reviewsTableView.rowHeight = UITableView.automaticDimension
         reviewsTableView.estimatedRowHeight = 150
         reviewsTableView.separatorColor = .clear
         reviewsTableView.register(ReviewTableViewCell.self)
    }
}

extension ProductContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setup()
            return cell

    }
}

extension ProductContentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let height: CGFloat = 280
           return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: height)
           //10 is minimum line spacing between two columns
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }

}
