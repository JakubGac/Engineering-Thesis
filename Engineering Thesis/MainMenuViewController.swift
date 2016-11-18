//
//  MainMenuViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    private struct Storyboard {
        static let teacherButton = "Wykładowca"
        static let studentButton = "Student"
        static let ShowTeacherSegue = "Show Teacher"
        static let ShowStudentSeque = "Show Student"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let buttonText = sender.currentTitle {
            if buttonText == Storyboard.teacherButton {
                performSegue(withIdentifier: Storyboard.ShowTeacherSegue, sender: sender)
            } else {
                if buttonText == Storyboard.studentButton {
                    performSegue(withIdentifier: Storyboard.ShowStudentSeque, sender: sender)
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
