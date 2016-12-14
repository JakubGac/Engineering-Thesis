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
    dynamic var content = ""
    dynamic var number = 0
    dynamic var isOpen = false
    dynamic var received = false
    var answers = List<Answer>()
}
