//
//  StoreViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit

class StoreViewController: UIViewController {

//    @IBOutlet weak var contentView: StoreContentView!
    let contentView = StoreContentView()
    lazy var scrollView = ScrollContainerView(contentView: contentView)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.layout.fill(.superview)
        scrollView.scrollView.contentInset.bottom = 1

    }

}
