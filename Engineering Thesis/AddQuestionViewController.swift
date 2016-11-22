//
//  AddQuestionViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 18.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit
import CoreData

class AddQuestionViewController: UIViewController {

    var contentOfController = [Question]()
    
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
                if addOpenQuestion() {
                    if addCloseQuestion() {
                        printSafeAllert()
                    }
                }
            } else {
                if addOpenQuestion() {
                    printSafeAllert()
                }
            }
        } else {
            // just watch existing question
            saveQuestionButtonOutlet.isEnabled = false
        }
    }
    
    private var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
    
    private func addOpenQuestion() -> Bool {
        if !questionContent.text.isEmpty {
            if !numberOfQuestionTextField.text!.isEmpty {
                spinner?.startAnimating()
                let context = self.appDelegate!.persistentContainer.viewContext
                let number = numberOfQuestionTextField.text!
                let text = questionContent.text
                let open = !(switchButton.isOn)
                backgroundQueue.async {
                    // create new question to store in database
                    let newQuestion = Question(context: context)
                    newQuestion.number = Int16(number)!
                    newQuestion.content = text
                    newQuestion.open = open
                    do {
                        try context.save()
                        DispatchQueue.main.async {
                            self.spinner?.stopAnimating()
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            self.spinner?.stopAnimating()
                        }
                        print("Błąd w trakcie zapisu do bazy: \(error)")
                    }
                }
            } else {
                printAlert(alertMessage: "Brak numeru pytania")
                return false
            }
        } else {
            printAlert(alertMessage: "Brak treści pytania")
            return false
        }
        return true
    }
    
    private func addCloseQuestion() -> Bool {
        if !contentOfAAnswerTextView.text.isEmpty || !contentOfBAnswerTextView.text.isEmpty
            || !contentOfCAnswerTextView.text.isEmpty || !contentOfDAnswerTextView.text.isEmpty {
            let context = self.appDelegate!.persistentContainer.viewContext
            let text = contentOfAAnswerTextView.text!
            let correct = answerASwitchButton.isOn
            print(numberOfQuestionTextField.text!)
            backgroundQueue.async {
                // create new question to store in database
                let newAnswer = Answer(context: context)
                newAnswer.content = text
                newAnswer.correct = correct
                newAnswer.number = Int16(self.numberOfQuestionTextField.text!)!
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        self.spinner?.stopAnimating()
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.spinner?.stopAnimating()
                    }
                    print("Błąd w trakcie zapisu do bazy: \(error)")
                }
            }
        } else {
            printAlert(alertMessage: "Brak treści odpowiedzi")
            return false
        }
        return true
    }

    private func displayContent() {
        if (contentOfController.first?.open)! {
            // open question
            changeStates(visible: false)
            numberOfQuestionTextField.text = String(describing: (contentOfController.first?.number)!)
            questionContent.text = contentOfController.first?.content!
        } else {
            // close questtion
            /*changeStates(visible: true)
            numberOfQuestionTextField.text = String(describing: (contentOfController.first?.number))
            questionContent.text = contentOfController.first?.content!
            let context = self.appDelegate!.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
            request.predicate = NSPredicate(format: "numberOfQuestion", contentOfController.first!.number!)
            let answers = (try? context.fetch(request)) as? [Answer]
            print(answers ?? "pusta tablica")
            //let question = (try? context.fetch(request))?.first as? Question
            */
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
