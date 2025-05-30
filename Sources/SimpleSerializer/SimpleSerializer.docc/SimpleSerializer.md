# ``SimpleSerializer``

A simple utility for **Serializing** a Swift object in the smallest space possible by converting it to a **Divider** separated `String`. Useful when you need to store an object in a `String` container such as **User Preferences**.

## Overview

`SimpleSerializer` provides an easy way to simply **Serialize** and **Deserialize** a Swift object in the smallest space possible by converting it to a **Divider** separated `String`. Additionally, you have total control over the Properties that get encoded/decoded.

### Keeping Track of Your Divider Characters

You can define an `enum` to keep track the divider's that you are using for **Serialization**. For Example:

```swift
enum Divider:String, Codable {
    case gameTile = ";"
    case tileElement = ">"
    case tileBag = "<"
    case word = "/"
    case player = "$"
    case playerElement = "^"
    case gridCell = "!"
    case gridCellElement = "@"
    case gridCol = "#"
    case bonus = "%"
    case gameState = "|"
    case storedWord = "&"
}
```

### Simple Use Case

The following code shows an example of **Serializing** and **Deserializing** a simple object:

```swift
@Observable class BonusSpot {
    
    // MARK: - Properties
    /// The amount of the bonus.
    var multiplier:Int = 0
    
    /// If `true`, the bonus is active, else it is not.
    var isEnabled:Bool = false
    
    // MARK: - Computed Properties
    /// Returns the `BonusSpot` as a serialized string.
    var serialized:String {
        let serializer = Serializer(divider: Divider.bonus)
            .append(multiplier)
            .append(isEnabled)
        
        return serializer.value
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - multiplier: The bonus amount.
    ///   - isEnabled: If `true`, the bonus is active, else it is not.
    init(multiplier: Int, isEnabled: Bool = true) {
        self.multiplier = multiplier
        self.isEnabled = isEnabled
    }
    
    /// Creates a new instance from a serialized string.
    /// - Parameter value: The serialized string representing the `BonusSpot`.
    init(from value:String) {
        let deserializer = Deserializer(text: value, divider: Divider.bonus)
        
        self.multiplier = deserializer.int()
        self.isEnabled = deserializer.bool()
    }
}
```

> Remember to keep the same order when **Serializing** and **Deserializing** a given property, as they are dependent on the specific order.

### Encoding/Decoding Enumerations

**SimpleSerializer** has built-in methods for enumerations that have a `RawValue` of either `String` or `Int`. Take a look at the following examples.

For Strings:

```swift
enum TestValues: String, SimpleSerializeableEnum {
    case one = "1"
    case two = "2"
    case three = "3"
}

...

var test:TestValues = .two
        
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(test)
    
let value = serializer.value
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
test = deserializer.stringEnum() // Test will equal .two
```

For Integers:

```swift
enum TestInts: Int, SimpleSerializeableEnum {
    case one = 1
    case two = 2
    case three = 3
}

...

var test:TestInts = .two
        
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(test)
    
let value = serializer.value
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
test = deserializer.intEnum() // Test will equal .two
```

Optionally, you can use the following method to decode enumerations:

```swift
enum TestInts: Int, Hashable {
    case one = 1
    case two = 2
    case three = 3
}

...

var test:TestInts = .two
        
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(test)
    
let value = serializer.value
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")

// Get the next value and default to first case if
// Unable to decode.
test = deserializer.value() ?? .one
```

### Encoding/Decoding Conforming Classes

**SimpleSerializer** includes methods for working with Classes that conform to the `SimpleSerializeable` protocol. Take a look at the following example:

```swift
class ChildClass: SimpleSerializeable {
    var one: String = ""
    var two: String = ""
    
    var serialized: String {
        let serializer = SimpleSerializer.Serializer(divider: ":")
            .append(one)
            .append(two)
        return serializer.value
    }
    
    init(one:String, two:String) {
        self.one = one
        self.two = two
    }
    
    required init(from value: String) {
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ":")
        self.one = deserializer.string()
        self.two = deserializer.string()
    }
}
    
class ParentClass: SimpleSerializeable {
    var firstChild: ChildClass = ChildClass(one: "", two: "")
    var secondChild: ChildClass = ChildClass(one: "", two: "")
    
    var serialized: String {
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append(firstChild)
            .append(secondChild)
        return serializer.value
    }
    
    init(firstChild:ChildClass, secondChild:ChildClass) {
        self.firstChild = firstChild
        self.secondChild = secondChild
    }
    
    required init(from value: String) {
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
        self.firstChild = deserializer.child()
        self.secondChild = deserializer.child()
    }
}

...

let parent:ParentClass = ParentClass(firstChild: ChildClass(one: "1", two: "2"), secondChild: ChildClass(one: "3", two: "4"))
        
let value = parent.serialized
let newParent = ParentClass(from: value)
```

### Encoding/Decoding Generics

**SimpleSerializer** includes methods for working with generics:

```swift
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(1)
    .append(2)
    
let deserializer = SimpleSerializer.Deserializer(text: serializer.value, divider: ",")
let x:Int = deserializer.value() ?? 0
let y:Int = deserializer.value() ?? 0
```

