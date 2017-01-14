//
//  AllTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class AllTableViewController: UITableViewController, UISearchBarDelegate {

    // model
    private var questionsList = [Question]()
    private var filteredQuestionsList = [Question]()
    private var searchActive = false
    private struct Storyboard {
        static let addNewItemSegue = "Add New Item"
        static let showItemSegue = "Show Item"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func getData() {
        // clear all existing data
        questionsList.removeAll()
        
        // add new data
        questionsList = DaoManager().getAllQuestions()
        questionsList.sort { $0.content < $1.content }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredQuestionsList.count
        } else {
            return questionsList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question Cell", for: indexPath)
        if searchActive {
            let question = filteredQuestionsList[indexPath.row]
            if let questionCell = cell as? AllTableViewCell {
                questionCell.question = question
            }
        } else {
            let question = questionsList[indexPath.row]
            if let questionCell = cell as? AllTableViewCell {
                questionCell.question = question
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DaoManager().deleteQuestion(questionToDelete: questionsList[indexPath.row])
        }
        getData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questionsList[indexPath.row]
        performSegue(withIdentifier: Storyboard.showItemSegue, sender: question)
    }

    // MARK: - Search Button
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredQuestionsList = questionsList.filter({ (question) -> Bool in
            let tmp: NSString = question.content as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
        })
        if filteredQuestionsList.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        tableView.reloadData()
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
