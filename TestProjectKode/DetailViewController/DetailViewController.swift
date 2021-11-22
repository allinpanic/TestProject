//
//  DetailViewController.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/16/21.
//

import UIKit

final class DetailViewController: UIViewController {
  
  var employee: Employee
  
  private lazy var navigationView: NavigationView = {
    let view = NavigationView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.employee = employee
    view.backgroundColor = UIColor(named: "bgSecondary")
    return view
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "actionCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    return tableView
  }()
  
  init(employee: Employee) {
    self.employee = employee
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setNavBarAppearance()
  }
  
  private func setNavBarAppearance() {
    guard let backButtonImage = UIImage(named: "left") else {return}
    
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
    navBarAppearance.backgroundColor = UIColor(named: "bgSecondary")
    navBarAppearance.shadowColor = .clear
    navigationController?.navigationBar.standardAppearance = navBarAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    
    navigationController?.navigationBar.topItem?.backButtonTitle = ""
    navigationController?.navigationBar.tintColor = UIColor(named: "ContentActiveSecondary")
  }
  
  private func setupLayout() {
    view.addSubview(navigationView)
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      navigationView.heightAnchor.constraint(equalToConstant: 200),
      
      tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell(style: .value1, reuseIdentifier: "actionCell")
    cell.selectionStyle = .none
    
    if indexPath.row == 0 {
      cell = UITableViewCell(style: .value1, reuseIdentifier: "actionCell")
      cell.imageView?.image = UIImage(named: "favorite")
      
      if let birthdayString = employee.getBirthday(){
        cell.textLabel?.text = birthdayString
      }
      
      if let age = employee.getAge() {
        cell.detailTextLabel?.text = "\(age)"
      }
      
    } else {
      cell.imageView?.image = UIImage(named: "phone")
      cell.textLabel?.text = employee.phone
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 1 {
      var number = employee.phone
      number.removeAll(where: {$0 == "-"})
      showAction(number: number)
    }
  }
  
  private func showAction(number: String) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let callingAction = UIAlertAction(title: number, style: .default) { _ in
      
      if let phoneCallURL = URL(string: "tel://\(number)") {

          let application:UIApplication = UIApplication.shared
          if (application.canOpenURL(phoneCallURL)) {
              application.open(phoneCallURL, options: [:], completionHandler: nil)
          }
        }
    }
    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    }
    actionSheet.addAction(callingAction)
    actionSheet.addAction(cancelAction)
    actionSheet.view.tintColor = UIColor(named: "ContentActiveSecondary")
    
    present(actionSheet, animated: true, completion: nil)
  }
  
//  private func getDate(string: String) -> Date? {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    
//    let date = dateFormatter.date(from: string)
//
//    return date
//  }
//  
//  private func getBirthdayString(date: Date) -> String? {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .medium
//    dateFormatter.timeStyle = .none
//    
//    dateFormatter.locale = Locale(identifier: "ru")
//    
//    let string = dateFormatter.string(from: date)
//    return string
//  }
//  
//  private func getPrettyString(birthday: String) -> String? {
//    guard let date = getDate(string: birthday) else {return nil}
//    guard let prettyString = getBirthdayString(date: date) else {return nil}
//    
//    return prettyString
//  }
//  
//  private func getAge(birthday: String) -> Int? {
//    guard let date = getDate(string: birthday) else {return nil}
//    let now = Date()
//    let calendar = Calendar.current
//
//    let ageComponents = calendar.dateComponents([.year], from: date, to: now)
//    let age = ageComponents.year!
//    
//    return age
//  }
}
