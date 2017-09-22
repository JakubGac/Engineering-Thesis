//
//  Test.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 06.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class Test: Object {
    @objc dynamic var id = 0
    @objc dynamic var type = ""
    @objc dynamic var name = ""
    @objc dynamic var subject = ""
    @objc dynamic var duration = 0
    @objc dynamic var totalNumberOfQuestions = 0
    @objc dynamic var numberOfQuestionsForOneStudent = 0
    var questions = List<Question>()
}
