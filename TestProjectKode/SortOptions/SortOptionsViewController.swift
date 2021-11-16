//
//  SortOptionsModalViewController.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/4/21.
//

import UIKit

final class SortOptionsViewController: UIViewController {
  
  var sortingStyle: SortingStyle = .byAlphabet
  
  private lazy var optionsTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.layer.cornerRadius = 20
    tableView.clipsToBounds = true
    return tableView
  }()
  
  private let dimmedView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    view.alpha = 0.12
    return view
  }()
  
  init(sortingStyle: SortingStyle) {
    super.init(nibName: nil, bundle: nil)
    self.sortingStyle = sortingStyle
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupLayout()
  }
  
  private func setupLayout() {
    view.addSubview(dimmedView)
    view.addSubview(optionsTableView)
    
    NSLayoutConstraint.activate([
      dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      optionsTableView.heightAnchor.constraint(equalToConstant: 300),
      optionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
      optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

// MARK: - TableView delegate, dataSource

extension SortOptionsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.selectionStyle = .none
    
    if indexPath.row == 0 {
      cell.textLabel?.text = "По алфавиту"
      
      if sortingStyle == .byAlphabet {
        cell.imageView?.image = UIImage(named: "Selected-29")
      } else {
        cell.imageView?.image = UIImage(named: "Unselected-29")
      }
    } else {
      cell.textLabel?.text = "По дню рождения"
      
      if sortingStyle == .byBirthday {
        cell.imageView?.image = UIImage(named: "Selected-29")
      } else {
        cell.imageView?.image = UIImage(named: "Unselected-29")
      }
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let anotherIndexpath = IndexPath(row: 1, section: 0)
      sortingStyle = .byAlphabet

      tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "Selected-29")
      tableView.cellForRow(at: anotherIndexpath)?.imageView?.image = UIImage(named: "Unselected-29")
      
      guard let parent = parent as? EmployeeListViewController else {return}
      parent.sortingBy = sortingStyle
      
      willMove(toParent: nil)
      removeFromParent()
      view.removeFromSuperview()
    } else {
      let anotherIndexpath = IndexPath(row: 0, section: 0)
      sortingStyle = .byBirthday

      tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "Selected-29")
      tableView.cellForRow(at: anotherIndexpath)?.imageView?.image = UIImage(named: "Unselected-29")
      
      guard let parent = parent as? EmployeeListViewController else {return}
      parent.sortingBy = sortingStyle
      print(parent.sortingBy)
      
      willMove(toParent: nil)
      removeFromParent()
      view.removeFromSuperview()
    }
  }
}
