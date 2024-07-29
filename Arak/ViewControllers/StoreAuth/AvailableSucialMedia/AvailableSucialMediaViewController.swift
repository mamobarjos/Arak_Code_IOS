//
//  AvailableSucialMediaViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 20/07/2024.
//

import UIKit

protocol AvailableSucialMediaViewControllerDelegate: AnyObject{
    func didSelectSocialMedia(type: Set<SocialMediaType>)
}

enum SocialMediaType{
    case whatsApp
    case instagram
    case youtube
    case website
    case facebook
}
class AvailableSucialMediaViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var whatsButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    
    weak var delegate: AvailableSucialMediaViewControllerDelegate?
    var selectedSocialMedia: Set<SocialMediaType> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismissViewController()
    }
    
    @IBAction func whatsButtonAction(_ sender: UIButton) {
        toggleSelectionSocialMedia(for: .whatsApp, button: sender)

    }
    
    @IBAction func facebookButtonAction(_ sender: UIButton) {
        toggleSelectionSocialMedia(for: .facebook, button: sender)

    }
    
    @IBAction func instaButtonAction(_ sender: UIButton) {
        toggleSelectionSocialMedia(for: .instagram, button: sender)

    }
    
    @IBAction func youtubeButtonAction(_ sender: UIButton) {
        toggleSelectionSocialMedia(for: .youtube, button: sender)

    }
    
    @IBAction func webButtonAction(_ sender: UIButton) {
        toggleSelectionSocialMedia(for: .website, button: sender)
    }
    
    @IBAction func adduttonAction(_ sender: Any) {
        delegate?.didSelectSocialMedia(type: selectedSocialMedia)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func toggleSelectionSocialMedia(for type: SocialMediaType, button: UIButton){
        if selectedSocialMedia.contains(type){
            selectedSocialMedia.remove(type)
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1
        }else{
            selectedSocialMedia.insert(type)
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.4309999943, blue: 0.1800000072, alpha: 1)
            button.layer.borderWidth = 2
        }
    }
}
