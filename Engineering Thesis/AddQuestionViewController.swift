//
//  AddQuestionViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 18.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit
import RealmSwift

class AddQuestionViewController: UIViewController {

    // outlets
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionContent: UITextView!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    @IBOutlet weak var numberOfQuestionTextField: UITextField!
    @IBOutlet weak var contentOfAAnswerTextView: UITextView!
    @IBOutlet weak var answerASecondLabel: UILabel!
    @IBOutlet weak var answerASwitchButton: UISwitch!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var contentOfBAnswerTextView: UITextView!
    @IBOutlet weak var answerBSecondLabel: UILabel!
    @IBOutlet weak var answerBSwitchButton: UISwitch!
    @IBOutlet weak var answerCLabel: UILabel!
    @IBOutlet weak var contentOfCAnswerTextView: UITextView!
    @IBOutlet weak var answerCSecondLabel: UILabel!
    @IBOutlet weak var answerCSwitchButton: UISwitch!
    @IBOutlet weak var answerDLabel: UILabel!
    @IBOutlet weak var contentOfDAnswerTextView: UITextView!
    @IBOutlet weak var answerDSecondLabel: UILabel!
    @IBOutlet weak var answerDSwitchButton: UISwitch!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var saveQuestionButtonOutlet: UIBarButtonItem!
    
    // model
    var contentOfController = [Question]()
    
    @IBAction func switchButtonChanged(_ sender: UISwitch) {
        if switchButton.isOn {
            changeStates(visible: false)
        } else {
            changeStates(visible: true)
        }
    }
    
    @IBAction func saveQuestionButton(_ sender: UIBarButtonItem) {
        if contentOfController.isEmpty {
            if switchButton.isOn {
                // add close question
                if addCloseQuestion() {
                    printSafeAllert()
                }
            } else {
                if addOpenQuestion() {
                    printSafeAllert()
                }
            }
        } else {
            // just watch existing question
            saveQuestionButtonOutlet.isEnabled = false
            printNoEditionAlert(alertMessage: "Brak możliwości edycji pytania")
        }
    }
    
    private func addOpenQuestion() -> Bool {
        if let questionText = questionContent.text {
            if !questionText.isEmpty {
                if let questionNumber = numberOfQuestionTextField.text {
                    if !questionNumber.isEmpty {
                        spinner?.startAnimating()
                        DaoManager().addNewQuestion(content: questionText, number: Int(questionNumber)!, isOpen: !switchButton.isOn, received: false)
                        spinner?.stopAnimating()
                    } else {
                        printAlert(alertMessage: "Błąd w numerze pytania")
                        return false
                    }
                }
            } else {
                printAlert(alertMessage: "Brak treści pytania")
                return false
            }
        }
        return true
    }
    
    private func addCloseQuestion() -> Bool {
        if let firstAnswerText = contentOfAAnswerTextView.text {
            if let secondAnswerText = contentOfBAnswerTextView.text {
                if let thirdAnswerText = contentOfCAnswerTextView.text {
                    if let fourthAnswerText = contentOfDAnswerTextView.text {
                        if !firstAnswerText.isEmpty && !secondAnswerText.isEmpty && !thirdAnswerText.isEmpty && !fourthAnswerText.isEmpty {
                            if let questionText = questionContent.text {
                                if !questionText.isEmpty {
                                    if let questionNumber = numberOfQuestionTextField.text {
                                        if !questionNumber.isEmpty {
                                            spinner?.startAnimating()
                                            DaoManager().addNewQuestion(content: questionText, number: Int(questionNumber)!, isOpen: !switchButton.isOn, answerAText: firstAnswerText, answerBText: secondAnswerText, answerCText: thirdAnswerText, answerDText: fourthAnswerText, answerAIsCorrect: answerASwitchButton.isOn, answerBIsCorrect: answerBSwitchButton.isOn, answerCIsCorrect: answerCSwitchButton.isOn, answerDIsCorrect: answerDSwitchButton.isOn, received: false)
                                            spinner?.stopAnimating()
                                            return true
                                        } else {
                                            printAlert(alertMessage: "Błąd w numerze pytania")
                                            return false
                                        }
                                    }
                                } else {
                                    printAlert(alertMessage: "Brak treści pytania")
                                    return false
                                }
                            }
                        } else {
                            printAlert(alertMessage: "Brak treści odpowiedzi")
                            return false
                        }
                    }
                }
            }
        }
        return false
    }

