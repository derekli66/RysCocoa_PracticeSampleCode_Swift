//
//  ProductData.swift
//  CocoaPointOfSales
//
//  Created by LEE CHIEN-MING on 2/15/15.
//  Copyright (c) 2015 cheesecake. All rights reserved.
//

import Foundation
import Cocoa

func == (lhs: ProductData, rhs: ProductData) -> Bool {
    if (lhs.name == rhs.name) && (lhs.price.compare(rhs.price) == NSComparisonResult.OrderedSame) {
        return true
    }
    return false
}

class ProductData: NSObject, NSCoding, Equatable {
    dynamic var name: String!
    var price: NSDecimalNumber!
    var image: NSImage?
    var numberOfSales: Int = 0
    
    init(name: String, price: NSDecimalNumber) {
        self.name = name
        self.price = price
    }
    
    // conform to protocol NSCoding
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.price = aDecoder.decodeObjectForKey("price") as! NSDecimalNumber
        self.image = aDecoder.decodeObjectForKey("image") as? NSImage
        self.numberOfSales = aDecoder.decodeObjectForKey("numberOfSales") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.price, forKey: "price")
        aCoder.encodeObject(self.image, forKey: "image")
        aCoder.encodeInt32(Int32(self.numberOfSales), forKey: "numberOfSales")
    }
}

class ProductListData: NSObject {
    
    // Using manual KVO
    var products = [ProductData]()
    
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Compliant.html#//apple_ref/doc/uid/20002172
    // Ready for KVO
    func countOfProducts() -> Int {
        return products.count
    }
    
    func objectInProductsAtIndex(index: Int) -> ProductData? {
        return products[index]
    }
    
    func insertObject(object: ProductData, inProductsAtIndex index: Int) {
        // manual KVO compliance
        self.willChange(NSKeyValueChange.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "products")
        products.insert(object, atIndex: index)
        self.didChange(NSKeyValueChange.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "products")
    }
    
    func removeObjectFromProductsAtIndex(index: Int) {
        // manual KVO compliance
        self.willChange(NSKeyValueChange.Removal, valuesAtIndexes: NSIndexSet(index: index), forKey: "products")
        products.removeAtIndex(index)
        self.didChange(NSKeyValueChange.Removal, valuesAtIndexes: NSIndexSet(index: index), forKey: "products")
    }
    
    // Convenient method
    func indexOfObjectInProducts(product: ProductData) -> Int {
        // find function must implement Equtable protocol on ProductData
        if let result = find(self.products, product) {
            return Int(result)
        }
        else {
            return 0
        }
    }
}