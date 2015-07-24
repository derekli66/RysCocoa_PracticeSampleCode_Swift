//
//  DetailController.swift
//  CocoaPointOfSales
//
//  Created by LEE CHIEN-MING on 3/13/15.
//  Copyright (c) 2015 cheesecake. All rights reserved.
//

import Cocoa

class DetailController: NSObject {
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var numberOfSalesTextField: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var editImageButton: NSButton!
    @IBOutlet weak var makeSaleButton: NSButton!
    
    var product: ProductData? {
        didSet {
            println("Display product: \(self.product)")
            self.synchronzieWithData()
        }
    }
    
    override func awakeFromNib() {
        self.synchronzieWithData()
    }
    
    func synchronzieWithData() {
        // check optional
        if let product = self.product {
            nameTextField.enabled = true
            priceTextField.enabled = true
            imageView.enabled = true
            imageView.editable = true
            editImageButton.enabled = true
            makeSaleButton.enabled = true
            
            nameTextField.stringValue = product.name
            imageView.image = product.image
            
            let formatter: NSNumberFormatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            
            if let stringValue = formatter.stringFromNumber(product.price) {
                priceTextField.stringValue = stringValue;
            }
            
            numberOfSalesTextField.stringValue = "Sales: \(product.numberOfSales)"

        }
        else {
            // if product is nil
            nameTextField.enabled = false
            priceTextField.enabled = false
            imageView.enabled = false
            imageView.editable = false
            editImageButton.enabled = false
            makeSaleButton.enabled = false
            
            nameTextField.stringValue = ""
            priceTextField.stringValue = ""
            numberOfSalesTextField.stringValue = ""
            imageView.image = nil
            return
        }
    }
    
    @IBAction func changeName(sender: AnyObject) {
        product?.name = nameTextField.stringValue
        self.synchronzieWithData()
    }
    
    @IBAction func changePrice(sender: AnyObject) {
        let notAllowedSet = NSCharacterSet(charactersInString: "0123456789.").invertedSet
        let results = priceTextField.stringValue.componentsSeparatedByCharactersInSet(notAllowedSet)
        let priceAsString = (results as NSArray).componentsJoinedByString("")
        product?.price = NSDecimalNumber(string: priceAsString)
        self.synchronzieWithData()
    }
    
    @IBAction func changeImage(sender: AnyObject) {
        product?.image = imageView.image
        self.synchronzieWithData()
    }
    
    @IBAction func makeSale(sender: AnyObject) {
        product?.numberOfSales++
        self.synchronzieWithData()
    }
    
    @IBAction func selectImageWithPanel(sender: AnyObject) {
        var panel: NSOpenPanel = NSOpenPanel()
        
        panel.allowedFileTypes = ["public.image"]
        
        panel.beginWithCompletionHandler { [weak panel] result in
            if result == NSFileHandlingPanelOKButton {
                if let url = panel?.URLs.first as? NSURL {
                    if let image = NSImage(contentsOfURL: url) {
                        self.product?.image = image
                        self.synchronzieWithData()
                    }
                    else {
                        println("Error loading image: \(url)")
                    }
                }
            }
        }
    }
}