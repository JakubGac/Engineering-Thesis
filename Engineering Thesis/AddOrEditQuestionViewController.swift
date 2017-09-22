//
//  AddQuestionViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit

class AddOrEditQuestionViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    // model
    var question: Question?

    private var screenSize = UIScreen.main.bounds
    private var categoryTextField: UITextField?
    private var subjectTextField: UITextField?
    private var pointsTextField: UITextField?
    private var questionContentTextField: UITextField?
    private var addAnswerButton: UIButton?
    private var removeAnswerButton: UIButton?
    private var firstAnswerTextField: UITextField?
    private var secondAnswerTextField: UITextField?
    private var thirdAnswerTextField: UITextField?
    private var fourthAnswerTextField: UITextField?
    private var firstAnswerSwitch: UISwitch?
    private var secondAnswerSwitch: UISwitch?
    private var thirdAnswerSwitch: UISwitch?
    private var fourthAnswerSwitch: UISwitch?
    private var tableViewForCategory: UITableView?
    private var tableViewForSubject: UITableView?
    
    private var tfv = TextFieldValidator()
    private var categoryPromps: [String]?
    private var subjectPromps: [String]?
    private var autoCompleteForCategory = [String]()
    private var autoCompleteForSubject = [String]()
    
    private let x = UIScreen.main.bounds.width / 20
    private let y = UIScreen.main.bounds.height / 40
    private let textFieldSizeWidth = CGFloat(UIScreen.main.bounds.width / 1.7)
    private let textFieldSizeHeight = CGFloat(30)
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView?.contentSize = CGSize(width: screenSize.width, height: screenSize.height / 1.1)
        }
    }
    
    @IBAction func addQuestionButtonPressed(_ sender: UIBarButtonItem) {
        if checkQuestion() {
            if let category = categoryTextField?.text {
                if let subject = subjectTextField?.text {
                    if let number = pointsTextField?.text {
                        if let questionContent = questionContentTextField?.text {
                            if let firstAnswer = firstAnswerTextField?.text {
                                if let secondAnswer = secondAnswerTextField?.text {
                                    // pytanie zamknięte
                                    if checkFirstTwoAnswers() {
                                        if checkThirdAnswer() {
                                            if let thirdAnswer = thirdAnswerTextField?.text {
                                                if let fourthAnswer = fourthAnswerTextField?.text {
                                                    if checkFourthAnswer() {
                                                        // close question, four answers
                                                        if question == nil {
                                                            QuestionDao().addNewQuestionToDatabase(category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: firstAnswer, secondAnswerContent: secondAnswer, thirdAnswerContent: thirdAnswer, fourthAnswerContent: fourthAnswer, firstAnswerIsCorrect: firstAnswerSwitch?.isOn, secondAnswerIsCorrect: secondAnswerSwitch?.isOn, thirdAnswerIsCorrect: thirdAnswerSwitch?.isOn, fourthAnswerIsCorrect: fourthAnswerSwitch?.isOn)
                                                        } else {
                                                            QuestionDao().editQuestion(question: question!, category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: firstAnswer, secondAnswerContent: secondAnswer, thirdAnswerContent: thirdAnswer, fourthAnswerContent: fourthAnswer, firstAnswerIsCorrect: firstAnswerSwitch?.isOn, secondAnswerIsCorrect: secondAnswerSwitch?.isOn, thirdAnswerIsCorrect: thirdAnswerSwitch?.isOn, fourthAnswerIsCorrect: fourthAnswerSwitch?.isOn)
                                                        }
                                                        printSafeAllert()
                                                    }
                                                } else {
                                                    // pytanie zamknięte, 3 odpowiedzi
                                                    if question == nil {
                                                        QuestionDao().addNewQuestionToDatabase(category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: firstAnswer, secondAnswerContent: secondAnswer, thirdAnswerContent: thirdAnswer, fourthAnswerContent: nil, firstAnswerIsCorrect: firstAnswerSwitch?.isOn, secondAnswerIsCorrect: secondAnswerSwitch?.isOn, thirdAnswerIsCorrect: thirdAnswerSwitch?.isOn, fourthAnswerIsCorrect: nil)
                                                    } else {
                                                        QuestionDao().editQuestion(question: question!, category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: firstAnswer, secondAnswerContent: secondAnswer, thirdAnswerContent: thirdAnswer, fourthAnswerContent: nil, firstAnswerIsCorrect: firstAnswerSwitch?.isOn, secondAnswerIsCorrect: secondAnswerSwitch?.isOn, thirdAnswerIsCorrect: thirdAnswerSwitch?.isOn, fourthAnswerIsCorrect: nil)
                                                    }
                                                    printSafeAllert()
                                                }
                                            }
                                        }  else {
                                            // pytanie zamknięte, 2 odpowiedzi
                                            if question == nil {
                                                QuestionDao().addNewQuestionToDatabase(category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: firstAnswer, secondAnswerContent: secondAnswer, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect:  firstAnswerSwitch?.isOn, secondAnswerIsCorrect: secondAnswerSwitch?.isOn, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
                                            } else {
                                                QuestionDao().editQuestion(question: question!, category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: firstAnswer, secondAnswerContent: secondAnswer, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: firstAnswerSwitch?.isOn, secondAnswerIsCorrect: secondAnswerSwitch?.isOn, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
                                            }
                                            printSafeAllert()
                                        }
                                    }
                                }
                            } else {
                                // pytanie otwarte
                                if question == nil {
                                    QuestionDao().addNewQuestionToDatabase(category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
                                } else {
                                    QuestionDao().editQuestion(question: question!, category: category, subject: subject, numberOfPoints: Double(number)!, contentOfQuestion: questionContent, firstAnswerContent: nil, secondAnswerContent: nil, thirdAnswerContent: nil, fourthAnswerContent: nil, firstAnswerIsCorrect: nil, secondAnswerIsCorrect: nil, thirdAnswerIsCorrect: nil, fourthAnswerIsCorrect: nil)
                                }
                                printSafeAllert()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func checkQuestion() -> Bool {
        if tfv.checkIfFieldIsFilled(view: categoryTextField!) && tfv.checkIfFieldContainsAlphabets(view: categoryTextField!) {
            if tfv.checkIfFieldIsFilled(view: subjectTextField!) && tfv.checkIfFieldContainsAlphabets(view: subjectTextField!) {
                if tfv.checkIfFieldIsFilled(view: pointsTextField!) && tfv.checkIfFieldContainsNumbers(view: pointsTextField!) {
                    if tfv.checkIfFieldIsFilled(view: questionContentTextField!) && tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: questionContentTextField!) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func checkFirstTwoAnswers() -> Bool {
        if let firstAnswer = firstAnswerTextField {
            if let secondAnswer = secondAnswerTextField {
                if tfv.checkIfFieldIsFilled(view: firstAnswer) && tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: firstAnswer) {
                    if tfv.checkIfFieldIsFilled(view: secondAnswer) && tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: secondAnswer) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func checkThirdAnswer() -> Bool {
        if let thirdAnswer = thirdAnswerTextField {
            if tfv.checkIfFieldIsFilled(view: thirdAnswer) && tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: thirdAnswer) {
                return true
            }
        }
        return false
    }
    
    private func checkFourthAnswer() -> Bool {
        if let fourthAnswer = fourthAnswerTextField {
            if tfv.checkIfFieldIsFilled(view: fourthAnswer) && tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: fourthAnswer) {
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        categoryTextField?.delegate = self
        subjectTextField?.delegate = self
        pointsTextField?.delegate = self
        questionContentTextField?.delegate = self
        
        if question == nil {
            // adding new question
            self.title = "Nowe pytanie"
        } else {
            // editing question
            self.title = "Edycja pytania"
            displayContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryPromps = QuestionDao().getAllCategories()
        subjectPromps = QuestionDao().getAllSubjects()
    }
    
    private func displayContent() {
        // kategoria, przedmiot, punkty, treść pytania
        if let questionToDisplay = question {
            categoryTextField?.text = questionToDisplay.category
            subjectTextField?.text = questionToDisplay.subject
            pointsTextField?.text = String(questionToDisplay.numberOfPoints)
            questionContentTextField?.text = questionToDisplay.content
            if !(questionToDisplay.answers.isEmpty) {
                addFirstAndSecondQuestionElements(x: x, y: y)
                firstAnswerTextField?.text = questionToDisplay.answers[0].content
                firstAnswerSwitch?.isOn = questionToDisplay.answers[0].isCorrect
                secondAnswerTextField?.text = questionToDisplay.answers[1].content
                secondAnswerSwitch?.isOn = questionToDisplay.answers[1].isCorrect
                if questionToDisplay.answers.count > 2 {
                    addThirdQuestionElements(x: x, y: y)
                    thirdAnswerTextField?.text = questionToDisplay.answers[2].content
                    thirdAnswerSwitch?.isOn = questionToDisplay.answers[2].isCorrect
                    if questionToDisplay.answers.count > 3 {
                        addFourthQuestionElements(x: x, y: y)
                        fourthAnswerTextField?.text = questionToDisplay.answers[3].content
                        fourthAnswerSwitch?.isOn = questionToDisplay.answers[3].isCorrect
                    }
                }
            }
        }
    }
    
    private func createView() {
        categoryTextField = UITextField(frame: CGRect(x: x, y: y, width: textFieldSizeWidth, height: textFieldSizeHeight))
        categoryTextField?.borderStyle = UITextBorderStyle.roundedRect
        categoryTextField?.keyboardType = .asciiCapable
        categoryTextField?.placeholder = "Kategoria"
        categoryTextField?.backgroundColor = UIColor.clear
        categoryTextField?.textColor = UIColor.black
        categoryTextField?.tintColor = UIColor.black
        categoryTextField?.returnKeyType = UIReturnKeyType.done
        
        subjectTextField = UITextField(frame: CGRect(x: x, y: y * 4, width: textFieldSizeWidth, height: textFieldSizeHeight))
        subjectTextField?.borderStyle = UITextBorderStyle.roundedRect
        subjectTextField?.keyboardType = .asciiCapable
        subjectTextField?.placeholder = "Przedmiot"
        subjectTextField?.backgroundColor = UIColor.clear
        subjectTextField?.textColor = UIColor.black
        subjectTextField?.tintColor = UIColor.black
        
        pointsTextField = UITextField(frame: CGRect(x: x, y: y * 7, width: textFieldSizeWidth, height: textFieldSizeHeight))
        pointsTextField?.borderStyle = UITextBorderStyle.roundedRect
        pointsTextField?.keyboardType = .decimalPad
        pointsTextField?.placeholder = "Punkty"
        pointsTextField?.backgroundColor = UIColor.clear
        pointsTextField?.textColor = UIColor.black
        pointsTextField?.tintColor = UIColor.black
        
        questionContentTextField = UITextField(frame: CGRect(x: x, y: y * 11, width: screenSize.width / 1.12, height: textFieldSizeHeight * 2))
        questionContentTextField?.borderStyle = UITextBorderStyle.roundedRect
        questionContentTextField?.keyboardType = .asciiCapable
        questionContentTextField?.placeholder = "Treść pytania"
        questionContentTextField?.backgroundColor = UIColor.clear
        questionContentTextField?.textColor = UIColor.black
        questionContentTextField?.tintColor = UIColor.black
        
        showAddAnswerButton(x: x, y: y * 16)
        
        scrollView.addSubview(categoryTextField!)
        scrollView.addSubview(subjectTextField!)
        scrollView.addSubview(pointsTextField!)
        scrollView.addSubview(questionContentTextField!)
        
        tableViewForCategory = UITableView(frame: CGRect(x: x, y: y + textFieldSizeHeight, width: textFieldSizeWidth, height: textFieldSizeHeight))
        tableViewForCategory?.delegate = self
        tableViewForCategory?.dataSource = self
        tableViewForCategory?.register(UITableViewCell.self, forCellReuseIdentifier: "cellForCategory")
        tableViewForCategory?.rowHeight = CGFloat(textFieldSizeHeight)
        rescaleTableView(tableView: tableViewForCategory!, number: 0)
        tableViewForCategory?.backgroundColor = UIColor.white
        
        tableViewForSubject = UITableView(frame: CGRect(x: x, y: y * 4 + textFieldSizeHeight, width: textFieldSizeWidth, height: textFieldSizeHeight))
        tableViewForSubject?.delegate = self
        tableViewForSubject?.dataSource = self
        tableViewForSubject?.register(UITableViewCell.self, forCellReuseIdentifier: "cellForCategory")
        tableViewForSubject?.rowHeight = CGFloat(textFieldSizeHeight)
        rescaleTableView(tableView: tableViewForSubject!, number: 0)
        tableViewForSubject?.backgroundColor = UIColor.white
        
        scrollView.addSubview(tableViewForCategory!)
        scrollView.addSubview(tableViewForSubject!)
    }
    
    private func showAddAnswerButton(x: CGFloat, y: CGFloat) {
        if addAnswerButton != nil {
            addAnswerButton?.removeFromSuperview()
        }
        addAnswerButton = UIButton(frame: CGRect(x: x, y: y, width: screenSize.width / 1.12, height: CGFloat(30)))
        addAnswerButton?.setTitle("➕   Dodaj odpowiedź", for: UIControlState.normal)
        addAnswerButton?.setTitleColor(UIColor.black, for: UIControlState.normal)
        addAnswerButton?.backgroundColor = UIColor.clear
        addAnswerButton?.contentHorizontalAlignment = .left
        addAnswerButton?.addTarget(self, action: #selector(addAnswerButtonAction), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(addAnswerButton!)
    }
    
    private func showRemoveAnswerButton(x: CGFloat, y: CGFloat) {
        if removeAnswerButton != nil {
            removeAnswerButton?.removeFromSuperview()
        }
        removeAnswerButton = UIButton(frame: CGRect(x: x, y: y, width: screenSize.width / 1.12, height: CGFloat(30)))
        removeAnswerButton?.setTitle("➖   Usuń odpowiedź", for: UIControlState.normal)
        removeAnswerButton?.setTitleColor(UIColor.black, for: UIControlState.normal)
        removeAnswerButton?.backgroundColor = UIColor.clear
        removeAnswerButton?.contentHorizontalAlignment = .left
        removeAnswerButton?.addTarget(self, action: #selector(removeAnswerButtonAction), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(removeAnswerButton!)
    }
    
    @objc private func addAnswerButtonAction(sender: UIButton!) {
        if firstAnswerTextField == nil && secondAnswerTextField == nil {
            addFirstAndSecondQuestionElements(x: x, y: y)
        } else if thirdAnswerTextField == nil {
            addThirdQuestionElements(x: x, y: y)
        } else if fourthAnswerTextField == nil {
            addFourthQuestionElements(x: x, y: y)
        } else {
            printErrorAlert(alertMessage: "Nie można stworzyć więcej niż 4 odpowiedzi")
        }
    }
    
    private func addFirstAndSecondQuestionElements(x: CGFloat, y: CGFloat) {
        firstAnswerTextField = UITextField(frame: CGRect(x: x, y: y / 16, width: screenSize.width / 1.12, height: CGFloat(60)))
        firstAnswerTextField?.borderStyle = UITextBorderStyle.roundedRect
        firstAnswerTextField?.keyboardType = .asciiCapable
        firstAnswerTextField?.placeholder = "Treść pierwszej odpowiedzi"
        firstAnswerTextField?.backgroundColor = UIColor.clear
        firstAnswerTextField?.textColor = UIColor.black
        firstAnswerTextField?.tintColor = UIColor.black
        firstAnswerTextField?.delegate = self
        firstAnswerSwitch = UISwitch(frame: CGRect(x: x, y: y * 20, width: 49, height: 31))
        firstAnswerSwitch?.isOn = false
        
        secondAnswerTextField = UITextField(frame: CGRect(x: x, y: y * 22, width: screenSize.width / 1.12, height: CGFloat(60)))
        secondAnswerTextField?.borderStyle = UITextBorderStyle.roundedRect
        secondAnswerTextField?.keyboardType = .asciiCapable
        secondAnswerTextField?.placeholder = "Treść drugiej odpowiedzi"
        secondAnswerTextField?.backgroundColor = UIColor.clear
        secondAnswerTextField?.textColor = UIColor.black
        secondAnswerTextField?.tintColor = UIColor.black
        secondAnswerTextField?.delegate = self
        secondAnswerSwitch = UISwitch(frame: CGRect(x: x, y: y * 26, width: 49, height: 31))
        secondAnswerSwitch?.isOn = false
        
        showRemoveAnswerButton(x: x, y: y * 29)
        showAddAnswerButton(x: x, y: y * 32)
        scrollView.addSubview(firstAnswerTextField!)
        scrollView.addSubview(secondAnswerTextField!)
        scrollView.addSubview(firstAnswerSwitch!)
        scrollView.addSubview(secondAnswerSwitch!)
    }
    
    private func addThirdQuestionElements(x: CGFloat, y: CGFloat) {
        thirdAnswerTextField = UITextField(frame: CGRect(x: x, y: y * 28, width: screenSize.width / 1.12, height: CGFloat(60)))
        thirdAnswerTextField?.borderStyle = UITextBorderStyle.roundedRect
        thirdAnswerTextField?.keyboardType = .asciiCapable
        thirdAnswerTextField?.placeholder = "Treść trzeciej odpowiedzi"
        thirdAnswerTextField?.backgroundColor = UIColor.clear
        thirdAnswerTextField?.textColor = UIColor.black
        thirdAnswerTextField?.tintColor = UIColor.black
        thirdAnswerTextField?.delegate = self
        thirdAnswerSwitch = UISwitch(frame: CGRect(x: x, y: y * 32, width: 49, height: 31))
        thirdAnswerSwitch?.isOn = false
        
        scrollView?.contentSize.height *= CGFloat(1.15)
        showRemoveAnswerButton(x: x, y: y * 35)
        showAddAnswerButton(x: x, y: y * 38)
        scrollView.addSubview(thirdAnswerTextField!)
        scrollView.addSubview(thirdAnswerSwitch!)
    }
    
    private func addFourthQuestionElements(x: CGFloat, y: CGFloat) {
        fourthAnswerTextField = UITextField(frame: CGRect(x: x, y: y * 34, width: screenSize.width / 1.12, height: CGFloat(60)))
        fourthAnswerTextField?.borderStyle = UITextBorderStyle.roundedRect
        fourthAnswerTextField?.keyboardType = .asciiCapable
        fourthAnswerTextField?.placeholder = "Treść czwartej odpowiedzi"
        fourthAnswerTextField?.backgroundColor = UIColor.clear
        fourthAnswerTextField?.textColor = UIColor.black
        fourthAnswerTextField?.tintColor = UIColor.black
        fourthAnswerTextField?.delegate = self
        fourthAnswerSwitch = UISwitch(frame: CGRect(x: x, y: y * 38, width: 49, height: 31))
        fourthAnswerSwitch?.isOn = false
        
        scrollView?.contentSize.height *= CGFloat(1.15)
        showRemoveAnswerButton(x: x, y: y * 41)
        showAddAnswerButton(x: x, y: y * 44)
        scrollView.addSubview(fourthAnswerTextField!)
        scrollView.addSubview(fourthAnswerSwitch!)
    }
    
    @objc private func removeAnswerButtonAction(sender: UIButton!) {
        if fourthAnswerTextField != nil {
            fourthAnswerTextField?.removeFromSuperview()
            fourthAnswerTextField = nil
            fourthAnswerSwitch?.removeFromSuperview()
            fourthAnswerSwitch = nil
            showRemoveAnswerButton(x: x, y: y * 35)
            showAddAnswerButton(x: x, y: y * 38)
            scrollView?.contentSize.height /= CGFloat(1.15)
        } else if thirdAnswerTextField != nil {
            thirdAnswerTextField?.removeFromSuperview()
            thirdAnswerTextField = nil
            thirdAnswerSwitch?.removeFromSuperview()
            thirdAnswerSwitch = nil
            showRemoveAnswerButton(x: x, y: y * 29)
            showAddAnswerButton(x: x, y: y * 32)
            scrollView?.contentSize.height /= CGFloat(1.15)
        } else if secondAnswerTextField != nil && firstAnswerTextField != nil {
            firstAnswerTextField?.removeFromSuperview()
            secondAnswerTextField?.removeFromSuperview()
            firstAnswerTextField = nil
            secondAnswerTextField = nil
            firstAnswerSwitch?.removeFromSuperview()
            firstAnswerSwitch = nil
            secondAnswerSwitch?.removeFromSuperview()
            secondAnswerSwitch = nil
            showAddAnswerButton(x: x, y: y * 16)
            //scrollView?.contentSize.height /= CGFloat(1.15)
            removeAnswerButton?.removeFromSuperview()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = tfv.checkIfFieldIsFilled(view: textField)
        if textField == categoryTextField {
            _ = tfv.checkIfFieldContainsAlphabets(view: categoryTextField!)
        }
        if textField == subjectTextField {
            _ = tfv.checkIfFieldContainsAlphabets(view: subjectTextField!)
        }
        if textField == pointsTextField {
            _ = tfv.checkIfFieldContainsNumbers(view: pointsTextField!)
        }
        if textField == questionContentTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: questionContentTextField!)
        }
        if textField == firstAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: firstAnswerTextField!)
        }
        if textField == secondAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: secondAnswerTextField!)
        }
        if textField == thirdAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: thirdAnswerTextField!)
        }
        if textField == fourthAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: fourthAnswerTextField!)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = tfv.checkIfFieldIsFilled(view: textField)
        if textField == categoryTextField {
            _ = tfv.checkIfFieldContainsAlphabets(view: categoryTextField!)
        }
        if textField == subjectTextField {
            _ = tfv.checkIfFieldContainsAlphabets(view: subjectTextField!)
        }
        if textField == pointsTextField {
            _ = tfv.checkIfFieldContainsNumbers(view: pointsTextField!)
        }
        if textField == questionContentTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: questionContentTextField!)
        }
        if textField == firstAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: firstAnswerTextField!)
        }
        if textField == secondAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: secondAnswerTextField!)
        }
        if textField == thirdAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: thirdAnswerTextField!)
        }
        if textField == fourthAnswerTextField {
            _ = tfv.checkIfFieldContaintsAlphabetsWithSymbols(view: fourthAnswerTextField!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == categoryTextField {
            if let text = categoryTextField?.text {
                let substring = NSString(string: text).replacingCharacters(in: range, with: string)
                searchAutocompletedEntriesWithSubstring(substring: substring, textField: categoryTextField!)
            }
        } else if textField == subjectTextField {
            if let text = subjectTextField?.text {
                let substring = NSString(string: text).replacingCharacters(in: range, with: string)
                searchAutocompletedEntriesWithSubstring(substring: substring, textField: subjectTextField!)
            }
        }
        return true
    }
    
    private func searchAutocompletedEntriesWithSubstring(substring: String, textField: UITextField) {
        if textField == categoryTextField {
            autoCompleteForCategory.removeAll()
            for item in categoryPromps! {
                let string = item as NSString
                let range = string.range(of: substring, options: .caseInsensitive)
                if range.location == 0 {
                    autoCompleteForCategory.append(item)
                }
            }
            rescaleTableView(tableView: tableViewForCategory!, number: autoCompleteForCategory.count)
            tableViewForCategory?.reloadData()
        } else if textField == subjectTextField {
            autoCompleteForSubject.removeAll()
            for item in subjectPromps! {
                let string = item as NSString
                let range = string.range(of: substring, options: .caseInsensitive)
                if range.location == 0 {
                    autoCompleteForSubject.append(item)
                }
            }
            rescaleTableView(tableView: tableViewForSubject!, number: autoCompleteForSubject.count)
            tableViewForSubject?.reloadData()
        }
    }
    
    private func rescaleTableView(tableView: UITableView, number: Int) {
        if tableView == tableViewForCategory {
            tableViewForCategory?.frame.size.height = CGFloat(number) * 30
        } else if tableView == tableViewForSubject {
            tableViewForSubject?.frame.size.height = CGFloat(number) * 30
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewForCategory {
            return autoCompleteForCategory.count
        } else if tableView == tableViewForSubject {
            return autoCompleteForSubject.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewForCategory {
            let cell = tableViewForCategory!.dequeueReusableCell(withIdentifier: "cellForCategory", for: indexPath)
            cell.textLabel?.text = autoCompleteForCategory[indexPath.row]
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = CGFloat(0.5)
            return cell
        } else if tableView == tableViewForSubject {
            let cell = tableViewForSubject!.dequeueReusableCell(withIdentifier: "cellForCategory", for: indexPath)
            cell.textLabel?.text = autoCompleteForSubject[indexPath.row]
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = CGFloat(0.5)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewForCategory {
            let selectedCell = tableViewForCategory?.cellForRow(at: indexPath)
            categoryTextField?.text = selectedCell?.textLabel?.text!
            rescaleTableView(tableView: tableViewForCategory!, number: 0)
        } else if tableView == tableViewForSubject {
            let selectedCell = tableViewForSubject?.cellForRow(at: indexPath)
            subjectTextField?.text = selectedCell?.textLabel?.text!
            rescaleTableView(tableView: tableViewForSubject!, number: 0)
        }
    }
}
