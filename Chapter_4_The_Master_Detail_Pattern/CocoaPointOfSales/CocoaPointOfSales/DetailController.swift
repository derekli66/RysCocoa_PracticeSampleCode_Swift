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
            print("Display product: \(self.product)")
            self.synchronzieWithData()
        }
    }
    
    override func awakeFromNib() {
        self.synchronzieWithData()
    }
    
    func synchronzieWithData() {
        // check optional
        if let product = self.product {
            nameTextField.isEnabled = true
            priceTextField.isEnabled = true
            imageView.isEnabled = true
            imageView.isEditable = true
            editImageButton.isEnabled = true
            makeSaleButton.isEnabled = true
            
            nameTextField.stringValue = product.name
            imageView.image = product.image
            
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            
            if let stringValue = formatter.string(from: product.price) {
                priceTextField.stringValue = stringValue;
            }
            
            numberOfSalesTextField.stringValue = "Sales: \(product.numberOfSales)"

        }
        else {
            // if product is nil
            nameTextField.isEnabled = false
            priceTextField.isEnabled = false
            imageView.isEnabled = false
            imageView.isEditable = false
            editImageButton.isEnabled = false
            makeSaleButton.isEnabled = false
            
            nameTextField.stringValue = ""
            priceTextField.stringValue = ""
            numberOfSalesTextField.stringValue = ""
            imageView.image = nil
            return
        }
    }
    
    @IBAction func changeName(_ sender: AnyObject) {
        product?.name = nameTextField.stringValue
        self.synchronzieWithData()
    }
    
    @IBAction func changePrice(_ sender: AnyObject) {
        let priceAsString = priceTextField.stringValue.replacingOccurrences(of: "$", with: "")
        product?.price = NSDecimalNumber(string: priceAsString)
        self.synchronzieWithData()
    }
    
    @IBAction func changeImage(_ sender: AnyObject) {
        product?.image = imageView.image
        self.synchronzieWithData()
    }
    
    @IBAction func makeSale(_ sender: AnyObject) {
        product?.numberOfSales += 1
        self.synchronzieWithData()
    }
}
