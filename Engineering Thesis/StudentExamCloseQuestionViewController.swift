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
    private var listOfCloseAnswers = Array<StudentCloseAnswer>()
    
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
            questionContentLabel.numberOfLines = 4
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
            if let answerCell = cell as? StudentExamAnswerCell {
                if !question.listOfAnswers.isEmpty {
                    let answer = question.listOfAnswers[indexPath.row]
                    var studentAnswer: StudentCloseAnswer?
                    
                    // ustawiamy treść pytania
                    answerCell.answer = answer
                    
                    // sprawdzamy czy dana odpowiedź była już wcześniej wybrana
                    for item in listOfCloseAnswers {
                        if item.content == answer.content {
                            // tak, była
                            studentAnswer = item
                        }
                    }
                
                    // ustawiamy czy komórka jest prawdziwa czy nie
                    if studentAnswer == nil {
                        answerCell.isCorrect = false
                    } else {
                        answerCell.isCorrect = true
                    }
                    
                } else {
                    // brak odpowiedzi
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
            var studentAnswer: StudentCloseAnswer?
            
            // sprawdzamy czy dana odpowiedź była już wcześniej wybrana
            for item in listOfCloseAnswers {
                if item.content == answer.content {
                    // tak, była
                    studentAnswer = item
                }
            }
            
            if let answerCell = cell as? StudentExamAnswerCell {
                if studentAnswer == nil {
                    // odpowiedź nie została wcześniej wybrana
                    // dodajemy ja do listy odpowiedzi
                    // i zaznaczamy wiersz jako wybrny
                    answerCell.isCorrect = true
                        
                    let newStudentAnswer = StudentCloseAnswer()
                    newStudentAnswer.content = answer.content
                    newStudentAnswer.isCorrect = true
                    
                    listOfCloseAnswers.append(newStudentAnswer)
                } else {
                    // odpowiedź została wcześniej wybrana
                    // usuwamy ją z listy
                    // i zaznaczamy wiersz jako niewybrany
                    answerCell.isCorrect = false
                    listOfCloseAnswers.remove(at: listOfCloseAnswers.index(of: studentAnswer!)!)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func saveQuestionButtonPressed(_ sender: Any) {
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
            cellLabel.numberOfLines = 0
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
