//
//  CharacteristicUIHelper.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 03/06/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

struct CharacteristicUIHelper {
    private enum CharacteristicGroupNames: String {
        case personalEffieciency = "Личная эффективность"
        case peopleWorking = "Работа с людьми"
        case resultAchievement = "Достижение результата"
        case thinking = "Мышление"
    }
    
    private let groupName: CharacteristicGroupNames
    
    init?(with groupName: String) {
        switch groupName {
        case CharacteristicGroupNames.personalEffieciency.rawValue:
            self.groupName = CharacteristicGroupNames.personalEffieciency
        case CharacteristicGroupNames.peopleWorking.rawValue:
            self.groupName = CharacteristicGroupNames.peopleWorking
        case CharacteristicGroupNames.resultAchievement.rawValue:
            self.groupName = CharacteristicGroupNames.resultAchievement
        case CharacteristicGroupNames.thinking.rawValue:
            self.groupName = CharacteristicGroupNames.thinking
        default:
            return nil
        }
    }
    
    func getGroupName() -> String {
        return groupName.rawValue
    }
    
    func getGroupInfo() -> String {
        return "Краткий текст про данную тему, текст не меньше двух рядов примерно так…"
    }
    
    func getGroupArrowImage() -> UIImage {
        let imageName: String
        switch groupName {
        case .peopleWorking:
            imageName = "twArrow"
        case .personalEffieciency:
            imageName = "peArrow"
        case .resultAchievement:
            imageName = "raArrow"
        case .thinking:
            imageName = "tArrow"
        }
        
        return UIImage(named: imageName) ?? UIImage()
    }
    
    func getGroupBoxImage() -> UIImage {
        let imageName: String
        switch groupName {
        case .peopleWorking:
            imageName = "teamWorking"
        case .personalEffieciency:
            imageName = "personalEfficiency"
        case .resultAchievement:
            imageName = "resultAchievement"
        case .thinking:
            imageName = "thinking"
        }
        
        return UIImage(named: imageName) ?? UIImage()
    }
    
    func getSmallBoxImage() -> UIImage {
        let imageName: String
        switch groupName {
        case .peopleWorking:
            imageName = "twSmallBlock"
        case .personalEffieciency:
            imageName = "peSmallBlock"
        case .resultAchievement:
            imageName = "raSmallBlock"
        case .thinking:
            imageName = "tSmallBlock"
        }
        
        return UIImage(named: imageName) ?? UIImage()
    }
    
    func getSmallBoxArrow() -> UIImage {
        return UIImage(named: "whiteArrow") ?? UIImage()
    }
    
    func gradientEnd() -> UIColor {
        let hexColor: String
        
        switch groupName {
        case .peopleWorking:
            hexColor = "#23D374"
        case .personalEffieciency:
            hexColor = "#E06689"
        case .resultAchievement:
            hexColor = "#7C7BFA"
        case .thinking:
            hexColor = "#E5A53D"
        }
        
        return UIColor(hexString: hexColor) ?? .white
    }
    
    func gradientStart() -> UIColor {
        let hexColor: String
        
        switch groupName {
        case .peopleWorking:
            hexColor = "#19AB5E"
        case .personalEffieciency:
            hexColor = "#9A51F5"
        case .resultAchievement:
            hexColor = "#248EF5"
        case .thinking:
            hexColor = "#EF7754"
        }
        
        return UIColor(hexString: hexColor) ?? .white
    }
    
    func getBGColor() -> UIColor {
        switch groupName {
        case .peopleWorking:
//            return .green
            return UIColor(red: 44/255, green: 191/255, blue: 109/255, alpha: 1)
        case .personalEffieciency:
//            return .magenta
            return UIColor(red: 193/255, green: 96/255, blue: 179/255, alpha: 1)
        case .resultAchievement:
//            return .blue
            return UIColor(red: 84/255, green: 135/255, blue: 244/255, alpha: 1)
        case .thinking:
//            return .orange
            return UIColor(red: 232/255, green: 143/255, blue: 79/255, alpha: 1)
        }
    }
    
    func getSubscribedBGColor() -> UIColor {
//        switch groupName {
//        case .peopleWorking:
//            return UIColor(red: 50/255, green: 209/255, blue: 119/255, alpha: 1)
//        case .personalEffieciency:
//            return UIColor(red: 222/255, green: 104/255, blue: 138/255, alpha: 1)
//        case .resultAchievement:
//            return UIColor(red: 125/255, green: 127/255, blue: 247/255, alpha: 1)
//        case .thinking:
//            return UIColor(red: 227/255, green: 164/255, blue: 72/255, alpha: 1)
//        }
        return UIColor(red: 79/255, green: 85/255, blue: 82/255, alpha: 1)
    }
}
