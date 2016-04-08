//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground
import Foundation


var str = "Hello, playground"

struct Set<T: Hashable> {
    typealias Index = T
    private var dictionary: [T: Bool] = [:]
    
    var count: Int {
        return self.dictionary.count
    }
    
    var isEmpty: Bool {
        return self.dictionary.isEmpty
    }
    
    func contains(element: T) -> Bool {
        return self.dictionary[element] ?? false
    }
    
    mutating func put(element: T) {
        self.dictionary[element] = true
    }
    
    mutating func remove(element: T) -> Bool {
        if self.contains(element) {
            self.dictionary.removeValueForKey(element)
            return true
        } else {
            return false
        }
    }
}


protocol ArrayLiteralConvertible {
    typealias Element
    init(arrayLiteral elements: Element...)
}

extension Set: ArrayLiteralConvertible {
     init(arrayLiteral elements: T...) {
        for element in elements {
            put(element)
        }
    }
}

let set: Set = [1,2,3]
set.contains(1) // true
set.count // 3

