//
//  SearchViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/05.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

protocol SearchPresenter {
    var view: SearchView? { get set }
    var items: [Item] { get }
    func viewDidLoad()
    func searchButtonTapped(with text: String)
    func textDidChange()
}

class SearchViewPresenter: SearchPresenter {
    var view: SearchView?
    private(set) var items: [Item] = []
    
    func viewDidLoad() {
        
    }
    
    func searchButtonTapped(with text: String) {
        
    }
    
    func textDidChange() {
        
    }
}
