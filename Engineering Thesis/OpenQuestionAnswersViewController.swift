//
//  OpenQuestionAnswersViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 21.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class OpenQuestionAnswersViewController: UIViewController {
    
    // model
    // nazwa testu, nazwa studenta, treść pytania, treść odpowiedzi, max punkty za pytanie
    var infos: (String, String, String, String, Double)?
    
    @IBOutlet weak var questionContentLabel: UILabel!
    @IBOutlet weak var questionAnswerLabel: UILabel!
    @IBOutlet weak var givenPointsLabel: UILabel!
    @IBOutlet weak var givePointsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonLook(button: givePointsButton)
        
        if let info = infos {
            // clear existing info
            questionContentLabel.text = nil
            questionAnswerLabel.text = nil
            givenPointsLabel.text = nil
            
            questionContentLabel.text = info.2
            questionAnswerLabel.text = info.3
            let openQuestion = StudentAnswersForTeacherDao().getQuestionWithTestNameStudentNameQuestionContent(testName: info.0, studentName: info.1, questionContent: info.2)
            if openQuestion.givenPoints < 0 {
                givenPointsLabel.text = "Przydzielone punkty: brak"
            } else {
                givenPointsLabel.text = "Przydzielone punkty: \(openQuestion.givenPoints)"
            }
        }
    }
    
    @IBAction func givePointsButtonPressed(_ sender: Any) {
        let myAlert = UIAlertController(title: "", message: "Podaj liczbę punktów. Maksymalna ilość dla tego pytania to: \(infos!.4)", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addTextField { (textField : UITextField) in
            textField.placeholder = "Dodaj"
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (ACTION) in
            if let array = myAlert.textFields {
                if let textField = array.first {
                    if let text = textField.text {
                        if let liczba = Double(text) {
                            if let info = self.infos {
                                if liczba <= info.4 {
                                    StudentAnswersForTeacherDao().saveNumberOfPointsForQuestion(testName: info.0, studentName: info.1, questionContent: info.2, points: liczba)
                                    self.givenPointsLabel.text = "Przydzielone punkty: \(liczba)"
                                } else {
                                    self.printErrorAlert(alertMessage: "Maksymalna ilość punktów dla tego pytania to: \(info.4)")
                                }
                            }
                        } else {
                            self.printErrorAlert(alertMessage: "Nie podałeś liczby!")
                        }
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Anuluj", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
