//
//  File.swift
//  
//
//  Created by Kevin Mullins on 1/4/24.
//

import Foundation

/// Objects that support this protocol can be automatically serialized or decoded by routines on the `Serializer` and `Deserializer` classes.
public protocol SimpleSerializeable {
    /// Property that returns the object serialized using a `Serializer`.
    var serialized:String {get}
    
    /// Creates a new instance from a serialized string.
    /// - Parameter value: The serialized string representing an object.
    init(from value:String)
}
