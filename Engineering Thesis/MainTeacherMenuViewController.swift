//
//  MainTeacherMenuViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 28.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class MainTeacherMenuViewController: UIViewController {
    
    @IBOutlet weak var questionsDataBaseButton: UIButton!
    @IBOutlet weak var testsDataBaseButton: UIButton!
    @IBOutlet weak var examButton: UIButton!
    
    private struct Storyboard {
        static let showQuestionsDataBaseSegue = "Show Questions Data Base"
        static let showTestsDataBaseSegue = "Show Tests Data Base"
        static let examSegue = "Exam Segue"
        static let showQuestionsDataBaseButton = "Baza pytań"
        static let showTestsDataBaseButton = "Baza testów"
        static let examButton = "Egzamin"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set buttons border
        setButtonLook(button: questionsDataBaseButton)
        setButtonLook(button: testsDataBaseButton)
        setButtonLook(button: examButton)
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if let buttonText = sender.currentTitle {
            if buttonText == Storyboard.showQuestionsDataBaseButton {
                performSegue(withIdentifier: Storyboard.showQuestionsDataBaseSegue, sender: nil)
            } else if buttonText == Storyboard.showTestsDataBaseButton {
                performSegue(withIdentifier: Storyboard.showTestsDataBaseSegue, sender: nil)
            } else if buttonText == Storyboard.examButton {
                // czyścimy tablę z tymczasowym ID testu
                DaoManager().cleareTmpPickedTestTable()
                performSegue(withIdentifier: Storyboard.examSegue, sender: nil)
            }
        }
    }
}
