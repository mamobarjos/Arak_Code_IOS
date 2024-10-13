//
//  CongretsStoreViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 25/02/2022.
//

import UIKit

class CongretsStoreViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createAdLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    private(set) var congretsType: CongretsType = .store

    override func viewDidLoad() {
        super.viewDidLoad()
        successLabel.text = "title.Success".localiz()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        createAdLabel.addGestureRecognizer(tap)
        titleLabel.text = congretsType.title
        createAdLabel.text = congretsType.actionTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
    public func configure(for type: CongretsType = .store) {
        congretsType = type
    }

    private func openCreateService() {
        show(congretsType.view)
    }

    @objc func handleTap() {
        // go to create service
        openCreateService()
    }

    @IBAction func nextAction(_ sender: Any) {
        // go to create service
        openCreateService()
    }
}

extension CongretsStoreViewController {
    enum CongretsType {
        case store
        case service

        var title: String {
            switch self {
            case .store:
                return "title.Your store has been successfully created".localiz()
            case .service:
                return "title.Your Service has been successfully created".localiz()
            }
        }

        var actionTitle: String {
            switch self {
            case .store:
                return "title.Go To Your Store".localiz()
            case .service:
                return "title.Go To Your Store".localiz()
            }
        }

        var view: UIViewController {
            switch self {
            case .store:
                let vc = initViewControllerWith(identifier: StoreViewController.className, and:  "") as! StoreViewController
                vc.storeId = Helper.UserStoreId
                return vc
            case .service:
                let vc = initViewControllerWith(identifier: StoreViewController.className, and:  "") as! StoreViewController
                vc.storeId = Helper.UserStoreId
                vc.mode = .edit
                return vc
            }
        }

        private func initViewControllerWith(identifier: String, and title: String, storyboardName: String = "Main_2") -> UIViewController {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: identifier)
            vc.title = title
            return vc
        }
    }
}
