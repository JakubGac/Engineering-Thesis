//
//  StudentTestDao.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class StudentTestDao {
    private var realm = try! Realm()
    
    // dodanie nowego testu
    func addStudentTestToDatabase(newTest: StudentTest) {
        clearStudentTest()
        try! realm.write {
            realm.add(newTest)
        }
    }
    
    // pobranie testu dla studenta
    func getStudentTest() -> [StudentTest] {
        if let tmp = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            return [tmp]
        }
        return []
    }
    
    // pobranie ostatnie ID pytania
    func getLastStudentQuestionID() -> Int {
        return Int(realm.objects(StudentQuestion.self).count.toIntMax())
    }
    
    // sprawdzenie czy w bazie istnieje test dla studenta
    func checkIfStudentTestExist() -> Bool {
        if let _ = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            return true
        }
        return false
    }
    
    // sprawdź czy test jest w trakcie wykonywania
    func checkIfStudentTestLast() -> Bool {
        if let item = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            return item.doesTestLast
        }
        return false
    }
    
    // sprawdź czy dany test został już wykonany
    func checkIfStudentTestIsDone() -> Bool {
        if let item = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            return item.doesTestDone
        }
        return false
    }
    
    // ustaw test na "w trakcie wykonywania"
    func setStudentTestLast() {
        if let item = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            try! realm.write {
                item.doesTestLast = true
            }
        }
    }
    
    // ustaw test na "zakończony"
    func setStudentTestFinish() {
        if let item = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            try! realm.write {
                item.doesTestLast = false
            }
        }
    }
    
    // ustaw test na "wykonany"
    func setStudentTestIsDone() {
        if let item = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            try! realm.write {
                item.doesTestDone = true
            }
        }
    }
    
    // zeruj ustawienie "wykonany" testu
    func setStudentTestIsNotDone() {
        if let item = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            try! realm.write {
                item.doesTestDone = false
            }
        }
    }
    
    // czyszczenie tabeli z testem dla studenta
    func clearStudentTest() {
        let tmpTests = realm.objects(StudentTest.self)
        try! realm.write {
            realm.delete(tmpTests)
        }
    }
}
