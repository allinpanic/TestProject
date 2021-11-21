//
//  YearSectionView.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/18/21.
//

import UIKit

final class YearSectionView: UITableViewHeaderFooterView {
  
  static let reuseIdentifier  = "header"
  
  private let leftLine: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(color: UIColor(named: "ContentSecondary") ?? .systemGray, size: CGSize(width: 72, height: 0.5))
    imageView.layer.cornerRadius = 3
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let rightLine: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(color: UIColor(named: "ContentSecondary") ?? .systemGray, size: CGSize(width: 72, height: 0.5))
    imageView.layer.cornerRadius = 3
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let yearLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "2022"
    label.textColor = UIColor(named: "TextTetriary")
    label.font = UIFont(name: "Inter", size: 15)
    return label
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    addSubview(leftLine)
    addSubview(rightLine)
    addSubview(yearLabel)
    
    NSLayoutConstraint.activate([
      //leftLine.topAnchor.constraint(equalTo: topAnchor, constant: 34),
      leftLine.centerYAnchor.constraint(equalTo: centerYAnchor),
      leftLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      leftLine.widthAnchor.constraint(equalToConstant: 72),
      
//      rightLine.topAnchor.constraint(equalTo: topAnchor,constant: 34),
      rightLine.centerYAnchor.constraint(equalTo: centerYAnchor),
      rightLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      rightLine.widthAnchor.constraint(equalToConstant: 72),
      
      yearLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      yearLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
