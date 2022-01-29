//
//  SortOptionsModalViewController.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/4/21.
//

import UIKit

protocol SortingOptionsDelegate: AnyObject {
  func changeSortingStyle(style: SortingStyle)
}

final class SortOptionsViewController: UIViewController {
  
  var sortingStyle: SortingStyle = .byAlphabet
  
  weak var delegate: SortingOptionsDelegate?
  
  private var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.layer.cornerRadius = 20
    view.clipsToBounds = true
    return view
  }()
  
  private let maxDimmedAlpha: CGFloat = 0.2
  
  private lazy var dimmedView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    view.alpha = maxDimmedAlpha
    return view
  }()
  
  private let sortLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Сортировка"
    label.textColor = UIColor(named: "TextPrimary")
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "left"), for: .normal)
    button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    return button
  }()
  
  private lazy var optionsTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isScrollEnabled = false
    return tableView
  }()
  
  private let defaultHeight: CGFloat = 300
  
  private let dismissibleHeight: CGFloat = 200
  private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64

  private var currentContainerHeight: CGFloat = 300
  
  private var containerViewHeightConstraint: NSLayoutConstraint?
  private var containerViewBottomConstraint: NSLayoutConstraint?
  
  init(sortingStyle: SortingStyle) {
    super.init(nibName: nil, bundle: nil)
    self.sortingStyle = sortingStyle
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    
    setupLayout()
    setupPanGesture()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    animateContainerPresentation()
  }
  
  private func setupLayout() {
    view.addSubview(dimmedView)
    view.addSubview(containerView)
    containerView.addSubview(optionsTableView)
    containerView.addSubview(backButton)
    containerView.addSubview(sortLabel)
    
    NSLayoutConstraint.activate([
      dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      backButton.heightAnchor.constraint(equalToConstant: 25),
      backButton.widthAnchor.constraint(equalToConstant: 25),
      
      sortLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      sortLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      
      optionsTableView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 16),
      optionsTableView.heightAnchor.constraint(equalToConstant: 200),
      optionsTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      optionsTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
    ])
    
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
    containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)

    containerViewHeightConstraint?.isActive = true
    containerViewBottomConstraint?.isActive = true
  }
  
  private func animateContainerPresentation() {

      UIView.animate(withDuration: 0.3) {
          self.containerViewBottomConstraint?.constant = 0
          self.view.layoutIfNeeded()
      }
  }
  
  private func animateDimmedViewAppearance() {
      dimmedView.alpha = 0
      UIView.animate(withDuration: 0.4) {
          self.dimmedView.alpha = self.maxDimmedAlpha
      }
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
      
      dismiss(animated: true, completion: { [weak self] in
        guard let self = self else {return}
        self.delegate?.changeSortingStyle(style: self.sortingStyle)})
    } else {
      let anotherIndexpath = IndexPath(row: 0, section: 0)
      sortingStyle = .byBirthday

      tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "Selected-29")
      tableView.cellForRow(at: anotherIndexpath)?.imageView?.image = UIImage(named: "Unselected-29")
      
      dismiss(animated: true, completion: { [weak self] in
        guard let self = self else {return}
        self.delegate?.changeSortingStyle(style: self.sortingStyle)})
    }
  }
  
  @objc private func backButtonPressed() {
    print("back button pressed")
    dismiss(animated: true, completion: nil)
  }
  
  private func setupPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
    
    panGesture.delaysTouchesBegan = false
    panGesture.delaysTouchesEnded = false
    view.addGestureRecognizer(panGesture)
  }
  
  @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
    
    let translation = gesture.translation(in: view)
    let isDraggingDown = translation.y > 0
    
    let newHeight = currentContainerHeight - translation.y
    
    switch gesture.state {
    case .changed:
      if newHeight < maximumContainerHeight {
        containerViewHeightConstraint?.constant = newHeight
        view.layoutIfNeeded()
      }
      
    case .ended:
      if newHeight < dismissibleHeight {
        dismiss(animated: true) { [weak self] in
          guard let self = self else {return}
          self.delegate?.changeSortingStyle(style: self.sortingStyle)
        }
      } else if newHeight < defaultHeight {
        animateContainerHeight(defaultHeight)
      } else if newHeight < maximumContainerHeight && isDraggingDown {
        animateContainerHeight(defaultHeight)
      } else if newHeight > defaultHeight && !isDraggingDown {
        animateContainerHeight(maximumContainerHeight)
      }
      
    default:
      break
    }
  }
  
  private func animateContainerHeight(_ height: CGFloat) {
      UIView.animate(withDuration: 0.4) {
          self.containerViewHeightConstraint?.constant = height
          self.view.layoutIfNeeded()
      }

      currentContainerHeight = height
  }
}
