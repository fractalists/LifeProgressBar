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
    
    let menuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var _born:Double = 0
    var _newStart:Double = 0
    var _denominator:Double = 0
    
    func timeInterval2Day(ti: TimeInterval) -> Int {
        return Int(ti / (24 * 3600))
    }
    
    func updateProgress() {
        let now = Date().timeIntervalSince1970
        let numerator = now - _born
        let ratio = 100 * numerator / _denominator
        
        DispatchQueue.main.async {
            self.menuItem.title = String(self.timeInterval2Day(ti: numerator)) + "/" + String(self.timeInterval2Day(ti: self._denominator)) + "  " + String(format: "%.3f", ratio) + "%"
        }
    }
    
    @objc func calendarDayDidChange() {
        updateProgress()
    }
    
    @IBAction func configPreferences(_ sender: NSMenuItem) {
        DispatchQueue.global().async {
            var initTitle: String = ""
            DispatchQueue.main.sync {
                initTitle = self.menuItem.title!
            }
            let charCount = initTitle.count
            
            for _ in 1...charCount {
                DispatchQueue.main.async {
                    let str = self.menuItem.title!
                    self.menuItem.title = String(str.dropFirst() + str.prefix(1))
                }
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
    }
    
    @IBAction func moveForward(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NotificationCenter.default.addObserver(self, selector:#selector(calendarDayDidChange), name:.NSCalendarDayChanged, object:nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let born = "1994-04-19 00:00:00"
        let newStart = "2074-04-19 00:00:00"
        
        _born = dateFormatter.date(from: born)!.timeIntervalSince1970
        _newStart = dateFormatter.date(from: newStart)!.timeIntervalSince1970
        _denominator = _newStart - _born
        
        updateProgress()
        
        menuItem.menu = lifeProgressMenu
        let font = menuItem.button!.font!
        menuItem.button!.font = NSFont(name: "Menlo", size: font.pointSize)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Nope
    }
    
}

