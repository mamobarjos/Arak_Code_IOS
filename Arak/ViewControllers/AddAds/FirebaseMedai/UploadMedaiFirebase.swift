//
//  UploadImages.swift
//  Arak
//
//  Created by Abed Qassim on 08/03/2021.
//

import Foundation
import Firebase
import FirebaseStorage

class UploadMedia: NSObject{

  static func saveImages(userId:String,imagesArray : [UIImage?], completionHandler: @escaping ([String]) -> ()){
      uploadImages(userId: userId, imagesArray: imagesArray, completionHandler: completionHandler)
  }

  static func uploadVideo(userId:String , videoURL: URL? ,completionHandler: @escaping (String) -> ()) {
    let storage =  Storage.storage()
    let storageRef = storage.reference().child("\(Int(Date().timeIntervalSince1970)).mp4")
    guard let videoURLPath = videoURL else{
        return
    }
    let data = NSData(contentsOf: videoURLPath as URL)
    guard let dataWrapped = data as Data?  else {
      return
    }
    let metaData = StorageMetadata()
    metaData.contentType = "mp4"


    let uploadVideoTask = storageRef.putData(dataWrapped, metadata: metaData) { (metaData, error) in
      if error != nil{
          print(error?.localizedDescription ?? "")
          return
      }
      storageRef.downloadURL { (url, error) in
        if error != nil{
            print(error?.localizedDescription ?? "")
            return
        }
        if let videoUrl = url?.absoluteString {
           completionHandler(videoUrl)
        }
      }
    }
    observeUploadTaskFailureCases(uploadTask : uploadVideoTask)
  }
  static func deleteMedia(dataArray : [String], completionHandler: @escaping () -> ()){
    let storage =  Storage.storage()
    var uploadCount = 0
    for item in dataArray {
        if item.contains("firebasestorage") {
            let storageRef = storage.reference(forURL: item)
            storageRef.delete { error in
              uploadCount += 1
              if uploadCount == dataArray.count {
                  completionHandler()
              }
            }
        } else {
            uploadCount += 1
        }
    }
  }

  static func uploadImages(userId: String, imagesArray : [UIImage?], completionHandler: @escaping ([String]) -> ()){
    let storage =  Storage.storage()
    var uploadedImageUrlsArray = [String]()
    var uploadCount = 0
    let imagesCount = imagesArray.count

    for image in imagesArray {

        let imageName = UUID().uuidString
        let storageRef = storage.reference().child("\(imageName).jpg")
        guard let img = image else {
          continue
        }
        guard let uplodaData = img.jpegData(compressionQuality: 0.5) else{
            return
        }

          let metaData = StorageMetadata()
          metaData.contentType = "image/jpg"


        let uploadTask = storageRef.putData(uplodaData, metadata: metaData, completion: { (metadata, error) in
            if error != nil{
                print(error?.localizedDescription ?? "")
                return
            }

          storageRef.downloadURL { (url, error) in
            if error != nil{
                print(error?.localizedDescription ?? "")
                return
            }
            if let imageUrl = url?.absoluteString {
                  print(imageUrl)
                  uploadedImageUrlsArray.append(imageUrl)
                  uploadCount += 1
                  print("Number of images successfully uploaded: \(uploadCount)")
                  if uploadCount == imagesCount{
                      NSLog("All Images are uploaded successfully, uploadedImageUrlsArray: \(uploadedImageUrlsArray)")
                      completionHandler(uploadedImageUrlsArray)
                  }
              }
          }

        })

        observeUploadTaskFailureCases(uploadTask : uploadTask)
    }
}

    static func observeUploadTaskFailureCases(uploadTask : StorageUploadTask){
        uploadTask.observe(.failure) { snapshot in
          if let error = snapshot.error as NSError? {
            switch (StorageErrorCode(rawValue: error.code)!) {
            case .objectNotFound:
              NSLog("File doesn't exist")
              break
            case .unauthorized:
              NSLog("User doesn't have permission to access file")
              break
            case .cancelled:
              NSLog("User canceled the upload")
              break

            case .unknown:
              NSLog("Unknown error occurred, inspect the server response")
              break
            default:
              NSLog("A separate error occurred, This is a good place to retry the upload.")
              break
            }
          }
        }
    }

}
