//
//  TransformArticleInsideOperation.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 24/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class TransformArticleInsideOperation: BaseOperation<UIArticleInside> {
    var articleInside: ArticleInside
    let networkingController: NetworkingController
    
    init(articleInside: ArticleInside) {
        self.articleInside = articleInside
        self.networkingController = NetworkingController()
    }
    
    override func main() {
        if let imageURL = articleInside.imageURL {
            self.networkingController.downloadImage(from: imageURL) {
                (imageResult: Result<UIImage>) in

                switch imageResult {
                case .success(let image):
                    let uiArticleInside = UIArticleInside(id: self.articleInside.id,
                                                          parentID: self.articleInside.parentID,
                                                          sequence: self.articleInside.sequence,
                                                          type: self.articleInside.type,
                                                          caption: self.articleInside.caption,
                                                          text: nil,
                                                          image: image,
                                                          imageURL: imageURL,
                                                          imageStorageURL: self.articleInside.imageStorageURL,
                                                          imageName: self.articleInside.imageName,
                                                          numericList: nil,
                                                          listElements: nil
                                                        )
                    
                    self.result = Result.success(uiArticleInside)
                case .failure(let error):
                    self.result = Result.failure(error)
                }
            }
        } else {
            let uiArticleInside = UIArticleInside(id: self.articleInside.id,
                                                  parentID: self.articleInside.parentID,
                                                  sequence: self.articleInside.sequence,
                                                  type: self.articleInside.type,
                                                  caption: self.articleInside.caption,
                                                  text: self.articleInside.text,
                                                  image: nil,
                                                  imageURL: nil,
                                                  imageStorageURL: nil,
                                                  imageName: nil,
                                                  numericList: self.articleInside.numericList,
                                                  listElements: self.articleInside.listElements
                                                    )
            
            self.result = Result.success(uiArticleInside)
        }
    }
}
