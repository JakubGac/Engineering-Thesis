//
//  QuestionsTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 18.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionsTableViewController: UITableViewController {

    private struct Storyboard {
        static let AddQuestionSegue = "Add Question"
        static let EditQuestionSegue = "Edit Question"
    }
    
    // model
    private var questions = [Question]() { didSet { tableView.reloadData() } }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func getData() {
        questions = DaoManager().getAllQuestionsForTeacher()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question", for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = String(question.number) + ". " + question.content
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DaoManager().deleteQuestion(questionToDelete: questions[indexPath.row])
        }
        getData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.AddQuestionSegue {
            if let nvc = segue.destination as? AddQuestionViewController {
                nvc.title = "Dodaj pytanie"
            }
        } else if segue.identifier == Storyboard.EditQuestionSegue {
            if let nvc = segue.destination as? AddQuestionViewController {
                nvc.title = "Pytanie"
                nvc.contentOfController = [questions[(tableView.indexPathForSelectedRow?.row)!]]
            }
        }
    }
}
