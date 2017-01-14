//
//  TestsDataBaseViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 08.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class TestsDataBaseViewController: UIViewController {
    
    @IBOutlet weak var openTestsButton: UIButton!
    @IBOutlet weak var closeTestsButton: UIButton!
    @IBOutlet weak var mixedTestsButton: UIButton!
    @IBOutlet weak var subjectsTestsButton: UIButton!
    @IBOutlet weak var addNewTestButton: UIButton!
    
    private struct Storyboard {
        static let showTestsSegue = "Show Tests Segue"
        static let addNewTestSegue = "Add New Test Segue"
        static let openTestsButton = "otwarte"
        static let closeTestsButton = "zamknięte"
        static let mixedTestsButton = "mieszane"
        static let subjectsTestsButton = "z przedmiotu"
        static let addNewTestButton = "Dodaj nowy"
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
        setButtonLook(button: addNewTestButton)
    }
    
    @IBAction func typeOfTestButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Storyboard.showTestsSegue, sender: sender.currentTitle)
    }
    
    @IBAction func addNewTestButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Storyboard.addNewTestSegue, sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showTestsSegue {
            if let nvc = segue.destination as? TestsDataBaseTableViewController {
                if let buttonText = sender as? String {
                    if buttonText == Storyboard.openTestsButton {
                        nvc.testName = Storyboard.openTestsButton
                    } else if buttonText == Storyboard.closeTestsButton {
                        nvc.testName = Storyboard.closeTestsButton
                    } else if buttonText == Storyboard.mixedTestsButton {
                        nvc.testName = Storyboard.mixedTestsButton
                    } else if buttonText == Storyboard.subjectsTestsButton {
                        nvc.testName = Storyboard.subjectsTestsButton
                    }
                }
            }
        }
    }
}
