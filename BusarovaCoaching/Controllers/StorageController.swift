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
        if let result = UIImageJPEGRepresentation(image, 1.0)  {
            return result
        } else if let result = UIImagePNGRepresentation(image) {
            return result
        } else {
            return nil
        }
    }
    
    func uploadImage(_ image: UIImage, with name: String, to address: StoragePath, completion: @escaping (Result<URL>) -> Void) {
        guard
            let data = image2data(image),
            let extention = data.imageFormat else {
            return
        }
        
        let pathToUpload = "\(address.rawValue)\(name).\(extention)"
        
        let imageReference = storage.reference().child(pathToUpload)
        
        let uploadTask = imageReference.putData(data, metadata: nil) {
            (metadata, error) in
            
            guard let _ = metadata else {
                if let error = error {
                    completion(Result.failure(.otherError(error)))
                } else {
                    print("There is an error with metadata while uploading an image: \(String(describing: error))")
                }
                return
            }
            
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
        uploadTask.resume()
    }
}
