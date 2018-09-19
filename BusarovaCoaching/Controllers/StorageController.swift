//
//  StorageController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 11/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation
import Firebase

class StorageController {
    private let storage: Storage

    init() {
        self.storage = Storage.storage()
    }
    
    private func image2data(_ image: UIImage) -> Data? {
        if let result = image.jpegData(compressionQuality: 1.0)  {
            return result
        } else if let result = image.pngData() {
            return result
        } else {
            return nil
        }
    }
    
    func uploadImage(_ image: UIImage, with name: String, to address: StoragePath, completion: @escaping (Result<String>) -> Void) {
        guard
            let data = image2data(image),
            let extention = data.imageFormat,
            let imageMetadata = data.imageMetadata else {
            return
        }
        
        let pathToUpload = "\(address.rawValue)\(name).\(extention)"
        
        let imageReference = storage.reference().child(pathToUpload)
        
        let metadata = StorageMetadata()
        metadata.contentType = imageMetadata
        
        let uploadTask = imageReference.putData(data, metadata: metadata) {
            (metadata, error) in
            
            guard let _ = metadata else {
                if let error = error {
                    completion(Result.failure(.otherError(error)))
                } else {
                    print("There is an error with metadata while uploading an image: \(String(describing: error))")
                }
                return
            }
            
            let resultURL = "gs://\(imageReference.bucket)/\(imageReference.fullPath)"
            
            completion(Result.success(resultURL))
        }
        uploadTask.resume()
    }
    
    func downloadImage(with gsURL: String, completion: @escaping (Result<UIImage>) -> Void) {
        let imageReference = storage.reference(forURL: gsURL)
        
//      The size should be decreased!!!!
        imageReference.getData(maxSize: 10 * 1024 * 1024) {
            (data, error) in
            
            guard
                let data = data,
                let image = UIImage(data: data) else {
                    if let error = error {
                        completion(Result.failure(.otherError(error)))
                    } else {
                        completion(Result.failure(.downloadedImageCreation(error)))
                    }
                    return
            }
            
            completion(Result.success(image))
        }
    }
    
    func getDownloadURL(for gsURL: String, completion: @escaping (Result<URL>) -> Void) {
        let imageReference = storage.reference(forURL: gsURL)
        
        imageReference.downloadURL {
            (url, error) in

            if let error = error {
                completion(Result.failure(.otherError(error)))
                return
            }

            guard let downloadURL = url else {
                completion(Result.failure(.downloadURLWrong(url)))
                return
            }

            completion(Result.success(downloadURL))
        }
    }
}
