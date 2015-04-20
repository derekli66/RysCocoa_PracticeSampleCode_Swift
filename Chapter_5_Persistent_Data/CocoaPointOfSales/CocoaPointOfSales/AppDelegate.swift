//
//  AppDelegate.swift
//  CocoaPointOfSales
//
//  Created by LEE CHIEN-MING on 2/15/15.
//  Copyright (c) 2015 cheesecake. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var masterController: MasterController!
    
    lazy var desktopPath: String? = {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DesktopDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var aPath: String? = paths.last as? String
        return aPath
    }()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let savingPath = desktopPath?.stringByAppendingPathComponent("product-data.plist") {
            masterController.loadProductsFromFile(savingPath)
        }
        
        // Insert code here to initialize your application
        masterController.loadSelectionFromUserDefaults()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Save product list data to the path
        if let savingPath = desktopPath?.stringByAppendingPathComponent("product-data.plist") {
            masterController.saveProductsToFile(savingPath)
        }
        
        // Save user's selection
        masterController.saveSelectionToUserDefaults()
    }
}