### Encoding/Decoding Arrays

**SimpleSerializer** includes methods for working with arrays:

```swift
let names:[String] = ["one", "two", "three"]
let numbers:[Int] = [1, 2, 3]
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(array: names, divider: ":")
    .append(array: numbers, divider: ";")
let value = serializer.value
    
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
let words:[String] = deserializer.array(divider: ":")
```

This also works for `nil` arrays:

```swift
let names:[String?] = ["one", nil, "two"]
        
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(array: names, divider: ":")
    
let value = serializer.value
    
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
let words:[String?] = deserializer.nilArray(divider: ":")
```

### Encoding/Decoding Dictionaries

**SimpleSerializer** includes methods for working with Dictionaries:

```swift
var state:[String:String] = [:]
        
state["1"] = "One"
state["2"] = "Two"
state["3"] = "Three"
    
let serializer = SimpleSerializer.Serializer(divider: ":")
    .append(dictionary: state)
    
let value = serializer.value
    
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ":")
let newState:[String:String] = deserializer.dictionary()
```

### Encoding/Decoding Base64 Encoded & Obfuscated Strings

**SimpleSerializer** includes methods for working with Base64 Encoded Strings:

```swift
let script = """
import StandardLib;
    
main {
    var s:string = 'Hello world';
    call @print($s);
}
"""
    
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(script, isBase64Encoded: true)
    
let value = serializer.value
    
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
let newScript = deserializer.string(isBase64Encoded: true)
```

Additionally, you can obfuscate a `String` value:

```swift
let secret = "A hidden message"
        
let serializer = SimpleSerializer.Serializer(divider: ",")
    .append(secret, isObfuscated: true)
    
let value = serializer.value
let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
let hidden = deserializer.string(isObfuscated: true)
```

> **WARNING!** This is NOT a cryptographically secure process! It's only meant to hide specific values against casual "prying-eyes".

### Complex Use Case

The following code shows an example of **Serializing** and **Deserializing** a complex object:

```swift
@Observable class GameGridCell {
    
    // MARK: - Properties
    /// The current tile that has been played at this location.
    var playedTile:GameTile? = nil
    
    /// A tile that the current player is starting to build a new word with.
    var inPlayTile:GameTile? = nil
    
    /// An available bonus at this grid location.
    var bonus:BonusSpot? = nil
    
    // MARK: - Computed Properties
    /// Returns the gird cell as a serialized string.
    var serialized:String {
        let serializer = Serializer(divider: Divider.gridCell)
            .append(encodeTile(playedTile))
            .append(encodeTile(inPlayTile))
            .append(encodeBonus(bonus))
        
        return serializer.value
    }
    
    /// Returns the tile currently on top at this location or `nil` if no tile is available.
    var tile:GameTile? {
        if let tile = inPlayTile {
            return tile
        } else {
            return playedTile
        }
    }
    
    // MARK: - Initializers
    /// Creates a new empty instance.
    init() {
        
    }
    
    /// Creates a new instance from a serialized string.
    /// - Parameter value: The serialized string holding a grid cell.
    init(from value:String) {
        let deserializer = Deserializer(text: value, divider: Divider.gridCell)
        
        self.playedTile = decodeTile(from: deserializer.string())
        self.inPlayTile = decodeTile(from: deserializer.string())
        self.bonus = decodeBonus(from: deserializer.string())
    }
    
    // MARK: - Functions
    /// Encodes a `GameTile`.
    /// - Parameter tile: The tile to encode.
    /// - Returns: Returns the tile as a serialized string or `(e)` if the `GameTile` is `nil`
    private func encodeTile(_ tile:GameTile?) -> String {
        if let tile {
            return tile.serialized
        } else {
            return "(e)"
        }
    }
    
    /// Decodes a `GameTile` from the given serialized string.
    /// - Parameter value: The serialized string holding the `GameTile`.
    /// - Returns: Returns the `GameTile` or `nil` if the value was `(e)`.
    private func decodeTile(from value:String) -> GameTile? {
        if value == "(e)" {
            return nil
        } else {
            return GameTile(from: value)
        }
    }
    
    /// Encodes a `BonusSpot`.
    /// - Parameter bonus: The `BonusSpot` to encode.
    /// - Returns: Returns the encoded `BonusSpot` or `(e)` if the spot was `nil`.
    private func encodeBonus(_ bonus:BonusSpot?) -> String {
        if let bonus {
            return bonus.serialized
        } else {
            return "(e)"
        }
    }
    
    /// Decodes a `BonusSpot` from the given serialized string.
    /// - Parameter value: The serialized string holding the `BonusSpot`.
    /// - Returns: Returns the `BonusSpot` or `nil` if the value was `(e)`.
    private func decodeBonus(from value:String) -> BonusSpot? {
        if value == "(e)" {
            return nil
        } else {
            return BonusSpot(from: value)
        }
    }
}
```

> Any `nil` properties will be encoded to the string property `"(e)"`.

