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
    @objc dynamic var id = 0
    @objc dynamic var content = ""
    @objc dynamic var subject = ""
    @objc dynamic var category = ""
    @objc dynamic var isOpen = false
    @objc dynamic var numberOfPoints = 0.0
    var answers = List<Answer>()
}

class Answer: Object {
    @objc dynamic var content = ""
    @objc dynamic var isCorrect = false
}
