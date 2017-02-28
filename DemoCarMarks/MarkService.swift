//
//  MarkService.swift
//  DemoCarMarks
//
//  Created by Dima on 28/02/2017.
//  Copyright © 2017 Dmitriy Rozov. All rights reserved.
//

import Alamofire

struct MarkService {
    
    func get(completionHandler: @escaping (Result<[Mark]>) -> ()) {
        Alamofire.request(API.BaseURL).responseJSON { response in
            switch response.result {
            case .success(let json):
                guard let json = json as? [String: Any],
                    let items = json["Marks"] as? [[String : Any]] else {
                        completionHandler(.error(.server))
                        return
                }
                
                var marks = [Mark]()
                for item in items {
                    if let mark = Mark(json: item) {
                        marks.append(mark)
                    } else {
                        completionHandler(.error(.server))
                        return
                    }
                }
                completionHandler(.success(marks))
            case .failure(let error):
                if let error = error as? AFError {
                    
                    switch error {
                    case .responseSerializationFailed(_):
                        completionHandler(.error(.server))
                    default:
                        completionHandler(.error(.noInternet))
                    }
                } else {
                    completionHandler(.error(.noInternet))
                }
            }
        }
    }
}
