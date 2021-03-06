//
//  MasterController.swift
//  CocoaPointOfSales
//
//  Created by LEE CHIEN-MING on 2/16/15.
//  Copyright (c) 2015 cheesecake. All rights reserved.
//

import Cocoa

class MasterController: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var detailController: DetailController!
    
    var productList: ProductListData
    
    override init() {
        self.productList = ProductListData()
        
        super.init()
    }
    
    override func awakeFromNib() {
        productList.addObserver(self,
            forKeyPath: "products",
            options: NSKeyValueObservingOptions.Old | NSKeyValueObservingOptions.New,
            context: nil)
        
        self.tableView.selectRowIndexes(NSIndexSet(index: 2), byExtendingSelection: false)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object is ProductListData {
            if keyPath == "products" {
                let changeTypeAsNumber: NSNumber = change[NSKeyValueChangeKindKey] as! NSNumber
                let changeType: NSKeyValueChange? = NSKeyValueChange(rawValue: changeTypeAsNumber.unsignedLongValue)
                let indexes: NSIndexSet = change[NSKeyValueChangeIndexesKey] as! NSIndexSet
                let index = indexes.firstIndex
                
                // optional check
                if let theType = changeType {
                    // Use Swift type switch case
                    switch theType {
                    case .Insertion:
                        // Update the table view to match
                        tableView.beginUpdates()
                        tableView.insertRowsAtIndexes(NSIndexSet(index: index), withAnimation: NSTableViewAnimationOptions.SlideDown)
                        tableView.scrollRowToVisible(index)
                        tableView.endUpdates()
                    case .Removal:
                        tableView.beginUpdates()
                        tableView.removeRowsAtIndexes(NSIndexSet(index: index), withAnimation: NSTableViewAnimationOptions.EffectFade)
                        tableView.scrollRowToVisible(index)
                        tableView.endUpdates()
                    default:
                        break
                    }
                }
            }
        }
        
        if keyPath == "name" && object is ProductData {
            // The selected product's name changed, so refresh that row in the table
            let indexSet = NSIndexSet(index: productList.indexOfObjectInProducts(object as! ProductData))
            let columnSet = NSIndexSet(index: 0)
            tableView.reloadDataForRowIndexes(indexSet, columnIndexes: columnSet)
        }
    }
    
    // MARK: Public methods
    func saveSelectionToUserDefaults() {
        let currentSelection = tableView.selectedRow
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(currentSelection, forKey: NSUserDefaultsConstants.InitialSelection)
        println("Saved selected row: \(currentSelection)")
    }
    
    func loadSelectionFromUserDefaults() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let initialSelection = defaults.integerForKey(NSUserDefaultsConstants.InitialSelection)
        tableView.selectRowIndexes(NSIndexSet(index: initialSelection), byExtendingSelection: false)
    }
    
    func saveProductsToFile(path: String) {
        var productsArray = [Dictionary<String, AnyObject>]()
        for product in productList.products {
            var productInfo = Dictionary<String, AnyObject>()
            productInfo["name"] = product.name
            productInfo["price"] = product.price
            
            if let image = product.image {
                productInfo["image"] = image
            }
            
            productInfo["numberOfSales"] = NSNumber(integer: product.numberOfSales)
            productsArray.append(productInfo)
        }
        
        (productsArray as NSArray).writeToFile(path, atomically: true)
        
        println("Saved products: %@\nTo file: \(productsArray)")
    }
    
    func loadProductsFromFile(path: String) {
        productList.removeObserver(self, forKeyPath: "products")
        productList = ProductListData()
        productList.addObserver(self, forKeyPath: "products", options:  NSKeyValueObservingOptions.Old | NSKeyValueObservingOptions.New, context: nil)
        
        // Load the array of dictionaries
        if let productAsArray = NSArray(contentsOfFile: path) {
            // Turn the array of dictionaries into products
            for idx in 0..<productAsArray.count {
                let productInfo: Dictionary? = productAsArray[idx] as? Dictionary<String, AnyObject>;
                let name: String? = productInfo?["name"] as? String
                let price: NSNumber? = productInfo?["price"] as? NSNumber
                let anImage: NSImage? = productInfo?["image"] as? NSImage
                let numberOfSales: Int? = (productInfo?["numberOfSales"] as? NSNumber)?.integerValue

                if let proName = name, proPrice = price {
                    let product = ProductData(name: proName, price: NSDecimalNumber(double: proPrice.doubleValue))
                    
                    if let numbers = numberOfSales { product.numberOfSales = numbers }
                    if let image = anImage { product.image = image }
                    
                    productList.insertObject(product, inProductsAtIndex: idx)
                }
            }
            
            println("Loaded products: \(productAsArray) \nFrom file: \(path)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: IBAction
    @IBAction func insertNewProduct(sender: AnyObject) {
        let product: ProductData = ProductData(name: "New Product", price: NSDecimalNumber(string: "1.99"))
        var index = tableView.selectedRow
        if index == -1 {
            // No selection, so insert at top of list
            index = 0
        }
        
        productList.insertObject(product, inProductsAtIndex: index)
        
        // Select the new row
        tableView.selectRowIndexes(NSIndexSet(index: index), byExtendingSelection: false)
    }
    
    @IBAction func removeSelectedProduct(sender: AnyObject) {
        var index = tableView.selectedRow
        if index == -1 {
            return
        }
        
        productList.removeObjectFromProductsAtIndex(index)
        
        if productList.countOfProducts() > 0 {
            var newIndex = index - 1
            if newIndex < 0 {
                newIndex = 0
            }
            
            tableView.selectRowIndexes(NSIndexSet(index: index), byExtendingSelection: false)
        }
    }
    
    // MARK: NSTableViewDelegate
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return productList.countOfProducts()
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Request a view for the cell
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier("ProductNameCell", owner: nil) as! NSTableCellView
        let product: ProductData? = productList.objectInProductsAtIndex(row)
        if let productData = product {
            cellView.textField?.stringValue = productData.name
        }
        
        return cellView
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        // Stop observing old product's name property
        detailController.product?.removeObserver(self, forKeyPath: "name")
        
        let selectedRow = tableView.selectedRow
        if selectedRow > -1 {
            let product: ProductData? = productList.objectInProductsAtIndex(selectedRow)
            detailController.product = product
            detailController.product?.addObserver(self, forKeyPath: "name", options: .New | .Old, context:nil)
        }
        else {
            detailController.product = nil
        }
    }
    
    // MARK: Private methods

    
}
