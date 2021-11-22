//
//  SearchIssueView.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/4/21.
//

import UIKit

final class SearchIssueView: UIView {
  
  private let searchImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "magnifyingGlass")
    return imageView
  }()
  
  private let issueDescriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Мы никого не нашли"
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.textColor = UIColor(named: "TextPrimary")
    return label
  }()
  
  private let adviseLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Попробуй скорректировать запрос"
    label.font = UIFont(name: "Inter", size: 16)
    label.textColor = UIColor(named: "TextSecondary")
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    addSubview(searchImage)
    addSubview(issueDescriptionLabel)
    addSubview(adviseLabel)
    
    NSLayoutConstraint.activate([
      searchImage.centerXAnchor.constraint(equalTo: centerXAnchor),
      searchImage.topAnchor.constraint(equalTo: topAnchor, constant: 80),
      searchImage.heightAnchor.constraint(equalToConstant: 56),
      searchImage.widthAnchor.constraint(equalToConstant: 56),
      
      issueDescriptionLabel.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 8),
      issueDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      adviseLabel.topAnchor.constraint(equalTo: issueDescriptionLabel.bottomAnchor, constant: 12),
      adviseLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
}
