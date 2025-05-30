import XCTest
@testable import SimpleSerializer

final class SimpleSerializerTests: XCTestCase {
    
    enum TestValues: String, SimpleSerializeableEnum {
        case one = "1"
        case two = "2"
        case three = "3"
    }
    
    enum TestInts: Int, SimpleSerializeableEnum {
        case one = 1
        case two = 2
        case three = 3
    }
    
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
    
    func testSerializer() throws {
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append("one")
            .append("two")
        XCTAssert(serializer.value == "one,two")
    }
    
    func testObfuscation() throws {
        let secret = "A hidden message"
        
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append(secret, isObfuscated: true)
        
        let value = serializer.value
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
        let hidden = deserializer.string(isObfuscated: true)
        
        XCTAssert(secret == hidden)
    }
    
    func testStringEnum() throws {
        var test:TestValues = .two
        
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append(test)
        
        let value = serializer.value
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
        test = deserializer.stringEnum()
        
        XCTAssert(test == .two)
    }
    
    func testChildClass() throws {
        let parent:ParentClass = ParentClass(firstChild: ChildClass(one: "1", two: "2"), secondChild: ChildClass(one: "3", two: "4"))
        
        let value = parent.serialized
        let newParent = ParentClass(from: value)
        
        XCTAssert(newParent.secondChild.two == "4")
    }
    
    func testIntEnum() throws {
        var test:TestInts = .two
        
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append(test)
        
        let value = serializer.value
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ",")
        test = deserializer.intEnum()
        
        XCTAssert(test == .two)
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
    
    func testDictionaries() throws {
        var state:[String:String] = [:]
        
        state["1"] = "One"
        state["2"] = "Two"
        state["3"] = "Three"
        
        let serializer = SimpleSerializer.Serializer(divider: ":")
            .append(dictionary: state)
        
        let value = serializer.value
        
        let deserializer = SimpleSerializer.Deserializer(text: value, divider: ":")
        let newState:[String:String] = deserializer.dictionary()
        
        XCTAssert(newState["2"] == "Two")
    }
}
