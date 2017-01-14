//
//  TestsDataBaseTableViewCell.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 08.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class TestsDataBaseTableViewCell: UITableViewCell {

    // model
    var test: Test? {
        didSet {
            updateUI()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel?.text = nil
            cellLabel?.text = "Brak testów w bazie"
            self.accessoryType = .none
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        
        if let test = test {
            cellLabel.text = test.name
        }
    }
}
