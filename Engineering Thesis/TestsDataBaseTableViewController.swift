//
//  TestsDataBaseTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 08.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class TestsDataBaseTableViewController: UITableViewController {

    // model
    var testName: String?
    private var listsOfTests = [Array<Test>]()
    private var sections = [String]()
    
    private struct Storyboard {
        static let addNewTestSegue = "Add New Test Segue"
        static let showTestDetailsSegue = "Show Test Details Segue"
        static let openTest = "otwarte"
        static let closeTest = "zamknięte"
        static let mixedTest = "mieszane"
        static let subjectsTest = "z przedmiotu"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let addNewItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        self.navigationItem.rightBarButtonItem = addNewItemButton
        if let item = testName {
            self.title = "Testy " + item
            
            switch item {
            case Storyboard.openTest:
                let tmp = TestDao().getOpenTests()
                if !tmp.isEmpty {
                    listsOfTests.append(tmp)
                }
            case Storyboard.closeTest:
                let tmp = TestDao().getCloseTests()
                if !tmp.isEmpty {
                    listsOfTests.append(tmp)
                }
            case Storyboard.mixedTest:
                let tmp = TestDao().getMixedTests()
                if !tmp.isEmpty {
                    listsOfTests.append(tmp)
                }
            case Storyboard.subjectsTest:
                sections = TestDao().getTestsSubjects()
                for item in sections {
                    listsOfTests.append(TestDao().getTestsWithSubject(subject: item))
                }
            default: break
            }
        }
    }
    
    @objc private func addNewItem() {
        performSegue(withIdentifier: Storyboard.addNewTestSegue, sender: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty {
            return 1
        } else {
            return sections.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listsOfTests.isEmpty {
            return 1
        } else {
            return listsOfTests[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections.isEmpty {
            return ""
        } else {
            return sections[section]
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test Cell", for: indexPath)
        if listsOfTests.isEmpty {
            if let testCell = cell as? TestsDataBaseTableViewCell {
                testCell.isEmpty = true
            }
        } else {
            let test = listsOfTests[indexPath.section][indexPath.row]
            if let testCell = cell as? TestsDataBaseTableViewCell {
                testCell.test = test
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listsOfTests.isEmpty {
            let test = listsOfTests[indexPath.section][indexPath.row]
            performSegue(withIdentifier: Storyboard.showTestDetailsSegue, sender: test)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showTestDetailsSegue {
            if let nvc = segue.destination as? TestDetailsViewController {
                nvc.test = sender as? Test
            }
        }
    }
}

class TestsDataBaseTableViewCell: UITableViewCell {
    
    // model
    var test: Test? {
        didSet {
            updateUI()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel?.text = nil
            cellLabel?.text = "Brak testów w bazie"
            self.accessoryType = .none
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        
        if let test = test {
            cellLabel.text = test.name
        }
    }
}
