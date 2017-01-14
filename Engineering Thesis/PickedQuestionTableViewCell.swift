//
//  PickedQuestionTableViewCell.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 07.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class PickedQuestionTableViewCell: UITableViewCell {

    // model
    var question: Question? {
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
            cellImageView.alpha = 0
            cellLabel?.text = "Brak pytań w bazie"
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        cellImageView.alpha = 0
        
        if let question = self.question {
            cellLabel.text = question.content
        }
    }
    
    private func updateImage() {
        if cellImageView != nil {
            let image = UIImage(named: "ikona.png")
            cellImageView.image = image
            if picked {
                cellImageView.alpha = 1
            } else {
                cellImageView.alpha = 0
            }
        }
    }
}
