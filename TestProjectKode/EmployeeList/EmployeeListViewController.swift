//
//  ViewController.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/4/21.
//

import UIKit

class EmployeeListViewController: UIViewController {
  
  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Введи имя, тег, почту..."
    searchController.searchBar.delegate = self
    searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "bgSecondary")
    searchController.searchBar.searchTextField.layer.cornerRadius = 16
    searchController.searchBar.searchTextField.clipsToBounds = true
    
    searchController.searchBar.showsBookmarkButton = true
    searchController.searchBar.setImage(UIImage(named: "sortButton"), for: .bookmark, state: .normal)
    searchController.searchBar.setImage(UIImage(named: "sortButtonActive"), for: .bookmark, state: .focused)
    searchController.searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
    definesPresentationContext = true
    return searchController
  }()
  
  private let searchIssueView: SearchIssueView = {
    let view = SearchIssueView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    setupLayout()
  }
  
  
}

extension EmployeeListViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    
    if searchController.isActive {
      searchController.searchBar.setImage(UIImage(named: "searchActive"), for: .search, state: .normal)
      
      searchIssueView.isHidden = false
      
    } else {
      searchController.searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
    
      searchIssueView.isHidden = true
    }
  }
  
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    let searchOptions = SortOptionsViewController()
    searchOptions.view.translatesAutoresizingMaskIntoConstraints = false
    searchOptions.view.layer.cornerRadius = 20
    searchOptions.view.clipsToBounds = true
    
    let dimmedView = UIView()
    dimmedView.translatesAutoresizingMaskIntoConstraints = false
    dimmedView.backgroundColor = .black
    dimmedView.alpha = 0.12
    
    view.addSubview(dimmedView)
    view.addSubview(searchOptions.view)
    
    NSLayoutConstraint.activate([
      dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      searchOptions.view.heightAnchor.constraint(equalToConstant: 300),
      searchOptions.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
      searchOptions.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchOptions.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    
    self.addChild(searchOptions)
    searchOptions.didMove(toParent: self)
  }
}

extension EmployeeListViewController {
  private func setupLayout() {
    view.addSubview(searchIssueView)
    
    NSLayoutConstraint.activate([
      searchIssueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      searchIssueView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      searchIssueView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      searchIssueView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 474),
      searchIssueView.heightAnchor.constraint(equalToConstant: 118)
//      searchIssueView.widthAnchor.constraint(equalToConstant: 118)
    ])
  }
}
