//
//  gradientUITableView.swift
//  GradientTableExample
//
//  Created by Ryan Lease on 8/1/14.
//  Copyright (c) 2014 rlease. All rights reserved.
//

import UIKit

class gradientUITableView : UITableView
{
    private var backgroundColors = [UIColor]()
    private var numberOfRows : Int = 10
    
    // MARK: Getters
    
    func getNumberOfRows() -> Int
    {
        return numberOfRows
    }
    
    func getBackgroundColors() -> [UIColor]
    {
        return backgroundColors
    }
    
    // MARK: Setters
    
    func setNumberOfRows(rows: Int)
    {
        numberOfRows = rows
    }
        
    // MARK: Color management methods
    
    //Specify a starting color and ending color for the gradient, calculates all the colors needed for the table
    //Saves them to the backgroundColors array
    func setupColors(startcolor: UIColor, endcolor: UIColor)
    {
        for i in (0 ..< numberOfRows) {
            if(i==0) {
                backgroundColors.append(startcolor)
            }
            else {
                backgroundColors.append(findBackgroundColor(i, startColor: startcolor, endColor: endcolor))
            }
        }
    }
    
    //Specify the starting color and ending color with RGB strings, and calculate all the colors needed for the table
    //Save them to the backgroundColors array
    func setupColorsWithStrings(start: String, end: String)
    {
        let startcolor = UIColorFromRGB(UInt(hexFromString(start)))
        let endcolor = UIColorFromRGB(UInt(hexFromString(end)))
        
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
    
    func clearBackgroundColors ()
    {
        backgroundColors = []
    }
}
