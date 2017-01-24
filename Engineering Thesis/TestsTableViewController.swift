//
//  TestsTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 21.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class TestsTableViewController: UITableViewController {

    // model
    var listOfTestNames = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func getData() {
        listOfTestNames = StudentAnswersForTeacherDao().getAllStudentAnswersTestNames()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfTestNames.isEmpty {
            return 1
        } else {
            return listOfTestNames.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test Cell", for: indexPath)
        if listOfTestNames.isEmpty {
            cell.textLabel?.text = "Brak odpowiedzi do testów w bazie"
            cell.isUserInteractionEnabled = false
            cell.accessoryType = UITableViewCellAccessoryType.none
        } else {
            let name = listOfTestNames[indexPath.row]
            cell.textLabel?.text = name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StudentAnswersForTeacherDao().deleteStudentAnswersForTeacherWithGivenName(name: listOfTestNames[indexPath.row])
            getData()
        }
    }
    
    private struct Storyboard {
        static let showAnswersForTestSegue = "Show Answers For Test"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testName = listOfTestNames[indexPath.row]
        performSegue(withIdentifier: Storyboard.showAnswersForTestSegue, sender: testName)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showAnswersForTestSegue {
            if let nvc = segue.destination as? AnswersForSpecifiedTestTableViewController {
                nvc.testName = sender as? String
            }
        }
    }
}
