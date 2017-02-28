//
//  Mark.swift
//  DemoCarMarks
//
//  Created by Dima on 28/02/2017.
//  Copyright © 2017 Dmitriy Rozov. All rights reserved.
//

struct Mark {
    var id: String
    var name: String
}

extension Mark {
    init?(json: [String: Any])  {
        guard let id = json["id"] as? String,
            let name = json["mark"] as? String else { return nil }
        
        self.id = id
        self.name = name
    }
}
