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
  let defaults = UserDefaults.standard

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NotificationCenter.default.addObserver(self, selector:#selector(calendarDayDidChange), name:.NSCalendarDayChanged, object:nil)
    dateFormatter.dateFormat = "YYYYMMdd"
    
//    defaults.removeObject(forKey: "notFirstTime")
//    defaults.removeObject(forKey: "born")
//    defaults.removeObject(forKey: "newStart")
    
    if (!defaults.bool(forKey: "notFirstTime")) {
      setDate(firstTime: true)
      defaults.set(true, forKey: "notFirstTime")
    }

    updateProgress()
    
    menuItem.menu = lifeProgressMenu
    menuItem.button!.font = NSFont(name: statusBarFont, size: menuItem.button!.font!.pointSize)
  }

  func updateProgress() {
    let born = dateFormatter.date(from: defaults.string(forKey: "born")!)!.timeIntervalSince1970
    let newStart = dateFormatter.date(from: defaults.string(forKey: "newStart")!)!.timeIntervalSince1970
    let denominator = newStart - born
    
    let now = Date().timeIntervalSince1970
    let numerator = now - born
    let ratio = 100 * numerator / denominator
  
    DispatchQueue.main.async {
      self.menuItem.title = String(self.timeInterval2Day(ti: numerator)) +
                                    "/" +
                                    String(self.timeInterval2Day(ti: denominator)) +
                                    " " +
                                    String(format: "%.3f", ratio) +
                                    "%"
    }
  }

  func anime() {
    preferences.isEnabled = false
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
      
      DispatchQueue.main.async {
        self.preferences.isEnabled = true
      }
    }
  }

  @objc func calendarDayDidChange() {
    updateProgress()
    anime()
  }

  @IBAction func configPreferences(_ sender: NSMenuItem) {
    setDate(firstTime: false)
    anime()
  }
  
  func setDate(firstTime: Bool) {
    if (firstTime) {
      
      var notSet: Bool = true
      repeat {
        let dialog = NSAlert()
        dialog.messageText = "Set your birthday and that day:"
        dialog.informativeText = "Both in format of \"YYYYMMdd\" e.g.\n19991231\n29990101"
        dialog.alertStyle = .informational
        
        let date1 = NSTextField(frame: NSRect(x: 0, y: 2, width: 200, height: 24))
        let date2 = NSTextField(frame: NSRect(x: 0, y: 28, width: 200, height: 24))
        date2.nextKeyView = date1
        let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 58))
        
        stackViewer.addSubview(date1)
        stackViewer.addSubview(date2)
        dialog.accessoryView = stackViewer
        dialog.addButton(withTitle: "OK")
        dialog.addButton(withTitle: "Quit")
        
        let response: NSApplication.ModalResponse = dialog.runModal()
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
          let d1 = dateFormatter.date(from: date1.stringValue)
          let d2 = dateFormatter.date(from: date2.stringValue)
          let now = Date()
          if (d1 != nil && d2 != nil && d1! > now && now > d2!) {
            defaults.set(date2.stringValue, forKey: "born")
            defaults.set(date1.stringValue, forKey: "newStart")
            updateProgress()
            notSet = false;
          }
        } else {
          NSApplication.shared.terminate(self)
        }
      } while (notSet)
      
    } else {
      
      let dialog = NSAlert()
      dialog.messageText = "Set your birthday and that day:"
      dialog.informativeText = "Both in format of \"YYYYMMdd\" e.g.\n19991231\n29990101"
      dialog.alertStyle = .informational
      
      let date2 = NSTextField(frame: NSRect(x: 0, y: 28, width: 200, height: 24))
      let date1 = NSTextField(frame: NSRect(x: 0, y: 2, width: 200, height: 24))
      date2.nextKeyView = date1
      let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 58))
      
      stackViewer.addSubview(date1)
      stackViewer.addSubview(date2)
      dialog.accessoryView = stackViewer
      dialog.addButton(withTitle: "OK")
      dialog.addButton(withTitle: "Cancel")
      
      let response: NSApplication.ModalResponse = dialog.runModal()
      if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
        let d2 = dateFormatter.date(from: date2.stringValue)
        let d1 = dateFormatter.date(from: date1.stringValue)
        let now = Date()
        if (d2 != nil && d1 != nil && d2! < now && now < d1!) {
          defaults.set(date2.stringValue, forKey: "born")
          defaults.set(date1.stringValue, forKey: "newStart")
          updateProgress()
        }
      } else {
        // do nothing
      }
      
    }
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
