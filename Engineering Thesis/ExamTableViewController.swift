//
//  ExamTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 10.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class ExamTableViewController: UITableViewController {

    @IBOutlet weak var labelWithTime: UILabel!
    
    // model
    private var questionsList = [Question]() { didSet { tableView.reloadData() } }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        labelWithTime.textColor = UIColor.black
        labelWithTime.text = "   Pozostało do końca: 00:00:00"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question", for: indexPath)
        
        let question = questionsList[indexPath.row]
        if let questionCell = cell as? QuestionTableViewCell {
            questionCell.question = question
        }
        
        return cell
    }
    
    private func getData() {
        questionsList = DaoManager().getAllQuestionsForStudent()
        print(questionsList)
    }
}
