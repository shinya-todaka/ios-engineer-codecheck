//
//  SearchModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/05.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import APIKit

protocol SearchModelProtocol {
    var delegate: SearchModelDelegate? { get set }
    var sessionTask: SessionTask? { get }
    func fetchItems(text: String)
}

class SearchModel: SearchModelProtocol {
    weak var delegate: SearchModelDelegate?
    private(set) var sessionTask: SessionTask?
    
    func fetchItems(text: String) {
        self.sessionTask = GitHubAPI.call(request: GitHubAPI.SearchRepositories(query: text)) { [weak self] (result) in
            switch result {
            case let .success(response):
                self?.delegate?.didChange(items: response.items)
            case let .failure(error):
                self?.delegate?.didReceive(error: error)
            }
        }
    }
}

protocol SearchModelDelegate: class {
    func didChange(items: [Item])
    func didReceive(error: Error)
}
