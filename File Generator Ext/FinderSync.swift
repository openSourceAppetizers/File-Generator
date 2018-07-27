//
//  FinderSync.swift
//  File Generator Ext
//
//  Created by Team on 7/26/18.
//  Copyright © 2018 Team. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    var myFolderURL = URL(fileURLWithPath: "/")
    
    var fileTypes = [["Text Document", "New Text Document.txt"],
                     ["Microsoft Word Document", "New Word Document.docx"],
                     ["Microsoft PowerPoint Presentation", "New PowerPoint Presentation.pptx"],
                     ["Microsoft Excel Worksheet", "New Excel Document.xlsx"]]
    
    override init() {
        super.init()
        
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once.
    }
    
    
    override func endObservingDirectory(at url: URL) {
        // The user is no longer seeing the container's contents.
    }
    
    // MARK: - Menu and toolbar item support
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "")
        let newMenuItem = menu.addItem(withTitle: "New File", action: nil, keyEquivalent: "")
        let newMenu = NSMenu()
        
        var i = 0;
        for fileType in fileTypes
        {
            let submenu = newMenu.addItem(withTitle: fileType[0], action: #selector(createFile) , keyEquivalent: "")
            submenu.tag = i
            i += 1
        }
        
        newMenu.addItem(NSMenuItem.separator())
        newMenu.addItem(withTitle: "Custom...", action: #selector(custom) , keyEquivalent: "")
        
        newMenu.addItem(NSMenuItem.separator())
        newMenu.addItem(withTitle: "Visit us Online...", action: #selector(visit) , keyEquivalent: "")
        
        newMenuItem.submenu = newMenu
        
        return menu
    }
    
    @IBAction func custom(_ sender : AnyObject?)
    {
        let target = FIFinderSyncController.default().targetedURL()
        
        DispatchQueue.main.async
            {
                self.displayCustomAlert(path: target!.path)
        }
    }
    
    func displayCustomAlert(path : String)
    {
        let answer = displayAlert()
        if(answer == "" || answer.hasPrefix("."))
        {
            return
        }
        
        guard let writePath = NSURL(fileURLWithPath: path as String).appendingPathComponent(answer) else { return }
        do
        {
            try "".write(to: writePath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch
        {
            NSLog("\(error)")
        }
    }
    
    func displayAlert() -> String
    {
        let alert = NSAlert()
        alert.messageText = "File Generator"
        alert.informativeText = "Enter the name of the file you want to create (i.e. fileName.txt):"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Create")
        alert.addButton(withTitle: "Cancel")
        
        let ansField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        alert.accessoryView = ansField
        
        let response: NSApplication.ModalResponse = alert.runModal()
        alert.window.initialFirstResponder = ansField
        
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn)
        {
            return ansField.stringValue
        }
        else
        {
            return ""
        }
    }
    
    @IBAction func visit(_ sender : AnyObject?)
    {
        let url = URL(string: "https://www.facebook.com/groups/digitalapple")
        NSWorkspace.shared.open(url!)
    }
    
    @IBAction func createFile(_ sender : AnyObject?)
    {
        let target = FIFinderSyncController.default().targetedURL()
        let name = fileTypes[sender!.tag][1]
        
        guard let writePath = NSURL(fileURLWithPath: target!.path as String).appendingPathComponent(name) else { return }
        do
        {
            try "".write(to: writePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch
        {
            NSLog("\(error)")
        }
    }
    
}

