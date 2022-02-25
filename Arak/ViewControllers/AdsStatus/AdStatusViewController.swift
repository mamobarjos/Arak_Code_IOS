//
//  AdStatusViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import UIKit
import KDCircularProgress

class AdStatusViewController: UIViewController {
    @IBOutlet weak var progressCotntaierView: UIView!
    var progress: KDCircularProgress!

    override func viewDidLoad() {
        super.viewDidLoad()
        createProgressPar()

    }

    @IBAction func hilghightAction(_ sender: Any) {
    }

    @IBAction func editAction(_ sender: Any) {
    }

    @IBAction func deleteAction(_ sender: Any) {
    }
}

extension AdStatusViewController {
    func createProgressPar() {
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        progress.startAngle = -90
        progress.progressThickness = 0.8
        progress.trackThickness = 0.8
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .forward
        progress.glowAmount = 0
        progress.trackColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.9215686275, alpha: 1)
        progress.set(colors: .accentOrange)
//        progress.center = CGPoint(x: progressCotntaierView.center.x, y: progressCotntaierView.center.y)
        progress.animate(fromAngle: 0, toAngle: 270, duration: 2) { completed in
        }
        progressCotntaierView.addSubview(progress)
    }
}
