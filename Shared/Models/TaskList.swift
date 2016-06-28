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

import UIKit

// NSObject Inheritance required for NSCoding
final public class TaskList: NSObject {
  
  public var ongoingTasks: [Task]
  public var completedTasks: [Task]
  
  public init(ongoing: [Task] = [], completed: [Task] = []) {
    self.ongoingTasks = ongoing
    self.completedTasks = completed
  }
}

// MARK: Methods
extension TaskList {
  public func addTaskToFront(task: Task) {
    guard !task.isCompleted else { return }
    ongoingTasks.insert(task, atIndex: 0)
  }
  
  public func addTask(task: Task) {
    if (task.isCompleted) {
      completedTasks.append(task)
    }
    else {
      ongoingTasks.append(task)
    }
  }
  
  public func didTask(task:Task) {
    if task.isCompleted {
      return
    }
    task.completeOnce()
    if task.isCompleted {
      finishedTask(task)
    }
  }
  
  public func finishedTask(task: Task) {
    if let index = ongoingTasks.indexOf(task) {
      ongoingTasks.removeAtIndex(index)
      completedTasks.append(task)
    }
  }
}

// MARK: NSCoding
extension TaskList: NSCoding {
  private struct CodingKeys {
    static let ongoing = "ongoing"
    static let completed = "completed"
  }
  
  public convenience init(coder aDecoder: NSCoder) {
    let ongoing = aDecoder.decodeObjectForKey(CodingKeys.ongoing) as! [Task]
    let completed = aDecoder.decodeObjectForKey(CodingKeys.completed) as! [Task]

    self.init(ongoing: ongoing, completed: completed)
  }
  
  public func encodeWithCoder(encoder: NSCoder) {
    encoder.encodeObject(ongoingTasks, forKey: CodingKeys.ongoing)
    encoder.encodeObject(completedTasks, forKey: CodingKeys.completed)
  }
  
}