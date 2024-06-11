# SimpleSerializer

![](https://img.shields.io/badge/license-MIT-green) ![](https://img.shields.io/badge/maintained%3F-Yes-green) ![](https://img.shields.io/badge/swift-6.0-green) ![](https://img.shields.io/badge/iOS-18.0-red) ![](https://img.shields.io/badge/iPadOS-18.0-red) ![](https://img.shields.io/badge/macOS-15.0-red) ![](https://img.shields.io/badge/tvOS-18.0-red) ![](https://img.shields.io/badge/watchOS-11.0-red) ![](https://img.shields.io/badge/dependency-LogManager-orange) ![](https://img.shields.io/badge/dependency-SwiftletUtilities-orange)

A simple utility for **Serializing** a Swift object in the smallest space possible by converting it to a **Divider** separated `String`.

## Support

If you find `SimpleSerialize` useful and would like to help support its continued development and maintenance, please consider making a small donation, especially if you are using it in a commercial product:

<a href="https://www.buymeacoffee.com/KevinAtAppra" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

It's through the support of contributors like yourself, I can continue to build, release and maintain high-quality, well documented Swift Packages like `SimpleSerialize` for free.

## Installation

**Swift Package Manager** (Xcode 11 and above)

1. In Xcode, select the **File** > **Add Package Dependency…** menu item.
2. Paste `https://github.com/Appracatappra/SimpleSerializer.git` in the dialog box.
3. Follow the Xcode's instruction to complete the installation.

> Why not CocoaPods, or Carthage, or etc?

Supporting multiple dependency managers makes maintaining a library exponentially more complicated and time consuming.

Since, the **Swift Package Manager** is integrated with Xcode 11 (and greater), it's the easiest choice to support going further.

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

> **NOTE:** Remember to keep the same order when **Serializing** and **Deserializing** a given property, as they are dependent on the specific order.

### Complex Use Case

The following code shows an example of **Serializing** and **Deserializing** a complex object:

```
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

> **NOTE:** Any `nil` properties will be encoded to the string property `"(e)"`.

# Documentation

The **Package** includes full **DocC Documentation** for all features.

