GradientTableExample
====================

A simple UITableView with cell background colors that form a gradient. Written in Swift. The colors chosen for the 
background of the cells is determined by finding the distance between the two colors, dividing the distance by the number
of rows, and changing the colors based on that average color change distance. 

How to use:
===========

1. Add a UITableView to a view controller either through Interface Builder or initialized through code. 
2. Add starting and ending colors for the table view gradient through either of the following methods
  1.If you have specific UIColors already, use the regular setupColors method

  ```
  setupColors(startcolor: UIColor, endcolor: UIColor)
  ```
  2.If you are reading colors in from RGB strings, use the setupColorsWithStrings method
  
  ```
  setupColorsWithStrings(start: String, end: String)
  ```
3. The default number of rows for the table is 10. This can be changed either by manually setting it, or using

  ```
  setNumberOfRows(rows: Int)
  ```
  
Enjoy!

![Gradient Table Example](http://gifyu.com/images/gradientTable.gif)

You can reach me on Twitter, ![@_rlease](http://twitter.com/_rlease)
