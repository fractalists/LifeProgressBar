//
//  AppDelegate.swift
//  LifeProgressBar
//
//  Created by JacobChengZhang on 2018/6/14.
//  Copyright © 2018 xor. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var lifeProgressMenu: NSMenu!
  @IBOutlet weak var moveForward: NSMenuItem!
  @IBOutlet weak var preferences: NSMenuItem!
  
  let statusBarFont = "Menlo"
  let menuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let dateFormatter = DateFormatter()

  var _born:Double = 0
  var _newStart:Double = 0
  var _denominator:Double = 0

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NotificationCenter.default.addObserver(self, selector:#selector(calendarDayDidChange), name:.NSCalendarDayChanged, object:nil)
    
    let born = "1994-04-19 00:00:00"
    let newStart = "2074-04-19 00:00:00"
    
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    _born = dateFormatter.date(from: born)!.timeIntervalSince1970
    _newStart = dateFormatter.date(from: newStart)!.timeIntervalSince1970
    _denominator = _newStart - _born
    
    updateProgress()
    
    menuItem.menu = lifeProgressMenu
    menuItem.button!.font = NSFont(name: statusBarFont, size: menuItem.button!.font!.pointSize)
  }

  func updateProgress() {
      let now = Date().timeIntervalSince1970
      let numerator = now - _born
      let ratio = 100 * numerator / _denominator
    
      DispatchQueue.main.async {
          self.menuItem.title = String(self.timeInterval2Day(ti: numerator)) +
                                      "/" +
                                      String(self.timeInterval2Day(ti: self._denominator)) +
                                      " " +
                                      String(format: "%.3f", ratio) +
                                      "%"
      }
  }

  func anime() {
      DispatchQueue.global().async {
          var initTitle: String = ""
          DispatchQueue.main.sync {
              initTitle = self.menuItem.title!
          }
          let charCount = initTitle.count
        
          for i in 1...(charCount * 10) {
              Thread.sleep(forTimeInterval: 2.0 / Double(i))
              DispatchQueue.main.async {
                  let str = self.menuItem.title!
                  self.menuItem.title = String(String(str.last!) + str.dropLast())
              }
          }
          for i in 1...(charCount * 5) {
              Thread.sleep(forTimeInterval: 2.0 / Double(2 * (charCount * 5 + 1 - i)))
              DispatchQueue.main.async {
                  let str = self.menuItem.title!
                  self.menuItem.title = String(String(str.last!) + str.dropLast())
              }
          }
      }
  }

  @objc func calendarDayDidChange() {
      updateProgress()
      anime()
  }

  @IBAction func configPreferences(_ sender: NSMenuItem) {
      anime()
  }

  @IBAction func moveForward(_ sender: NSMenuItem) {
      NSApplication.shared.terminate(self)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
      // Nope
  }
  
  func timeInterval2Day(ti: TimeInterval) -> Int {
    return Int(ti / (24 * 3600))
  }
    
}
