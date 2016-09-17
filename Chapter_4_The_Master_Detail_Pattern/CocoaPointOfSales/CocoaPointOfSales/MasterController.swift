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
        
        // Add some dummy data
        self.productList.insertObject(ProductData(name:"Coffee", price:NSDecimalNumber(string: "1.99")), inProductsAtIndex: 0)
        self.productList.insertObject(ProductData(name:"Latte", price:NSDecimalNumber(string: "3.49")), inProductsAtIndex: 1)
        self.productList.insertObject(ProductData(name:"Flat White", price:NSDecimalNumber(string: "3.99")), inProductsAtIndex: 2)
        
        super.init()
    }
    
    override func awakeFromNib() {
        var options: NSKeyValueObservingOptions = NSKeyValueObservingOptions()
        options.insert(.old)
        options.insert(.new)
        productList.addObserver(self, forKeyPath: "products", options: options, context: nil)
        self.tableView.selectRowIndexes(IndexSet(integer: 2), byExtendingSelection: false)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let change = change,
            let theType = change[.kindKey] as? NSKeyValueChange,
            let indexes = change[.indexesKey] as? IndexSet,
            let index = indexes.first,
            keyPath == "products"
        {
            // optional check
            // Use Swift type switch case
            tableView.beginUpdates()
            switch theType {
            case .insertion:
                // Update the table view to match
                tableView.insertRows(at: indexes, withAnimation: NSTableViewAnimationOptions.slideDown)
            case .removal:
                tableView.removeRows(at: indexes, withAnimation: NSTableViewAnimationOptions.effectFade)
            default:
                break
            }
            tableView.scrollRowToVisible(index)
            tableView.endUpdates()
        }
        
        if let object = object as? ProductData, keyPath == "name" {
            // The selected product's name changed, so refresh that row in the table
            let indexSet = IndexSet(integer: productList.indexOfObjectInProducts(object))
            let columnSet = IndexSet(integer: 0)
            tableView.reloadData(forRowIndexes: indexSet, columnIndexes: columnSet)
        }
    }
    
    @IBAction func insertNewProduct(_ sender: AnyObject) {
        let product: ProductData = ProductData(name: "New Product", price: NSDecimalNumber(string: "1.99"))
        var index = tableView.selectedRow
        if index == -1 {
            // No selection, so insert at top of list
            index = 0
        }
        
        productList.insertObject(product, inProductsAtIndex: index)
        
        // Select the new row
        tableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
    }
    
    @IBAction func removeSelectedProduct(_ sender: AnyObject) {
        let index = tableView.selectedRow
        if index == -1 {
            return
        }
        
        productList.removeObjectFromProductsAtIndex(index)
        
        if productList.countOfProducts() > 0 {
            var newIndex = index - 1
            if newIndex < 0 {
                newIndex = 0
            }
            
            tableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        }
    }
    
    // MARK: NSTableViewDelegate
    func numberOfRows(in tableView: NSTableView) -> Int {
        return productList.countOfProducts()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Request a view for the cell
        let cellView: NSTableCellView = tableView.make(withIdentifier: "ProductNameCell", owner: nil) as! NSTableCellView
        let product: ProductData = productList.objectInProductsAtIndex(row) as! ProductData
        cellView.textField?.stringValue = product.name
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        // Stop observing old product's name property
        detailController.product?.removeObserver(self, forKeyPath: "name")
        
        let selectedRow = tableView.selectedRow
        if selectedRow > -1 {
            let product: ProductData = productList.objectInProductsAtIndex(selectedRow) as! ProductData
            detailController.product = product
            var options: NSKeyValueObservingOptions = NSKeyValueObservingOptions()
            options.insert(.old)
            options.insert(.new)
            detailController.product?.addObserver(self, forKeyPath: "name", options: options, context:nil)
        }
        else {
            detailController.product = nil
        }
    }
    
}
