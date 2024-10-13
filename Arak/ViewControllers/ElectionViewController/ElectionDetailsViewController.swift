//
//  ElectionDetailsViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 28/07/2024.
//

import UIKit
import MessageUI

class ElectionDetailsViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLAbel: UILabel!
    @IBOutlet weak var distrectLabel: UILabel!
    @IBOutlet weak var descrriptionLabel: UITextView!
    
    @IBOutlet weak var clusterHeaderLabel: UILabel!
    @IBOutlet weak var clusterLabel: UILabel!
    
    @IBOutlet weak var electoralDistrictHeaderLabel: UILabel!
    @IBOutlet weak var electoralDistricLabel: UILabel!
    
    @IBOutlet weak var governorateHeaderLabel: UILabel!
    @IBOutlet weak var governorateLabel: UILabel!
    
    var electionPerson: EllectionPeople?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    func setupUI() {
        guard let electionPerson else {return}
        bannerImageView.getAlamofireImage(urlString: electionPerson.coverImg ?? "")
        descrriptionLabel.text = electionPerson.description
        profileImageView.getAlamofireImage(urlString: electionPerson.img ?? "")
        nameLAbel.text = electionPerson.name
//        distrectLabel.text = electionPerson.district?.name
        clusterLabel.text = electionPerson.cluster
        electoralDistricLabel.text = electionPerson.governorate?.name
        governorateLabel.text = electionPerson.governorate?.name
        
        clusterHeaderLabel.text = "Cluster".localiz()
        electoralDistrictHeaderLabel.text = "Electoral district".localiz()
        governorateHeaderLabel.text = "Governorate".localiz()
    }
    
    func makePhoneCall(to phoneNumber: String) {
        // Ensure the phone number is properly formatted
        let formattedPhoneNumber = phoneNumber.filter { "0123456789".contains($0) }
        
        // Create the URL with the tel scheme
        if let phoneURL = URL(string: "tel://\(formattedPhoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
            // Open the URL to initiate the phone call
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            // Handle the error (e.g., device cannot make phone calls)
            print("Error: Cannot make phone call")
        }
    }
    
    func sendEmail(email: String) {
        // Check if the device is configured to send email
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services are not available")
            return
        }
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        
        // Configure the fields of the interface
        mailComposeViewController.setToRecipients([email])
        
        // Present the view controller
        present(mailComposeViewController, animated: true, completion: nil)
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        makePhoneCall(to: electionPerson?.phoneNo ?? "")
    }
    @IBAction func messageButtonAction(_ sender: Any) {
        sendEmail(email: electionPerson?.email ?? "")
    }
}


extension ElectionDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller
        controller.dismiss(animated: true, completion: nil)
        
        // Handle the result
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        @unknown default:
            break
        }
    }
}
