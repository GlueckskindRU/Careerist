//
//  NetworkingController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 04/12/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class NetworkingController {
    // MARK: - private properties
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    lazy var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.allowsCellularAccess = false
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let session = URLSession(configuration: configuration, delegate: self as? URLSessionDelegate, delegateQueue: queue)
        return session
    }()
    
    // MARK: - private methods
    private func createRequest(to url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public func downloadImage(from url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        let request = createRequest(to: url)
        
        let dataTask = defaultSession.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                return completion(Result.failure(AppError.otherError(error!)))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    return completion(Result.failure(AppError.noReachability("Ошибка получения изображения: \(httpResponse.statusCode)")))
                }
            }
            
            guard let data = data else {
                return completion(Result.failure(AppError.noReachability("Не получили никаких данных")))
            }
            
            guard let image = UIImage(data: data) else {
                return completion(Result.failure(AppError.noReachability("Ошибка конвертации полученных данных в изображение")))
            }
            
            completion(Result.success(image))
        }
        dataTask.resume()
    }
}
