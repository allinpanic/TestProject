//
//  DetailViewController.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/16/21.
//

import UIKit

final class DetailViewController: UIViewController {
  
  let employee: Employee
  
  init(employee: Employee) {
    self.employee = employee
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .darkGray
    title = employee.lastName
  }
}
