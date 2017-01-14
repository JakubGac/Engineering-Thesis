//
//  TestQuestionsTableViewCell.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 08.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class TestQuestionsTableViewCell: UITableViewCell {

    // model
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel?.text = nil
            cellLabel?.text = "Brak pytań w bazie"
            self.accessoryType = .none
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        
        if let question = question {
            cellLabel.text = question.content
        }
    }
}
