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
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(cellType: RepositoryCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 98
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RepositoryCell.self, for: indexPath)
        let repository = presenter.repositories[indexPath.item]
        cell.configure(repository: repository)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.repositories[indexPath.item]
        let detailVC = DetailViewController.instantiate(with: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxScrollDistance = max(0, scrollView.contentSize.height - scrollView.bounds.size.height)
        presenter.setIsReachedBottom(maxScrollDistance <= scrollView.contentOffset.y)
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
