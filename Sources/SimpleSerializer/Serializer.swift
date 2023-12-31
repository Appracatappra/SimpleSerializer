//
//  Serializer.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/3/23.
//

import Foundation
import SwiftUI
import LogManager
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
    
    /// Appends the given Color value to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append(_ item:Color) -> Serializer {
        let text = "\(item.toHex(withPrefix: true, includeAlpha: true))"
        
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
    
    /// Appends an object that conforms to `SimpleSerializeable` to the serialized list.
    /// - Parameter child: The child object to serialize.
    /// - Returns: Returns self.
    @discardableResult public func append(_ child:SimpleSerializeable?) -> Serializer {
        var text = ""
        
        if let child {
            text = child.serialized
        } else {
            text = "<n>"
        }
        
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
        var text = ""
        let serializer = Serializer(divider: divider)
        
        if children.count == 0 {
            text = "<e>"
        } else {
            // Encode array
            for child in children {
                serializer.append(child)
            }
            text = serializer.value
        }
        
        if value == "" {
            value = text
        } else {
            value += "\(self.divider)\(text)"
        }
        
        return self
    }
    
    /// Appends an array of object that conform to `SimpleSerializeable` to the serialized list.
    /// - Parameters:
    ///   - children: The array of objects to append.
    ///   - divider: The divider for the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T:SimpleSerializeable>(children:[T?], divider: String) -> Serializer {
        var text = ""
        let serializer = Serializer(divider: divider)
        
        if children.count == 0 {
            text = "<e>"
        } else {
            // Encode array
            for child in children {
                serializer.append(child)
            }
            text = serializer.value
        }
        
        if value == "" {
            value = text
        } else {
            value += "\(self.divider)\(text)"
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
    
    /// Appends an array of object that conform to `SimpleSerializeable` to the serialized list.
    /// - Parameters:
    ///   - children: The array of objects to append.
    ///   - divider: The divider for the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T:SimpleSerializeable, X>(children:[T?], divider: StringRepresentable<X>) -> Serializer {
        return append(children: children, divider: divider.rawValue)
    }
    
    /// Appends a generic type to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append<T>(_ item:T) -> Serializer {
        
        if let value = item as? String {
            self.append(value)
        } else if let value = item as? Int {
            self.append(value)
        } else if let value = item as? Bool {
            self.append(value)
        } else if let value = item as? Double {
            self.append(value)
        } else if let value = item as? Float {
            self.append(value)
        } else if let value = item as? CGFloat {
            self.append(value)
        } else if let value = item as? Color {
            self.append(value)
        } else {
            Debug.error(subsystem: "SimpleSerializer", category: "Append", "Unknown Type Found")
        }
        
        return self
    }
    
    /// Appends a generic type to the serialized list.
    /// - Parameter item: The item to append.
    /// - Returns: Returns self.
    @discardableResult public func append<T>(_ item:T?) -> Serializer {
        
        if item == nil {
            self.append("<n>")
        } else if let value = item as? String {
            self.append(value)
        } else if let value = item as? Int {
            self.append(value)
        } else if let value = item as? Bool {
            self.append(value)
        } else if let value = item as? Double {
            self.append(value)
        } else if let value = item as? Float {
            self.append(value)
        } else if let value = item as? CGFloat {
            self.append(value)
        } else if let value = item as? Color {
            self.append(value)
        } else {
            Debug.error(subsystem: "SimpleSerializer", category: "Append", "Unknown Type Found")
        }
        
        return self
    }
    
    /// Appends an array of generic types to the serialized list.
    /// - Parameters:
    ///   - array: The array of items to append.
    ///   - divider: The divider character for the items in the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T>(array:[T], divider:String) -> Serializer {
        var text = ""
        let serializer = Serializer(divider: divider)
        
        if array.count == 0 {
            text = "<e>"
        } else {
            for item in array {
                serializer.append(item)
            }
            
            text = serializer.value
        }
        
        if value == "" {
            value = text
        } else {
            value += "\(self.divider)\(text)"
        }
        
        return self
    }
    
    /// Appends an array of generic types to the serialized list.
    /// - Parameters:
    ///   - array: The array of items to append.
    ///   - divider: The divider character for the items in the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T>(array:[T?], divider:String) -> Serializer {
        var text = ""
        let serializer = Serializer(divider: divider)
        
        if array.count == 0 {
            text = "<e>"
        } else {
            for item in array {
                serializer.append(item)
            }
            
            text = serializer.value
        }
        
        if value == "" {
            value = text
        } else {
            value += "\(self.divider)\(text)"
        }
        
        return self
    }
    
    /// Appends an array of generic types to the serialized list.
    /// - Parameters:
    ///   - array: The array of items to append.
    ///   - divider: The divider character for the items in the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T, X>(array:[T], divider:StringRepresentable<X>) -> Serializer {
        return append(array: array, divider: divider.rawValue)
    }
    
    /// Appends an array of generic types to the serialized list.
    /// - Parameters:
    ///   - array: The array of items to append.
    ///   - divider: The divider character for the items in the array.
    /// - Returns: Returns self.
    @discardableResult public func append<T, X>(array:[T?], divider:StringRepresentable<X>) -> Serializer {
        return append(array: array, divider: divider.rawValue)
    }
    
    /// Appends the string dictionary to the serialized list.
    /// - Parameters:
    ///   - dictionary: The dictionary to serialize.
    ///   - keyDivider: The key divider.
    ///   - itemDivider: The item divider.
    /// - Returns: Returns self.
    @discardableResult public func append(dictionary:[String:String], keyDivider:String = "|", itemDivider:String = ",") -> Serializer {
        
        let itemSerializer = Serializer(divider: itemDivider)
        for key in dictionary.keys {
            if let item = dictionary[key] {
                let keySerializer = Serializer(divider: keyDivider)
                    .append(key)
                    .append(item, isBase64Encoded: true)
                
                itemSerializer.append(keySerializer.value)
            }
        }
        
        let text = itemSerializer.value
        
        if value == "" {
            value = text
        } else {
            value += "\(self.divider)\(text)"
        }
        
        return self
    }
}
