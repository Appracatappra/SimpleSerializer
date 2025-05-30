//
//  SimpleSerializeableEnum.swift
//  SimpleSerializer
//
//  Created by Kevin Mullins on 5/30/25.
//
import Foundation

/// Protocol to mark an enumeration with an Int or String based `RawValue` as automatically decodeable via the SimpleSerializer.
public protocol SimpleSerializeableEnum: Encodable & Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection {
    
}

/// Extends the `SimpleSerializeableEnum` and inserts default initializers.
public extension SimpleSerializeableEnum {
    /// Creates an instance from a decoder.
    /// - Parameter decoder: The decoder to create the instance from.
    /// - remark: Will default to the first case if unable to decode.
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
    
    /// Creates an instance from the given `String RawValue`
    /// - Parameter value: The string value to decode.
    /// - remark: Will default to the first case if unable to decode.
    init(from value:String) {
        self = Self(rawValue: value as! Self.RawValue) ?? Self.allCases.first!
    }
    
    /// Creates an instance from the given `Int RawValue`
    /// - Parameter value: The int value to decode.
    /// - remark: Will default to the first case if unable to decode.
    init(from value:Int) {
        self = Self(rawValue: value as! Self.RawValue) ?? Self.allCases.first!
    }
}
