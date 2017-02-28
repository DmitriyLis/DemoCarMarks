//
//  UITableViewExtension.swift
//  DemoCarMarks
//
//  Created by Dima on 28/02/2017.
//  Copyright © 2017 Dmitriy Rozov. All rights reserved.
//

import UIKit

extension UITableView {
    func setBackgraundView() {
        let backView = UIView(frame: self.bounds)
        backView.backgroundColor = UIColor.rbBlack
        self.backgroundView = backView
    }
}
