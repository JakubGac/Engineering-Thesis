//
//  MainMenuViewController.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 17.11.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import UIKit
import RealmSwift

class MainMenuViewController: UIViewController {

    
    @IBOutlet weak var teacherButton: UIButton!
    @IBOutlet weak var studentButton: UIButton!
    
    private struct Storyboard {
        static let teacherButton = "Wykładowca"
        static let studentButton = "Student"
        static let ShowTeacherSegue = "Show Teacher"
        static let ShowStudentSeque = "Show Student"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let buttonText = sender.currentTitle {
            if buttonText == Storyboard.teacherButton {
                performSegue(withIdentifier: Storyboard.ShowTeacherSegue, sender: sender)
            } else if buttonText == Storyboard.studentButton {
                performSegue(withIdentifier: Storyboard.ShowStudentSeque, sender: sender)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonLook(button: teacherButton)
        setButtonLook(button: studentButton)
        
        DaoManager().addData()
    }
}

extension UIViewController {
    func printErrorAlert(alertMessage: String) {
        let myAlert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(actionOK)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func printSafeAllert(){
        let myAlert = UIAlertController(title: "Baza danych", message: "Zapis zakończony prawidłowo", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (ACTION) in
            self.navigationController!.popViewController(animated: true)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func setButtonLook(button: UIButton) {
        button.layer.borderWidth = CGFloat(0.5)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = CGFloat(25)
    }
}
