//
//  Data.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 17/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

extension Data {
    var imageFormat: String? {
        let array = [UInt8](self)
        let ext: String?
        
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D:
            ext = "tiff"
        default:
            ext = nil
        }
        
        return ext
    }
    
    var imageMetadata: String? {
        let array = [UInt8](self)
        let ext: String?
        
        switch (array[0]) {
        case 0xFF:
            ext = "image/jpeg"
        case 0x89:
            ext = "image/png"
        case 0x47:
            ext = "image/gif"
        case 0x49, 0x4D:
            ext = "image/tiff"
        default:
            ext = nil
        }
        
        return ext
    }
}
