//
//  Question.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 22.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class Question: Object {
    dynamic var id = 0
    dynamic var content = ""
    dynamic var subject = ""
    dynamic var category = ""
    dynamic var isOpen = false
    dynamic var numberOfPoints = 0.0
    var answers = List<Answer>()
    let test = LinkingObjects(fromType: Test.self, property: "questions")
}
