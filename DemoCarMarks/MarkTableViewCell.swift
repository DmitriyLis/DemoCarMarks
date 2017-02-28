//
//  MarkTableViewCell.swift
//  DemoCarMarks
//
//  Created by Dima on 28/02/2017.
//  Copyright © 2017 Dmitriy Rozov. All rights reserved.
//

import UIKit

class MarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var markImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
    var name = "" {
        didSet {
            nameLabel.text = name
            setImage(name: name)
        }
    }
    
    override func awakeFromNib() {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.19, green: 0.19, blue:0.19, alpha: 1.0)
        self.selectedBackgroundView = view
    }
    
    func setImage(name: String) {
        imageLabel.isHidden = true
        imageLabel.text = ""
        
        let trimmedName = name
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
        
        if let markImage = UIImage(named: trimmedName) {
            markImageView.image = markImage
        } else {
            markImageView.image = nil
            imageLabel.isHidden = false
            imageLabel.text = String(self.name.characters.first!)
        }
    }
}
