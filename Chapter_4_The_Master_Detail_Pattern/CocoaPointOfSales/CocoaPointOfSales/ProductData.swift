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

struct ProductData: Equatable {
    var name: String!
    var price: NSDecimalNumber!
    var image: NSImage?
    var numberOfSales: Int?
    
    init(name: String, price: NSDecimalNumber) {
        self.name = name
        self.price = price
    }
}

class ProductListData: NSObject {
    var products: [ProductData] = []
    
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Compliant.html#//apple_ref/doc/uid/20002172
    // Ready for KVO
    func countOfProducts() -> Int {
        return products.count
    }
    
    func objectInProductsAtIndex(index: Int) -> Any? {
        return products[index]
    }
    
    func insertObject(object: ProductData, inProductsAtIndex index: Int) {
        products.insert(object, atIndex: index)
    }
    
    func removeObjectFromProductsAtIndex(index: Int) {
        products.removeAtIndex(index)
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