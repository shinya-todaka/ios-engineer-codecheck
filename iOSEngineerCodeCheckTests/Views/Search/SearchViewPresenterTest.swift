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
    
    private var fetchRepositoriesResponse: [String: Result<[Repository], Error>] = [:]
    
    func addFetchRepositoriesResponse(text: String, result: Result<[Repository], Error>) {
        self.fetchRepositoriesResponse[text] = result
    }
    
    func fetchItems(text: String) {
        guard let response = fetchRepositoriesResponse[text] else {
            fatalError("fetchItemsResponse not found when text is \(text)")
        }
        
        switch response {
            case let .failure(error):
                delegate?.didReceive(error: error)
            case let .success(repositories):
                delegate?.didChange(repositories: repositories)
        }
    }
}

extension SearchModelStub {
    enum APIErrpr: Error {
        case unknownError
    }
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
                let response: Result<[Repository], Error> = .success([.init(id: 0, fullName: "swift", language: "japanese", stargazersCount: 9, watchersCount: 4, forksCount: 2, openIssuesCount: 2, owner: Owner(avatarUrl: ""))])
                
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
                let response: Result<[Repository], Error> = .failure(SearchModelStub.APIErrpr.unknownError)
                
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
}
