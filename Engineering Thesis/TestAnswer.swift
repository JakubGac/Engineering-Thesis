//
//  TestAnswers.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 14.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class TestAnswer: Object {
    dynamic var questionID = 0
    dynamic var answer = "Brak odpowiedzi"
    var closeAnswers = List<StudentCloseAnswer>()
}

class StudentCloseAnswer: Object {
    dynamic var content = ""
    dynamic var isCorrect = false
    let testAnswer = LinkingObjects(fromType: TestAnswer.self, property: "closeAnswers")
}
