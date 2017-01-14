//
//  StudentAnswer.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 13.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class StudentAnswer: Object {
    dynamic var content = ""
    dynamic var isCorrect = false
    let question = LinkingObjects(fromType: StudentQuestion.self, property: "listOfAnswers")
}
