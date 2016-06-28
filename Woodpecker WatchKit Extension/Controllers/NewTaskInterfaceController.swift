/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import WatchKit

class NewTaskInterfaceController: WKInterfaceController {
  static let ControllerName = "NewTaskInterfaceController"
  @IBOutlet var addNameButton: WKInterfaceButton!
  @IBOutlet var addNameGroup: WKInterfaceGroup!
  
  @IBOutlet var timesLabel: WKInterfaceLabel!
  @IBOutlet var timesSelectedLabel: WKInterfaceLabel!
  @IBOutlet var timesSlider: WKInterfaceSlider!
  
  @IBOutlet var colorLabel: WKInterfaceLabel!
  @IBOutlet var blueButton: WKInterfaceButton!
  @IBOutlet var purpleButton: WKInterfaceButton!
  @IBOutlet var greenButton: WKInterfaceButton!
  @IBOutlet var orangeButton: WKInterfaceButton!
  @IBOutlet var yellowButton: WKInterfaceButton!
  @IBOutlet var redButton: WKInterfaceButton!
  
  @IBOutlet var bottomGroup: WKInterfaceGroup!
  @IBOutlet var createButton: WKInterfaceButton!
  @IBOutlet var cancelButton: WKInterfaceButton!
  
  @IBOutlet var errorImage: WKInterfaceImage!
  
  private func colorButtons() -> [WKInterfaceButton] {
    return [blueButton, purpleButton, greenButton, orangeButton, redButton, yellowButton]
  }
  
  var selectedColorButton: WKInterfaceButton?
  var selectedColor: Task.Color?
  var name: String?
  var times: Int = 20
  
  var tasks: TaskList!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    tasks = context as! TaskList
    setUpColorButtons()
    
  }
 
}

// MARK: Actions
extension NewTaskInterfaceController {
  @IBAction func addName() {
    let options = ["Work Out", "Express Love", "Drink Water", "Skip Dessert"]
    presentTextInputControllerWithSuggestions(options, allowedInputMode: WKTextInputMode.Plain) { results in
      if let result = results?.first as? String {
        self.addNameButton.setTitle(result)
        self.name = result
      }
    }
  }
  
  @IBAction func onSliderChange(value: Float) {
    times = Int(value)
    timesSelectedLabel.setText("\(times)")
  }
  
  @IBAction func onCreate() {
    guard let name = name, color = selectedColor else {
      displayError()
      return
    }
    let task = Task(name: name, color: color, totalTimes: times)
    tasks.addTask(task)
    dismissController()
  }
  
  @IBAction func onCancel() {
    dismissController()
  }
}

// MARK: Error Handling
extension NewTaskInterfaceController {
  func displayError() {
    errorImage.setHidden(false)
    
    errorImage.setImageNamed("x")
    errorImage.startAnimating()
    animateWithDuration(0.4) {
      self.errorImage.sizeToFitHeight()
    }
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.animateWithDuration(0.4) {
        self.errorImage.setHeight(0)
      }
    }
  }
}

// MARK: Color Selection
extension NewTaskInterfaceController {
  func setUpColorButtons() {
    blueButton.setBackgroundColor(Task.Color.Blue.color)
    purpleButton.setBackgroundColor(Task.Color.Purple.color)
    greenButton.setBackgroundColor(Task.Color.Green.color)
    orangeButton.setBackgroundColor(Task.Color.Orange.color)
    yellowButton.setBackgroundColor(Task.Color.Yellow.color)
    redButton.setBackgroundColor(Task.Color.Red.color)
  }
  
  func selectColor(color: Task.Color, button: WKInterfaceButton) {
    selectedColor = color
    
    self.animateWithDuration(0.4) {
      if let previous = self.selectedColorButton {
        previous.setAlpha(0.3)
      }
      self.selectedColorButton = button
      button.setAlpha(1)
      self.addNameGroup.setBackgroundColor(color.color.colorWithAlphaComponent(0.3))
    }
  }
  
  @IBAction func onBlue() {
    selectColor(Task.Color.Blue, button: blueButton)
  }
  @IBAction func onPurple() {
    selectColor(Task.Color.Purple, button: purpleButton)
  }
  @IBAction func onGreen() {
    selectColor(Task.Color.Green, button: greenButton)
  }
  @IBAction func onOrange() {
    selectColor(Task.Color.Orange, button: orangeButton)
  }
  @IBAction func onYellow() {
    selectColor(Task.Color.Yellow, button: yellowButton)
  }
  @IBAction func onRed() {
    selectColor(Task.Color.Red, button: redButton)
  }
}