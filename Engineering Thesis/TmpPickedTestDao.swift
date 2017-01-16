//
//  TmpPickedTestDao.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class TmpPickedTestDao {
    private var realm = try! Realm()

    // dodaj nową wartość
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

    // pobierz ID zapisanego testu
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
    
    // usuń wszystkie dane
    func cleareTmpPickedTestTable() {
        let items = realm.objects(TmpPickedTest.self)
        try! realm.write {
            realm.delete(items)
        }
    }
}
