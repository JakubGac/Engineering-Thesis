//
//  TmpPickedQuestionsDao.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class TmpPickedQuestionsDao {
    private var realm = try! Realm()
    
    
    
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
    
    // pobranie ID wszystkich zapisanych pytań do testu
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
    
    // wyczysc dane
    func cleareTmpPickedQuestionsTable() {
        let items = realm.objects(TmpPickedQuestions.self)
        try! realm.write {
            realm.delete(items)
        }
    }
}
