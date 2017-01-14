//
//  ShowQuestionViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 27.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class ShowQuestionViewController: UIViewController {

    // model
    var question: Question?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    
    private struct Storyboard {
        static let editQuestionSegue = "Edit Item"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    private func updateUI() {
        firstAnswerLabel.alpha = 0
        secondAnswerLabel.alpha = 0
        thirdAnswerLabel.alpha = 0
        fourthAnswerLabel.alpha = 0
        if let questionToDisplay = question {
            if questionToDisplay.isOpen {
                // pytanie otwarte
                fillOpenQuestion(item: questionToDisplay)
            } else {
                // pytanie zamknięte
                fillCloseQuestion(item: questionToDisplay)
            }
        }
    }
    
    private func fillOpenQuestion(item: Question) {
        categoryLabel.text = "Kategoria: " + item.category
        subjectLabel.text = "Przedmiot: " + item.subject
        pointsLabel.text = "Punkty: " + String(item.numberOfPoints)
        questionLabel.text = item.content
    }
    
    private func fillCloseQuestion(item: Question) {
        fillOpenQuestion(item: item)
        if !(item.answers.isEmpty) {
            if item.answers.endIndex > 1 {
                firstAnswerLabel.text = "a) " + item.answers[0].content
                secondAnswerLabel.text = "b) " + item.answers[1].content
                firstAnswerLabel.alpha = 1
                secondAnswerLabel.alpha = 1
            }
            if item.answers.endIndex > 2 {
                thirdAnswerLabel.text = "c) " + item.answers[2].content
                thirdAnswerLabel.alpha = 1
            }
            if item.answers.endIndex > 3 {
                fourthAnswerLabel.text = "d) " + item.answers[3].content
                fourthAnswerLabel.alpha = 1
            }
        }
    }
    
    @IBAction func editQuestionButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Storyboard.editQuestionSegue, sender: question)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.editQuestionSegue {
            if let nvc = segue.destination as? AddOrEditQuestionViewController {
                nvc.question = sender as? Question
            }
        }
    }
}
