//
//  CategoriesTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    private var sections = [String]()
    private var items = [Array<Question>]()
    private struct Storyboard {
        static let addNewItemSegue = "Add New Item"
        static let showItemSegue = "Show Item"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func getData() {
        // clear all existing data
        sections.removeAll()
        items.removeAll()
        
        // add new data
        sections = QuestionDao().getAllCategories()
        for item in sections {
            let array = QuestionDao().getQuestionWithCategory(category: item)
            items.append(array)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question Cell", for: indexPath)
        let question = items[indexPath.section][indexPath.row]
        if let questionCell = cell as? CategoriesTableViewCell {
            questionCell.question = question
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                QuestionDao().deleteQuestion(questionToDelete: items[indexPath.section][indexPath.row])
            }
            getData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = items[indexPath.section][indexPath.row]
        performSegue(withIdentifier: Storyboard.showItemSegue, sender: question)
    }
    
    @objc private func addNewItem() {
        performSegue(withIdentifier: Storyboard.addNewItemSegue, sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showItemSegue {
            if let nvc = segue.destination as? ShowQuestionViewController {
                nvc.question = sender as? Question
            }
        }
    }
}

class CategoriesTableViewCell: UITableViewCell {
    
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
