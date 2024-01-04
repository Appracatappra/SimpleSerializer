//
//  Serializer.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/3/23.
//

import Foundation
import SwiftUI
import SwiftletUtilities

/// A simple utility for **Serializing** a Swift object in the smallest space possible by converting it to a **Divider** separated `String`.
open class Serializer {
    public typealias StringRepresentable<T : RawRepresentable & Hashable> = T
      where T.RawValue == String
    
    public typealias IntRepresentable<T : RawRepresentable & Hashable> = T
      where T.RawValue == Int
    
    // MARK: - Properties
    /// Holds the serialized value
    public var value:String = ""
    
    /// The divider used to separate items in the serialized string.
    public var divider:String = ","
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameter divider: The divider used to separate items.
    public init(divider: String) {
        self.divider = divider
    }
    
    /// Creates a new instance.
    /// - Parameter divider: The divider character used to separate the items.
    public init <T>(divider: StringRepresentable<T>) {
        self.divider = divider.rawValue
    }
    
    // MARK: - Functions
    /// Appends the given string value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Parameter isBase64Encoded: if `true`, encode the string to base64 before storing it.
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:String, isBase64Encoded:Bool = false) -> Serializer {
        var text = (item == "") ? "<e>" : item
        
        if isBase64Encoded {
            text = text.base64Encoded()
        }
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends the given string value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append<T>(_ item:StringRepresentable<T>) -> Serializer {
        let text = item.rawValue
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends the given string value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append<T>(_ item:IntRepresentable<T>) -> Serializer {
        let text = "\(item.rawValue)"
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends the given int value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:Int) -> Serializer {
        let text = "\(item)"
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends the given bool value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:Bool) -> Serializer {
        let text = "\(item)"
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends the given double value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:Double) -> Serializer {
        let text = "\(item)"
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends the given float value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:Float) -> Serializer {
        let text = "\(item)"
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends the given CGFloat value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:CGFloat) -> Serializer {
        let text = "\(item)"
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends an object that conforms to `SimpleSerializeable` to the serialized list.
    /// - Parameter child: The child object to serialize.
    /// - Returns: Returns self.
    @discardableResult public func append(_ child:SimpleSerializeable) -> Serializer {
        let text = child.serialized
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    // divider: String
    // <T>(divider: StringRepresentable<T>)
    // divider.rawValue
    
    /// Appends an array of object that conform to `SimpleSerializeable` to the serialized list.
    /// - Parameters:
    ///   - children: The array of objects to append.
    ///   - divider: The divider for the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T:SimpleSerializeable>(children:[T], divider: String) -> Serializer {
        let serializer = Serializer(divider: divider)
        
        // Encode array
        for child in children {
            serializer.append(child.serialized)
        }
        
        let text = serializer.value
        
        if value == "" {
            value = text
        } else {
            value += "\(divider)\(text)"
        }
        
        return self
    }
    
    /// Appends an array of object that conform to `SimpleSerializeable` to the serialized list.
    /// - Parameters:
    ///   - children: The array of objects to append.
    ///   - divider: The divider for the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T:SimpleSerializeable, X>(children:[T], divider: StringRepresentable<X>) -> Serializer {
        return append(children: children, divider: divider.rawValue)
    }
}
