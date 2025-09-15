//
//  Deserializer.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/3/23.
//

import Foundation
import SwiftUI
import SwiftletUtilities

/// A simple utility for **Deserializering** a Swift object in the smallest space possible by converting it from a **Divider** separated `String`.
open class Deserializer {
    public typealias SubSequence = Substring
    
    public typealias StringRepresentable<T : RawRepresentable & Hashable> = T
      where T.RawValue == String
    
    public typealias IntRepresentable<T : RawRepresentable & Hashable> = T
      where T.RawValue == Int
    
    // MARK: - Properties
    /// The text being deserialized.
    private var text:String = ""
    
    /// The divider used to separate the parts of the string.
    private var divider:String = ""
    
    /// The deserialized parts of the input string.
    private var parts:[SubSequence] = []
    
    /// The current index of items being deserialized.
    private var index:Int = 0
    
    // MARK: - Computed Properies
    /// Returns the number of items that have been deserialized.
    public var items:Int {
        return parts.count
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - text: The text to deserialize.
    ///   - divider: The divider used to separate items in the text.
    public init(text: String, divider: String) {
        self.text = text
        self.divider = divider
        
        if self.text != "<e>" {
            self.parts = self.text.split(separator: self.divider)
        }
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - text: The text to deserialize.
    ///   - divider: The divider used to separate items in the text.
    public init <T>(text: String, divider: StringRepresentable<T>) {
        self.text = text
        self.divider = divider.rawValue
        
        if self.text != "<e>" {
            self.parts = self.text.split(separator: self.divider)
        }
    }
    
    // MARK: - Functions
    /// Decodes any New Line and Carriage Return characters read from a serialized text file.
    /// - Parameter text: The text to decode.
    /// - Returns: Returns the text with any New Line and Carriage Return characters decoded.
    public func decodeNewline(_ text:String) -> String {
        var value = text.replacingOccurrences(of: "</n>", with: "\n")
        value = value.replacingOccurrences(of: "</r>", with: "\r")
        return value
    }
    
    /// Moves to the next item that was deserialized.
    public func moveNext() {
        if index <= parts.count {
            index += 1
        }
    }
    
    /// Show the next part coming up.
    /// - Returns: The next part coming up as a string.
    public func lookAhead() -> String {
        
        if index < items {
            return String(parts[index])
        } else {
            return ""
        }
    }
    
    /// Gets the next available string.
    /// - Returns: Returns the next available string or "" if not available.
    /// - Parameter isBase64Encoded: if `true` decode the string from Base 64.
    /// - Parameter isObfuscated: isObfuscated: If `true`, obfuscate the string before storing it.
    /// - Parameter decodeLinefeeds: If `true` decode any New Line and Carriage Return characters.
    /// - Remark: **WARNING:** This is NOT a cryptographically secure process! It's only meant to hide specific values against casual "prying-eyes".
    public func string(isBase64Encoded:Bool = false, isObfuscated:Bool = false, decodeLinefeeds:Bool = false) -> String {
        guard index < parts.count else {
            return ""
        }
        
        var text = String(parts[index])
        moveNext()
        
        if isObfuscated {
            text = ObfuscationProvider.deobfuscate(text)
        }
        
        if isBase64Encoded {
            text = text.base64Decoded()
        }
        
        if decodeLinefeeds {
            text = decodeNewline(text)
        }
        
        if text == "<e>" {
            return ""
        } else {
            return text
        }
    }
    
    /// Gets the string at the given index.
    /// - Parameter index: The index to get the string at.
    /// - Parameter isBase64Encoded: if `true` decode the string from Base 64.
    /// - Parameter isObfuscated: isObfuscated: If `true`, obfuscate the string before storing it.
    /// - Parameter decodeLinefeeds: If `true` decode any New Line and Carriage Return characters.
    /// - Remark: **WARNING:** This is NOT a cryptographically secure process! It's only meant to hide specific values against casual "prying-eyes".
    /// - Returns: Returns the next requested string or "" if not available.
    public func string(at index:Int, isBase64Encoded:Bool = false, isObfuscated:Bool = false, decodeLinefeeds:Bool = false) -> String {
        guard index >= 0 && index < parts.count else {
            return ""
        }
        
        var text = String(parts[index])
        
        if isObfuscated {
            text = ObfuscationProvider.deobfuscate(text)
        }
        
        if isBase64Encoded {
            text = text.base64Decoded()
        }
        
        if decodeLinefeeds {
            text = decodeNewline(text)
        }
        
        if text == "<e>" {
            return ""
        } else {
            return text
        }
    }
    
    /// Get the Int at the given index.
    /// - Parameter index: The index to get the Int from.
    /// - Returns: Returns the next requested Int or `0` if not available.
    public func int(at index:Int = -1) -> Int {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        if let value = Int(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the Bool at the given index.
    /// - Parameter index: The index to get the Bool from.
    /// - Returns: Returns the next requested Bool or `false` if not available.
    public func bool(at index:Int = -1) -> Bool {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        if let value = Bool(text) {
            return value
        } else {
            return false
        }
    }
    
    /// Get the Double at the given index.
    /// - Parameter index: The index to get the Double from.
    /// - Returns: Returns the next requested Double or `0` if not available.
    public func double(at index:Int = -1) -> Double {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        if let value = Double(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the Float at the given index.
    /// - Parameter index: The index to get the Float from.
    /// - Returns: Returns the next requested Float or `0` if not available.
    public func float(at index:Int = -1) -> Float {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        if let value = Float(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the CGFloat at the given index.
    /// - Parameter index: The index to get the CGFloat from.
    /// - Returns: Returns the next requested CGFloat or `0` if not available.
    public func cgFloat(at index:Int = -1) -> CGFloat {
        
        return CGFloat(float(at: index))
    }
    
    /// Get the Color at the given index.
    /// - Parameter index: The index to get the Color from.
    /// - Returns: Returns the next requested Color or `white` if not available.
    public func color(at index:Int = -1) -> Color {
        let text = string(at: index)
        
        if let value = Color(fromHex: text) {
            return value
        } else {
            return .white
        }
    }
    
    /// Get the next available generic item.
    /// - Returns: The next generic item or `nil` if not available.
    public func value<T>() -> T? {
        
        if T.self is String.Type {
            return self.string() as? T
        } else if T.self is Int.Type {
            return self.int() as? T
        } else if T.self is Bool.Type {
            return self.bool() as? T
        } else if T.self is Double.Type {
            return self.double() as? T
        } else if T.self is Float.Type {
            return self.float() as? T
        } else if T.self is CGFloat.Type {
            return self.cgFloat() as? T
        } else if T.self is Color.Type {
            return self.color() as? T
        }
        
        return nil
    }
    
    /// Get the generic item at the given index.
    /// - Parameter index: The index to get the generic item from.
    /// - Returns: descriptionThe requested generic item or `nil` if not available.
    public func value<T>(at index:Int) -> T? {
        
        if T.self is String.Type {
            return self.string(at: index) as? T
        } else if T.self is Int.Type {
            return self.int(at: index) as? T
        } else if T.self is Bool.Type {
            return self.bool(at: index) as? T
        } else if T.self is Double.Type {
            return self.double(at: index) as? T
        } else if T.self is Float.Type {
            return self.float(at: index) as? T
        } else if T.self is CGFloat.Type {
            return self.cgFloat(at: index) as? T
        } else if T.self is Color.Type {
            return self.color(at: index) as? T
        }
        
        return nil
    }
    
    /// Gets the requested child object conforming to `SimpleSerializeable`.
    /// - Parameter index: The index to get the child from.
    /// - Returns: Returns the requested child.
    public func child<T:SimpleSerializeable>(at index:Int = -1) -> T {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        return T(from: text)
    }
    
    /// Gets the requested child object conforming to `SimpleSerializeable`.
    /// - Parameter index: The index to get the child from.
    /// - Returns: Returns the requested child.
    public func child<T:SimpleSerializeable>(at index:Int = -1) -> T? {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        if text == "<n>" {
            return nil
        } else {
            return T(from: text)
        }
    }
    
    /// Gets the requested array of child objects conforming to `SimpleSerializeable`.
    /// - Parameters:
    ///   - index: The index to get the child from.
    ///   - divider: The divider used to separate items in the array.
    /// - Returns: Returns requested array of child objects.
    public func children<T:SimpleSerializeable>(at index:Int = -1, divider:String) -> [T] {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        var children:[T] = []
        
        guard text != "<e>" else {
            return children
        }
        
        let deserializer = Deserializer(text: text, divider: divider)
        
        // Decode all children
        for _ in 0..<deserializer.items {
            children.append(deserializer.child())
        }
        
        return children
    }
    
    /// Gets the requested array of child objects conforming to `SimpleSerializeable`.
    /// - Parameters:
    ///   - index: The index to get the child from.
    ///   - divider: The divider used to separate items in the array.
    /// - Returns: Returns requested array of child objects.
    public func children<T:SimpleSerializeable>(at index:Int = -1, divider:String) -> [T?] {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        var children:[T?] = []
        
        guard text != "<e>" else {
            return children
        }
        
        let deserializer = Deserializer(text: text, divider: divider)
        
        // Decode all children
        for _ in 0..<deserializer.items {
            children.append(deserializer.child())
        }
        
        return children
    }
    
    /// Gets the requested array of child objects conforming to `SimpleSerializeable`.
    /// - Parameters:
    ///   - index: The index to get the child from.
    ///   - divider: The divider used to separate items in the array.
    /// - Returns: Returns requested array of child objects.
    public func children<T:SimpleSerializeable, X>(at index:Int = -1, divider:StringRepresentable<X>) -> [T] {
        return children(at: index, divider: divider.rawValue)
    }
    
    /// Gets the requested array of child objects conforming to `SimpleSerializeable`.
    /// - Parameters:
    ///   - index: The index to get the child from.
    ///   - divider: The divider used to separate items in the array.
    /// - Returns: Returns requested array of child objects.
    public func children<T:SimpleSerializeable, X>(at index:Int = -1, divider:StringRepresentable<X>) -> [T?] {
        return children(at: index, divider: divider.rawValue)
    }
    
    public func stringEnum<T:SimpleSerializeableEnum>(at index:Int = -1) -> T {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        return T(from: text)
    }
    
    public func intEnum<T:SimpleSerializeableEnum>(at index:Int = -1) -> T {
        var value = 0
        
        if index < 0 {
            value = int()
        } else {
            value = int(at: index)
        }
        
        return T(from: value)
    }
    
    /// Decode an array of generic items.
    /// - Parameters:
    ///   - index: The index to read the array from
    ///   - divider: The divider for the array items.
    /// - Returns: The array of generic items.
    public func array<T>(at index:Int = -1, divider:String) -> [T] {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        var children:[T] = []
        
        guard text != "<e>" else {
            return children
        }
        
        let deserializer = Deserializer(text: text, divider: divider)
        
        // Decode all children
        for _ in 0..<deserializer.items {
            
            if T.self is String.Type {
                if let value = deserializer.string() as? T {
                    children.append(value)
                }
            } else if T.self is Int.Type {
                if let value = deserializer.int() as? T {
                    children.append(value)
                }
            } else if T.self is Bool.Type {
                if let value = deserializer.bool() as? T {
                    children.append(value)
                }
            } else if T.self is Double.Type {
                if let value = deserializer.double() as? T {
                    children.append(value)
                }
            } else if T.self is Float.Type {
                if let value = deserializer.float() as? T {
                    children.append(value)
                }
            } else if T.self is CGFloat.Type {
                if let value = deserializer.cgFloat() as? T {
                    children.append(value)
                }
            } else if T.self is Color.Type {
                if let value = deserializer.color() as? T {
                    children.append(value)
                }
            }
        }
        
        return children
    }
    
    /// Decode an array of generic items.
    /// - Parameters:
    ///   - index: The index to read the array from
    ///   - divider: The divider for the array items.
    /// - Returns: The array of generic items.
    public func nilArray<T>(at index:Int = -1, divider:String) -> [T?] {
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        var children:[T?] = []
        
        guard text != "<e>" else {
            return children
        }
        
        let deserializer = Deserializer(text: text, divider: divider)
        
        // Decode all children
        for _ in 0..<deserializer.items {
            
            if deserializer.lookAhead() == "<n>" {
                deserializer.moveNext()
                children.append(nil)
            } else if T.self is String.Type {
                if let value = deserializer.string() as? T {
                    children.append(value)
                }
            } else if T.self is Int.Type {
                if let value = deserializer.int() as? T {
                    children.append(value)
                }
            } else if T.self is Bool.Type {
                if let value = deserializer.bool() as? T {
                    children.append(value)
                }
            } else if T.self is Double.Type {
                if let value = deserializer.double() as? T {
                    children.append(value)
                }
            } else if T.self is Float.Type {
                if let value = deserializer.float() as? T {
                    children.append(value)
                }
            } else if T.self is CGFloat.Type {
                if let value = deserializer.cgFloat() as? T {
                    children.append(value)
                }
            } else if T.self is Color.Type {
                if let value = deserializer.color() as? T {
                    children.append(value)
                }
            }
        }
        
        return children
    }
    
    /// Decode an array of generic items.
    /// - Parameters:
    ///   - index: The index to read the array from
    ///   - divider: The divider for the array items.
    /// - Returns: The array of generic items.
    public func array<T, X>(at index:Int = -1, divider:StringRepresentable<X>) -> [T] {
        return array(at: index, divider: divider.rawValue)
    }
    
    /// Decode an array of generic items.
    /// - Parameters:
    ///   - index: The index to read the array from
    ///   - divider: The divider for the array items.
    /// - Returns: The array of generic items.
    public func nilArray<T, X>(at index:Int = -1, divider:StringRepresentable<X>) -> [T?] {
        return nilArray(at: index, divider: divider.rawValue)
    }
    
    /// Decodes a string dictionary.
    /// - Parameters:
    ///   - index: The index of the dictionary to decode.
    ///   - keyDivider: The key divider.
    ///   - itemDivider: The item divider.
    /// - Returns: Returns the requested dictionary.
    public func dictionary(at index:Int = -1, keyDivider:String = "|", itemDivider:String = ",") -> [String:String] {
        var dictionary:[String:String] = [:]
        var text = ""
        
        if index < 0 {
            text = string()
        } else {
            text = string(at: index)
        }
        
        let itemDeserializer = Deserializer(text: text, divider: itemDivider)
        for _ in 0..<itemDeserializer.items {
            let entry = itemDeserializer.string()
            let keyDeserializer = Deserializer(text: entry, divider: keyDivider)
            let key = keyDeserializer.string()
            let value = keyDeserializer.string(isBase64Encoded: true)
            dictionary[key] = value
        }
        
        return dictionary
    }
}
