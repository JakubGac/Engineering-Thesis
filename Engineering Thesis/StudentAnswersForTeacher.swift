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
    dynamic var id = 0
    dynamic var studentName = ""
    dynamic var testName = ""
    dynamic var score = 0.0
    dynamic var maxScore = 0.0
    var listOfOpenQuestionsAnswers = List<OpenQuestion>()
}

class OpenQuestion: Object {
    dynamic var quetsionId = 0
    dynamic var questionContent = ""
    dynamic var questionAnswer = ""
    dynamic var maxPoints = 0.0
    dynamic var givenPoints = -1.0
}
