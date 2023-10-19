//
//  Serializer.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/3/23.
//

import Foundation

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
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:String) -> Serializer {
        let text = (item == "") ? "<e>" : item
        
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
    
    /// Appends the given string value to the serialized list.
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
    
    /// Appends the given string value to the serialized list.
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
}
