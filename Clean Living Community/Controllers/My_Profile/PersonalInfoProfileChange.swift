//
//  PersonalInfoProfileChange.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

//  protocol returns information to super view controller about this view's fields
protocol personalDelegate
{
    func returnPersonal(personalInfo: [String : String])
}


class PersonalInfoProfileChange: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate
{
    let currentUserID = Auth.auth().currentUser?.uid
    var userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    let edupicker = UIPickerView()
    let relationpicker = UIPickerView()
    let orientationpicker = UIPickerView()
    let religiouspicker = UIPickerView()
    let spiritualpicker = UIPickerView()
    let smokepicker = UIPickerView()
    let supportpicker = UIPickerView()
    
    var personalDelegate : personalDelegate?
    var tempDict = [String:String]()

    var selectedfield: UITextField?
    @IBOutlet weak var eduField: UITextField!
    @IBOutlet weak var relationField: UITextField!
    @IBOutlet weak var orientationField: UITextField!
    @IBOutlet weak var religiousField: UITextField!
    @IBOutlet weak var spiritualField: UITextField!
    @IBOutlet weak var smokeField: UITextField!
    @IBOutlet weak var supportField: UITextField!
    
    // allow for switching pickerviews and saving of data while editing a textfield
    @IBAction func eduChanged(_ sender: UITextField)
    {
        selectedfield = eduField

    }
    @IBAction func relationChanged(_ sender: UITextField)
    {
        selectedfield = relationField

    }
    @IBAction func orientationChanged(_ sender: UITextField)
    {
        selectedfield = orientationField

    }
    @IBAction func religiousChanged(_ sender: UITextField)
    {
        selectedfield = religiousField

    }
    @IBAction func spiritualChanged(_ sender: UITextField)
    {
        selectedfield = spiritualField
    }
    
    @IBAction func smokeChanged(_ sender: UITextField)
    {
        selectedfield = smokeField
    }
    
    @IBAction func supportChanged(_ sender: UITextField)
    {
        selectedfield = supportField
    }
    
    
    
    
    // possible values for each pickerview
    let education = ["High School/GED","Some College/Bachelors Degree","Graduate Degree","PHD"]
    let religious = ["Yes","No"]
    let spiritual = ["Yes", "No"]
    let relationship = ["Single", "In a Relationship"]
    let smoke = ["Yes","No"]
    let orientation = ["Heterosexual","Homosexual","Bisexual","Wish not to disclose"]
    let support = ["Yes","No","Occasionally"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // handle moving the view if keyboard would cover the text fields
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        
        // set delegates and data sources for pickers
        edupicker.delegate = self
        edupicker.dataSource = self
        relationpicker.delegate = self
        relationpicker.dataSource = self
        religiouspicker.delegate = self
        religiouspicker.dataSource = self
        spiritualpicker.delegate = self
        spiritualpicker.dataSource = self
        smokepicker.delegate = self
        smokepicker.dataSource = self
        orientationpicker.delegate = self
        orientationpicker.dataSource = self
        supportpicker.delegate = self
        supportpicker.dataSource = self
        
        // sets the pickers to correct fields
        eduField.inputView = edupicker
        relationField.inputView = relationpicker
        religiousField.inputView = religiouspicker
        spiritualField.inputView = spiritualpicker
        smokeField.inputView = smokepicker
        orientationField.inputView = orientationpicker
        supportField.inputView = supportpicker
        
        var userlist = userModel.users
        displayedUser = userModel.findUser(uid: currentUserID!)
        
        // get data about the user, and fill the text fields with that data
        userModel.returnUserObject(UID: currentUserID!) { (user) in
            self.displayedUser = user
            self.eduField.text = self.displayedUser.education
            self.relationField.text = self.displayedUser.relationship
            self.religiousField.text = self.displayedUser.religious
            self.spiritualField.text = self.displayedUser.spiritual
            self.smokeField.text = self.displayedUser.smoker
            self.orientationField.text = self.displayedUser.orientation
            self.supportField.text = self.displayedUser.support
            
            // record and send this information back to the super view controller
            if (self.personalDelegate != nil)
            {
                self.tempDict["edu"] = self.eduField.text
                self.tempDict["rel"] = self.relationField.text
                self.tempDict["religion"] = self.religiousField.text
                self.tempDict["spt"] = self.spiritualField.text
                self.tempDict["smoke"] = self.smokeField.text
                self.tempDict["ori"] = self.orientationField.text
                self.tempDict["sup"] = self.supportField.text
                self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)
            }
            
        }
        
       
        
