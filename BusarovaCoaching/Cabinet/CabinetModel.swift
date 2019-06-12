//
//  CabinetModel.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

struct CabinetModel {
    enum Level {
        case zero
        case one
    }
    
    let level: Level
    let name: String
    let hasChildern: Bool
    
    init(level: Level, name: String, hasChildern: Bool) {
        self.level = level
        self.name = name
        self.hasChildern = hasChildern
    }
    
    static func fetchInitialData() -> [CabinetModel] {
        let result: [CabinetModel] = [
            CabinetModel(level: .zero, name: "Мои достижения", hasChildern: false),
            CabinetModel(level: .zero, name: "График развития", hasChildern: false),
            CabinetModel(level: .zero, name: "Мои компетенции", hasChildern: true),
//            CabinetModel(level: .one, name: "Компетенция 1", hasChildern: false),
//            CabinetModel(level: .one, name: "Компетенция 2", hasChildern: false),
//            CabinetModel(level: .one, name: "Компетенция 3", hasChildern: false),
//            CabinetModel(level: .one, name: "Компетенция 4", hasChildern: false),
//            CabinetModel(level: .one, name: "Компетенция 5", hasChildern: false),
//            CabinetModel(level: .zero, name: "Мои записи", hasChildern: false)
        ]
        
        return result
    }
    
    static func fetchCompetenceData() -> [String] {
        return [
            "Ваши советы дня",
            "Ваши статьи" //,
//            "Ваши видео",
//            "Полезные инструменты"
        ]
    }
    
    static func fetchAchivements() -> [String] {
        return [
            "Мастер саморазвития",
            "Скоростной"
        ]
    }
    
    static func fetchDevelopmentSettings() -> [String] {
        return [
            "Советы дня",
            "Полезные статьи"
        ]
    }
    
    static func fetchNotes() -> [String] {
        return [
            "Заголовок 1",
            "Заголовок 2",
            "Заголовок 3",
            "Заголовок 4",
            "Заголовок 5",
            "Заголовок 6",
            "Заголовок 7"
        ]
    }
    
