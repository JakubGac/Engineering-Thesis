//
//  TmpPickedTest.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 13.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation
import RealmSwift

class TmpPickedTest: Object {
    dynamic var id = 0
    var listOfPickedTestsID = List<TmpTest>()
}

class TmpTest: Object {
    dynamic var id = 0
}
