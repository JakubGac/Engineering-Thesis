//
//  TestViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 27.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class TestViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Cos tam"
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.tabBarController?.navigationItem.rightBarButtonItem = button
    }
}
