//
//  ViewController.swift
//  demo-swift
//
//  Created by Igor Khomenko on 6/11/14.
//  Copyright (c) 2014 Igor Khomenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QBActionStatusDelegate, UITextFieldDelegate {
    
    @IBOutlet var label: UILabel
    //
    @IBOutlet var firstNameTextField: UITextField
    @IBOutlet var lastNameTextField: UITextField
    @IBOutlet var companyTextField: UITextField
    @IBOutlet var pnoneTextField: UITextField
    @IBOutlet var emailTextField: UITextField
    //
    @IBOutlet var submitButton: UIButton
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        label.text = "Qmunicate Beta Testers"
        
        let authRequest = QBASessionCreationRequest()
        authRequest.userLogin = "JohnDoe";
        authRequest.userPassword = "Hello123";
        //
        QBAuth.createSessionWithExtendedRequest(authRequest, delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(AnyObject) {
        let object = QBCOCustomObject()
        object.className = "BetaTesters"
        
        var params = ["first_name": firstNameTextField.text,
                      "last_name": lastNameTextField.text,
                      "company": companyTextField.text,
                      "email_address": emailTextField.text,
                      "phone_number": pnoneTextField.text,
                      "source": "Apps world app"].bridgeToObjectiveC() as NSMutableDictionary
        
        
        object.fields = params
        //
        QBCustomObjects.createObject(object, delegate: self)
    }
    
    
    // QuickBlox delegate
    //
    func completedWithResult(result: Result){
        if result is QBCOCustomObjectResult{
            if result.success{
                let alert = UIAlertView()
                alert.title = "Thanks!"
                alert.message = "Your data was submited successfully"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }else{
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = result.errors.description
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }else if result is QBAAuthSessionCreationResult{
            if result.success{
                submitButton.enabled = true
            }else{
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = result.errors.description
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }
    
    // UITextFieldDelegate
    //
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

