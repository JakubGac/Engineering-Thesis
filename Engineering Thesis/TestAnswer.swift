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
    @objc dynamic var questionID = 0
    @objc dynamic var answer = "Brak odpowiedzi"
    var closeAnswers = List<StudentCloseAnswer>()
}

class StudentCloseAnswer: Object {
    @objc dynamic var content = ""
    @objc dynamic var isCorrect = false
}
