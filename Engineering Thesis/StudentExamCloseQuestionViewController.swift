//
//  StudentExamCloseQuestionViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class StudentExamCloseQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // model
    var question: StudentQuestion?
    private var answer: TestAnswer?
    private var listOfCloseAnswers = Array<StudentAnswer>()
    
    @IBOutlet weak var questionNameLabel: UILabel!
    @IBOutlet weak var questionContentLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!
    
    private struct Storyboard {
        static let cellIdentifier = "Exam Answer Cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answersTableView.delegate = self
        answersTableView.dataSource = self
        answersTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let question = question {
            if let item = TestAnswerDao().getAnswerWithQuestionId(id: question.id).first {
                // mamy już odpowiedź dla tego pytania
                answer = item
                listOfCloseAnswers = Array(item.closeAnswers)
            }
            questionNameLabel.text = "Pytanie zamknięte za " + String(question.points) + " pkt"
            questionContentLabel.text = question.content
        }
        
        answersTableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let question = question {
            return question.listOfAnswers.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIdentifier, for: indexPath)
        if let question = question {
            if !question.listOfAnswers.isEmpty {
                if let answerCell = cell as? StudentExamAnswerCell {
                    let studentAnswer = question.listOfAnswers[indexPath.row]
                    answerCell.answer = studentAnswer
                    if listOfCloseAnswers.contains(studentAnswer) {
                        answerCell.isCorrect = true
                    } else {
                        answerCell.isCorrect = false
                    }
                }
            } else {
                // brak odpowiedzi
                if let answerCell = cell as? StudentExamAnswerCell {
                    answerCell.isEmpty = true
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let question = question {
            let answer = question.listOfAnswers[indexPath.row]
            if listOfCloseAnswers.contains(answer) {
                // odpowiedź już zaznaczona
                if let answerCell = cell as? StudentExamAnswerCell {
                    answerCell.isCorrect = false
                }
                listOfCloseAnswers.remove(at: listOfCloseAnswers.index(of: answer)!)
            } else {
                // zaznaczamy nową odpowiedź
                if let answerCell = cell as? StudentExamAnswerCell {
                    answerCell.isCorrect = true
                }
                listOfCloseAnswers.append(answer)
            }
        }
    }
    
    @IBAction func saveAnswerButtonPressed(_ sender: Any) {
        if let question = question {
            TestAnswerDao().saveCloseAnswer(questionID: question.id, closeAnswers: listOfCloseAnswers)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

class StudentExamAnswerCell: UITableViewCell {
    
    // model 
    var answer: StudentAnswer? {
        didSet {
            updateUI()
        }
    }
    
    var isCorrect: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel.text = nil
            cellLabel.text = "Brak odpowiedzi w bazie"
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    private func updateUI() {
        // reset exisiting informations
        cellLabel.text = nil
        
        if let answer = answer {
            cellLabel.text = answer.content
            cellImage.image = nil
        }
    }
    
    private func updateImage() {
        if cellImage != nil {
            if isCorrect {
                let image = UIImage(named: "ok.png")
                cellImage.image = image
            } else {
                cellImage.image = nil
            }
        }
    }
    
}
