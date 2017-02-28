//
//  API.swift
//  DemoCarMarks
//
//  Created by Dima on 28/02/2017.
//  Copyright © 2017 Dmitriy Rozov. All rights reserved.
//

import Alamofire

struct API {
    static let BaseURL = "https://dl.dropboxusercontent.com/s/rbu6uc41x20guvr/Marks.json?"
    
    func networkReachability(completionHandler: @escaping (Bool) -> ()) {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            switch status {
            case .reachable(_):
                completionHandler(true)
                manager?.stopListening()
            default:
                break
            }
        }
        manager?.startListening()
    }
}

enum Result<T> {
    case success(T)
    case error(ErrorType)
}

enum ErrorType: String {
    case noInternet = "Нет доступа к сети 😩\nОжидание подключения..."
    case server = "Ошибка сервера 😳"
}
