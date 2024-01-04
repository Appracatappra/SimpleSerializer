import XCTest
@testable import SimpleSerializer

final class SimpleSerializerTests: XCTestCase {
    func testSerializer() throws {
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append("one")
            .append("two")
        XCTAssert(serializer.value == "one,two")
    }
    
    func testGenerics() throws {
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append(1)
            .append(2)
        
        let deserializer = SimpleSerializer.Deserializer(text: serializer.value, divider: ",")
        let x:Int = deserializer.value() ?? 0
        let y:Int = deserializer.value() ?? 0
        
        XCTAssert(x == 1 && y == 2)
    }
    
    func testArray() throws {
        let names:[String] = ["one", "two", "three"]
        let numbers:[Int] = [1, 2, 3]
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append(array: names, divider: ":")
            .append(array: numbers, divider: ";")
        let value = serializer.value
        
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
        let words:[String] = deserializer.array(divider: ":")
        
        XCTAssert(words[1] == "two")
    }
    
    func testBase64() throws {
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
        
        XCTAssert(script == newScript)
    }
    
    func testNilArray() throws {
        let names:[String?] = ["one", nil, "two"]
        
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append(array: names, divider: ":")
        
        let value = serializer.value
        
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
        let words:[String?] = deserializer.nilArray(divider: ":")
        
        XCTAssert(words[1] == nil)
    }
}
