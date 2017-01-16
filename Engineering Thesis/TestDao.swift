//
//  TestDao.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class TestDao {
    private var realm = try! Realm()
    
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
            list.append(QuestionDao().getQuestionWithId(id: item))
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
        TmpPickedQuestionsDao().cleareTmpPickedQuestionsTable()
    }
    
    // pobranie wszystkich testów z danym typem
    //func getAllTestsWithType(type: String) -> [Test] {
      //  return Array(realm.objects(Test.self).filter("type == %@", type))
    //}
    
    // pobranie testu o temacie
    func getTestsWithSubject(subject: String) -> [Test] {
        return Array(realm.objects(Test.self).filter("subject == %@", subject))
    }
    
    // pobranie testu o ID
    func getTestWithID(id: Int) -> Test {
        return Array(realm.objects(Test.self).filter("id == %@", id)).first!
    }
    
    // pobranie tematów dla zapisanych testów
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
    
    // pobranie wszystkich otwartych testów
    func getOpenTests() -> [Test] {
        return Array(realm.objects(Test.self).filter("type == %@", "open"))
    }
    
    // pobranie wszystkich zamkniętych testów
    func getCloseTests() -> [Test] {
        return Array(realm.objects(Test.self).filter("type == %@", "close"))
    }
    
    // pobierz wszystkie mieszane testy
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
    
    // pobranie ID ostatniego testu
    func getLastTestID() -> Int {
        return Int(realm.objects(Test.self).count.toIntMax())
    }
    
    // pobranie wszystkich testów
    func getAllTests() -> [Test] {
        return Array(realm.objects(Test.self))
    }
    
    // pobranie pytań z testu o określonym ID
    func getQuestionsWithTestID(id: Int) -> [Question] {
        if let tmp = Array(realm.objects(Test.self).filter("id == %@", id)).first {
            return Array(tmp.questions)
        }
        return []
    }
    
    // usuń wszystkei testy
    func deleteTests() {
        let items = realm.objects(Test.self)
        try! realm.write {
            realm.delete(items)
        }
    }
}
