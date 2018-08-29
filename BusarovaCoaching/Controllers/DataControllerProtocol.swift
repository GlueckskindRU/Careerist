//
//  DataControllerProtocol.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 28/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

protocol DataControllerProtocol: class {
    var dataController: DataController! { get set }
    
    func configure(with: DataController)
}

extension DataControllerProtocol {
    func configure(with dataController: DataController) {
        self.dataController = dataController
    }
}
