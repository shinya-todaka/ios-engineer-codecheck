//
//  SearchViewPresenterTest.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 戸高新也 on 2021/02/05.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
import APIKit
@testable import iOSEngineerCodeCheck

class SearchViewPresenterSpy: SearchView {
    private(set) var countOfInvokingUpdateTableView: Int = 0
    private(set) var countOfInvokingShowAlert: Int = 0
    
    var _showAlert: ((String) -> Void)?
    var _updateTableView: (() -> Void)?
    
    func updateTableView() {
        self.countOfInvokingUpdateTableView += 1
        self._updateTableView?()
    }
    
    func showAlert(with errorMessage: String) {
        self.countOfInvokingShowAlert += 1
        self._showAlert?(errorMessage)
    }
}

class SearchModelStub: SearchModelProtocol {
    var delegate: SearchModelDelegate?
    var sessionTask: SessionTask?
    
    private var fetchRepositoriesResponse: [String: Result<[Item], Error>] = [:]
    
    func addFetchRepositoriesResponse(text: String, result: Result<[Item], Error>) {
        self.fetchRepositoriesResponse[text] = result
    }
    
    func fetchItems(text: String) {
        guard let response = fetchRepositoriesResponse[text] else {
            fatalError("fetchUserResponse not found when emailAddress is \(text)")
        }
        
        switch response {
            case let .failure(error):
                delegate?.didReceive(error: error)
            case let .success(items):
                delegate?.didChange(items: items)
        }
    }
}

extension SearchModelStub {
    enum APIErrpr: Error {
        case unknownError
    }
}

class SearchViewPresenterTest: XCTestCase {
    
    func testFetchItems() {
        XCTContext.runActivity(named: "SearchButtonタップ") { _ in
            XCTContext.runActivity(named: "tableViewがupdateされること") { _ in
                let spy = SearchViewPresenterSpy()
                let stub = SearchModelStub()
                let presenter = SearchViewPresenter(model: stub)
                presenter.view = spy
                let textToSearch = "swift"
                let response: Result<[Item], Error> = .success([.init(id: 0, fullName: "swift", language: "japanese", stargazersCount: 9, watchersCount: 4, forksCount: 2, openIssuesCount: 2, owner: Owner(avatarUrl: ""))])
                
                stub.addFetchRepositoriesResponse(text: textToSearch, result: response)
                let exp = XCTestExpectation(description: "searchButtonTappedが呼ばれた後に実行されるupdateTableViewを待つ")
                spy._updateTableView = {
                    exp.fulfill()
                }
                
                presenter.searchButtonTapped(with: textToSearch)
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(spy.countOfInvokingUpdateTableView == 1)
            }
            
            XCTContext.runActivity(named: "ViewControllerのshowAlertが呼ばれること") { _  in
                let spy = SearchViewPresenterSpy()
                let stub = SearchModelStub()
                let presenter = SearchViewPresenter(model: stub)
                presenter.view = spy
                let textToSearch = "swift"
                let response: Result<[Item], Error> = .failure(SearchModelStub.APIErrpr.unknownError)
                
                stub.addFetchRepositoriesResponse(text: textToSearch, result: response)
                let exp = XCTestExpectation(description: "searchButtonTappedが呼ばれた後に実行されるshowAlertを待つ")
                spy._showAlert = { text in
                    exp.fulfill()
                }
                
                presenter.searchButtonTapped(with: textToSearch)
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(spy.countOfInvokingShowAlert == 1)
            }
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
