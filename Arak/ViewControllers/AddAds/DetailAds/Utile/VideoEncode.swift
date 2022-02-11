//
//  VideoEncode.swift
//  Arak
//
//  Created by Abed Qassim on 28/02/2021.
//

import UIKit
import AVKit
class VideoEncode {

  static var sheard = VideoEncode()
  // Don't forget to import AVKit
  func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
      let avAsset = AVURLAsset(url: videoURL, options: nil)

      let startDate = Date()

      //Create Export session
      guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
          completionHandler?(nil, nil)
          return
      }

      //Creating temp path to save the converted video
      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
      let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")

      //Check if the file already exists then remove the previous file
      if FileManager.default.fileExists(atPath: filePath.path) {
          do {
              try FileManager.default.removeItem(at: filePath)
          } catch {
              completionHandler?(nil, error)
          }
      }

      exportSession.outputURL = filePath
      exportSession.outputFileType = AVFileType.mp4
      exportSession.shouldOptimizeForNetworkUse = true
      let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
      let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
      exportSession.timeRange = range

      exportSession.exportAsynchronously(completionHandler: {() -> Void in
          switch exportSession.status {
          case .failed:
              print(exportSession.error ?? "NO ERROR")
              completionHandler?(nil, exportSession.error)
          case .cancelled:
              print("Export canceled")
              completionHandler?(nil, nil)
          case .completed:
              //Video conversion finished
              let endDate = Date()

              let time = endDate.timeIntervalSince(startDate)
              print(time)
              print("Successful!")
              print(exportSession.outputURL ?? "NO OUTPUT URL")
              completionHandler?(exportSession.outputURL, nil)

              default: break
          }

      })
  }

  func deleteFile(_ filePath:URL) {
      guard FileManager.default.fileExists(atPath: filePath.path) else{
          return
      }
      do {
          try FileManager.default.removeItem(atPath: filePath.path)
      }catch{
          fatalError("Unable to delete file: \(error) : \(#function).")
      }
  }
}
