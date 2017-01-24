//
//  AnswersForSpecifiedTestTableViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 21.01.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import UIKit

class AnswersForSpecifiedTestTableViewController: UITableViewController {

    // model
    var testName: String?
    private var testAnswers = Array<StudentAnswersForTeacher>()
    private var sections = [String]()
    private var rows = [Array<String>]()
    private var studentScore = 0.0
    private var maxTestScore = 0.0
    private var contentsOfQuestionsThatAreNotChecked = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    private func getData() {
        // zerujemy zmienne pomocnicze
        contentsOfQuestionsThatAreNotChecked.removeAll()
        studentScore = 0.0
        maxTestScore = 0.0
        
        if let name = testName {
            testAnswers = StudentAnswersForTeacherDao().getAllStudentAnswersWithGivenTestName(name: name)
        }
        
        // reset all data
        sections.removeAll()
        rows.removeAll()
        
        if !testAnswers.isEmpty {
            // przypisujemy nazwy sekcji czyli imię i nazwiska studenta
            for item in testAnswers {
                sections.append(item.studentName)
            }
            
            // przypisujemy każdemu studentowi punkty za odpowiedzi zamknięte oraz otwarte
            for i in 0...sections.count - 1 {
                for item in testAnswers {
                    if item.studentName == sections[i] {
                        var tmpArray = Array<String>()
                        
                        tmpArray.append("Student uzyskał \(item.score) z \(item.maxScore) punktów za pytania zamknięte.")
                        studentScore += item.score
                        maxTestScore += item.maxScore
                        
                        if item.listOfOpenQuestionsAnswers.isEmpty {
                            tmpArray.append("Brak odpowiedzi do pytań otwartych")
                        } else {
                            for tmp in item.listOfOpenQuestionsAnswers {
                                maxTestScore += tmp.maxPoints
                                if tmp.questionAnswer.contains("Student nie udzielił odpowiedzi") {
                                    tmpArray.append("\(tmp.questionContent) - \(tmp.questionAnswer)")
                                } else {
                                    tmpArray.append("\(tmp.questionContent)")
                                    // dodajemy liczbę punktów za pytanie do ogólnego wyniku
                                    if tmp.givenPoints < 0 {
                                        contentsOfQuestionsThatAreNotChecked.append(tmp.questionContent)
                                    } else {
                                        studentScore += tmp.givenPoints
                                    }
                                }
                            }
                        }
                        
                        // ostatni wiersz z maksymalnym wynikiem
                        var tmp = "Student uzyskał: \(studentScore) z \(maxTestScore) możliwych do zdobycia punktów."
                        if !contentsOfQuestionsThatAreNotChecked.isEmpty {
                            tmp.append("\nUwaga!\nStudent nie ma sprawdzonych wszystkich pytań!:\n")
                            for item in contentsOfQuestionsThatAreNotChecked {
                                tmp.append("- \(item)\n")
                            }
                        }
                        tmpArray.append(tmp)
                        
                        rows.append(tmpArray)
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty {
            return 1
        } else {
            return sections.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !sections.isEmpty {
            return sections[section]
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rows.isEmpty {
            return 1
        } else {
            return rows[section].count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Student Cell", for: indexPath)
        let item = rows[indexPath.section][indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = item
        
        if item.contains("Student uzyskał") || item.contains("Student nie udzielił odpowiedzi") || item.contains("Brak odpowiedzi do pytań otwartych") {
            cell.isUserInteractionEnabled = false
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    private struct Storyboard {
        static let showOpenQuestionDetailsSegue = "Show Open Question Details"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellText = rows[indexPath.section][indexPath.row]
        let studentName = sections[indexPath.section]
        // musimy przekazać dalej dane:
        // nazwa testu, nazwa studenta, treść pytania, treść odpowiedzi, max punktów
        for item in testAnswers {
            if item.studentName == studentName {
                // mam odpowiedzi naszego studenta
                // szukamy tego pytania
                for tmp in item.listOfOpenQuestionsAnswers {
                    if tmp.questionContent == cellText {
                        // mamy pytanie
                        let info = (item.testName, item.studentName, tmp.questionContent, tmp.questionAnswer, tmp.maxPoints)
                        performSegue(withIdentifier: Storyboard.showOpenQuestionDetailsSegue, sender: info)
                    }
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showOpenQuestionDetailsSegue {
            if let nvc = segue.destination as? OpenQuestionAnswersViewController {
                nvc.infos = sender as? (String, String, String, String, Double)
            }
        }
    }
}
