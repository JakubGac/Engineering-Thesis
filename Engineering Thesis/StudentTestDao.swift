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
    
    // ustaw test na "w trakcie wykonywania"
    func setStudentTestLast() {
        if let item = Array(realm.objects(StudentTest.self).filter("id == %@", 0)).first {
            try! realm.write {
                item.doesTestLast = true
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
