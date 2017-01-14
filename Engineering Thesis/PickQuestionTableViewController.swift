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
        listOfPickedQuestionsID = DaoManager().getAllPickedQuestionsID()
        
        sections.removeAll()
        listOfQuestions.removeAll()
        
        if let testType = typeOfTest {
            if typeOfQuestionsToDisplay == "all" {
                let items = DaoManager().getAllQuestionsWithTestType(type: testType)
                if !items.isEmpty {
                    listOfQuestions.append(items)
                }
            } else if typeOfQuestionsToDisplay == "category" {
                sections = DaoManager().getAllCategoriesWithTestType(type: testType)
                for item in sections {
                    let array = DaoManager().getQuestionWithCategoryAndTestType(category: item, type: testType)
                    listOfQuestions.append(array)
                }
            } else if typeOfQuestionsToDisplay == "subject" {
                sections = DaoManager().getAllSubjectsWithTestType(type: testType)
                for item in sections {
                    let array = DaoManager().getQuestionsWithSubjectAndTestType(subject: item, type: testType)
                    listOfQuestions.append(array)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DaoManager().addQuestionsIDToDatabase(list: listOfPickedQuestionsID)
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
