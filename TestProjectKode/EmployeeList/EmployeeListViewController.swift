//
//  ViewController.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/4/21.
//

import UIKit

class EmployeeListViewController: UIViewController {
  
  var sortingBy: SortingStyle = .byAlphabet
  
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
  
  private lazy var departmentSegmentedControl: DepartmentSegmentedControl = {
    let segmentedControl = DepartmentSegmentedControl(items: ["Все", "Дизайн", "Аналитика", "Менеджмент", "iOS", "Android", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка"])
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.tintColor = UIColor(named: "ContentActivePrimary")
    segmentedControl.apportionsSegmentWidthsByContent = true
    segmentedControl.setAppearance()
    return segmentedControl
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentSize = CGSize(width: departmentSegmentedControl.frame.width, height: departmentSegmentedControl.frame.height)
    scrollView.delegate = self
    scrollView.isScrollEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
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
    
    showSortingOptions()
  }
  
  private func showSortingOptions() {
    let searchOptions = SortOptionsViewController(sortingStyle: sortingBy)
    searchOptions.view.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(searchOptions.view)
    
    NSLayoutConstraint.activate([
      searchOptions.view.topAnchor.constraint(equalTo: view.topAnchor),
      searchOptions.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      searchOptions.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchOptions.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    self.addChild(searchOptions)
    searchOptions.didMove(toParent: self)
  }
}

// MARK: - Layout

extension EmployeeListViewController {
  private func setupLayout() {
    view.addSubview(searchIssueView)
    view.addSubview(scrollView)
    scrollView.addSubview(departmentSegmentedControl)
    
    NSLayoutConstraint.activate([
      searchIssueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      searchIssueView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      searchIssueView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      searchIssueView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 474),
      searchIssueView.heightAnchor.constraint(equalToConstant: 118),
      
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      scrollView.heightAnchor.constraint(equalTo: departmentSegmentedControl.heightAnchor),
      scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
      
      departmentSegmentedControl.topAnchor.constraint(equalTo: scrollView.topAnchor),
      departmentSegmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      departmentSegmentedControl.widthAnchor.constraint(equalToConstant: 1020)
    ])
  }
}

extension EmployeeListViewController: UIScrollViewDelegate {
  
}
