//
//  ExamViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 24.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class ExamViewController: UIViewController {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var showTestsButton: UIButton!
    @IBOutlet weak var shareTestButton: UIButton!
    @IBOutlet weak var chooseTestLabel: UILabel!
    @IBOutlet weak var testLastTime: UILabel!
    
    private var format: DateFormatter!
    private var timer = Timer()
    private var test: Test?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .long
        format.dateFormat = "hh:mm:ss"
        updateClock()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonLook(button: showTestsButton)
        setButtonLook(button: shareTestButton)
        
        if let item = TmpPickedTestDao().getPickedTestID().first {
            test = TestDao().getTestWithID(id: item)
        }
        
        if let exam = test {
            chooseTestLabel.text = exam.name
            testLastTime.text = "Czas trwania egzaminu: \(exam.duration) minut"
        } else {
            testLastTime.text = "Czas trwania egzaminu: Brak wybranego testu"
            chooseTestLabel.text = "Brak wybranego testu"
        }
    }
    
    @objc private func updateClock(){
        clockLabel.text = format.string(from: Date())
    }
    
    @IBAction func sharedButtonPressed(_ sender: UIButton) {
        if test == nil || TmpPickedTestDao().getPickedTestID().count == 0 {
            printErrorAlert(alertMessage: "Nie wybrałeś żadnego testu!")
        } else {
            if let url = exportToFileUrl() {
                let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                controller.excludedActivityTypes = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.postToWeibo, UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo, UIActivityType.mail, UIActivityType.message, UIActivityType.addToReadingList]
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    private func exportToFileUrl() -> URL? {
        var dictionary = [String : String ]()
        if let exam = test {
            // 10 - nazwa testu
            dictionary[String(10)] = exam.name
            // 20 - czas trwania testu
            dictionary[String(20)] = String(exam.duration)
            // 30 - ilość pytań w teście
            dictionary[String(30)] = String(exam.numberOfQuestionsForOneStudent)
            
            // sprawdzamy ile mamy ogólnie pytań i ile przypisujemy jednej osobie
            // oraz tworzymy listę pytań
            let totalNumberOfQuestions = exam.totalNumberOfQuestions
            let numberOfQuestionsForOneStudent = exam.numberOfQuestionsForOneStudent
            var listOfQuestions = Array<Question>()
            if totalNumberOfQuestions == numberOfQuestionsForOneStudent {
                // taka sama liczba, wysyłamy wszystkie pytania
                listOfQuestions = Array(exam.questions)
            } else {
                // losujemy pytania
                var listOfQuestionsId = Array<Int>()
                while listOfQuestionsId.count < numberOfQuestionsForOneStudent {
                    let number = Int(arc4random_uniform(UInt32(totalNumberOfQuestions))) + 1
                    if !listOfQuestionsId.contains(number) {
                        listOfQuestionsId.append(number)
                    }
                }
                for question in exam.questions {
                    if listOfQuestionsId.contains(question.id) {
                        listOfQuestions.append(question)
                    }
                }
            }
            
            // stworzoną listę pytań dodajemy do słownika
            var questionindex = 0
            for question in listOfQuestions {
                questionindex += 100
                // dodajemy treść pytania
                dictionary[String(questionindex + 10)] = question.content
                dictionary[String(questionindex + 15)] = question.isOpen.description
                dictionary[String(questionindex + 18)] = String(question.numberOfPoints)
                
                if !question.isOpen {
                    if question.answers.endIndex > 1 {
                        dictionary[String(questionindex + 20)] = question.answers[0].content
                        dictionary[String(questionindex + 25)] = question.answers[0].isCorrect.description
                        
                        dictionary[String(questionindex + 30)] = question.answers[1].content
                        dictionary[String(questionindex + 35)] = question.answers[1].isCorrect.description
                    }
                    if question.answers.endIndex > 2 {
                        dictionary[String(questionindex + 40)] = question.answers[2].content
                        dictionary[String(questionindex + 45)] = question.answers[2].isCorrect.description
                    }
                    if question.answers.endIndex > 3 {
                        dictionary[String(questionindex + 50)] = question.answers[3].content
                        dictionary[String(questionindex + 55)] = question.answers[3].isCorrect.description
                    }
                }
            }
        }
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let saveFileURL = path.appendingPathComponent("/exam.ex")
        (dictionary as NSDictionary).write(to: saveFileURL, atomically: true)
        return saveFileURL
    }
    
    // segues
    private struct Storyboard {
        static let showTestsSegue = "Show Test Segue"
        static let showTestsButton = "Wybierz test"
    }
    
    @IBAction func showTestsButton(_ sender: UIButton) {
        if let buttonText = sender.currentTitle {
            if buttonText == Storyboard.showTestsButton {
                performSegue(withIdentifier: Storyboard.showTestsSegue, sender: nil)
            }
        }
    }
}
