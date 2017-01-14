//
//  ExamTestsViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 11.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class ExamTestsViewController: UIViewController {

    @IBOutlet weak var openTestsButton: UIButton!
    @IBOutlet weak var closeTestsButton: UIButton!
    @IBOutlet weak var mixedTestsButton: UIButton!
    @IBOutlet weak var subjectsTestsButton: UIButton!
    
    private struct Storyboard {
        static let chooseTestSegue = "Choose Test Segue"
        static let openTestsButton = "otwarte"
        static let closeTestsButton = "zamknięte"
        static let mixedTestsButton = "mieszane"
        static let subjectsTestsButton = "z przedmiotu"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set buttons border
        setButtonLook(button: openTestsButton)
        setButtonLook(button: closeTestsButton)
        setButtonLook(button: mixedTestsButton)
        setButtonLook(button: subjectsTestsButton)
    }
    
    @IBAction func typeOfTestButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Storyboard.chooseTestSegue, sender: sender.currentTitle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.chooseTestSegue {
            if let nvc = segue.destination as? ExamTestsTableViewController {
                nvc.testName = sender as? String
            }
        }
    }
}
