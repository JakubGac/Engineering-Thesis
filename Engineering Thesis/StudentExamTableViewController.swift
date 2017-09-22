//
//  StudentExamTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class StudentExamTableViewController: UITableViewController {

    // model
    private var test: StudentTest?
    private var answersIDList = Array<Int>()
    
    @IBOutlet weak var testInfosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if test == nil {
            test = StudentTestDao().getStudentTest().first!
        }
        answersIDList = TestAnswerDao().getTestAnswersIDs()
        printTestInfos()
        tableView.reloadData()
    }
    
    private func printTestInfos() {
        if let test = test {
            testInfosLabel.text = test.name + "\n"
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let test = test {
            return test.listOfQuestions.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exam Question Cell", for: indexPath)
        if let test = test {
            if !test.listOfQuestions.isEmpty {
                let question = test.listOfQuestions[indexPath.row]
                if let questionCell = cell as? StudentExamTableViewCell {
                    questionCell.studentQuestion = question
                    if answersIDList.contains(question.id) {
                        questionCell.hasAnswer = true
                    } else {
                        questionCell.hasAnswer = false
                    }
                }
            } else {
                // pusta lista pytań
                if let questionCell = cell as? StudentExamTableViewCell {
                    questionCell.isEmpty = true
                }
            }
        }
        return cell
    }

    private struct Storyboard {
        static let showOpenQuestionSegue = "Show Open Question Segue"
        static let showCloseQuestionSegue = "Show Close Question Segue"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let test = test {
            let question = test.listOfQuestions[indexPath.row]
            if question.isOpen {
                performSegue(withIdentifier: Storyboard.showOpenQuestionSegue, sender: question)
            } else {
                performSegue(withIdentifier: Storyboard.showCloseQuestionSegue, sender: question)
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showOpenQuestionSegue {
            if let nvc = segue.destination as? StudentExamOpenQuestionViewController {
                nvc.question = sender as? StudentQuestion
            }
        } else if segue.identifier == Storyboard.showCloseQuestionSegue {
            if let nvc = segue.destination as? StudentExamCloseQuestionViewController {
                nvc.question = sender as? StudentQuestion
            }
        }
    }
    
    // zakończ test
    @IBAction func endTestButtonPressed(_ sender: Any) {
        //printSafeAllert()
    }
    
    /*override func printSafeAllert() {
        var alertMessage = ""
        if let test = test {
            if answersIDList.count < test.totalNumberOfQuestions {
                alertMessage = "Odpowiedziałeś na " + String(answersIDList.count) + " z " + String(test.totalNumberOfQuestions) + " pytań. Czy na pewno chcesz zakończyć test?"
            } else {
                alertMessage = "Czy na pewno chcesz zakończyć test?"
            }
        }
        let myAlert = UIAlertController(title: "Uwaga!", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Anuluj", style: UIAlertActionStyle.cancel, handler: nil)
        let cancelAction = UIAlertAction(title: "Zakończ", style: UIAlertActionStyle.default) { (Action) in
            self.finishTheExam()
        }
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true, completion: nil)
    }*/
    
    // funcka kończąca test
    private func finishTheExam() {
        // ustawiamy w bazie egzamin jako zakończony oraz jako wykonany
        // zatrzymujemy zegar
        StudentTestDao().setStudentTestFinish()
        StudentTestDao().setStudentTestIsDone()
        UIApplication.shared.isIdleTimerDisabled = false
        self.navigationController!.popViewController(animated: true)
    }
}

class StudentExamTableViewCell: UITableViewCell {
    
    // model
    var studentQuestion: StudentQuestion? {
        didSet {
            updateUI()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel?.text = nil
            cellLabel?.text = "Brak pytań w bazie"
        }
    }
    
    var hasAnswer: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    private func updateUI() {
        // reset existing infos
        cellLabel.text = nil
        
        if let question = studentQuestion {
            cellLabel.text = question.content
        }
    }
    
    private func updateImage() {
        if cellImage != nil {
            if hasAnswer {
                let image = UIImage(named: "ok.png")
                cellImage.image = image
            } else {
                let image = UIImage(named: "x.png")
                cellImage.image = image
            }
        }
    }
}
