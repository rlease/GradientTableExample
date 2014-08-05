//
//  ViewController.swift
//  GradientTableExample
//
//  Created by Ryan Lease on 7/29/14.
//  Copyright (c) 2014 rlease. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var gradientTableView: gradientUITableView!
    @IBOutlet weak var numberOfRowsTextField: UITextField!
    @IBOutlet weak var startingColorTextField: UITextField!
    @IBOutlet weak var endingColorTextField: UITextField!
    @IBOutlet weak var startingColorUIView: UIView!
    @IBOutlet weak var endingColorUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfields()
        gradientTableView.setupColorsWithStrings(startingColorTextField.text, end: endingColorTextField.text)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table handling 
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return gradientTableView.getNumberOfRows()
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        cell.textLabel.text = "test"
        cell.backgroundColor = gradientTableView.getBackgroundColorAtRow(indexPath.row)
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
    }
    
    // MARK: Keyboard handling
    
    func setupTextfields ()
    {
        numberOfRowsTextField.delegate = self
        numberOfRowsTextField.keyboardType = UIKeyboardType.NumberPad
        startingColorTextField.delegate = self
        endingColorTextField.delegate = self
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool
    {
        //Only allows numbers to be input into the numberOfRows textfield
        if(textField == numberOfRowsTextField)
        {
            let currentstring: NSString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            let expression = "^([0-9])*"
            let regex: NSRegularExpression = NSRegularExpression.regularExpressionWithPattern(expression, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            
            let matches : NSNumber = regex.numberOfMatchesInString(currentstring, options: nil, range: NSMakeRange(0, currentstring.length))
            
            if(!(matches > 0)) {
                return false
            }
        }
        return true
    }
    
    //Checks if there is valid input before dismissing the keyboard
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool
    {
        if(textField == numberOfRowsTextField)
        {
            if(numberOfRowsTextField.text.isEmpty)
            {
                gradientTableView.setNumberOfRows(10)
                numberOfRowsTextField.text = "10"
            }
        }
        if (textField == startingColorTextField || textField == endingColorTextField)
        {
            let expression = "^([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})*"
            let regex: NSRegularExpression = NSRegularExpression.regularExpressionWithPattern(expression, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            
            let matches: NSNumber = regex.numberOfMatchesInString(textField.text, options: nil, range: NSMakeRange(0, (textField.text as NSString).length))
            
            if(!(matches > 0)) {
                return false
            }
        }
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        //Clear the current background colors and recalculate
        if(textField == numberOfRowsTextField)
        {
            gradientTableView.clearBackgroundColors()
            gradientTableView.setNumberOfRows(numberOfRowsTextField.text.toInt()!)
        }
        else if (textField == startingColorTextField)
        {
            gradientTableView.clearBackgroundColors()
            let hexcolor : UInt32 = gradientTableView.hexFromString(startingColorTextField.text)
            let newstartcolor = gradientTableView.UIColorFromRGB(UInt(hexcolor))
            startingColorUIView.backgroundColor = newstartcolor
        }
        else if(textField == endingColorTextField)
        {
            gradientTableView.clearBackgroundColors()
            let hexcolor : UInt32 = gradientTableView.hexFromString(endingColorTextField.text)
            let newstartcolor = gradientTableView.UIColorFromRGB(UInt(hexcolor))
            endingColorUIView.backgroundColor = newstartcolor
        }
        gradientTableView.setupColorsWithStrings(startingColorTextField.text, end: endingColorTextField.text)
        gradientTableView.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
}