    private func displayContent() {
        if let question = contentOfController.first {
            if question.isOpen {
                // open question
                changeStates(visible: false)
                questionContent.text = question.content
                numberOfQuestionTextField.text = String(question.number)
            } else {
                // close question
                changeStates(visible: true)
                numberOfQuestionTextField.text = String(question.number)
                questionContent.text = question.content
                contentOfAAnswerTextView.text = question.answers[0].content
                answerASwitchButton.isOn = question.answers[0].isCorrect
                contentOfBAnswerTextView.text = question.answers[1].content
                answerBSwitchButton.isOn = question.answers[1].isCorrect
                contentOfCAnswerTextView.text = question.answers[2].content
                answerCSwitchButton.isOn = question.answers[2].isCorrect
                contentOfDAnswerTextView.text = question.answers[3].content
                answerDSwitchButton.isOn = question.answers[3].isCorrect
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contentOfController.isEmpty {
            changeStates(visible: false)
        } else {
            displayContent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        questionContent.endEditing(true)
        contentOfAAnswerTextView.endEditing(true)
        contentOfBAnswerTextView.endEditing(true)
        contentOfCAnswerTextView.endEditing(true)
        contentOfDAnswerTextView.endEditing(true)
    }
    
    private func printAlert(alertMessage: String) {
        let myAlert = UIAlertController(title: "Błąd", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(actionOK)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    private func printSafeAllert(){
        let myAlert = UIAlertController(title: "Baza danych", message: "Zapis zakończony prawidłowo", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (ACTION) in
            self.navigationController!.popViewController(animated: true)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    private func printNoEditionAlert(alertMessage: String) {
        let myAlert = UIAlertController(title: "Błąd", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(actionOK)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    private func changeStates(visible: Bool) {
        let backgroundColor: UIColor?
        let textColor: UIColor?
        let alpha: CGFloat
        if visible {
            backgroundColor = UIColor.white
            textColor = UIColor.black
            alpha = CGFloat(1.0)
        } else {
            let color = UIColor(colorLiteralRed: 72, green: 144, blue: 142, alpha: 0)
            backgroundColor = color
            textColor = color
            alpha = CGFloat(0.0)
        }
        
        switchButton.isOn = visible
        
        answerALabel.alpha = alpha
        answerBLabel.alpha = alpha
        answerCLabel.alpha = alpha
        answerDLabel.alpha = alpha
        
        answerASecondLabel.alpha = alpha
        answerBSecondLabel.alpha = alpha
        answerCSecondLabel.alpha = alpha
        answerDSecondLabel.alpha = alpha
        
        answerASwitchButton.alpha = alpha
        answerBSwitchButton.alpha = alpha
        answerCSwitchButton.alpha = alpha
        answerDSwitchButton.alpha = alpha
        
        contentOfAAnswerTextView.isEditable = visible
        contentOfBAnswerTextView.isEditable = visible
        contentOfCAnswerTextView.isEditable = visible
        contentOfDAnswerTextView.isEditable = visible
        
        contentOfAAnswerTextView.backgroundColor = backgroundColor
        contentOfBAnswerTextView.backgroundColor = backgroundColor
        contentOfCAnswerTextView.backgroundColor = backgroundColor
        contentOfDAnswerTextView.backgroundColor = backgroundColor
        
        contentOfAAnswerTextView.textColor = textColor
        contentOfBAnswerTextView.textColor = textColor
        contentOfCAnswerTextView.textColor = textColor
        contentOfDAnswerTextView.textColor = textColor
    }
}
