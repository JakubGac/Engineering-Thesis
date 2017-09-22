//
//  StudentAnswersForTeacher.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 20.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class StudentAnswersForTeacher: Object {
    @objc dynamic var id = 0
    @objc dynamic var studentName = ""
    @objc dynamic var testName = ""
    @objc dynamic var score = 0.0
    @objc dynamic var maxScore = 0.0
    var listOfOpenQuestionsAnswers = List<OpenQuestion>()
}

class OpenQuestion: Object {
    @objc dynamic var quetsionId = 0
    @objc dynamic var questionContent = ""
    @objc dynamic var questionAnswer = ""
    @objc dynamic var maxPoints = 0.0
    @objc dynamic var givenPoints = -1.0
}
