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
    
    func importData(from url: URL) {
        if let dictionary = NSDictionary(contentsOf: url) as? [String : String] {
            let newTest = StudentTest()
            // sczytujemy dane testu
            // nazwa
            newTest.name = dictionary[String(10)]!
            // czas trwania
            newTest.duration = Int(dictionary[String(20)]!)!
            // ilość pytań
            newTest.totalNumberOfQuestions = Int(dictionary[String(30)]!)!
            newTest.listOfQuestions = List<StudentQuestion>()
            
            var questionindex = 0
            for _ in 0...newTest.totalNumberOfQuestions - 1 {
                questionindex += 100
                // treść pytania
                let newQuestion = StudentQuestion()
                newQuestion.id = questionindex / 100
                newQuestion.content = dictionary[String(questionindex + 10)]!
                let tmp = dictionary[String(questionindex + 15)]!
                if tmp == "true" {
                    newQuestion.isOpen = true
                } else {
                    newQuestion.isOpen = false
                }
                newQuestion.points = Double(dictionary[String(questionindex + 18)]!)!
                newQuestion.listOfAnswers = List<StudentAnswer>()
                
                if !newQuestion.isOpen {
                    // pierwsza odpowiedź
                    if let answer = dictionary[String(questionindex + 20)] {
                        let newAnswer = StudentAnswer()
                        newAnswer.content = answer
                        let isCorrect = dictionary[String(questionindex + 25)]!
                        if isCorrect == "true" {
                            newAnswer.isCorrect = true
                        } else {
                            newAnswer.isCorrect = false
                        }
                        newQuestion.listOfAnswers.append(newAnswer)
                    }
                    // druga odpowiedź
                    if let answer = dictionary[String(questionindex + 30)] {
                        let newAnswer = StudentAnswer()
                        newAnswer.content = answer
                        let isCorrect = dictionary[String(questionindex + 35)]!
                        if isCorrect == "true" {
                            newAnswer.isCorrect = true
                        } else {
                            newAnswer.isCorrect = false
                        }
                        newQuestion.listOfAnswers.append(newAnswer)
                    }
                    // trzecia odpowiedź
                    if let answer = dictionary[String(questionindex + 40)] {
                        let newAnswer = StudentAnswer()
                        newAnswer.content = answer
                        let isCorrect = dictionary[String(questionindex + 45)]!
                        if isCorrect == "true" {
                            newAnswer.isCorrect = true
                        } else {
                            newAnswer.isCorrect = false
                        }
                        newQuestion.listOfAnswers.append(newAnswer)
                    }
                    // czwarte odpowiedź
                    if let answer = dictionary[String(questionindex + 50)] {
                        let newAnswer = StudentAnswer()
                        newAnswer.content = answer
                        let isCorrect = dictionary[String(questionindex + 55)]!
                        if isCorrect == "true" {
                            newAnswer.isCorrect = true
                        } else {
                            newAnswer.isCorrect = false
                        }
                        newQuestion.listOfAnswers.append(newAnswer)
                    }
                }
                newTest.listOfQuestions.append(newQuestion)
            }
            StudentTestDao().addStudentTestToDatabase(newTest: newTest)
        }

        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("Niepowodzenie usuwania pliku. Error: \(error)")
        }
    }
    
    func importAnswers(from url: URL) {
        if let dictionary = NSDictionary(contentsOf: url) as? [String : String] {
            let newObject = StudentAnswersForTeacher()
            // wpisujemy id
            newObject.id = StudentAnswersForTeacherDao().getLastStudentAnswerForTeacherID() + 1
            // wpisujemy imię i nazwisko studenta
            newObject.studentName = dictionary[String(10)]!
            // nazwę testu
            newObject.testName = dictionary[String(20)]!
            
            // sprawdzamy czy są odpowowiedzi do testu
            if let item = dictionary[String(30)] {
                // brak odpowiedzi do testu
                if item == "Brak odpowiedzi" {
                    StudentAnswersForTeacherDao().addNewStudentAnswersForTeacher(newObject: newObject)
                }
            } else {
                // zczytujemy ilość zdobytych punktów
                newObject.score = Double(dictionary[String(60)]!)!
                // zczytujemy maksymalną ilość punktów
                newObject.maxScore = Double(dictionary[String(70)]!)!
                
                var questionIndex = 100
                if let item = dictionary[String(questionIndex + 10)] {
                    var openQuestionsAnswersList = Array<OpenQuestion>()
                    let newOpenQuestion = OpenQuestion()
                    newOpenQuestion.quetsionId = Int(item)!
                    newOpenQuestion.questionContent = dictionary[String(questionIndex + 12)]!
                    newOpenQuestion.maxPoints = Double(dictionary[String(questionIndex + 13)]!)!
                    if dictionary[String(questionIndex + 15)] != nil {
                        // brak odpowiedzi na otwarte pytanie
                        newOpenQuestion.questionAnswer = "Student nie udzielił odpowiedzi"
                    } else {
                        newOpenQuestion.questionAnswer = dictionary[String(questionIndex + 20)]!
                    }
                    openQuestionsAnswersList.append(newOpenQuestion)
                    questionIndex += 100
                    
                    // zczytujemy pozostałe odpowiedzi
                    while dictionary[String(questionIndex + 10)] != nil {
                        let newOpenQuestion = OpenQuestion()
                        newOpenQuestion.quetsionId = Int(dictionary[String(questionIndex + 10)]!)!
                        newOpenQuestion.questionContent = dictionary[String(questionIndex + 12)]!
                        newOpenQuestion.maxPoints = Double(dictionary[String(questionIndex + 13)]!)!
                        if dictionary[String(questionIndex + 15)] != nil {
                            // brak odpowiedzi na otwarte pytanie
                            newOpenQuestion.questionAnswer = "Student nie udzielił odpowiedzi"
                        } else {
                            newOpenQuestion.questionAnswer = dictionary[String(questionIndex + 20)]!
                        }
                        openQuestionsAnswersList.append(newOpenQuestion)
                        questionIndex += 100
                    }
                    
                    newObject.listOfOpenQuestionsAnswers = List(openQuestionsAnswersList)
                    StudentAnswersForTeacherDao().addNewStudentAnswersForTeacher(newObject: newObject)
                } else {
                    // brak odpowiedzi na pytania otwarte
                    // lub po prostu brak pytań otwartych :)
                    StudentAnswersForTeacherDao().addNewStudentAnswersForTeacher(newObject: newObject)
                }
            }
        }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("Niepowodzenie usuwania pliku. Error: \(error)")
        }
    }
    
    func addData() {
        if QuestionDao().getAllQuestions().isEmpty {
            TestDao().deleteTests()
            
            // 1
            QuestionDao().addNewQuestionToDatabase(category: "Wiedza ogólna", subject: "Język Swift", numberOfPoints: 3, contentOfQuestion: "Co to są krotki?", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 2
            QuestionDao().addNewQuestionToDatabase(category: "Wiedza ogólna", subject: "Język Swift", numberOfPoints: 5, contentOfQuestion: "Opisz do czego służy stuktura 'if let'.", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 3
            QuestionDao().addNewQuestionToDatabase(category: "Wiedza szczgółowa", subject: "Język Swift", numberOfPoints: 6, contentOfQuestion: "Wymień znane narzędzia wchodzące w skład pakietu 'Instruments'.", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 4
            QuestionDao().addNewQuestionToDatabase(category: "Wiedza szczgółowa", subject: "Język Swift", numberOfPoints: 1.5, contentOfQuestion: "Napisz czym jest zmienna 'Optional'.", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 5
            QuestionDao().addNewQuestionToDatabase(category: "Wiedza ogólna", subject: "Język Swift", numberOfPoints: 4.5, contentOfQuestion: "Która wersja języka Swift jest aktualnie najnowszą?", firstAnswerContent: "2.0", secondAnswerContent: "3.0", thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: true, secondAnswerIsCorrect: false, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 6
            QuestionDao().addNewQuestionToDatabase(category: "Wiedza szczgółowa", subject: "Język Swift", numberOfPoints: 5.2, contentOfQuestion: "Co to jest interpolacja zmiennych tekstowych?", firstAnswerContent: "mechanizm pozwlający tworzyć zmienne tekstowy ze zmiennych innego typu", secondAnswerContent: "narzędzie używane przy tworzeniu Delegate", thirdAnswerContent: "pozwala w zmiennej String zapisywać zmienne Int", fourthAnswerContent: nil, firstAnswerIsCorrect: true, secondAnswerIsCorrect: true, thirdAnswerIsCorrect: false, fourthAnswerIsCorrect: nil)
            // 7
            QuestionDao().addNewQuestionToDatabase(category: "Wiedza szczgółowa", subject: "Język Swift", numberOfPoints: 10, contentOfQuestion: "Do czego służą rozszerzenia (ang. Extensions) ?", firstAnswerContent: "Nie ma takiego narzędzia w języku Swift", secondAnswerContent: "Rozszerzenie funkcjonalności klas, struktur, protokołów", thirdAnswerContent: "dodawanie nowych metod do systemowych klas", fourthAnswerContent: "pozwalają zwracać więcej niż jedną wartość dla pojedynczej zmiennej", firstAnswerIsCorrect: true, secondAnswerIsCorrect: false, thirdAnswerIsCorrect: false, fourthAnswerIsCorrect: false)
            
            TestDao().addNewTestToDatabase(type: "open", name: "Test z języka Swift, pytania otwarte", duration: 60, totalAmountOfQuestions: 4, amountOfQuestionsPerStudent: 2, listOfQuestionsID: [1,2,3,4])
            TestDao().addNewTestToDatabase(type: "close", name: "Test z języka Swift, pytania zamknięte", duration: 60, totalAmountOfQuestions: 3, amountOfQuestionsPerStudent: 3, listOfQuestionsID: [5,6,7])
            TestDao().addNewTestToDatabase(type: "all", name: "Test z języka Swift, pytania mieszane", duration: 60, totalAmountOfQuestions: 8, amountOfQuestionsPerStudent: 8, listOfQuestionsID: [1,2,3,4,5,6,7])
        }
    }
}
