//
//  PickQuestionTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 06.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class PickQuestionTableViewController: UITableViewController {

    // model
    var totalNumberOfQuestions: Int?
    var typeOfQuestionsToDisplay: String?
    var typeOfTest: String?
    
    private var sections = [String]()
    private var listOfQuestions = [Array<Question>()]
    private var listOfPickedQuestionsID = Array<Int>() {
        didSet {
            if let number = totalNumberOfQuestions {
                self.title = String(listOfPickedQuestionsID.count) + " z " + String(number)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listOfPickedQuestionsID = TmpPickedQuestionsDao().getAllPickedQuestionsID()
        
        sections.removeAll()
        listOfQuestions.removeAll()
        
        if let testType = typeOfTest {
            if typeOfQuestionsToDisplay == "all" {
                let items = QuestionDao().getAllQuestionsWithTestType(type: testType)
                if !items.isEmpty {
                    listOfQuestions.append(items)
                }
            } else if typeOfQuestionsToDisplay == "category" {
                sections = QuestionDao().getAllCategoriesWithTestType(type: testType)
                for item in sections {
                    let array = QuestionDao().getQuestionWithCategoryAndTestType(category: item, type: testType)
                    listOfQuestions.append(array)
                }
            } else if typeOfQuestionsToDisplay == "subject" {
                sections = QuestionDao().getAllSubjectsWithTestType(type: testType)
                for item in sections {
                    let array = QuestionDao().getQuestionsWithSubjectAndTestType(subject: item, type: testType)
                    listOfQuestions.append(array)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TmpPickedQuestionsDao().addQuestionsIDToDatabase(list: listOfPickedQuestionsID)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty {
            return 1
        } else {
            return sections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfQuestions.isEmpty {
            return 1
        } else {
            return listOfQuestions[section].count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections.isEmpty {
            return ""
        } else {
            return sections[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question Cell", for: indexPath)
        let question = listOfQuestions[indexPath.section][indexPath.row]
        if let questionCell = cell as? PickedQuestionTableViewCell {
            if listOfQuestions.isEmpty {
                questionCell.isEmpty = true
            } else {
                questionCell.question = question
                if listOfPickedQuestionsID.contains(question.id) {
                    questionCell.picked = true
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listOfQuestions.isEmpty {
            let cell = tableView.cellForRow(at: indexPath)
            let question = listOfQuestions[indexPath.section][indexPath.row]
            if let pickedCell = cell as? PickedQuestionTableViewCell {
                if let totalNumberOfQuestions = totalNumberOfQuestions {
                    if listOfPickedQuestionsID.count < totalNumberOfQuestions {
                        if pickedCell.picked {
                            pickedCell.picked = false
                            if listOfPickedQuestionsID.contains(question.id) {
                                listOfPickedQuestionsID.remove(at: listOfPickedQuestionsID.index(of: question.id)!)
                            }
                        } else {
                            pickedCell.picked = true
                            listOfPickedQuestionsID.append(question.id)
                        }
                    } else if listOfPickedQuestionsID.count == totalNumberOfQuestions {
                        if pickedCell.picked {
                            // komórka jest wybrana, chcemy ją odznaczyć
                            pickedCell.picked = false
                            if listOfPickedQuestionsID.contains(question.id) {
                                listOfPickedQuestionsID.remove(at: listOfPickedQuestionsID.index(of: question.id)!)
                            }
                        } else {
                            let message = "Nie możesz wybrać więcej niż " + String(totalNumberOfQuestions) + " pytań!"
                            printErrorAlert(alertMessage: message)
                        }
                    }
                }
            }
        }
    }
}

class PickedQuestionTableViewCell: UITableViewCell {
    
    // model
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    var picked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel?.text = nil
            cellImageView.alpha = 0
            cellLabel?.text = "Brak pytań w bazie"
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        cellImageView.alpha = 0
        
        if let question = self.question {
            cellLabel.text = question.content
        }
    }
    
    private func updateImage() {
        if cellImageView != nil {
            let image = UIImage(named: "ok.png")
            cellImageView.image = image
            if picked {
                cellImageView.alpha = 1
            } else {
                cellImageView.alpha = 0
            }
        }
    }
}
