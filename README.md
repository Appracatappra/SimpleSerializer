# SimpleSerializer

![](https://img.shields.io/badge/license-MIT-green) ![](https://img.shields.io/badge/maintained%3F-Yes-green) ![](https://img.shields.io/badge/swift-5.4-green) ![](https://img.shields.io/badge/iOS-13.0-red) ![](https://img.shields.io/badge/macOS-10.15-red) ![](https://img.shields.io/badge/tvOS-13.0-red) ![](https://img.shields.io/badge/watchOS-6.0-red) ![](https://img.shields.io/badge/release-v1.0.8-blue)

A simple utility for **Serializing** a Swift object in the smallest space possible by converting it to a **Divider** separated `String`.

## Overview

`SimpleSerializer` provides an easy way to simply **Serialize** and **Deserialize** a Swift object in the smallest space possible by converting it to a **Divider** separated `String`. Additionally, you have total control over the Properties that get encoded/decoded.

### Keeping Track of Your Divider Characters

You can define an `enum` to keep track the divider's that you are using for **Serialization**. For Example:

```
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

```
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

**NOTE:** Remember to keep the same order when **Serializing** and **Deserializing** a given property, as they are dependent on the specific order.

### Complex Use Case

The following code shows an example of **Serializing** and **Deserializing** a complex object:

```
@Observable class GameGridCell {
    
    // MARK: - Properties
    /// The current tile that has been played at this location.
    var playedTile:GameTile? = nil
    
    /// A tile that the current player is starting to build a new word with.
    var inPlayTile:GameTile? = nil
    
    /// An avaliable bonus at this grid location.
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

**NOTE:** Any `nil` properties will be encoded to the string property `"(e)"`.


