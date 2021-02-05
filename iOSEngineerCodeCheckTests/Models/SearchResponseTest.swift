//
//  RepositoryTest.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 戸高新也 on 2021/02/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
import XCTest

class RepositoryTest: XCTestCase {

    func testJSONDecoding_WithBadData() {
        let path = Bundle(for: type(of: self)).url(forResource: "SearchRepositories", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        let decoder = JSONDecoder()
        let searchResponse = try? decoder.decode(SearchResponse.self, from: data)
        XCTAssertNotNil(searchResponse)
    }

}
