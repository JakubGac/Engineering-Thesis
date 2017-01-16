//
//  StudentTest.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 13.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class StudentTest: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var duration = 0
    dynamic var totalNumberOfQuestions = 0
    var listOfQuestions = List<StudentQuestion>()
    
    dynamic var doesTestLast = false
}

class StudentQuestion: Object {
    dynamic var id = 0
    dynamic var content = ""
    dynamic var isOpen = false
    dynamic var points = 0.0
    var listOfAnswers = List<StudentAnswer>()
    let test = LinkingObjects(fromType: StudentTest.self, property: "listOfQuestions")
}

class StudentAnswer: Object {
    dynamic var content = ""
    dynamic var isCorrect = false
    let question = LinkingObjects(fromType: StudentQuestion.self, property: "listOfAnswers")
}