    static let articleText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quis libero neque. Nulla felis ipsum, scelerisque ac interdum non, sodales sed erat. Ut vitae egestas nisi, in lacinia elit. Fusce sed ullamcorper ligula. Donec aliquet dolor venenatis, sagittis orci nec, consectetur purus. Integer auctor ut metus eget cursus. Vivamus quis sagittis lacus. Donec leo neque, vulputate nec dolor sed, eleifend rutrum nibh. Nulla luctus sollicitudin nibh eu suscipit. Aenean fringilla rutrum turpis, sit amet egestas est accumsan eu. Cras non enim velit. Suspendisse ac nisi in nisi faucibus consectetur.

Etiam id imperdiet lectus. Maecenas ex nunc, finibus at aliquam eu, accumsan quis elit. In lacus mi, efficitur nec mollis fringilla, luctus at orci. Nam nisl lectus, ultricies eu dignissim nec, ultrices non arcu. Quisque vitae tristique nunc. Pellentesque vitae rutrum tortor, id feugiat massa. Proin nulla urna, ultricies vitae hendrerit eu, vehicula vel nisi. Aliquam condimentum accumsan varius. Nulla blandit, odio sed hendrerit varius, nulla leo laoreet urna, non viverra quam magna non turpis. Sed pretium aliquam aliquet. Vestibulum leo tortor, egestas non risus nec, commodo mollis diam. Morbi dictum, leo gravida dapibus pretium, mi velit dapibus nulla, at convallis ligula nunc sed libero. Donec a venenatis est. Quisque aliquet elit facilisis felis placerat lobortis. Fusce id tincidunt diam.

Aliquam vitae rhoncus lectus, in gravida dolor. Sed eget mi vel ex pellentesque lobortis ac in quam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Quisque ac ex quis purus fermentum egestas ultrices vel dui. Quisque pretium iaculis libero eget mollis. Donec egestas euismod risus et facilisis. Integer pretium scelerisque diam, et tincidunt mi sagittis quis.

Ut faucibus viverra nibh, porttitor posuere velit tristique at. Proin lobortis lectus at lectus placerat, sed tempor velit porttitor. Fusce pellentesque lacus purus, id tristique libero condimentum in. Vivamus gravida ut orci id luctus. Mauris erat sem, hendrerit dapibus justo ut, maximus congue libero. Ut eleifend sit amet mauris sed sodales. Morbi non euismod justo.

Fusce at dui eu risus volutpat venenatis. Integer sagittis lectus sed ante volutpat elementum. Vestibulum luctus nec orci a tempus. Nulla vestibulum lobortis lorem ut commodo. Praesent tincidunt hendrerit nulla sit amet consectetur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur quis ex ante. Phasellus hendrerit, magna id blandit bibendum, lectus velit porta lectus, eu feugiat felis lacus a nibh. Morbi ullamcorper lectus aliquet, auctor tortor sed, pellentesque velit. Nullam posuere erat nec nulla bibendum, eu ornare urna ultricies. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus vulputate at tellus ac lacinia. In varius cursus diam, sit amet varius mi consequat in. Donec laoreet quam in molestie ultrices.

Vestibulum ac lacus euismod lorem volutpat tempus. Suspendisse finibus finibus consectetur. Etiam at ante orci. Nam viverra ultricies nibh, vel posuere enim viverra non. Nullam in augue nec dui auctor imperdiet. Duis ut ornare mi. Donec faucibus neque quis ligula dapibus pellentesque. Aenean sem eros, efficitur quis vehicula sit amet, iaculis ac orci. Duis porttitor tincidunt eros, at tempor leo blandit quis. Maecenas vestibulum arcu orci, ultricies auctor lorem aliquam vehicula. Cras sed urna sed ipsum ultrices elementum. Maecenas tempus in nisi nec ultrices. Etiam eget fringilla tellus. Quisque eget erat sagittis, volutpat sapien quis, luctus nunc. Morbi magna urna, dapibus in diam sed, congue vulputate nisi.

Maecenas aliquam viverra mi, vitae mattis eros fermentum id. Donec in nunc est. Praesent quam turpis, maximus eu ultrices vel, hendrerit nec dolor. Vestibulum venenatis id nibh ac tincidunt. Quisque nec diam sit amet lectus posuere convallis. Phasellus aliquam mollis vestibulum. In hac habitasse platea dictumst. Nullam fringilla accumsan mi eu varius. Aenean convallis ultrices tellus, quis imperdiet nisl porttitor sit amet. Integer sit amet placerat elit.

Donec interdum non neque eu feugiat. Integer vitae mi a lacus consequat porta a eu purus. Suspendisse ut scelerisque tellus. Integer molestie pharetra ex, a egestas ante venenatis non. Nam sit amet justo dictum, fringilla mi at, dapibus lorem. Sed finibus fermentum risus, at viverra urna eleifend quis. Vivamus volutpat lectus orci, ac egestas sem facilisis in.

Duis quis tellus pretium, placerat augue sed, blandit sapien. Sed ut nisl quam. Duis id dictum nisi, ut volutpat metus. Nunc ut arcu a nibh dapibus commodo. Pellentesque pellentesque mauris vel augue sollicitudin fringilla. Donec at ante ullamcorper, bibendum enim nec, scelerisque dolor. Nam sit amet ligula tempus, sagittis dolor at, convallis tellus. Aliquam ac metus neque. Nulla et nulla non urna sagittis fringilla. Nunc fringilla sodales tellus, nec eleifend ex gravida scelerisque. Fusce non lacus cursus, auctor turpis in, scelerisque turpis.

Nunc id ligula at tortor suscipit facilisis vel vitae nisi. Sed iaculis elit ut condimentum molestie. In hendrerit faucibus nisl vel hendrerit. Nam dapibus sodales enim non facilisis. Pellentesque ut augue in arcu congue interdum. Nam feugiat quam in ultrices pharetra. Vivamus augue nisl, consequat quis rhoncus in, maximus eu metus. Ut fermentum facilisis magna ut tristique. Praesent turpis turpis, aliquet nec purus ac, molestie pretium orci.
"""
}
