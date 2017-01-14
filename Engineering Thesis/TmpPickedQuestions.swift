//
//  TmpPickedQuestions.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 07.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class TmpPickedQuestions: Object {
    dynamic var id = 0
    var listOfPickedQuestionsID = List<TmpQuestion>()
}

class TmpQuestion: Object {
    dynamic var id = 0
}
