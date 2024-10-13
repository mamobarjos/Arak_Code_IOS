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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    public var productName: String?
    public var imageUrl: String?
    weak var delegate: OpenProductViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productNameLabel.text = productName
        imageView.kf.setImage(with: URL(string: imageUrl ?? ""))
        subtitleLabel.text = "Choose the option you want to apply".localiz()
        viewButton.setTitle("View".localiz(), for: .normal)
        editButton.setTitle("Edit".localiz(), for: .normal)
        dismissButton.setTitle("Dismiss", for: .normal)
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
