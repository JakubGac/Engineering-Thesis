//
//  NewTestViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 06.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class NewTestViewController: UIViewController {

    @IBOutlet weak var openQuestionsButton: UIButton!
    @IBOutlet weak var closeQuestionsButton: UIButton!
    @IBOutlet weak var mixedQuestionsButton: UIButton!
    
    private struct Storyboard {
        static let addNewTestSegue = "Add New Test Segue"
        static let openQuestionsButton = "otwarte"
        static let closeQuestionsButton = "zamknięte"
        static let mixedQuestionsButton = "mieszane"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        // set buttons border
        setButtonLook(button: openQuestionsButton)
        setButtonLook(button: closeQuestionsButton)
        setButtonLook(button: mixedQuestionsButton)
        
        // czyścimy tabelę tymczasową z wybranymi plikami
        // jeżeli użytkownik nie zapisał testu
        DaoManager().cleareTmpPickedQuestionsTable()
    }
    
    @IBAction func typeOfQuestionsButtonPressed(_ sender: UIButton) {
        if let buttonText = sender.currentTitle {
            var senderText = ""
            if buttonText == Storyboard.openQuestionsButton {
                senderText = "open"
            } else if buttonText == Storyboard.closeQuestionsButton {
                senderText = "close"
            } else if buttonText == Storyboard.mixedQuestionsButton {
                senderText = "all"
            }
            performSegue(withIdentifier: Storyboard.addNewTestSegue, sender: senderText)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nvc = segue.destination as? AddNewTestViewController {
            nvc.typeOfTest = sender as? String
        }
    }
}
