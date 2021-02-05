//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import APIKit

protocol SearchView: class {
    func updateTableView()
    func showAlert(with errorMessage: String)
}

class SearchViewController: UITableViewController, StoryboardInstantiatable, Injectable {

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
            searchBar.delegate = self
        }
    }
     
    var presenter: SearchPresenter!
    func inject(_ dependency: SearchPresenter) {
        self.presenter = dependency
        self.presenter.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        let repo = presenter.items[indexPath.row]
        cell.textLabel?.text = repo.fullName
        cell.detailTextLabel?.text = repo.language
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.items[indexPath.item]
        let detailVC = DetailViewController.instantiate(with: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: SearchView {
    func updateTableView() {
        self.tableView.reloadData()
    }
    
    func showAlert(with errorMessage: String) {
        //TODO: show alert
        print(errorMessage)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.textDidChange()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        presenter.searchButtonTapped(with: text)
    }
}
