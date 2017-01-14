//
//  TestDetailsViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 08.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class TestDetailsViewController: UIViewController {

    @IBOutlet weak var testTypeLabel: UILabel!
    @IBOutlet weak var testNameLabel: UILabel!
    @IBOutlet weak var testSubjectLabel: UILabel!
    @IBOutlet weak var testDurationLabel: UILabel!
    @IBOutlet weak var testTotalNumberOfQuestionsLabel: UILabel!
    @IBOutlet weak var testNumberOfQuestionsForOneStudentLabel: UILabel!
    @IBOutlet weak var questionsListButton: UIButton!
    
    // model 
    var test: Test? {
        didSet {
            if view != nil {
                updateInformations()
            }
        }
    }
    
    private func updateInformations() {
        if let item = test {
            switch item.type {
            case "all":
                testTypeLabel.text = "Typ: Test mieszany"
            case "open":
                testTypeLabel.text = "Typ: Test otwarty"
            case "close":
                testTypeLabel.text = "Typ: Test zamknięty"
            default: break
            }
            testNameLabel.text = "Nazwa: " + item.name
            testNameLabel.numberOfLines = 3
            if item.subject == "" {
                testSubjectLabel.text = "Przedmiot: Brak"
            } else {
                testSubjectLabel.text = "Przedmiot: " + item.subject
            }
            testDurationLabel.text = "Czas trwania: " + String(item.duration) + " minut"
            testTotalNumberOfQuestionsLabel.text = "Całkowita liczba pytań: " + String(item.totalNumberOfQuestions)
            testNumberOfQuestionsForOneStudentLabel.text = "Liczba pytań dla jednej osoby: " + String(item.numberOfQuestionsForOneStudent)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonLook(button: questionsListButton)
    }
    
    private struct Storybaord {
        static let showQuestionSegue = "Show Test Questions Segue"
    }
    
    @IBAction func questionsListButtonPressed(_ sender: Any) {
        if let item = test {
            performSegue(withIdentifier: Storybaord.showQuestionSegue, sender: item.id)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storybaord.showQuestionSegue {
            if let nvc = segue.destination as? TestQuestionsTableViewController {
                nvc.testID = sender as? Int
            }
        }
    }
}
