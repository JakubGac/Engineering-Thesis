//
//  SubjectsTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class SubjectsTableViewController: UITableViewController {

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
        tableView.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        let addNewItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        self.tabBarController?.navigationItem.rightBarButtonItem = addNewItemButton
    }
    
    private func getData() {
        // clear all existing data
        sections.removeAll()
        items.removeAll()
        
        // add new data
        sections = DaoManager().getAllSubjects()
        for item in sections {
            let array = DaoManager().getQuestionsWithSubject(subject: item)
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
        if let questionCell = cell as? SubjectsTableViewCell {
            questionCell.question = question
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                DaoManager().deleteQuestion(questionToDelete: items[indexPath.section][indexPath.row])
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.showItemSegue {
            if let nvc = segue.destination as? ShowQuestionViewController {
                nvc.question = sender as? Question
            }
        }
    }
}
