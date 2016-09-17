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
    if (lhs.name == rhs.name) && (lhs.price.compare(rhs.price) == ComparisonResult.orderedSame) {
        return true
    }
    return false
}

private func findIndex(of product: ProductData, in products: [ProductData]) -> Int? {
    let index = products.index(of: product)
    return index
}

class ProductData: NSObject {
    dynamic var name: String!
    var price: NSDecimalNumber!
    var image: NSImage?
    var numberOfSales: Int = 0
    
    init(name: String, price: NSDecimalNumber) {
        self.name = name
        self.price = price
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
    
    func objectInProductsAtIndex(_ index: Int) -> AnyObject? {
        return products[index]
    }
    
    func insertObject(_ object: ProductData, inProductsAtIndex index: Int) {
        // manual KVO compliance
        self.willChange(NSKeyValueChange.insertion, valuesAt: IndexSet(integer: index), forKey: "products")
        products.insert(object, at: index)
        self.didChange(NSKeyValueChange.insertion, valuesAt: IndexSet(integer: index), forKey: "products")
    }
    
    func removeObjectFromProductsAtIndex(_ index: Int) {
        // manual KVO compliance
        self.willChange(NSKeyValueChange.removal, valuesAt: IndexSet(integer: index), forKey: "products")
        products.remove(at: index)
        self.didChange(NSKeyValueChange.removal, valuesAt: IndexSet(integer: index), forKey: "products")
    }
    
    // Convenient method
    func indexOfObjectInProducts(_ product: ProductData) -> Int {
        // find function must implement Equtable protocol on ProductData
        if let result = findIndex(of: product, in: self.products) {
            return Int(result)
        }
        else {
            return 0
        }
    }
}
