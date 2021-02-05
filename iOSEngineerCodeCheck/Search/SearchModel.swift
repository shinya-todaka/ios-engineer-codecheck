//
//  SearchModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/05.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

protocol SearchModelDelegate: class {
    func didChange(items: [Item])
    func didReceive(error: Error)
}

class SearchModel {
    weak var delegate: SearchModelDelegate?
    
    func fetchItems(text: String) {
        
    }
}
