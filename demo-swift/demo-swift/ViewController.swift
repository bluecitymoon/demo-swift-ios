//
//  ViewController.swift
//  demo-swift
//
//  Created by Igor Khomenko on 6/11/14.
//  Copyright (c) 2014 Igor Khomenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QBActionStatusDelegate {
    
    @IBOutlet var nameTextField: UITextField
                            
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
        println(nameTextField.text)
        
        let object = QBCOCustomObject()
        object.className = "BetaTesters"
        object.fields["first_name"] = "Igor"
        //
        QBCustomObjects.createObject(object, delegate: self)
    }
    
    
    // QuickBlox delegate
    //
    func completedWithResult(result: Result){
        if result is QBCOCustomObjectResult && result.success{
            let alert = UIAlertView()
            alert.title = "Thanks!"
            alert.message = "Your data was submited successfully"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
}

