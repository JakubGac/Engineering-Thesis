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
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var duration = 0
    @objc dynamic var totalNumberOfQuestions = 0
    var listOfQuestions = List<StudentQuestion>()
    
    @objc dynamic var doesTestLast = false
    @objc dynamic var doesTestDone = false
}

class StudentQuestion: Object {
    @objc dynamic var id = 0
    @objc dynamic var content = ""
    @objc dynamic var isOpen = false
    @objc dynamic var points = 0.0
    var listOfAnswers = List<StudentAnswer>()
}

class StudentAnswer: Object {
    @objc dynamic var content = ""
    @objc dynamic var isCorrect = false
}
