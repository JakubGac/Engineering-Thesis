//
//  QuestionDao.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 15.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class QuestionDao {
    private var realm = try! Realm()
    
    // dodawanie nowego pytania
    func addNewQuestionToDatabase(category: String, subject: String, numberOfPoints: Double, contentOfQuestion: String, firstAnswerContent: String?,
                                  secondAnswerContent: String?, thirdAnswerContent: String?, fourthAnswerContent: String?, firstAnswerIsCorrect: Bool?,
                                  secondAnswerIsCorrect: Bool?, thirdAnswerIsCorrect: Bool?, fourthAnswerIsCorrect: Bool?) {
        let newQuestion = Question()
        newQuestion.id = getLastQuestionID() + 1
        newQuestion.category = category
        newQuestion.subject = subject
        newQuestion.numberOfPoints = numberOfPoints
        newQuestion.isOpen = true
        newQuestion.content = contentOfQuestion
        let answersList = List<Answer>()
        if let firstContent = firstAnswerContent {
            if let secondContent = secondAnswerContent {
                
                let firstNewAnswer = Answer()
                firstNewAnswer.content = firstContent
                firstNewAnswer.isCorrect = firstAnswerIsCorrect!
                let secondNewAnswer = Answer()
                secondNewAnswer.content = secondContent
                secondNewAnswer.isCorrect = secondAnswerIsCorrect!
                
                answersList.append(secondNewAnswer)
                answersList.append(firstNewAnswer)
                
                if let thirdContent = thirdAnswerContent {
                    
                    let thirdNewAnswer = Answer()
                    thirdNewAnswer.content = thirdContent
                    thirdNewAnswer.isCorrect = thirdAnswerIsCorrect!
                    
                    answersList.append(thirdNewAnswer)
                    
                    if let fourthContent = fourthAnswerContent {
                        
                        let fourthNewAnswer = Answer()
                        fourthNewAnswer.content = fourthContent
                        fourthNewAnswer.isCorrect = fourthAnswerIsCorrect!
                        
                        answersList.append(fourthNewAnswer)
                    }
                }
            }
            newQuestion.isOpen = false
        }
        
        newQuestion.answers = answersList
        try! realm.write {
            realm.add(newQuestion)
        }
    }
    
    // edycja istniejącego pytania
    func editQuestion(question: Question, category: String, subject: String, numberOfPoints: Double, contentOfQuestion: String, firstAnswerContent: String?,
                      secondAnswerContent: String?, thirdAnswerContent: String?, fourthAnswerContent: String?, firstAnswerIsCorrect: Bool?,
                      secondAnswerIsCorrect: Bool?, thirdAnswerIsCorrect: Bool?, fourthAnswerIsCorrect: Bool?) {
        if let editedQuestion = realm.objects(Question.self).filter("id == %@", question.id).first {
            if !(editedQuestion.category == category) {
                try! realm.write {
                    editedQuestion.category = category
                }
            }
            if !(editedQuestion.subject == subject) {
                try! realm.write {
                    editedQuestion.subject = subject
                }
            }
            if !(editedQuestion.numberOfPoints == numberOfPoints) {
                try! realm.write {
                    editedQuestion.numberOfPoints = numberOfPoints
                }
            }
            if !(editedQuestion.content == contentOfQuestion) {
                try! realm.write {
                    editedQuestion.content = contentOfQuestion
                }
            }
            
            let answersList = List<Answer>()
            if let firstContent = firstAnswerContent {
                if let secondContent = secondAnswerContent {
                    
                    let firstNewAnswer = Answer()
                    firstNewAnswer.content = firstContent
                    firstNewAnswer.isCorrect = firstAnswerIsCorrect!
                    let secondNewAnswer = Answer()
                    secondNewAnswer.content = secondContent
                    secondNewAnswer.isCorrect = secondAnswerIsCorrect!
                    
                    answersList.append(secondNewAnswer)
                    answersList.append(firstNewAnswer)
                    
                    if let thirdContent = thirdAnswerContent {
                        
                        let thirdNewAnswer = Answer()
                        thirdNewAnswer.content = thirdContent
                        thirdNewAnswer.isCorrect = thirdAnswerIsCorrect!
                        
                        answersList.append(thirdNewAnswer)
                        
                        if let fourthContent = fourthAnswerContent {
                            
                            let fourthNewAnswer = Answer()
                            fourthNewAnswer.content = fourthContent
                            fourthNewAnswer.isCorrect = fourthAnswerIsCorrect!
                            
                            answersList.append(fourthNewAnswer)
                        }
                    }
                }
            }
            
            if answersList.isEmpty {
                // brak zamkniętych pytań
                try! realm.write {
                    editedQuestion.isOpen = true
                    editedQuestion.answers.removeAll()
                }
            } else {
                try! realm.write {
                    editedQuestion.isOpen = false
                    editedQuestion.answers.removeAll()
                }
                for question in answersList {
                    try! realm.write {
                        editedQuestion.answers.append(question)
                    }
                }
            }
        }
    }

    // pobranie ID ostatniego pytania
    func getLastQuestionID() -> Int {
        return Int(realm.objects(Question.self).endIndex)
    }
    
    // pobranie wszystkich pytań
    func getAllQuestions() -> [Question] {
        return Array(realm.objects(Question.self))
    }

    // pobranie wszystkich pytań o określonym typie testu
    func getAllQuestionsWithTestType(type: String) -> [Question] {
        if type == "all" {
            return Array(realm.objects(Question.self))
        } else if type == "open" {
            return Array(realm.objects(Question.self).filter("isOpen == %@", true))
        } else if type == "close" {
            return Array(realm.objects(Question.self).filter("isOpen == %@", false))
        }
        return []
    }

    // pobranie wszystkich kategorii dla pytań
    func getAllCategories() -> [String] {
        let array = getAllQuestions()
        var categories = [String]()
        for item in array {
            if !categories.contains(item.category) {
                categories.append(item.category)
            }
        }
        return categories
    }

    // pobranie wszystkich kategorii dla pytań wraz z typem testu
    func getAllCategoriesWithTestType(type: String) -> [String] {
        let array = getAllQuestionsWithTestType(type: type)
        var categories = [String]()
        for item in array {
            if !categories.contains(item.category) {
                categories.append(item.category)
            }
        }
        return categories
    }

    // pobranie wszystkich tematów dla pytań
    func getAllSubjects() -> [String] {
        let array = getAllQuestions()
        var subjects = [String]()
        for item in array {
            if !subjects.contains(item.subject) {
                subjects.append(item.subject)
            }
        }
        return subjects
    }
    
    // pobranie wszystkich tematów dla pytań wraz z typem testu
    func getAllSubjectsWithTestType(type: String) -> [String] {
        let array = getAllQuestionsWithTestType(type: type)
        var subjects = [String]()
        for item in array {
            if !subjects.contains(item.subject) {
                subjects.append(item.subject)
            }
        }
        return subjects
    }
    
    // pobranie wszystkich pytań o określonym temacie
    func getQuestionsWithSubject(subject: String) -> [Question] {
        return Array(realm.objects(Question.self).filter("subject == %@", subject))
    }
    
    // pobranie wszystkich pytań o określonym temacie i typie testu
    func getQuestionsWithSubjectAndTestType(subject: String, type: String) -> [Question] {
        let tmpArray = Array(realm.objects(Question.self).filter("subject == %@", subject))
        if type == "all" {
            return tmpArray
        } else if type == "open" {
            var secondTmpArray = Array<Question>()
            for item in tmpArray {
                if item.isOpen {
                    secondTmpArray.append(item)
                }
            }
            return secondTmpArray
        } else if type == "close" {
            var secondTmpArray = Array<Question>()
            for item in tmpArray {
                if !item.isOpen {
                    secondTmpArray.append(item)
                }
            }
            return secondTmpArray
        }
        return []
    }
    
    // pobranie wszystkich pytań o określonej kategorii
    func getQuestionWithCategory(category: String) -> [Question] {
        return Array(realm.objects(Question.self).filter("category == %@", category))
    }
    
    // pobranie wszystkich pytań o określonej kategorii i typie testu
    func getQuestionWithCategoryAndTestType(category: String, type: String) -> [Question] {
        let tmpArray = Array(realm.objects(Question.self).filter("category == %@", category))
        if type == "all" {
            return tmpArray
        } else if type == "open" {
            var secondTmpArray = Array<Question>()
            for item in tmpArray {
                if item.isOpen {
                    secondTmpArray.append(item)
                }
            }
            return secondTmpArray
        } else if type == "close" {
            var secondTmpArray = Array<Question>()
            for item in tmpArray {
                if !item.isOpen {
                    secondTmpArray.append(item)
                }
            }
            return secondTmpArray
        }
        return []
    }

    // pobranie pytania o określonym ID
    func getQuestionWithId(id: Int) -> Question {
        return Array(realm.objects(Question.self).filter("id == %@", id)).first!
    }
    
    // pobranie ilość pytań w bazie o określonym typie testu
    func getAmountOfQuestionsInDatabaseWithTestType(type: String) -> Int {
        return getAllQuestionsWithTestType(type: type).count
    }

    // usunięcie konkretnego pytania
    func deleteQuestion(questionToDelete: Question) {
        let _ = realm.objects(Question.self).filter("id == %@", questionToDelete.id)
        try! realm.write {
            realm.delete(questionToDelete)
        }
    }
    
    // usunięcie wszystkich pytań
    func deleteQuestions() {
        let items = realm.objects(Question.self)
        try! realm.write {
            realm.delete(items)
        }
    }
}
