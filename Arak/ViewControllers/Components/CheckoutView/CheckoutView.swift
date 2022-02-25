//
//  CheckoutView.swift
//  Arak
//
//  Created by Osama Abu hdba on 25/02/2022.
//

import Foundation
import UIKit

class CheckoutView: UIView {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    var onAction: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }


    @IBAction func checkoutAction(_ sender: Any) {
        onAction?()
    }

     func setup() {
        guard let view = self.loadViewFromNip(nipName: "CheckoutView") else {return}
        view.frame = self.bounds
        self.addSubview(view)

         if !UIAccessibility.isReduceTransparencyEnabled {
             self.backgroundColor = .clear
             self.containerView.backgroundColor = .clear
             let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
             let blurEffectView = UIVisualEffectView(effect: blurEffect)

             //always fill the view
             blurEffectView.frame = self.containerView.bounds
             blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

             self.containerView.insertSubview(blurEffectView, at: 0) //if you have more UIViews, use an insertSubview API to place it where needed

         } else {
             self.containerView.backgroundColor = .white
         }
     }
}
