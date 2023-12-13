import XCTest
@testable import SimpleSerializer

final class SimpleSerializerTests: XCTestCase {
    func testSerializer() throws {
        let serializer = SimpleSerializer.Serializer(divider: ",")
            .append("one")
            .append("two")
        XCTAssert(serializer.value == "one,two")
    }
}
