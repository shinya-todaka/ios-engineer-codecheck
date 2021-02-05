//
//  SearchViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/05.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol SearchPresenter {
    var view: SearchView? { get set }
    var items: [Item] { get }
    func searchButtonTapped(with text: String)
    func textDidChange()
}

class SearchViewPresenter: SearchPresenter {
    
    weak var view: SearchView?
    private(set) var items: [Item] = []
    private var model: SearchModelProtocol
    
    init(model: SearchModelProtocol) {
        self.model = model
        self.model.delegate = self
    }
    
    func searchButtonTapped(with text: String) {
        guard text.count != 0 else { return }
        model.fetchItems(text: text)
    }
    
    func textDidChange() {
        model.sessionTask?.cancel()
    }
}

extension SearchViewPresenter: SearchModelDelegate {
    func didChange(items: [Item]) {
        self.items = items
        DispatchQueue.main.async {
            self.view?.updateTableView()
        }
    }
    
    func didReceive(error: Error) {
        DispatchQueue.main.async {
            //TODO: change error message
            self.view?.showAlert(with: error.localizedDescription)
        }
    }
}
