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
final public class Task: NSObject {
  
  public let name: String
  public var color: Color
  
  public var totalTimes: Int
  public var timesCompleted: Int
  
  public var isCompleted: Bool {
    return totalTimes == timesCompleted
  }
  
  public init(name: String, color: Color = .Red, totalTimes: Int = 0, timesCompleted: Int = 0) {
    self.name = name
    self.color = color
    self.totalTimes = totalTimes
    self.timesCompleted = timesCompleted
  }
}

// MARK: Public
extension Task {
  public func completeOnce() {
    if (!isCompleted) {
      timesCompleted += 1
    }
  }
}

// MARK: Color
extension Task {
  public enum Color: Int, CustomStringConvertible {
    case Blue, Purple, Green, Yellow, Orange, Red
    public static let allColors = [Blue, Purple, Green, Yellow, Orange, Red]
    
    public var name: String {
      switch self {
      case .Blue:     return "Blue"
      case .Purple:   return "Purple"
      case .Green:    return "Green"
      case .Orange:   return "Orange"
      case .Yellow:   return "Yellow"
      case .Red:      return "Red"
      }
    }
    
    public var color: UIColor {
      switch self {
      case .Blue:     return UIColor(red: 32/255.0, green: 148/255.0, blue: 250/255.0, alpha: 1)
      case .Purple:     return UIColor(red: 120/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
      case .Green:    return UIColor(red: 4/255.0, green: 222/255.0, blue: 113/255.0, alpha: 1)
      case .Orange:   return UIColor(red: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1)
      case .Yellow:   return UIColor(red: 250/255.0, green: 200/255.0, blue: 20/255.0, alpha: 1)
      case .Red:      return UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
      }
    }
    
    public var description: String {
      return name
    }
  }
}

// MARK: Equality
//extension Task: Equatable { }
public func ==(lhs: Task, rhs: Task) -> Bool {
  return lhs.name == rhs.name && lhs.color == rhs.color && lhs.totalTimes == rhs.totalTimes
}

// MARK: NSCoding
extension Task: NSCoding {
  private struct CodingKeys {
    static let name = "name"
    static let color = "color"
    static let totalTimes = "totalTimes"
    static let timesCompleted = "timesCompleted"
  }
  
  public convenience init(coder aDecoder: NSCoder) {
    let name = aDecoder.decodeObjectForKey(CodingKeys.name) as! String
    let color = Color(rawValue: aDecoder.decodeIntegerForKey(CodingKeys.color))!
    let totalTimes = aDecoder.decodeIntegerForKey(CodingKeys.totalTimes)
    let timesCompleted = aDecoder.decodeIntegerForKey(CodingKeys.timesCompleted)
    self.init(name: name, color: color, totalTimes: totalTimes, timesCompleted: timesCompleted)
  }
  
  public func encodeWithCoder(encoder: NSCoder) {
    encoder.encodeObject(name, forKey: CodingKeys.name)
    encoder.encodeInteger(color.rawValue, forKey: CodingKeys.color)
    encoder.encodeInteger(totalTimes, forKey: CodingKeys.totalTimes)
    encoder.encodeInteger(timesCompleted, forKey: CodingKeys.timesCompleted)
  }
}
