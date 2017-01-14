//
//  TextValidator.swift
//  Engineering Thesis
//
//  Created by Jakub Gac on 18.12.2016.
//  Copyright © 2016 Jakub Gac. All rights reserved.
//

import Foundation
import UIKit

class TextFieldValidator {
    
    private var alphabetCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private var numberCharacterSet = CharacterSet(charactersIn: "0123456789.")
    
    // puste text fields
    func checkIfFieldIsFilled(view: UITextField) -> Bool {
        if let text = view.text {
            if text.isEmpty {
                shakeTextField(textField: view)
                view.layer.borderWidth = CGFloat(1.0)
                view.layer.borderColor = UIColor.red.cgColor
                return false
            }
            view.layer.borderWidth = CGFloat(0.0)
            view.layer.borderColor = UIColor.black.cgColor
            return true
        }
        return false
    }
    
    func checkIfFieldContainsNumbers(view: UITextField) -> Bool {
        if let text = view.text {
            let specialSymbols = CharacterSet(charactersIn: ",?!~`@#$%^&*-+();:=_{}[]<>\\/|\"\'")
             // sprawdzamy ile jest cyfr w tekście
             // zmienna range będzie równa nil jeżeli
             // nie ma w ogóle liczb
            let numbers = text.rangeOfCharacter(from: numberCharacterSet)
            let characters = text.rangeOfCharacter(from: alphabetCharacterSet)
            let symbols = text.rangeOfCharacter(from: specialSymbols)
            if symbols == nil  {
                if characters == nil {
                    if numbers != nil {
                        // wszystko okej 
                        view.layer.borderWidth = CGFloat(0.0)
                        view.layer.borderColor = UIColor.black.cgColor
                        return true
                    }
                }
            }
            shakeTextField(textField: view)
            view.layer.borderWidth = CGFloat(1.0)
            view.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return false
    }
    
    func checkIfFieldContainsAlphabets(view: UITextField) -> Bool {
        if let text = view.text {
            let specialSymbols = CharacterSet(charactersIn: ".?,/!~`@#$%^&*-+();:=_{}[]<>\\/|\"\'")
            let symbols = text.rangeOfCharacter(from: specialSymbols)
            let characters = text.rangeOfCharacter(from: alphabetCharacterSet)
            let numbers = text.rangeOfCharacter(from: numberCharacterSet)
            if symbols == nil {
                if numbers == nil {
                    if characters != nil {
                        // wszystok okej
                        view.layer.borderWidth = CGFloat(0.0)
                        view.layer.borderColor = UIColor.black.cgColor
                        return true
                    }
                }
            }
            shakeTextField(textField: view)
            view.layer.borderWidth = CGFloat(1.0)
            view.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return false
    }
    
    func checkIfFieldContaintsAlphabetsWithSymbols(view: UITextField) -> Bool {
        if let text = view.text {
            let characters = text.rangeOfCharacter(from: alphabetCharacterSet)
            let numbers = text.rangeOfCharacter(from: numberCharacterSet)
            if numbers == nil {
                if characters != nil {
                    // wszystok okej
                    view.layer.borderWidth = CGFloat(0.0)
                    view.layer.borderColor = UIColor.black.cgColor
                    return true
                }
            }
            shakeTextField(textField: view)
            view.layer.borderWidth = CGFloat(1.0)
            view.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return false
    }
    
    private func shakeTextField(textField: UITextField) {
        let shake = CABasicAnimation(keyPath: "position")
        // długość trwania
        shake.duration = 0.1
        // ile razy ma sie powtórzyć
        shake.repeatCount = 3
        // automatyczny powrót
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: textField.center.x - textField.center.x.divided(by: 40), y: textField.center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: textField.center.x + textField.center.x.divided(by: 40), y: textField.center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        textField.layer.add(shake, forKey: "position")
    }
}
