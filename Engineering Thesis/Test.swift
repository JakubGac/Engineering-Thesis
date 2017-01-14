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
    dynamic var id = 0
    dynamic var type = ""
    dynamic var name = ""
    dynamic var subject = ""
    dynamic var duration = 0
    dynamic var totalNumberOfQuestions = 0
    dynamic var numberOfQuestionsForOneStudent = 0
    var questions = List<Question>()
}
