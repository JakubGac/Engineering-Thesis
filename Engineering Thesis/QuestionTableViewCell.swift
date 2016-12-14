//
//  QuestionTableViewCell.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    
    // model
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // reset any existing information
        questionTextLabel?.text = nil
        questionImageView?.image = nil
        
        if let question = self.question {
            questionTextLabel.text = String(question.number) + ". " + question.content + "   📃"
            questionImageView.image = UIImage(named: "apple.jpg")
        }
    }
}
