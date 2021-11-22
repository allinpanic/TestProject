//
//  ViewController.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/4/21.
//

import UIKit
import SkeletonView

class EmployeeListViewController: UIViewController, UIScrollViewDelegate {
  
  var sortingBy: SortingStyle = .byAlphabet
  
  // MARK: - Private properties
  private var employees: [Employee] = []
  private var filteredEmployees: [Employee] = []
  
  private var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  private var isFiltering: Bool {
    return searchController.isActive || departmentSegmentedControl.selectedSegmentIndex > 0
  }
  
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
    searchController.searchBar.tintColor = UIColor(named: "ContentActivePrimary")
    return searchController
  }()
  
  private lazy var departmentSegmentedControl: DepartmentSegmentedControl = {
    let segmentedControl = DepartmentSegmentedControl(items: ["Все", "Дизайн", "Аналитика", "Менеджмент", "iOS", "Android", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка"])
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.tintColor = UIColor(named: "ContentActivePrimary")
    segmentedControl.apportionsSegmentWidthsByContent = true
    segmentedControl.setAppearance()
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
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
  
  private lazy var employeeTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .white
    tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
    tableView.register(YearSectionView.self, forHeaderFooterViewReuseIdentifier: YearSectionView.reuseIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.isSkeletonable = true
    tableView.estimatedRowHeight = 84
    tableView.backgroundView?.isHidden = true
    return tableView
  }()
  
  private let searchIssueView: SearchIssueView = {
    let view = SearchIssueView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
  }()
  
  // MARK: - ViewDidload
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    setupLayout()
    
    getEmployees()
  }
}

// MARK: - Search delegate

extension EmployeeListViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    
    if searchController.isActive {
      searchController.searchBar.setImage(UIImage(named: "searchActive"), for: .search, state: .normal)
      searchIssueView.isHidden = false
    } else {
      searchController.searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
      searchIssueView.isHidden = true
    }
    
    let searchBar = searchController.searchBar
    let department = getDepartment()
    
    filterContentForSearchText(searchBar.text!, department: department)
  }
  
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    showSortingOptions()
  }
}

// MARK: - Layout

extension EmployeeListViewController {
  private func setupLayout() {
    view.addSubview(searchIssueView)
    view.addSubview(scrollView)
    scrollView.addSubview(departmentSegmentedControl)
    view.addSubview(employeeTableView)
    
    NSLayoutConstraint.activate([
      searchIssueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      searchIssueView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      searchIssueView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      searchIssueView.heightAnchor.constraint(equalToConstant: 118),
      
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      scrollView.heightAnchor.constraint(equalTo: departmentSegmentedControl.heightAnchor),
      scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
      
      departmentSegmentedControl.topAnchor.constraint(equalTo: scrollView.topAnchor),
      departmentSegmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      departmentSegmentedControl.widthAnchor.constraint(equalToConstant: 1020),
      
      employeeTableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 5),
      employeeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      employeeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      employeeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

// MARK: - TableView delegate, datasourse

extension EmployeeListViewController: UITableViewDelegate, SkeletonTableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      return filteredEmployees.count
    }
    return employees.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier,
                                                   for: indexPath) as? EmployeeTableViewCell
    else {return UITableViewCell()}
    
    cell.isSkeletonable = true
    
    if isFiltering {
        cell.employee = filteredEmployees[indexPath.row]
      } else {
        cell.employee = employees[indexPath.row]
      }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 84
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let employee: Employee
    
    if isFiltering {
      employee = filteredEmployees[indexPath.row]
    } else {
      employee = employees[indexPath.row]
    }
    
    let detailViewController = DetailViewController(employee: employee)
    
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return EmployeeTableViewCell.identifier
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if sortingBy == .byBirthday {
      if tableView.numberOfSections > 0 {
        let yearHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: YearSectionView.reuseIdentifier) as? YearSectionView
        
        return yearHeaderView
      }
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section > 0 {
      return 70
    }
    return 0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if sortingBy == .byBirthday {
      return 2
    }
    return 1
  }
}

// MARK: - Private methods

extension EmployeeListViewController {
  private func getDepartment() -> Department {
    switch departmentSegmentedControl.selectedSegmentIndex {
    case 0: return .all
    case 1: return .design
    case 2: return .analytics
    case 3: return .management
    case 4: return .ios
    case 5: return .android
    case 6: return .qa
    case 7: return .back_office
    case 8: return .frontend
    case 9: return .hr
    case 10: return .pr
    case 11: return .backend
    case 12: return .support
    default: return .all
    }
  }
  
  private func filterContentForSearchText(_ searchText: String,
                                            department: Department? = nil) {
      filteredEmployees = employees.filter { (employee: Employee) -> Bool in

        let doesDepartmentMatch = department == .all || employee.department == department
        let containsSearchText = employee.firstName.lowercased().contains(searchText.lowercased()) || employee.lastName.lowercased().contains(searchText.lowercased()) || employee.userTag.lowercased().contains(searchText.lowercased())

        if isSearchBarEmpty {
          return doesDepartmentMatch
        } else {
          return doesDepartmentMatch && containsSearchText
        }
    }
    
    print("filtered - \(filteredEmployees.count)")
    
    
    if filteredEmployees.isEmpty {
      employeeTableView.backgroundView?.isHidden = false
      employeeTableView.backgroundView = searchIssueView
    } else {
      employeeTableView.backgroundView?.isHidden = true
    }

    employeeTableView.reloadData()
  }
  
  private func getEmployees() {
    
    employeeTableView.isSkeletonable = true
    employeeTableView.showAnimatedGradientSkeleton()

    let networkManager = NetworkServiceManager()
    let session = URLSession.shared
    
    let request = networkManager.employeesRequest()
    let errorRequest = networkManager.errorRequest()
    
    networkManager.getData(request: request, session: session) { [weak self] result in
      switch result {
      case .success(let data):
        
        guard let result = networkManager.parseJSON(jsonData: data, toType: RequestResult.self) else {return}
        self?.employees = result.items
        
        DispatchQueue.main.async {
          self?.employeeTableView.stopSkeletonAnimation()
          self?.employeeTableView.hideSkeleton()
          self?.employeeTableView.reloadData()
        }
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    
    let department = getDepartment()
    print(department)
    
    filterContentForSearchText(searchController.searchBar.text ?? "", department: department)
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
