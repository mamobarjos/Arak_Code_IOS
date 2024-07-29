//
//  OpenProductViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 24/07/2024.
//

import UIKit

protocol OpenProductViewControllerDelegate: AnyObject {
    func didUserTapViewProduct(_ sender: OpenProductViewController)
    func didUserTapEditProduct(_ sender: OpenProductViewController)
}

class OpenProductViewController: UIViewController {

    weak var delegate: OpenProductViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func viewButtonAction(_ sender: Any) {
        delegate?.didUserTapViewProduct(self)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        delegate?.didUserTapEditProduct(self)
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismissViewController()
    }
}
