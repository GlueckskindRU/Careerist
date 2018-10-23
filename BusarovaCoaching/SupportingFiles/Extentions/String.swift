//
//  String.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

extension String {
    func getNameOfEmail() -> String? {
        if let atIndex = self.firstIndex(of: "@") {
            return "\(self.prefix(upTo: atIndex))"
        } else {
            return nil
        }
    }
}
