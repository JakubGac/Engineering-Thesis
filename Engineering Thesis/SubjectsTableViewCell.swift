//
//  DataBaseTableViewCell.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 26.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class SubjectsTableViewCell: UITableViewCell {
    
    // model
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        
        if let question = self.question {
            cellLabel.text = question.content
        }
    }
}
