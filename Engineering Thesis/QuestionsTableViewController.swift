//
//  QuestionsTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 18.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {

    private var questions = [Question]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private struct Storyboard {
        static let AddQuestionSegue = "Add Question"
        static let EditQuestionSegue = "Edit Question"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func getData() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        do {
            questions = try context.fetch(Question.fetchRequest())
        } catch let error {
            print("Błąd w trakcie odczytu danych z bazy: \(error)")
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "question cell", for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = String(question.number) + ". " + question.content!
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        if editingStyle == .delete {
            let questionToDelete = questions[indexPath.row]
            context.delete(questionToDelete)
            do {
                try context.save()
                getData()
            } catch let error {
                print("Błąd w czasie usuwania z bazy: \(error)")
            }
        }
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
