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
    
    private struct Storyboard {
        static let startExamButton = "Rozpocznij"
        static let StartExamSegue = "StartExam"
        static let lackOfTestInDatabase = "Brak testu w bazie!"
        static let testSavedCorectly = "Test zapisany prawidłowo"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonLook(button: startExamButton)
        if DaoManager().checkIfStudentTestExist() {
            label.text = Storyboard.testSavedCorectly
        } else {
            label.text = Storyboard.lackOfTestInDatabase
        }
    }
    
    @IBAction func startExamButtonPressed(_ sender: Any) {
        if label.text == Storyboard.lackOfTestInDatabase {
            printErrorAlert(alertMessage: "Brak testu w bazie!")
        } else {
            print(DaoManager().getStudentTest())
        }
    }
}
