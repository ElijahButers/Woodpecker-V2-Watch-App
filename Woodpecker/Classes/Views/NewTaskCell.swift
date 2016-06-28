//
//  NewTaskCell.swift
//  Woodpecker
//
//  Created by Jack Wu on 2015-07-24.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class NewTaskCell: UITableViewCell {
  
  @IBOutlet weak var topContainer: UIView!
  @IBOutlet weak var taskNameField: UITextField!
  @IBOutlet weak var taskTimesField: UITextField!
  
  @IBOutlet var colorButtons: [UIButton]!
  
  var selectedColor: Task.Color!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    for (i, button) in colorButtons.enumerate() {
      guard let color = Task.Color(rawValue: i)?.color else { continue }
      button.backgroundColor = color
    }
    reset()
  }
  
  func reset() {
    selectedColor = Task.Color.Blue
    topContainer.backgroundColor = selectedColor.color

    taskNameField.text = nil
    taskTimesField.text = nil
  }
  
  @IBAction func onColorButton(sender: UIButton) {
    guard let index = colorButtons.indexOf(sender) else { return }
    guard let color = Task.Color(rawValue: index) else { return }
    
    selectedColor = color
    
    topContainer.backgroundColor = selectedColor.color
  }
}
