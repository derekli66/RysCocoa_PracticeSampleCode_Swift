//
//  Document.swift
//  SimpleTextEditor
//
//  Created by LEE CHIEN-MING on 7/24/15.
//  Copyright (c) 2015 CHIENMING LEE. All rights reserved.
//

import Cocoa
import AppKit

class Document: NSDocument {
    
    private(set) var text: NSTextStorage  // make text be readonly
    
    @IBOutlet var textView: NSTextView!

    override init() {
        
        self.text = NSTextStorage(string: "")
        
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    convenience init(type typeName: String) throws {
        self.init()
        let attributedString = NSAttributedString(string: "Hello! World!")
        self.text.appendAttributedString(attributedString)
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.

        let aView: NSView = NSView(frame: NSMakeRect(20.0, 20.0, 100.0, 100.0))
        aView.wantsLayer = true
        aView.layer?.backgroundColor = NSColor.redColor().CGColor
        aController.window?.contentView?.addSubview(aView)
        textView.layoutManager?.replaceTextStorage(text)
        
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        let plainText = text.string
        var data = plainText.dataUsingEncoding(NSUTF8StringEncoding)
        data = data ?? NSData()
        return data!
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
        let plainText = String(data: data, encoding: NSUTF8StringEncoding)
        let range = NSMakeRange(0, self.text.length)
        self.text.replaceCharactersInRange(range, withString: plainText ?? "" )
    }

    override func prepareSavePanel(savePanel: NSSavePanel) -> Bool {
        savePanel.extensionHidden = false
        savePanel.canSelectHiddenExtension = false
        savePanel.message = "Select a destination for your text file."
        return true
    }
}

