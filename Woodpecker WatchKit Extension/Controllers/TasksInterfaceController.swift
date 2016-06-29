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

class TasksInterfaceController: WKInterfaceController {
  @IBOutlet var addTaskButton: WKInterfaceButton!
  @IBOutlet var ongoingTable: WKInterfaceTable!
  
  @IBOutlet var completedLabel: WKInterfaceLabel!
  @IBOutlet var completedTable: WKInterfaceTable!
  
  var tasks: TaskList = TaskList()
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    loadSavedTasks()
    
    loadOngoingTasks()
    loadCompletedTasks()
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    updateOngoingTasksIfNeeded()
  }
  
  
  
  @IBAction func onNewTask() {
    presentControllerWithName(NewTaskInterfaceController.ControllerName, context: tasks)
  }
}

// MARK: Table Interaction
extension TasksInterfaceController {
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    guard table === ongoingTable else { return }
    
    let task = tasks.ongoingTasks[rowIndex]
    tasks.didTask(task)
    if (task.isCompleted) {
      ongoingTable.removeRowsAtIndexes(NSIndexSet(index: rowIndex))
      
      let newRowIndex = tasks.completedTasks.count-1
      completedTable.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withRowType: CompletedTaskRowController.RowType)
      
      let row = completedTable.rowControllerAtIndex(newRowIndex) as! CompletedTaskRowController
      row.populateWithTask(task)
      
      self.updateAddTaskButton()
      self.updateCompletedLabel()
    }
    else {
      let row = ongoingTable.rowControllerAtIndex(rowIndex) as! OngoingTaskRowController
      animateWithDuration(0.4) {
        row.updateProgressWithTask(task, frameWidth:self.contentFrame.size.width)
      }
    }
    saveTasks()
  }
}

// MARK: Populate Tables
extension TasksInterfaceController {
  func loadOngoingTasks() {
    ongoingTable.setNumberOfRows(tasks.ongoingTasks.count, withRowType: OngoingTaskRowController.RowType)
    for i in 0..<ongoingTable.numberOfRows {
      let row = ongoingTable.rowControllerAtIndex(i) as! OngoingTaskRowController
      let task = tasks.ongoingTasks[i]
      row.populateWithTask(task, frameWidth:contentFrame.size.width)
    }
    
    updateAddTaskButton()
  }
  
  func updateOngoingTasksIfNeeded() {
    if ongoingTable.numberOfRows < tasks.ongoingTasks.count {
      // 1
      let newRowIndex = tasks.ongoingTasks.count-1
      ongoingTable.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withRowType: OngoingTaskRowController.RowType)
      
      // 2
      let row = ongoingTable.rowControllerAtIndex(newRowIndex) as! OngoingTaskRowController
      row.populateWithTask(tasks.ongoingTasks.last!, frameWidth: contentFrame.size.width)
      
      saveTasks()
      updateAddTaskButton()
    }
  }
  
  func loadCompletedTasks() {
    completedTable.setNumberOfRows(tasks.completedTasks.count, withRowType: CompletedTaskRowController.RowType)
    for i in 0..<completedTable.numberOfRows {
      let row = completedTable.rowControllerAtIndex(i) as! CompletedTaskRowController
      let task = tasks.completedTasks[i]
      row.populateWithTask(task)
    }
    
    updateCompletedLabel()
  }
  
  func updateCompletedLabel() {
    completedLabel.setHidden(completedTable.numberOfRows == 0)
  }
  
  func updateAddTaskButton() {
    addTaskButton.setHidden(ongoingTable.numberOfRows != 0)
    
    if (ongoingTable.numberOfRows == 0) {
      addTaskButton.setAlpha(0)
      animateWithDuration(0.4) {
        self.addTaskButton.setAlpha(1)
      }
    }
    
  }
}

// MARK: Task Persistance
extension TasksInterfaceController {
  private var savedTasksPath: String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let docPath = paths.first!
    return (docPath as NSString).stringByAppendingPathComponent("SavedTasks")
  }
  
  func loadSavedTasks() {
    if let data = NSData(contentsOfFile: savedTasksPath) {
      let savedTasks = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! TaskList
      tasks = savedTasks
    } else {
      tasks = TaskList()
    }
  }
  
  func saveTasks() {
    NSKeyedArchiver.archiveRootObject(tasks, toFile: savedTasksPath)
  }
  
  func animateInTableRows() {
    
    animateWithDuration(0.6) {
      for i in 0..<self.ongoingTable.numberOfRows {
        let row = self.ongoingTable.rowControllerAtIndex(i) as! OngoingTaskRowController
        row.spacerGroup.setWidth(0)
        row.progressBackgroundGroup.setAlpha(1)
      }
    }
  }
}
