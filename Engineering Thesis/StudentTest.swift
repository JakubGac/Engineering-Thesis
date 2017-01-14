//
//  StudentTest.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 13.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class StudentTest: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var subject = ""
    dynamic var duration = 0
    dynamic var totalNumberOfQuestions = 0
    var listOfQuestions = List<StudentQuestion>()
}
