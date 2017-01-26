//
//  AppDelegate.swift
//  HeySiriMacOS
//
//  Created by Matthijs Logemann on 16/06/2016.
//  Copyright © 2016 Matthijs Logemann. All rights reserved.
//

import Cocoa
import MenuBarController;

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechRecognizerDelegate {

    let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let SR:NSSpeechRecognizer = NSSpeechRecognizer()!
    var commands = ["Hey siri", "Hola siri", "시리야", "ヘイ シリ", "Dis siri"]
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.title = "Hey Siri listener"
        
        if let button = statusItem.button {

            if UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark" {
                button.image = NSImage(named: "StatusBarButtonImageDark")
            } else {
                button.image = NSImage(named: "StatusBarButtonImage")
            }

            button.image?.isTemplate = true // best for dark mode
            
//          button.action = Selector(("printQuote:"))
            
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: "Resume listening", action: #selector(AppDelegate.resumeListening), keyEquivalent: "r"))
            menu.addItem(NSMenuItem(title: "Stop listening", action: #selector(AppDelegate.stopListening), keyEquivalent: "s"))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit Hey Siri", action: #selector(AppDelegate.quit), keyEquivalent: "q"))
            
            statusItem.menu = menu
        }
        
        
        resumeListening()
        
        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(AppDelegate.stopListening), name: .NSWorkspaceWillSleep, object: nil)
        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(AppDelegate.resumeListening), name: .NSWorkspaceDidWake, object: nil)

    }
    
    func quit() {
        NSApplication.shared().terminate(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func stopListening() {
        SR.stopListening()
        NSApplication.shared().resignFirstResponder()
    }
    
    func resumeListening(){
        NSApplication.shared().becomeFirstResponder()

        SR.commands = commands
        SR.delegate = self
        SR.listensInForegroundOnly = false
        
        SR.startListening(); print("listening")
    }
    
    
    
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        if commands.contains(command)
        {
            NSWorkspace.shared().launchApplication("/Applications/Siri.app")
        }
    }

}

