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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    private var format: DateFormatter!
    private var questions = [Question]()
    private var countSeconds = 0
    private var countMinutes = 0
    private var countHours = 0
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .long
        format.dateFormat = "hh:mm:ss"
        updateClock()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        countSeconds += 1
        if countSeconds == 60 {
            countSeconds = 0
            countMinutes += 1
        }
        if countMinutes == 60 {
            countMinutes = 0
            countHours += 1
        }
        if countHours == 24 {
            countHours = 0
        }
        var printHour = "00"
        var printMinutes = "00"
        var printSeconds = "00"
        if countHours < 10 {
            printHour = "0" + String(countHours)
        } else {
            printHour = String(countHours)
        }
        if countMinutes < 10 {
            printMinutes = "0" + String(countMinutes)
        } else {
            printMinutes = String(countMinutes)
        }
        if countSeconds < 10 {
            printSeconds = "0" + String(countSeconds)
        } else {
            printSeconds = String(countSeconds)
        }
        timerLabel.text = printHour + ":" + printMinutes + ":" + printSeconds
    }
    
    @objc private func updateClock(){
        clockLabel.text = format.string(from: Date())
    }
    
    @IBAction func startStopButtonPressed(_ sender: UIButton) {
        if let textOnButton = sender.currentTitle {
            if textOnButton == "Start" {
                timerLabel.text = "00:00:00"
                countSeconds = 0
                countMinutes = 0
                countHours = 0
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                sender.setTitle("Stop", for: .normal)
            } else {
                timer.invalidate()
                sender.setTitle("Start", for: .normal)
            }
        }
    }
    
    @IBAction func sharedButtonPressed(_ sender: UIButton) {
        if let url = exportToFileUrl() {
            let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            controller.excludedActivityTypes = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.postToWeibo, UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo, UIActivityType.mail, UIActivityType.message, UIActivityType.addToReadingList]
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func exportToFileUrl() -> URL? {
        let questions = DaoManager().getAllQuestionsForTeacher()
     
        var dictionary = [String : String ]()
        
        for question in questions {
            // question content
            dictionary[String(question.number)] = question.content
            // question open or close
            dictionary[String(question.number + 100)] = String(question.isOpen)
            if !question.answers.isEmpty {
                // first answer
                dictionary[String(question.number + 200)] = question.answers[0].content
                // second answer
                dictionary[String(question.number + 300)] = question.answers[1].content
                // third answer
                dictionary[String(question.number + 400)] = question.answers[2].content
                // fourth answer
                dictionary[String(question.number + 500)] = question.answers[3].content
            }
        }

        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let saveFileURL = path.appendingPathComponent("/questionsList.qslt")
        (dictionary as NSDictionary).write(to: saveFileURL, atomically: true)
        return saveFileURL
    }
}