        eduField.setBottomBorder(bottom_border: "teal")
        relationField.setBottomBorder(bottom_border: "teal")
        religiousField.setBottomBorder(bottom_border: "teal")
        spiritualField.setBottomBorder(bottom_border: "teal")
        smokeField.setBottomBorder(bottom_border: "teal")
        orientationField.setBottomBorder(bottom_border: "teal")
        supportField.setBottomBorder(bottom_border: "teal")
        
        
        // datepicker.setValue(DesignHelper.getOffWhiteColor(), forKey: "textColor")
        // datepicker.performSelector(inBackground: "setHighlightsToday", with: <#T##Any?#>)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    // finish setting up the pickerviews
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch selectedfield
        {
        case eduField: return education.count
        case relationField: return relationship.count
        case religiousField: return religious.count
        case spiritualField: return spiritual.count
        case smokeField: return smoke.count
        case orientationField: return orientation.count
        case supportField: return support.count
        default: return 1
        }
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        switch selectedfield
        {
        case eduField: return education[row]
        case relationField: return relationship[row]
        case religiousField: return religious[row]
        case spiritualField: return spiritual[row]
        case smokeField: return smoke[row]
        case orientationField: return orientation[row]
        case supportField: return support[row]
        default: return education[row]
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch selectedfield
        {
        case eduField: eduField.text = education[row]
        self.view.endEditing(true)
        case relationField: relationField.text = relationship[row]
        self.view.endEditing(true)
        case religiousField: religiousField.text = religious[row]
        self.view.endEditing(true)
        case spiritualField: spiritualField.text = spiritual[row]
        self.view.endEditing(true)
        case smokeField: smokeField.text = smoke[row]
        self.view.endEditing(true)
        case orientationField: orientationField.text = orientation[row]
        self.view.endEditing(true)
        case supportField: supportField.text = support[row]
        self.view.endEditing(true)
        default: eduField.text = education[row]
        self.view.endEditing(true)
        }
    }
    
    // allows for the picker to switch correctly when going from editing one field to another field directly
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        selectedfield = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch selectedfield
        {
        case eduField: eduField.resignFirstResponder()
        case relationField: relationField.resignFirstResponder()
        case religiousField: religiousField.resignFirstResponder()
        case spiritualField: spiritualField.resignFirstResponder()
        case smokeField: smokeField.resignFirstResponder()
        case orientationField: orientationField.resignFirstResponder()
        case supportField: supportField.resignFirstResponder()
        default: eduField.resignFirstResponder()
        }
        
    }
    
    
    
    
   
    @IBAction func educationDidEnd(_ sender: UITextField)
    {
        self.tempDict["edu"] = self.eduField.text
        self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)

    }
    
    @IBAction func relationDidEnd(_ sender: UITextField)
    {
        self.tempDict["rel"] = self.relationField.text
        self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)

    }
    
    
    @IBAction func orientationDidEnd(_ sender: UITextField)
    {
        self.tempDict["ori"] = self.orientationField.text
        self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)

    }
    
    @IBAction func religiousDidEnd(_ sender: UITextField)
    {
        self.tempDict["religion"] = self.religiousField.text
        self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)

    }
    
    @IBAction func spiritualDidEnd(_ sender: UITextField)
    {
        self.tempDict["spt"] = self.spiritualField.text
        self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)

    }
    @IBAction func smokerDidEnd(_ sender: UITextField)
    {
        self.tempDict["smoke"] = self.smokeField.text
        self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)

    }
    @IBAction func supportDidEnd(_ sender: UITextField)
    {
        self.tempDict["sup"] = self.supportField.text
        self.personalDelegate?.returnPersonal(personalInfo: self.tempDict)

    }
    
    
    
    
    
    
    
    
    
    
    // BEGIN KEYBOARD METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    func handleDoneButtonOnKeyboard()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace,doneButton], animated: false)
        eduField.inputAccessoryView = toolbar
        relationField.inputAccessoryView = toolbar
        religiousField.inputAccessoryView = toolbar
        spiritualField.inputAccessoryView = toolbar
        smokeField.inputAccessoryView = toolbar
        supportField.inputAccessoryView = toolbar
        orientationField.inputAccessoryView = toolbar
    }
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    func handleViewAdjustmentsFromKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification)
    {
        if(smokeField.isEditing || supportField.isEditing || spiritualField.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            self.parent?.view.frame.origin.y = -1 * keyboard.height
        }
        else if(eduField.isEditing || relationField.isEditing || religiousField.isEditing || orientationField.isEditing)
        {
            self.parent?.view.frame.origin.y = 0
        }
        
    }
    @objc func keyboardWillHide(notification: Notification)
    {
        guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            return
        }
        if(self.parent?.view.frame.origin.y != 0)
        {
            self.parent?.view.frame.origin.y += keyboard.height
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

