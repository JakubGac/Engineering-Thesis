//
//  StudentExamOpenQuestionViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class StudentExamOpenQuestionViewController: UIViewController, UITextViewDelegate {

    // model
    var question: StudentQuestion?
    private var answer: TestAnswer?
    
    @IBOutlet weak var questionNameLabel: UILabel!
    @IBOutlet weak var questionContentLabel: UILabel!
    @IBOutlet weak var questionAnswerTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionAnswerTextView.delegate = self
        
        // chowanie klawiatury
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let question = question {
            if let item = TestAnswerDao().getAnswerWithQuestionId(id: question.id).first {
                answer = item
            }
            questionNameLabel.text = "Pytanie otwarte za " + String(question.points) + " pkt"
            questionContentLabel.text = question.content
            questionContentLabel.numberOfLines = 4
            
            if let item = answer {
                if item.answer == "Brak odpowiedzi" {
                    questionAnswerTextView.text = "Wpisz tutaj swoją odpowiedź"
                } else {
                    questionAnswerTextView.text = item.answer
                }
            }  else {
                questionAnswerTextView.text = "Wpisz tutaj swoją odpowiedź"
            }
        }
    }
    
    @IBAction func saveAnswerButtonPressed(_ sender: Any) {
        if let question = question {
            if answer != nil {
                // istnieje już odpowiedź dla tego pytania
                if questionAnswerTextView.text == "" || questionAnswerTextView.text == "Wpisz tutaj swoją odpowiedź" {
                    TestAnswerDao().saveOpenAnswer(questionID: question.id, answer: "Brak odpowiedzi")
                } else {
                    TestAnswerDao().saveOpenAnswer(questionID: question.id, answer: questionAnswerTextView.text)
                }
            } else {
                // brak odpowiedzi dla tego pytania, tworzymy nową
                if !(questionAnswerTextView.text == "") && !(questionAnswerTextView.text == "Wpisz tutaj swoją odpowiedź") {
                    TestAnswerDao().saveOpenAnswer(questionID: question.id, answer: questionAnswerTextView.text)
                } else {
                    TestAnswerDao().saveOpenAnswer(questionID: question.id, answer: "Brak odpowiedzi")
                }
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if questionAnswerTextView.text == "Wpisz tutaj swoją odpowiedź" {
            questionAnswerTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if questionAnswerTextView.text == "" {
            questionAnswerTextView.text = "Wpisz tutaj swoją odpowiedź"
        }
    }
}
