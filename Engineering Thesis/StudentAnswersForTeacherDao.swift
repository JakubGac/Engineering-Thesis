//
//  StudentAnswersForTeacherDao.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 20.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class StudentAnswersForTeacherDao {
    private var realm = try! Realm()
    
    // dodanie nowych odpowiedzi
    func addNewStudentAnswersForTeacher(newObject: StudentAnswersForTeacher) {
        try! realm.write {
            realm.add(newObject)
        }
    }
    
    // zapisz liczbę punktów dla pytania
    func saveNumberOfPointsForQuestion(testName: String, studentName: String, questionContent: String, points: Double) {
        let question = getQuestionWithTestNameStudentNameQuestionContent(testName: testName, studentName: studentName, questionContent: questionContent)
        try! realm.write {
            question.givenPoints = points
        }
    }
    
    // pobranie wszystkich odpowiedzi
    func getAllStudentAnswersForTeacher() -> [StudentAnswersForTeacher] {
        return Array(realm.objects(StudentAnswersForTeacher.self))
    }
    
    // pobranie nazw wszystkich testów
    func getAllStudentAnswersTestNames() -> [String] {
        let array = getAllStudentAnswersForTeacher()
        var names = Array<String>()
        if array.isEmpty {
            return []
        } else {
            for item in array {
                if !names.contains(item.testName) {
                    names.append(item.testName)
                }
            }
            return names
        }
    }
    
    // pobranie ostatniego ID
    func getLastStudentAnswerForTeacherID() -> Int {
        return Int(realm.objects(StudentAnswersForTeacher.self).endIndex)
    }
    
    // pobranie wszystkich odpowiedzi o nazwie testu
    func getAllStudentAnswersWithGivenTestName(name: String) -> [StudentAnswersForTeacher] {
        return Array(realm.objects(StudentAnswersForTeacher.self).filter("testName == %@", name))
    }
    
    // pobranie odpowiedzi dla nazwy testu, nazwy studenta i treści pytania
    func getQuestionWithTestNameStudentNameQuestionContent(testName: String, studentName: String, questionContent: String) -> OpenQuestion {
        let array = realm.objects(StudentAnswersForTeacher.self).filter("testName == %@", testName)
        for item in array {
            if item.studentName == studentName {
                for tmp in item.listOfOpenQuestionsAnswers {
                    if tmp.questionContent == questionContent {
                        return tmp
                    }
                }
            }
        }
        return OpenQuestion()
    }
    
    // usuń odpowiedz o wybranym ID
    func deleteStudentAnswersForTeacherWithID(id: Int) {
        let item = realm.objects(StudentAnswersForTeacher.self).filter("id == %@", id)
        try! realm.write {
            realm.delete(item)
        }
    }
    
    // usuń odpowiedz o wybranej nazwie
    func deleteStudentAnswersForTeacherWithGivenName(name: String) {
        let item = realm.objects(StudentAnswersForTeacher.self).filter("testName == %@", name)
        try! realm.write {
            realm.delete(item)
        }
    }
    
    
    // usunięcie wszystkich odpowiedzi
    func deleteAllStudentAnswersForTeacher() {
        let items = realm.objects(StudentAnswersForTeacher.self)
        try! realm.write {
            realm.delete(items)
        }
    }
}
