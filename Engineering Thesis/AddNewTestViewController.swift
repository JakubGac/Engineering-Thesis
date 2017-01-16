//
//  AddNewTestViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 06.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class AddNewTestViewController: UIViewController, UITextFieldDelegate {
    
    // model
    var typeOfTest: String? {
        didSet {
            if view != nil {
                if typeOfTest == "open" {
                    newTestLabel.text = "Nowy test otwarty"
                } else if typeOfTest == "close" {
                    newTestLabel.text = "Nowy test zamknięty"
                } else if typeOfTest == "all" {
                    newTestLabel.text = "Nowy test mieszany"
                }
            }
        }
    }
    
    @IBOutlet weak var newTestLabel: UILabel!
    @IBOutlet weak var testNameTextField: UITextField!
    @IBOutlet weak var durationOfTestTextField: UITextField!
    @IBOutlet weak var totalAmountOfQuestionsTextField: UITextField!
    @IBOutlet weak var numberOfQuestionsForOneStudentTextField: UITextField!
    @IBOutlet weak var allQuestionsButton: UIButton!
    @IBOutlet weak var categoryQuestionsButton: UIButton!
    @IBOutlet weak var subjectQuestionsButton: UIButton!

    private var tfv = TextFieldValidator()
    private var listOfPickedQuestions = Array<Int>()
    
    private struct Storyboard {
        static let showQuestionsToBeAddedSegue = "Show Questions To Be Added"
        static let showAllQuestionsButton = "wszystkie"
        static let showCategoryQuestionsButton = "według kategorii"
        static let showSubjectQuestionsButton = "według przedmiotów"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        testNameTextField.placeholder = "Nazwa:"
        durationOfTestTextField.placeholder = "Czas trwania w minutach:"
        totalAmountOfQuestionsTextField.placeholder = "Całkowita ilość pytań:"
        numberOfQuestionsForOneStudentTextField.placeholder = "Ilość pytań dla jednej osoby:"
        
        setButtonLook(button: allQuestionsButton)
        setButtonLook(button: categoryQuestionsButton)
        setButtonLook(button: subjectQuestionsButton)
        
        totalAmountOfQuestionsTextField.delegate = self
        numberOfQuestionsForOneStudentTextField.delegate = self
    }
    
    @IBAction func listOfQuestionsButtonPressed(_ sender: UIButton) {
        if tfv.checkIfFieldIsFilled(view: totalAmountOfQuestionsTextField) && tfv.checkIfFieldContainsNumbers(view: totalAmountOfQuestionsTextField) {
            performSegue(withIdentifier: Storyboard.showQuestionsToBeAddedSegue, sender: sender.currentTitle)
        }
    }
    
    @IBAction func addNewTestButtonPressed(_ sender: Any) {
        // walidacja pól
        if tfv.checkIfFieldIsFilled(view: testNameTextField) && tfv.checkIfFieldContainsAlphabets(view: testNameTextField) {
            if tfv.checkIfFieldIsFilled(view: durationOfTestTextField) && tfv.checkIfFieldContainsNumbers(view: durationOfTestTextField) {
                if tfv.checkIfFieldIsFilled(view: totalAmountOfQuestionsTextField) && tfv.checkIfFieldContainsNumbers(view: totalAmountOfQuestionsTextField) {
                    if tfv.checkIfFieldIsFilled(view: numberOfQuestionsForOneStudentTextField) && tfv.checkIfFieldContainsNumbers(view: numberOfQuestionsForOneStudentTextField) {
                        let questionsListID = TmpPickedQuestionsDao().getAllPickedQuestionsID()
                        if questionsListID.count == Int(totalAmountOfQuestionsTextField.text!) {
                            TestDao().addNewTestToDatabase(type: typeOfTest!, name: testNameTextField.text!, duration: Int(durationOfTestTextField.text!)!,totalAmountOfQuestions: Int(totalAmountOfQuestionsTextField.text!)!, amountOfQuestionsPerStudent: Int(numberOfQuestionsForOneStudentTextField.text!)!, listOfQuestionsID: questionsListID)
                            printSafeAllert()
                        } else {
                            let message = "Wybrano: " + String(questionsListID.count) + " z " + totalAmountOfQuestionsTextField.text! + " pytań!"
                            printErrorAlert(alertMessage: message)
                        }
                    }
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == totalAmountOfQuestionsTextField {
            if let number = totalAmountOfQuestionsTextField.text {
                if number != "" {
                    if Int(number)! > QuestionDao().getAmountOfQuestionsInDatabaseWithTestType(type: typeOfTest!) {
                        printErrorAlert(alertMessage: "W bazie nie ma tylu pytań!")
                        totalAmountOfQuestionsTextField.text = ""
                        TmpPickedQuestionsDao().cleareTmpPickedQuestionsTable()
                    }
                }
            }
        } else if textField == numberOfQuestionsForOneStudentTextField {
            if let numberOfQuestionsForOneStudent = numberOfQuestionsForOneStudentTextField.text {
                if let totalAmountOfQuestions = totalAmountOfQuestionsTextField.text {
                    if numberOfQuestionsForOneStudent != "" && totalAmountOfQuestions != "" {
                        if Int(numberOfQuestionsForOneStudent)! > Int(totalAmountOfQuestions)! {
                            printErrorAlert(alertMessage: "Nie możesz wybrać większej ilości pytań niż maksymalna dla całego testu")
                            numberOfQuestionsForOneStudentTextField.text = ""
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nvc = segue.destination as? PickQuestionTableViewController {
            if let buttonText = sender as? String {
                if buttonText == Storyboard.showAllQuestionsButton {
                    nvc.typeOfQuestionsToDisplay = "all"
                } else if buttonText == Storyboard.showSubjectQuestionsButton {
                    nvc.typeOfQuestionsToDisplay = "subject"
                } else if buttonText == Storyboard.showCategoryQuestionsButton {
                    nvc.typeOfQuestionsToDisplay = "category"
                }
            }
            nvc.totalNumberOfQuestions = Int(totalAmountOfQuestionsTextField.text!)!
            if let testType = typeOfTest {
                nvc.typeOfTest = testType
            }
        }
    }
}
