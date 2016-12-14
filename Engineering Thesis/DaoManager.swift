//
//  DaoManager.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 22.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class DaoManager {
    private var realm = try! Realm()
    
    func getAllQuestionsForTeacher() -> [Question] {
        return Array(realm.objects(Question.self).filter("received == %@", false))
    }
    
    func getAllQuestionsForStudent() -> [Question] {
        return Array(realm.objects(Question.self).filter("received == %@", true))
    }
    
    func importData(from url: URL) {
        deleteStudentQuestions()
        if let dictionary = NSDictionary(contentsOf: url) {
            if let list = dictionary as? [String : String] {
                for key in list.keys.sorted() where Int(key)! < 99 {
                    if list[String(Int(key)! + 100)] == "true" {
                        // open question
                        addNewQuestion(content: list[key]!, number: Int(key)!, isOpen: true, received: true)
                    } else {
                        // close question
                        addNewQuestion(content: list[key]!, number: Int(key)!,
                                       isOpen: false, answerAText: list[String(Int(key)! + 200)]!,
                                       answerBText: list[String(Int(key)! + 300)]!, answerCText: list[String(Int(key)! + 400)]!,
                                       answerDText: list[String(Int(key)! + 500)]!, received: true)
                    }
                }
            }
        }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("Niepowodzenie usuwania pliku. Error: \(error)")
        }
    }
    
    func addNewQuestion(content: String, number: Int, isOpen: Bool, received: Bool) {
        let newQuestion = Question()
        newQuestion.content = content
        newQuestion.number = number
        newQuestion.isOpen = isOpen
        newQuestion.received = received
        try! realm.write {
            realm.add(newQuestion)
        }
    }
    
    func addNewQuestion(content: String, number: Int, isOpen: Bool, answerAText: String, answerBText: String, answerCText: String, answerDText: String, answerAIsCorrect: Bool, answerBIsCorrect: Bool, answerCIsCorrect: Bool, answerDIsCorrect: Bool, received: Bool) {
        let answerA = Answer()
        answerA.content = answerAText
        answerA.isCorrect = answerAIsCorrect
        let answerB = Answer()
        answerB.content = answerBText
        answerB.isCorrect = answerBIsCorrect
        let answerC = Answer()
        answerC.content = answerCText
        answerC.isCorrect = answerCIsCorrect
        let answerD = Answer()
        answerD.content = answerDText
        answerD.isCorrect = answerDIsCorrect
        let listOfAnswers = List<Answer>()
        listOfAnswers.append(answerA)
        listOfAnswers.append(answerB)
        listOfAnswers.append(answerC)
        listOfAnswers.append(answerD)
        let newQuestion = Question()
        newQuestion.content = content
        newQuestion.number = number
        newQuestion.isOpen = isOpen
        newQuestion.answers = listOfAnswers
        newQuestion.received = received
        try! realm.write {
            realm.add(newQuestion)
        }
    }
    
    func addNewQuestion(content: String, number: Int, isOpen: Bool, answerAText: String, answerBText: String, answerCText: String, answerDText: String, received: Bool) {
        let answerA = Answer()
        answerA.content = answerAText
        let answerB = Answer()
        answerB.content = answerBText
        let answerC = Answer()
        answerC.content = answerCText
        let answerD = Answer()
        answerD.content = answerDText
        let listOfAnswers = List<Answer>()
        listOfAnswers.append(answerA)
        listOfAnswers.append(answerB)
        listOfAnswers.append(answerC)
        listOfAnswers.append(answerD)
        let newQuestion = Question()
        newQuestion.content = content
        newQuestion.number = number
        newQuestion.isOpen = isOpen
        newQuestion.answers = listOfAnswers
        newQuestion.received = received
        try! realm.write {
            realm.add(newQuestion)
        }
    }
    
    func deleteQuestion(questionToDelete: Question) {
        let _ = realm.objects(Question.self).filter("number == %@", questionToDelete.number)
        try! realm.write {
            realm.delete(questionToDelete)
        }
    }
    
    func deleteQuestion(numberOfQUestionToDelete: String) {
        let objectToDelete = realm.objects(Question.self).filter("number == %@", Int(numberOfQUestionToDelete)!)
        try! realm.write {
            realm.delete(objectToDelete)
        }
    }
    
    func deleteStudentQuestions() {
        let objectsToDelete = List(realm.objects(Question.self).filter("received == %@", true))
        try! realm.write {
            realm.delete(objectsToDelete)
        }
    }
}
