//
//  Duration.swift
//  Arak
//
//  Created by Abed Qassim on 09/03/2021.
//

import Foundation
import AVKit
extension String {
  

    func getDuration(compliation: @escaping ((Int)-> Void))   {
      DispatchQueue.global(qos: .userInitiated).async {
        if let url = URL(string: self) {
          let duration = AVURLAsset(url: url).duration.seconds
            DispatchQueue.main.async {
                compliation(Int(duration))
            }
        }

      }

    }
}

extension String {
  func isVideo() -> Bool {
    return self.contains(".mp4")
  }
}
