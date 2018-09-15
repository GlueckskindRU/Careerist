//
//  AppError.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

enum AppError: Error {
    case fetchDocument(Error)
    case documentNotFound(String)
    case saveDocument(Error)
    case otherError(Error)
    
    func getError() -> String {
        switch self {
        case .fetchDocument(let error):
            return "Ошибка получения документа: \(error)"
        case .documentNotFound(let id):
            return "Документ с идентификатором <\(id)> не найден"
        case .saveDocument(let error):
            return "Ошибка сохранения документа: \(error)"
        case .otherError(let error):
            return error.localizedDescription
        }
    }
}
