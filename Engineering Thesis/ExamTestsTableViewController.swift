//
//  ExamTestsTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 11.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class ExamTestsTableViewController: UITableViewController {

    // model
    var testName: String?
    
    private var listsOfTests = [Array<Test>]()
    private var sections = [String]()
    private var listOfPickedTestID = Array<Int>() {
        didSet {
            self.title = String(listOfPickedTestID.count) + " z 1"
        }
    }
    private struct Storyboard {
        static let openTest = "otwarte"
        static let closeTest = "zamknięte"
        static let mixedTest = "mieszane"
        static let subjectsTest = "z przedmiotu"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        listOfPickedTestID = TmpPickedTestDao().getPickedTestID()
        
        if let item = testName {
            // self.title do zmiany
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
    
    override func viewWillDisappear(_ animated: Bool) {
        TmpPickedTestDao().addTestIDToDatabase(list: listOfPickedTestID)
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
            if let testCell = cell as? ExamTestsTableViewCell {
                testCell.isEmpty = true
            }
        } else {
            let test = listsOfTests[indexPath.section][indexPath.row]
            if let testCell = cell as? ExamTestsTableViewCell {
                testCell.test = test
                if listOfPickedTestID.contains(test.id) {
                    testCell.picked = true
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listsOfTests.isEmpty {
            let cell = tableView.cellForRow(at: indexPath)
            let test = listsOfTests[indexPath.section][indexPath.row]
            if let pickedCell = cell as? ExamTestsTableViewCell {
                if listOfPickedTestID.count < 1 {
                    pickedCell.picked = true
                    listOfPickedTestID.append(test.id)
                } else if listOfPickedTestID.count == 1 {
                    if pickedCell.picked {
                        pickedCell.picked = false
                        if listOfPickedTestID.contains(test.id) {
                            listOfPickedTestID.remove(at: listOfPickedTestID.index(of: test.id)!)
                        }
                    } else {
                        printErrorAlert(alertMessage: "Nie możesz wybrać więcej niż jednego testu!")
                    }
                }
            }
        }
    }
}

class ExamTestsTableViewCell: UITableViewCell {
    
    // model
    var test: Test? {
        didSet {
            updateUI()
        }
    }
    
    var picked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    var isEmpty: Bool? {
        didSet {
            cellLabel?.text = nil
            cellImage?.alpha = 0
            cellLabel?.text = "Brak pytań w bazie"
        }
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    private func updateUI() {
        // reset any existing informations
        cellLabel?.text = nil
        cellImage?.alpha = 0
        
        if let test = self.test {
            cellLabel.text = test.name
        }
    }
    
    private func updateImage() {
        if cellImage != nil {
            let image = UIImage(named: "ok.png")
            cellImage.image = image
            if picked {
                cellImage.alpha = 1
            } else {
                cellImage.alpha = 0
            }
        }
    }
}
