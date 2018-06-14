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

    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
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
            self.statusItem.title = String(self.timeInterval2Day(ti: numerator)) + "/" + String(self.timeInterval2Day(ti: self._denominator)) + "  " + String(format: "%.3f", ratio) + "%"
        }
    }
    
    @objc func calendarDayDidChange() {
        updateProgress()
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
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
        
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Nope
    }
    
}

