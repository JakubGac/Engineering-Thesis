//
//  Answer.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 22.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class Answer: Object {
    dynamic var content = ""
    dynamic var isCorrect = false
    let question = LinkingObjects(fromType: Question.self, property: "answers")
}
