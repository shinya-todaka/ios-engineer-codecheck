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
    var repositories: [Repository] = []
    
    var delegate: SearchModelDelegate?
    var sessionTask: SessionTask?
    
    private var fetchInitialRepositoriesResponse: [String: Result<[Repository], SessionTaskError>] = [:]
    
    func addFetchInitialRepositoriesResponse(query: String, result: Result<[Repository], SessionTaskError>) {
        self.fetchInitialRepositoriesResponse[query] = result
    }
    
    func fetchInitialRepositories(query: String) {
        guard let response = fetchInitialRepositoriesResponse[query] else {
            fatalError("fetchItemsResponse not found when text is \(query)")
        }
        
        switch response {
            case let .failure(error):
                delegate?.didReceive(error: error)
            case let .success(repositories):
                delegate?.didChange(repositories: repositories)
        }
    }
    
    func cancel() {}
    func fetchAdditionalRepositories() {}
}

enum APIErrpr: Error {
    case unknownError
}

class SearchViewPresenterTest: XCTestCase {
  
    func test_searchButtonがタップされた時viewを更新する関数が呼ばれることを確認() {
        XCTContext.runActivity(named: "SearchButtonタップ") { _ in
            XCTContext.runActivity(named: "tableViewがupdateされること") { _ in
                let spy = SearchViewPresenterSpy()
                let stub = SearchModelStub()
                let presenter = SearchViewPresenter(model: stub)
                presenter.view = spy
                let textToSearch = "swift"
                
                let response: Result<[Repository], SessionTaskError> = .success([Repository.template])
                
                stub.addFetchInitialRepositoriesResponse(query: textToSearch, result: response)
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
                let response: Result<[Repository], SessionTaskError> = .failure(SessionTaskError.responseError(APIErrpr.unknownError))
                
                stub.addFetchInitialRepositoriesResponse(query: textToSearch, result: response)
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
}
