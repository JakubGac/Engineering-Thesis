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
    
    // pytania
    
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
    
    // dodawanie nowego testu
    func addNewTestToDatabase(type: String, name: String, duration: Int, totalAmountOfQuestions: Int, amountOfQuestionsPerStudent: Int, listOfQuestionsID: Array<Int>) {
        let newTest = Test()
        newTest.id = getLastTestID() + 1
        newTest.type = type
        newTest.name = name
        newTest.duration = duration
        newTest.totalNumberOfQuestions = totalAmountOfQuestions
        newTest.numberOfQuestionsForOneStudent = amountOfQuestionsPerStudent
        let list = List<Question>()
        for item in listOfQuestionsID {
            list.append(getQuestionWithId(id: item))
        }
        var tmpCountQuestions = 0
        let tmpSubject = list.first?.subject
        for item in list {
            if item.subject == tmpSubject {
                tmpCountQuestions += 1
            }
        }
        if tmpCountQuestions == list.count {
            newTest.subject = tmpSubject!
        }
        newTest.questions = list
        try! realm.write {
            realm.add(newTest)
        }
        cleareTmpPickedQuestionsTable()
    }
    
    // dodawanie nowych ID pytań wybranych do testu
    func addQuestionsIDToDatabase(list: Array<Int>) {
        if let savedData = realm.objects(TmpPickedQuestions.self).filter("id == %@", 0).first {
            try! realm.write {
                savedData.listOfPickedQuestionsID.removeAll()
            }
            for item in list {
                let newTmpQuestion = TmpQuestion()
                newTmpQuestion.id = item
                try! realm.write {
                    savedData.listOfPickedQuestionsID.append(newTmpQuestion)
                }
            }
        } else {
            let newObject = TmpPickedQuestions()
            newObject.listOfPickedQuestionsID = List<TmpQuestion>()
            for item in list {
                let newTmpQuestion = TmpQuestion()
                newTmpQuestion.id = item
                newObject.listOfPickedQuestionsID.append(newTmpQuestion)
            }
            try! realm.write {
                realm.add(newObject)
            }
        }
    }
    
    func addTestIDToDatabase(list: Array<Int>) {
        if let savedData = realm.objects(TmpPickedTest.self).filter("id == %@", 0).first {
            try! realm.write {
                savedData.listOfPickedTestsID.removeAll()
            }
            for item in list {
                let newTmpTest = TmpTest()
                newTmpTest.id = item
                try! realm.write {
                    savedData.listOfPickedTestsID.append(newTmpTest)
                }
            }
        } else {
            let newObject = TmpPickedTest()
            newObject.listOfPickedTestsID = List<TmpTest>()
            for item in list {
                let newTmpTest = TmpTest()
                newTmpTest.id = item
                newObject.listOfPickedTestsID.append(newTmpTest)
            }
            try! realm.write {
                realm.add(newObject)
            }
        }
    }
    
    func addStudentTestToDatabase(newTest: StudentTest) {
        clearStudentTest()
        try! realm.write {
            realm.add(newTest)
        }
    }
    
    // wydobywanie danych
    func getLastQuestionID() -> Int {
        return Int(realm.objects(Question.self).count.toIntMax())
    }
    
    func getLastTestID() -> Int {
        return Int(realm.objects(Test.self).count.toIntMax())
    }
    
    func getAllQuestions() -> [Question] {
        return Array(realm.objects(Question.self))
    }
    
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
    
    func getQuestionsWithSubject(subject: String) -> [Question] {
        return Array(realm.objects(Question.self).filter("subject == %@", subject))
    }
    
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
    
    func getQuestionWithCategory(category: String) -> [Question] {
        return Array(realm.objects(Question.self).filter("category == %@", category))
    }
    
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
    
    func getQuestionWithId(id: Int) -> Question {
        return Array(realm.objects(Question.self).filter("id == %@", id)).first!
    }
    
    func getAllTests() -> [Test] {
        return Array(realm.objects(Test.self))
    }
    
    func getAllTestsWithType(type: String) -> [Test] {
        return Array(realm.objects(Test.self).filter("type == %@", type))
    }
    
    func getAllPickedQuestionsID() -> [Int] {
        if let tmpPickedQuestions = realm.objects(TmpPickedQuestions.self).filter("id == %@", 0).first {
            var list = Array<Int>()
            for item in tmpPickedQuestions.listOfPickedQuestionsID {
                list.append(item.id)
            }
            return list
        }
        return []
    }
    
    func getPickedTestID() -> [Int] {
        if let tmpPickedTest = realm.objects(TmpPickedTest.self).filter("id == %@", 0).first {
            var list = Array<Int>()
            for item in tmpPickedTest.listOfPickedTestsID {
                list.append(item.id)
            }
            return list
        }
        return []
    }
    
    func getOpenTests() -> [Test] {
        return Array(realm.objects(Test.self).filter("type == %@", "open"))
    }
    
    func getCloseTests() -> [Test] {
        return Array(realm.objects(Test.self).filter("type == %@", "close"))
    }
    
    func getMixedTests() -> [Test] {
        let tmpOpenTests = getOpenTests()
        let tmpCloseTest = getCloseTests()
        var tmpMixedTests = getAllTests()
        for item in tmpOpenTests {
            if tmpMixedTests.contains(item) {
                tmpMixedTests.remove(at: tmpMixedTests.index(of: item)!)
            }
        }
        for item in tmpCloseTest {
            if tmpMixedTests.contains(item) {
                tmpMixedTests.remove(at: tmpMixedTests.index(of: item)!)
            }
        }
        return tmpMixedTests
    }
    
    func getTestsWithSubject(subject: String) -> [Test] {
        return Array(realm.objects(Test.self).filter("subject == %@", subject))
    }
    
    func getTestsSubjects() -> [String] {
        let array = getAllTests()
        var subjects = [String]()
        for item in array {
            if !subjects.contains(item.subject) {
                subjects.append(item.subject)
            }
        }
        if subjects.contains("") {
            subjects.remove(at: subjects.index(of: "")!)
        }
        return subjects
    }
    
    func getTestWithID(id: Int) -> Test {
        return Array(realm.objects(Test.self).filter("id == %@", id)).first!
    }
    
    func getQuestionsWithTestID(id: Int) -> [Question] {
        if let tmp = Array(realm.objects(Test.self).filter("id == %@", id)).first {
            return Array(tmp.questions)
        }
        return []
    }
    
    func getAmountOfQuestionsInDatabaseWithTestType(type: String) -> Int {
        return getAllQuestionsWithTestType(type: type).count
    }
    
    func getStudentTest() -> [StudentTest] {
        if let tmp = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            return [tmp]
        }
        return []
    }
    
    func checkIfStudentTestExist() -> Bool {
        if let _ = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            return true
        }
        return false
    }
    
    func getLastStudentQuestionID() -> Int {
        return Int(realm.objects(StudentQuestion.self).count.toIntMax())
    }
    
    // usuwanie danych
    func deleteQuestion(questionToDelete: Question) {
        let _ = realm.objects(Question.self).filter("id == %@", questionToDelete.id)
        try! realm.write {
            realm.delete(questionToDelete)
        }
    }
    
    func deleteQuestions() {
        let items = realm.objects(Question.self)
        try! realm.write {
            realm.delete(items)
        }
    }
    
    func deleteTests() {
        let items = realm.objects(Test.self)
        try! realm.write {
            realm.delete(items)
        }
    }
    
    func cleareTmpPickedQuestionsTable() {
        let items = realm.objects(TmpPickedQuestions.self)
        try! realm.write {
            realm.delete(items)
        }
    }
    
    func cleareTmpPickedTestTable() {
        let items = realm.objects(TmpPickedTest.self)
        try! realm.write {
            realm.delete(items)
        }
    }
    
    func clearStudentTest() {
        let tmpTests = realm.objects(StudentTest.self)
        try! realm.write {
            realm.delete(tmpTests)
        }
    }
    
    func importData(from url: URL) {
        //deleteStudentQuestions()
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
            addStudentTestToDatabase(newTest: newTest)
        }

        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("Niepowodzenie usuwania pliku. Error: \(error)")
        }
    }
    
    
    
    
    
    
    func addData() {
        if getAllQuestions().isEmpty {
            deleteQuestions()
            deleteTests()
            
            // 1
            addNewQuestionToDatabase(category: "Wiedza ogólna", subject: "Matematyka", numberOfPoints: 3, contentOfQuestion: "Podaj wzór na twierdzenie Pitagorasa", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 2
            addNewQuestionToDatabase(category: "Wiedza szczegółowa", subject: "Matematyka", numberOfPoints: 10, contentOfQuestion: "Podaj coś fajnego", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 3
            addNewQuestionToDatabase(category: "Wiedza ogólna", subject: "Język Polski", numberOfPoints: 5, contentOfQuestion: "Napisz pierwszy wiersz inwokacji", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 4
            addNewQuestionToDatabase(category: "Wiedza ogólna", subject: "WOS", numberOfPoints: 1.5, contentOfQuestion: "Ile trwa kandydatura prezydenta", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 5
            addNewQuestionToDatabase(category: "Wiedza szczegółowa", subject: "Geografia", numberOfPoints: 10, contentOfQuestion: "Ile jest rzek na świecie?", firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 6
            addNewQuestionToDatabase(category: "Brak", subject: "Test", numberOfPoints: 4.5, contentOfQuestion: "Pytanie z dwiema odpowiedziami", firstAnswerContent: "Pierwsza odpowiedź", secondAnswerContent: "Druga odpowiedź", thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: true, secondAnswerIsCorrect: false, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
            // 7
            addNewQuestionToDatabase(category: "Brak", subject: "Test", numberOfPoints: 5.2, contentOfQuestion: "Pytanie z trzema odpowiedziami", firstAnswerContent: "Pierwsza odpowiedź", secondAnswerContent: "Druga odpowiedź", thirdAnswerContent: "Trzecia odpowiedź", fourthAnswerContent: nil, firstAnswerIsCorrect: true, secondAnswerIsCorrect: true, thirdAnswerIsCorrect: false, fourthAnswerIsCorrect: nil)
            // 8
            addNewQuestionToDatabase(category: "Brak", subject: "Test", numberOfPoints: 10, contentOfQuestion: "Pytanie z czterema odpowiedziami", firstAnswerContent: "Pierwsza odpowiedź", secondAnswerContent: "Druga odpowiedź", thirdAnswerContent: "Trzecia odpowiedź", fourthAnswerContent: "Czwarta odpowiedź", firstAnswerIsCorrect: true, secondAnswerIsCorrect: false, thirdAnswerIsCorrect: false, fourthAnswerIsCorrect: false)
            
            addNewTestToDatabase(type: "open", name: "Pierwszy test z pytaniamia otwartymi", duration: 60, totalAmountOfQuestions: 4, amountOfQuestionsPerStudent: 2, listOfQuestionsID: [1,2,3,4,5])
            addNewTestToDatabase(type: "close", name: "Drugi test z pytaniami zamkniętymi", duration: 60, totalAmountOfQuestions: 3, amountOfQuestionsPerStudent: 3, listOfQuestionsID: [6,7,8])
            addNewTestToDatabase(type: "all", name: "Trzeci test z mieszanymi pytaniami", duration: 60, totalAmountOfQuestions: 8, amountOfQuestionsPerStudent: 4, listOfQuestionsID: [1,2,3,4,5,6,7,8])
            addNewTestToDatabase(type: "open", name: "Test z przedmiotu Matematyka", duration: 60, totalAmountOfQuestions: 2, amountOfQuestionsPerStudent: 2, listOfQuestionsID: [1,2])
            addNewTestToDatabase(type: "close", name: "Test z przedmiotu Język Polski", duration: 40, totalAmountOfQuestions: 1, amountOfQuestionsPerStudent: 1, listOfQuestionsID: [3])
        }
    }
}
