//
//  TestQuestionsTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 08.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class TestQuestionsTableViewController: UITableViewController {

    // model
    var testID: Int? {
        didSet {
            updateInfo()
        }
    }
    
    private var listOfQuestions = Array<Question>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInfo()
    }
    
    private func updateInfo() {
        if let id = testID {
            listOfQuestions = TestDao().getQuestionsWithTestID(id: id)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfQuestions.isEmpty {
            return 1
        } else {
            return listOfQuestions.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test Question Cell", for: indexPath)
        if listOfQuestions.isEmpty {
            if let questionCell = cell as? TestQuestionsTableViewCell {
                questionCell.isEmpty = true
            }
        } else {
            if let questionCell = cell as? TestQuestionsTableViewCell {
                let question = listOfQuestions[indexPath.row]
                questionCell.question = question
            }
        }
        return cell
    }
    
    private struct Storyboard {
        static let showTestQuestionDetailsSegue = "Show Test Question Details Segue"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listOfQuestions.isEmpty {
            let question = listOfQuestions[indexPath.row]
            performSegue(withIdentifier: Storyboard.showTestQuestionDetailsSegue, sender: question)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showTestQuestionDetailsSegue {
            if let nvc = segue.destination as? ShowQuestionViewController {
                nvc.question = sender as? Question
            }
        }
    }
}

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
