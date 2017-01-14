//
//  ExamTestsTableViewCell.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 11.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class ExamTestsTableViewCell: UITableViewCell {

    // model
    var test: Test? {
        didSet {
            updateUI()
        }
    }
    
    var picked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel?.text = nil
            cellImage?.alpha = 0
            cellLabel?.text = "Brak pytań w bazie"
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        cellImage?.alpha = 0
        
        if let test = self.test {
            cellLabel.text = test.name
        }
    }
    
    private func updateImage() {
        if cellImage != nil {
            let image = UIImage(named: "ikona.png")
            cellImage.image = image
            if picked {
                cellImage.alpha = 1
            } else {
                cellImage.alpha = 0
            }
        }
    }
}
