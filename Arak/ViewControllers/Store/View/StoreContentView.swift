//
//  StoreContentView.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit

class StoreContentView: UIView {
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backButoon: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var snabButton: UIButton!
    @IBOutlet weak var youTubeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }


     func setup() {
        guard let view = self.loadViewFromNip(nipName: "StroreContentView") else {return}
        view.frame = self.bounds
        self.addSubview(view)
         productsTableView.delegate = self
         productsTableView.dataSource = self
         productsTableView.rowHeight = UITableView.automaticDimension
         productsTableView.estimatedRowHeight = 150
         productsTableView.register(ProductTableViewCell.self)
    }
}

extension StoreContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProductTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup()
        return cell
    }


}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }

    func loadViewFromNip(nipName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nip = UINib(nibName: nipName, bundle: bundle)
        return nip.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
