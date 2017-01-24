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
    @IBOutlet weak var sendAnswersButton: UIButton!
    @IBOutlet weak var checkAnswersButton: UIButton!
    
    private var doesExamLast: Bool = false
    private var score = (0.0, 0.0)
    
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
        sendAnswersButton.alpha = CGFloat(0)
        sendAnswersButton.isEnabled = false
        checkAnswersButton.alpha = CGFloat(0)
        checkAnswersButton.isEnabled = false
        
        doesExamLast = StudentTestDao().checkIfStudentTestLast()
        
        setButtonLook(button: startExamButton)
        
        if StudentTestDao().checkIfStudentTestExist() {
            startExamButton.isEnabled = true
            startExamButton.alpha = CGFloat(1)
            label.text = Storyboard.testSavedCorectly
            if doesExamLast {
                startExamButton.setTitle(Storyboard.continuesExamButton, for: .normal)
            } else {
                startExamButton.setTitle(Storyboard.startExamButton, for: .normal)
            }
        } else {
            label.text = Storyboard.lackOfTestInDatabase
            startExamButton.isEnabled = false
            startExamButton.alpha = CGFloat(0)
        }
        
        if StudentTestDao().checkIfStudentTestIsDone() {
            setButtonLook(button: sendAnswersButton)
            sendAnswersButton.alpha = CGFloat(1)
            sendAnswersButton.isEnabled = true
            setButtonLook(button: checkAnswersButton)
            checkAnswersButton.alpha = CGFloat(1)
            checkAnswersButton.isEnabled = true
            
            score = checkAnswers()
        }
    }
    
    @IBAction func startExamButtonPressed(_ sender: UIButton) {
        if label.text == Storyboard.lackOfTestInDatabase {
            printErrorAlert(alertMessage: Storyboard.lackOfTestInDatabase)
        } else {
            if StudentTestDao().checkIfStudentTestIsDone() {
                printErrorAlert(alertMessage: "Zakończyłeś już test. Nie możesz do niego wrócić")
            } else {
                if let buttonText = sender.currentTitle {
                    if buttonText == Storyboard.startExamButton && doesExamLast == false {
                        StudentTestDao().setStudentTestLast()
                        UIApplication.shared.isIdleTimerDisabled = true
                        performSegue(withIdentifier: Storyboard.StartExamSegue, sender: nil)
                    } else if buttonText == Storyboard.continuesExamButton && doesExamLast == true {
                        performSegue(withIdentifier: Storyboard.StartExamSegue, sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func sendAnswerButtonPressed(_ sender: Any) {
        // odpytujemy o imię i nazwisko
        let myAlert = UIAlertController(title: "", message: "Podaj swoje imię i nazwisko", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addTextField { (textField : UITextField) in
            textField.placeholder = "Dodaj"
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (ACTION) in
            if let array = myAlert.textFields {
                if let textField = array.first {
                    if let text = textField.text {
                        // jeżeli wpisano imię to wysyłamy odpowiedzi
                        if text != "" {
                            self.sendAnswers(name: text)
                        }
                    }
                }
            }
        }
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    private func sendAnswers(name: String) {
        let answers = TestAnswerDao().getTestAnswers()
        
        if let url = exportToFileUrl(answers: answers, name: name) {
            let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            controller.excludedActivityTypes = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.postToWeibo, UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo, UIActivityType.mail, UIActivityType.message, UIActivityType.addToReadingList]
            self.present(controller, animated: true, completion: nil)
        }
        
        // jeżeli prawidłowo wysłano odpowiedzi to usuwamy test i dane z nim związane
        TestAnswerDao().clearStudentAnswers()
        //zerujemy zmienną o zakończonym teście i trwającym teście
        StudentTestDao().setStudentTestFinish()
        StudentTestDao().setStudentTestIsDone()
        // włączamy zegar bezczynności
        UIApplication.shared.isIdleTimerDisabled = true
        // usuwamy test z bazy
        StudentTestDao().clearStudentTest()
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func exportToFileUrl(answers: Array<TestAnswer>, name: String) -> URL? {
        var dictionary = [String : String ]()
        let test = StudentTestDao().getStudentTest().first
        
        // imię i nazwisko studenta
        dictionary[String(10)] = name
        // nazwa testu
        dictionary[String(20)] = test!.name
        
        // jeżeli nie ma odpowiedzi do testu
        if answers.isEmpty {
            dictionary[String(30)] = "Brak odpowiedzi"
        }
        
        // liczba zdobytych punktów
        dictionary[String(60)] = String(score.0)
        // liczba max punktów do zdobycia
        dictionary[String(70)] = String(score.1)
        
        var questionIndex = 0
        
        for answer in answers {
            questionIndex += 100
            // bierzemy pod uwagę tylko pytania otwarte
            if answer.closeAnswers.isEmpty {
                // zapisujemy ID pytania
                dictionary[String(questionIndex + 10)] = String(answer.questionID)
                // zapisujemy treść pytania
                for item in (test?.listOfQuestions)! {
                    if item.id == answer.questionID {
                        dictionary[String(questionIndex + 12)] = item.content
                        dictionary[String(questionIndex + 13)] = String(item.points)
                    }
                }
                // odpowiedź do otwartego pytania
                if answer.answer != "Brak odpowiedzi" {
                    dictionary[String(questionIndex + 20)] = answer.answer
                } else {
                    // brak odpowiedzi na pytanie otwarte
                    dictionary[String(questionIndex + 15)] = "Brak odpowiedzi"
                }
            }
        }
    
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let saveFileURL = path.appendingPathComponent("/testanswers.tean")
        (dictionary as NSDictionary).write(to: saveFileURL, atomically: true)
        
        return saveFileURL
    }
    
    @IBAction func checkAnswersButtonPressed(_ sender: Any) {
        let myAlert = UIAlertController(title: "", message: "Z pytań zamkniętych uzyskałeś \(score.0) na \(score.1) punktów", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    private func checkAnswers() -> (Double, Double) {
        let test = StudentTestDao().getStudentTest().first!
        let answers = TestAnswerDao().getTestAnswers()
        
        // liczymy możliwą liczbę punktów do uzyskania za zamknięte pytania
        var totalNumberOfPoints = 0.0
        var studentScore = 0.0
        for question in test.listOfQuestions {
            if !question.isOpen {
                totalNumberOfPoints += question.points
            }
        }
        
        if totalNumberOfPoints == 0.0 {
            // brak zamkniętych pytań
            return (0.0, 0.0)
        }
        
        if answers.isEmpty {
            // brak odpowiedzi do testu
            return (0.0, totalNumberOfPoints)
        }
        
        for answer in answers {
            if !answer.closeAnswers.isEmpty {
                // answer - odpowiedź udzielona przez studenta
                // zawiera question ID oraz listę odpowiedzi zamkniętych
                // przeszukujemy test w poszukiwaniu pytania tego pytania
                for item in test.listOfQuestions {
                    if item.id == answer.questionID {
                        // item - odnalezione wzorowe pytanie
                        //obliczamy ile jest prawidłowych zamkniętych pytań
                        var numberOfCorrectQuestions = 0
                        for correctAnswer in item.listOfAnswers {
                            if correctAnswer.isCorrect {
                                numberOfCorrectQuestions += 1
                            }
                        }
                        
                        for correctAnswer in item.listOfAnswers {
                            // bierzemy wzorowe pytania
                            // następnie odnajdujemy czy student też zaznaczył to pytanie
                            var tmpAnswer: StudentCloseAnswer?
                            for studentAnswer in answer.closeAnswers {
                                if studentAnswer.content == correctAnswer.content {
                                    tmpAnswer = studentAnswer
                                }
                            }
                            if let studentAnswer = tmpAnswer {
                                // student również podał tą odpowiedź, sprawdźmy czy jest ona poprawna
                                if studentAnswer.isCorrect && correctAnswer.isCorrect {
                                    // student udzielił dobrej odpowiedzi
                                    studentScore += Double(1.0 / Double(numberOfCorrectQuestions) * Double(item.points))
                                } else if !studentAnswer.isCorrect && !correctAnswer.isCorrect {
                                    // obie odpowiedzi sa false, dobrze, że student jej nie zaznaczył
                                    // nie robimy nic z punktami
                                    break
                                } else {
                                    // student ją zaznaczył, lub nie, odejmujemy punkty
                                    studentScore -= Double(1.0 / Double(numberOfCorrectQuestions) * Double(item.points))
                                }
                            } else {
                                // student nie podał tej odpowiedzi
                                // sprawdźmy czy jest prawidłowa
                                if correctAnswer.isCorrect  {
                                    // jest prawidłowa, student powinien był ją zaznaczyć
                                    // odejmujemy punkty
                                    studentScore += Double(1.0 / Double(numberOfCorrectQuestions) * Double(item.points))
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        return (studentScore, totalNumberOfPoints)
    }
}
