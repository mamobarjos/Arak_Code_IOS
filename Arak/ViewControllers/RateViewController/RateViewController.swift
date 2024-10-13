//
//  RateViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 03/08/2024.
//

import UIKit
import Cosmos

protocol RateViewControllerDelegate: AnyObject {
    func submiteReview(_ sender: RateViewController, context: String, rating: Double)
}

class RateViewController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var addReviewContainer: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    private(set) var rating: Double?
    
    weak var delegate: RateViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.delegate = self
        rateLabel.text = "label.Rate this service Provider".localiz()
        submitButton.setTitle("action.Submit".localiz(), for: .normal)
        reviewTextView.text = "placeHolder.Enter your review ...".localiz()
        reviewTextView.textAlignment = Helper.appLanguage == "en" ? .left : .right

        cosmosView.rating = 0
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            self?.rating = rating
        }
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submiteReviewAction(_ sender: Any) {
//        if reviewTextView.text == "placeHolder.Enter your review ...".localiz() || reviewTextView.text.isEmpty {
//            UIApplication.shared.topViewController?.showToast(message:  "error.please add your review".localiz())
//            return
//        }

        guard let rating = rating else {
            UIApplication.shared.topViewController?.showToast(message: "error.please rate this store".localiz())
            return
        }
        
        if reviewTextView.text == "placeHolder.Enter your review ...".localiz() {
            delegate?.submiteReview(self, context: "       ", rating: rating)
        } else {
            delegate?.submiteReview(self, context: reviewTextView.text, rating: rating)
        }
       
    }
}

extension RateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "placeHolder.Enter your review ...".localiz() {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "placeHolder.Enter your review ...".localiz()
            textView.textColor = .lightGray
        }
    }
}
