//
//  MainMenuModel.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 15/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct MainMenuModel {
    enum Level {
        case zero
        case one
        case two
    }
    
    let id: Int
    let level: Level
    let name: String
    var collapsed: Bool
    let parentId: Int
    
    init(id: Int, parentId: Int, level: Level, name: String, collapsed: Bool) {
        self.id = id
        self.parentId = parentId
        self.level = level
        self.name = name
        self.collapsed = collapsed
    }
    
    static func fetchInitialData() -> [MainMenuModel] {
        let levelZero: Level = .zero

        return fetchFullData().filter { $0.level == levelZero }
    }
    
    static func fetchChildernOf(_ parentId: Int) -> [MainMenuModel] {
        return fetchFullData().filter { $0.parentId == parentId }
    }
    
    private static func fetchFullData() -> [MainMenuModel] {
        let retVal: [MainMenuModel] = [
            MainMenuModel(id: 1, parentId: 0, level: .zero, name: "Компетенции", collapsed: true),
            MainMenuModel(id: 2, parentId: 0, level: .zero, name: "Влияние", collapsed: true),
            MainMenuModel(id: 3, parentId: 0, level: .zero, name: "Отношения", collapsed: true),
            MainMenuModel(id: 4, parentId: 0, level: .zero, name: "Результат", collapsed: true),
            
            MainMenuModel(id: 5, parentId: 1, level: .one, name: "Профессиональное мастерство", collapsed: true),
            MainMenuModel(id: 6, parentId: 1, level: .one, name: "Компетенция 2", collapsed: true),
            MainMenuModel(id: 7, parentId: 1, level: .one, name: "Компетенция 3", collapsed: true),
            MainMenuModel(id: 8, parentId: 1, level: .one, name: "Компетенция 4", collapsed: true),
            MainMenuModel(id: 9, parentId: 1, level: .one, name: "Компетенция 5", collapsed: true),
            
            MainMenuModel(id: 10, parentId: 2, level: .one, name: "Влияние 1", collapsed: true),
            MainMenuModel(id: 11, parentId: 2, level: .one, name: "Влияние 2", collapsed: true),
            MainMenuModel(id: 12, parentId: 2, level: .one, name: "Влияние 3", collapsed: true),
            MainMenuModel(id: 13, parentId: 2, level: .one, name: "Влияние 4", collapsed: true),
            MainMenuModel(id: 14, parentId: 2, level: .one, name: "Влияние 5", collapsed: true),
            
            MainMenuModel(id: 15, parentId: 3, level: .one, name: "Отношения 1", collapsed: true),
            MainMenuModel(id: 16, parentId: 3, level: .one, name: "Отношения 2", collapsed: true),
            MainMenuModel(id: 17, parentId: 3, level: .one, name: "Отношения 3", collapsed: true),
            MainMenuModel(id: 18, parentId: 3, level: .one, name: "Отношения 4", collapsed: true),
            MainMenuModel(id: 19, parentId: 3, level: .one, name: "Отношения 5", collapsed: true),
            
            MainMenuModel(id: 20, parentId: 4, level: .one, name: "Результат 1", collapsed: true),
            MainMenuModel(id: 21, parentId: 4, level: .one, name: "Результат 2", collapsed: true),
            MainMenuModel(id: 22, parentId: 4, level: .one, name: "Результат 3", collapsed: true),
            MainMenuModel(id: 23, parentId: 4, level: .one, name: "Результат 4", collapsed: true),
            MainMenuModel(id: 24, parentId: 4, level: .one, name: "Результат 5", collapsed: true),
            
            MainMenuModel(id: 25, parentId: 5, level: .two, name: "Активно прорабатывает детали", collapsed: true),
            MainMenuModel(id: 26, parentId: 5, level: .two, name: "Вовлечён в дела компании", collapsed: true),
            MainMenuModel(id: 27, parentId: 5, level: .two, name: "Выполняет задачи вовремя", collapsed: true),
            MainMenuModel(id: 28, parentId: 5, level: .two, name: "На работу и на встречи приходит вовремя", collapsed: true),
            
            MainMenuModel(id: 25, parentId: 6, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 26, parentId: 6, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 27, parentId: 6, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 28, parentId: 6, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 29, parentId: 6, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 30, parentId: 7, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 31, parentId: 7, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 32, parentId: 7, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 33, parentId: 7, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 34, parentId: 7, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 35, parentId: 8, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 36, parentId: 8, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 37, parentId: 8, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 38, parentId: 8, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 39, parentId: 8, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 40, parentId: 9, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 41, parentId: 9, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 42, parentId: 9, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 43, parentId: 9, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 44, parentId: 9, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 45, parentId: 10, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 46, parentId: 10, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 47, parentId: 10, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 48, parentId: 10, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 49, parentId: 10, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 50, parentId: 11, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 51, parentId: 11, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 52, parentId: 11, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 53, parentId: 11, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 54, parentId: 11, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 55, parentId: 12, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 56, parentId: 12, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 57, parentId: 12, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 58, parentId: 12, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 59, parentId: 12, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 60, parentId: 13, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 61, parentId: 13, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 62, parentId: 13, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 63, parentId: 13, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 64, parentId: 13, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 65, parentId: 14, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 66, parentId: 14, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 67, parentId: 14, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 68, parentId: 14, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 69, parentId: 14, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 70, parentId: 15, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 71, parentId: 15, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 72, parentId: 15, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 73, parentId: 15, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 74, parentId: 15, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 80, parentId: 16, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 81, parentId: 16, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 82, parentId: 16, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 83, parentId: 16, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 84, parentId: 16, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 85, parentId: 17, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 86, parentId: 17, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 87, parentId: 17, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 88, parentId: 17, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 89, parentId: 17, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 90, parentId: 18, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 91, parentId: 18, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 92, parentId: 18, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 93, parentId: 18, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 94, parentId: 18, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 95, parentId: 19, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 96, parentId: 19, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 97, parentId: 19, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 98, parentId: 19, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 99, parentId: 19, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 100, parentId: 20, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 101, parentId: 20, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 102, parentId: 20, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 103, parentId: 20, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 104, parentId: 20, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 105, parentId: 21, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 106, parentId: 21, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 107, parentId: 21, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 108, parentId: 21, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 109, parentId: 21, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 110, parentId: 22, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 111, parentId: 22, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 112, parentId: 22, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 113, parentId: 22, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 114, parentId: 22, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 115, parentId: 23, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 116, parentId: 23, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 117, parentId: 23, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 118, parentId: 23, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 119, parentId: 23, level: .two, name: "Индикатор 5", collapsed: true),
            
            MainMenuModel(id: 120, parentId: 24, level: .two, name: "Индикатор 1", collapsed: true),
            MainMenuModel(id: 121, parentId: 24, level: .two, name: "Индикатор 2", collapsed: true),
            MainMenuModel(id: 122, parentId: 24, level: .two, name: "Индикатор 3", collapsed: true),
            MainMenuModel(id: 123, parentId: 24, level: .two, name: "Индикатор 4", collapsed: true),
            MainMenuModel(id: 124, parentId: 24, level: .two, name: "Индикатор 5", collapsed: true)
        ]
        
        return retVal
    }
    
}
