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
        if let savingPath = self.productDataFilePath() {
            masterController.loadProductsFromFile(savingPath)
        }
        
        // Insert code here to initialize your application
        masterController.loadSelectionFromUserDefaults()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Save product list data to the path
        if let savingPath = self.productDataFilePath() {
            masterController.saveProductsToFile(savingPath)
        }
        
        // Save user's selection
        masterController.saveSelectionToUserDefaults()
    }
    
    func productDataFilePath() -> String? {
        let fm: NSFileManager = NSFileManager.defaultManager()
        let possibleURLs = fm.URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if let url = possibleURLs.first as? NSURL {
            var pathURL: NSURL?
            if let dirName = NSBundle.mainBundle().bundleIdentifier {
                pathURL = url.URLByAppendingPathComponent(dirName, isDirectory: true)
                
                // create directory
                var error: NSError?
                if let dirURL = pathURL,
                       dirPath = pathURL?.path {
                        if !fm.fileExistsAtPath(dirPath, isDirectory: nil) {
                            let success = fm.createDirectoryAtURL(dirURL, withIntermediateDirectories:false, attributes:nil, error:&error)
                            
                            if !success {
                                println("Could not create directory at \(pathURL) \(error?.localizedDescription)")
                                return nil
                            }
                        }
                }
            }
            
            let fileName = "product-data.plist"
            pathURL = pathURL?.URLByAppendingPathComponent(fileName)
            return pathURL?.path
        }
        else {
            return nil
        }
    }
}

