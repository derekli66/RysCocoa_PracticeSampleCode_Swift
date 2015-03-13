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
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        masterController.loadSelectionFromUserDefaults()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        
        // TODO: Verify real file path on Mac
        masterController.saveProductsToFile("~/Desktop/product-data.plist")
        masterController.saveSelectionToUserDefaults()
    }
}

