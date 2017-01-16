//
//  MainStudentViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class MainStudentViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startExamButton: UIButton!
    
    private var doesExamLast: Bool = false
    
    private struct Storyboard {
        static let startExamButton = "Rozpocznij"
        static let continuesExamButton = "Kontynuuj"
        static let StartExamSegue = "Start Exam Segue"
        static let lackOfTestInDatabase = "Brak testu w bazie!"
        static let testSavedCorectly = "Test zapisany prawidłowo"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doesExamLast = StudentTestDao().checkIfStudentTestLast()
        
        setButtonLook(button: startExamButton)
        
        if doesExamLast {
            startExamButton.setTitle(Storyboard.continuesExamButton, for: .normal)
        } else {
            startExamButton.setTitle(Storyboard.startExamButton, for: .normal)
        }
        
        if StudentTestDao().checkIfStudentTestExist() {
            label.text = Storyboard.testSavedCorectly
        } else {
            label.text = Storyboard.lackOfTestInDatabase
        }
    }
    
    @IBAction func startExamButtonPressed(_ sender: UIButton) {
        if label.text == Storyboard.lackOfTestInDatabase {
            printErrorAlert(alertMessage: Storyboard.lackOfTestInDatabase)
        } else {
            if let buttonText = sender.currentTitle {
                if buttonText == Storyboard.startExamButton && doesExamLast == false {
                    StudentTestDao().setStudentTestLast()
                    performSegue(withIdentifier: Storyboard.StartExamSegue, sender: nil)
                } else if buttonText == Storyboard.continuesExamButton && doesExamLast == true {
                    performSegue(withIdentifier: Storyboard.StartExamSegue, sender: nil)
                }
            }
        }
    }
}
