//
//  ViewController.swift
//  demo-swift
//
//  Created by Igor Khomenko on 6/11/14.
//  Copyright (c) 2014 Igor Khomenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QBActionStatusDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var topLabel: UILabel
    @IBOutlet var topSublabel: UILabel
    //
    @IBOutlet var questionsTableView: UITableView
    //
    @IBOutlet var submitButton: UIButton
    
    let questionAnswers = ["To integrate it to my app", "To integrate it to my client's app",
        "To use it for my personal purposes"]
    
    var selectedAnswer = 0
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let authRequest = QBASessionCreationRequest()
        authRequest.userLogin = "JohnDoe";
        authRequest.userPassword = "Hello123";
        //
        QBAuth.createSessionWithExtendedRequest(authRequest, delegate: self)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        questionsTableView.flashScrollIndicators()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(AnyObject) {
        let object = QBCOCustomObject()
        object.className = "BetaTesters"
        //
        var firstNameTextField = questionsTableView.viewWithTag(100201) as UITextField
        let lastNameTextField = questionsTableView.viewWithTag(100202) as UITextField
        let companyTextField = questionsTableView.viewWithTag(100203) as UITextField
        let phoneTextField = questionsTableView.viewWithTag(100204) as UITextField
        let emailTextField = questionsTableView.viewWithTag(100205) as UITextField
        
        var params = ["first_name": firstNameTextField.text,
                      "last_name": lastNameTextField.text,
                      "company": companyTextField.text,
                      "email_address": emailTextField.text,
                      "phone_number": phoneTextField.text,
                      "reason": questionAnswers[selectedAnswer],
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
    
    
    // keyboard
    //
    func keyboardWillShow(){
        
    }
    
    func keyboardWillHide(){
        
    }
    
    
    // UITableViewDelegate
    //
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        if indexPath.section == 2{
            // check
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            selectedAnswer = indexPath.row
            
            tableView.reloadData()
        }
    }
    
    
    // UITableViewDataSource
    //
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? 2 : 3
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var cell: UITableViewCell
        

        if indexPath.section == 0{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCellWithIdentifier("FirstNameCellIdentifier") as UITableViewCell
            }else{
                cell = tableView.dequeueReusableCellWithIdentifier("LastNameCellIdentifier") as UITableViewCell
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCellWithIdentifier("CompanyCellIdentifier") as UITableViewCell
            }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCellWithIdentifier("PhoneCellIdentifier") as UITableViewCell
            }else {
                cell = tableView.dequeueReusableCellWithIdentifier("EmailCellIdentifier") as UITableViewCell
            }
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("AnswerCellIdentifier") as UITableViewCell
            
            let cellLabel = cell.viewWithTag(100200) as UILabel
            cellLabel.text = questionAnswers[indexPath.row]
            
            if selectedAnswer == indexPath.row{
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return section == 2 ? "How are you planning to use Qmunicate?" : String()
    }
}

