//
//  AppDelegate.swift
//  LifeProgressBar
//
//  Created by Apple on 2018/6/14.
//  Copyright © 2018 xor. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var _beginTI:TimeInterval = 0
    var _newStartTI:TimeInterval = 0
    var _denominator:Double = 0
    
    func updateProgress() {
        let nowTI:TimeInterval = Date().timeIntervalSince1970
        let numerator = (nowTI - _beginTI) / (24 * 3600)
        let ratio = 100 * numerator / _denominator
        
        let numeratorInt = Int(numerator)
        let denominatorInt = Int(_denominator)
        
        DispatchQueue.main.async {
            self.statusItem.title = String(numeratorInt) + "/" + String(denominatorInt) + "  " + String(format: "%.3f", ratio) + "%"
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
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let begin = "1994-04-19"
        let newStart = "2074-04-19"
        
        _beginTI = dateFormatter.date(from: begin)!.timeIntervalSince1970
        _newStartTI = dateFormatter.date(from: newStart)!.timeIntervalSince1970
        _denominator = (_newStartTI - _beginTI) / (24 * 3600)
        
        updateProgress()
        
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

