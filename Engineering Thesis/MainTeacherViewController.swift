//
//  MainTeacherViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class MainTeacherViewController: UIViewController {

    private struct Storyboard {
        static let ShowQuestionsSegue = "Show Questions"
        static let StartExamSeque = "Start Exam"
        static let questionsButton = "Lista pytań"
        static let startExamButton = "Rozpocznij egzamin"
    }
    
    // MARK: - Navigation
    @IBAction func pressedButtons(_ sender: UIButton) {
        if let buttonText = sender.currentTitle {
            if buttonText == Storyboard.questionsButton {
                performSegue(withIdentifier: Storyboard.ShowQuestionsSegue, sender: sender)
            } else {
                if buttonText == Storyboard.startExamButton {
                    performSegue(withIdentifier: Storyboard.StartExamSeque, sender: sender)
                } else {
                    printAlert(alertMessage: "Brak przejścia w bazie dla podanego tytułu przycisku")
                }
            }
        } else {
            printAlert(alertMessage: "Brak tekstu na przycisku")
        }
    }
    
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
