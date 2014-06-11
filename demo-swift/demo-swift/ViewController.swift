//
//  ViewController.swift
//  demo-swift
//
//  Created by Igor Khomenko on 6/11/14.
//  Copyright (c) 2014 Igor Khomenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QBActionStatusDelegate, UITextFieldDelegate {
    
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
        
        println(firstNameTextField.text)
        println(lastNameTextField.text)
        println(companyTextField.text)
        println(emailTextField.text)
        println(pnoneTextField.text)
        
        var params = ["first_name": firstNameTextField.text,
                      "last_name": lastNameTextField.text,
                      "company": companyTextField.text,
                      "email_address": emailTextField.text,
                      "phone_number": pnoneTextField.text,
                      "source": "Apps world app"].mutableCopy() as NSMutableDictionary
        
        
        println(params)
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
            }
        }else{
            submitButton.enabled = true
        }
    }
    
    // UITextFieldDelegate
    //
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

