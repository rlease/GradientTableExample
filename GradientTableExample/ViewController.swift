//
//  ViewController.swift
//  GradientTableExample
//
//  Created by Ryan Lease on 7/29/14.
//  Copyright (c) 2014 rlease. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var gradientTableView: UITableView!
    @IBOutlet weak var numberOfRowsTextField: UITextField!
    @IBOutlet weak var startingColorTextField: UITextField!
    @IBOutlet weak var endingColorTextField: UITextField!
    @IBOutlet weak var startingColorUIView: UIView!
    @IBOutlet weak var endingColorUIView: UIView!
    
    var backgroundColors = [UIColor]()
    var numberOfRows = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfields()
        setupColors()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table handling 
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        cell.textLabel.text = "test"
        cell.backgroundColor = backgroundColors[indexPath.row]
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
            
            if(matches == 0) {
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
                numberOfRows = 10
                numberOfRowsTextField.text = "10"
            }
        }
        if (textField == startingColorTextField || textField == endingColorTextField)
        {
            let expression = "^([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})*"
            let regex: NSRegularExpression = NSRegularExpression.regularExpressionWithPattern(expression, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            
            let matches: NSNumber = regex.numberOfMatchesInString(textField.text, options: nil, range: NSMakeRange(0, (textField.text as NSString).length))
            
            if(matches == 0) {
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
            backgroundColors = []
            numberOfRows = numberOfRowsTextField.text.toInt()!
        }
        else if (textField == startingColorTextField)
        {
            backgroundColors = []
            let hexcolor : UInt32 = hexFromString(startingColorTextField.text)
            let newstartcolor = UIColorFromRGB(UInt(hexcolor))
            startingColorUIView.backgroundColor = newstartcolor
        }
        else if(textField == endingColorTextField)
        {
            backgroundColors = []
            let hexcolor : UInt32 = hexFromString(endingColorTextField.text)
            let newstartcolor = UIColorFromRGB(UInt(hexcolor))
            endingColorUIView.backgroundColor = newstartcolor
        }
        setupColors()
        gradientTableView.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Color management methods
    
    //Specify a starting color and ending color for the gradient, calculates all the colors needed for the table
    //Saves them to the backgroundColors array
    func setupColors()
    {
        let startcolor = UIColorFromRGB(UInt(hexFromString(startingColorTextField.text)))
        let endcolor = UIColorFromRGB(UInt(hexFromString(endingColorTextField.text)))
        
        for i in (0 ..< numberOfRows) {
            if(i==0) {
                backgroundColors.append(startcolor)
            }
            else {
                backgroundColors.append(findBackgroundColor(i, startColor: startcolor, endColor: endcolor))
            }
        }
    }
    
    //create a unsigned integer from a string
    func hexFromString(colorstring: String) -> UInt32
    {
        var hexcolor: UInt32 = 0
        let scanner : NSScanner = NSScanner(string: colorstring)
        scanner.scanHexInt(&hexcolor)
        return hexcolor
    }
    
    //newColor is the percentage change for each row multiplied by the distance between the two colors
    //this number is subtracted from the starting color piecewise from red, green, and blue values respectively
    func findBackgroundColor(row: Int, startColor: UIColor, endColor: UIColor) -> UIColor {
        let startcomponents = CGColorGetComponents(startColor.CGColor)
        let endcomponents = CGColorGetComponents(endColor.CGColor)
        
        let r = (startcomponents[0] - endcomponents[0])
        let g = (startcomponents[1] - endcomponents[1])
        let b = (startcomponents[2] - endcomponents[2])
        let a = (startcomponents[3] - endcomponents[3])
        
        let perchange = CGFloat(row)/CGFloat(numberOfRows-1)
        let rdelta = (perchange * r)
        let gdelta = (perchange * g)
        let bdelta = (perchange * b)
        let adelta = (perchange * a)
        
        let newColor: UIColor = UIColor(red: fabs(startcomponents[0] - rdelta), green: fabs(startcomponents[1] - gdelta), blue: fabs(startcomponents[2] - bdelta), alpha: fabs(startcomponents[3] - adelta))
        return newColor
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
