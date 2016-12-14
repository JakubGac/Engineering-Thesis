//
//  MainStudentViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class MainStudentViewController: UIViewController {

    private struct Storyboard {
        static let startExamButton = "Rozpocznij egzamin"
        static let receiveQuestionsButton = "Odbierz pytania"
        static let StartExamSegue = "StartExam"
        static let ReceiveQuestionsSeque = "ReceiveQuestions"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let buttonText = sender.currentTitle {
            if buttonText == Storyboard.startExamButton {
                performSegue(withIdentifier: Storyboard.StartExamSegue, sender: sender)
            } else {
                if buttonText == Storyboard.receiveQuestionsButton {
                    // przycisk do odbierania pytań
                }
            }
        }
    }
    
    // MARK: - Navigation
    private func printAlert(alertMessage: String) {
        let myAlert = UIAlertController(title: "Błąd", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(actionOK)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
