//
//  Deserializer.swift
//  Hexo
//
//  Created by Kevin Mullins on 10/3/23.
//

import Foundation

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
    /// Moves to the next item that was deserialized.
    private func moveNext() {
        if index <= parts.count {
            index += 1
        }
    }
    
    /// Gets the next available string.
    /// - Returns: Returns the next available string or "" if not available.
    public func string() -> String {
        guard index < parts.count else {
            return ""
        }
        
        let text = String(parts[index])
        moveNext()
        
        if text == "<e>" {
            return ""
        } else {
            return text
        }
    }
    
    /// Gets the string at the given index.
    /// - Parameter index: The index to get the string at.
    /// - Returns: Returns the next requested string or "" if not available.
    public func string(at index:Int) -> String {
        guard index >= 0 && index < parts.count else {
            return ""
        }
        
        let text = String(parts[index])
        
        if text == "<e>" {
            return ""
        } else {
            return text
        }
    }
    
    /// Get the next available Int.
    /// - Returns: Returns the next available Int or `0` if not available.
    public func int() -> Int {
        let text = string()
        
        if let value = Int(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the Int at the given index.
    /// - Parameter index: The index to get the Int from.
    /// - Returns: Returns the next requested Int or `0` if not available.
    public func int(at index:Int) -> Int {
        let text = string(at: index)
        
        if let value = Int(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the next available Bool.
    /// - Returns: Returns the next available Bool or `false` if not available.
    public func bool() -> Bool {
        let text = string()
        
        if let value = Bool(text) {
            return value
        } else {
            return false
        }
    }
    
    /// Get the Bool at the given index.
    /// - Parameter index: The index to get the Bool from.
    /// - Returns: Returns the next requested Bool or `false` if not available.
    public func bool(at index:Int) -> Bool {
        let text = string(at: index)
        
        if let value = Bool(text) {
            return value
        } else {
            return false
        }
    }
    
    /// Get the next available Bool.
    /// - Returns: Returns the next available Bool or `false` if not available.
    public func double() -> Double {
        let text = string()
        
        if let value = Double(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the Bool at the given index.
    /// - Parameter index: The index to get the Bool from.
    /// - Returns: Returns the next requested Bool or `false` if not available.
    public func double(at index:Int) -> Double {
        let text = string(at: index)
        
        if let value = Double(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the next available Bool.
    /// - Returns: Returns the next available Bool or `false` if not available.
    public func float() -> Float {
        let text = string()
        
        if let value = Float(text) {
            return value
        } else {
            return 0
        }
    }
    
    /// Get the Bool at the given index.
    /// - Parameter index: The index to get the Bool from.
    /// - Returns: Returns the next requested Bool or `false` if not available.
    public func float(at index:Int) -> Float {
        let text = string(at: index)
        
        if let value = Float(text) {
            return value
        } else {
            return 0
        }
    }
}
