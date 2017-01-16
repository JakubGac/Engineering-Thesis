//
//  TestAnswerDao.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class TestAnswerDao {
    private var realm = try! Realm()

    // dodanie lub edycja odpowiedzi na otwarte pytanie
    func saveOpenAnswer(questionID: Int, answer: String?) {
        let answersIDsarray = getTestAnswersIDs()
        if answersIDsarray.contains(questionID) {
            // edytujemy istniejące pytanie więc wyciągamy je z bazy
            if let item = getAnswerWithQuestionId(id: questionID).first {
                if answer == nil {
                    // usuwamy odpowiedź
                    try! realm.write {
                        realm.delete(item)
                    }
                }
                
                if let answer = answer {
                    // edytujemy odpowiedź
                    try! realm.write {
                        item.answer = answer
                    }
                }
            }
        } else {
            // dodajemy do bazy nowe pytanie
            let newAnswer = TestAnswer()
            newAnswer.questionID = questionID
            
            if let answer = answer {
                newAnswer.answer = answer
            }
            
            try! realm.write {
                realm.add(newAnswer)
            }
        }
    }
    
    // dodanie lub edycja odpowiedzi na zamknięte pytanie
    func saveCloseAnswer(questionID: Int, closeAnswers: Array<StudentAnswer>) {
        let answersIdsArray = getTestAnswersIDs()
        if answersIdsArray.contains(questionID) {
            // edytujemy istniejące pytanie więc wyciągamy je z bazy
            if let item = getAnswerWithQuestionId(id: questionID).first {
                if closeAnswers.isEmpty {
                    try! realm.write {
                        realm.delete(item)
                    }
                } else {
                    try! realm.write {
                        item.closeAnswers.removeAll()
                    }
                    for tmp in closeAnswers {
                        try! realm.write {
                            item.closeAnswers.append(tmp)
                        }
                    }
                }
            }
        } else {
            // dodajemy nowe pytanie
            let newAnswer = TestAnswer()
            newAnswer.questionID = questionID
            let listOfAnswers = List<StudentAnswer>()
            for item in closeAnswers {
                listOfAnswers.append(item)
            }
            newAnswer.closeAnswers = listOfAnswers
            try! realm.write {
                realm.add(newAnswer)
            }
        }
    }
    
    // pobranie wszystkich odpowiedzi
    func getTestAnswers() -> [TestAnswer] {
        let tmp = Array(realm.objects(TestAnswer.self))
        if tmp.isEmpty {
            return []
        } else {
            return tmp
        }
    }
    
    // pobranie wszystkich ID pytań na które udzielono odpowiedzi
    func getTestAnswersIDs() -> [Int] {
        let tmp = getTestAnswers()
        var array = Array<Int>()
        for item in tmp {
            array.append(item.questionID)
        }
        return array
    }
    
    // pobranie odpowiedzi po ID pytania
    func getAnswerWithQuestionId(id: Int) -> [TestAnswer] {
        if let item = realm.objects(TestAnswer.self).filter("questionID == %@", id).first {
            return [item]
        }
        return []
    }
    
    // czyszczenie wszystkich odpowiedzi studenta
    func clearStudentAnswers() {
        let tmpAnswers = realm.objects(TestAnswer.self)
        try! realm.write {
            realm.delete(tmpAnswers)
        }
    }
}
