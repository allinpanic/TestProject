//
//  NavigationView.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/22/21.
//

import UIKit

final class NavigationView: UIView {
  
  var employee: Employee! {
    didSet {
      guard let url = URL(string: employee.avatarUrl) else {return}
      avatarImageView.kf.setImage(with: url)
      nameLabel.text = employee.firstName + " " + employee.lastName
      tagLabel.text = employee.userTag
      positionLabel.text = employee.position
    }
  }
  
  private var avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 52
    imageView.clipsToBounds = true
    imageView.image = UIImage(color: .green, size: CGSize(width: 104, height: 104))
    return imageView
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(named: "TextPrimary")
    label.font = UIFont(name: "Inter", size: 28)
    label.sizeToFit()
    return label
  }()
  
  private lazy var tagLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(named: "TextTetriary")
    label.font = UIFont(name: "Inter", size: 17)
    label.sizeToFit()
    return label
  }()
  
  private lazy var positionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(named: "TextSecondary")
    label.font = UIFont(name: "Inter", size: 13)
    label.sizeToFit()
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
    addSubview(avatarImageView)
    addSubview(nameLabel)
    addSubview(tagLabel)
    addSubview(positionLabel)
    
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: topAnchor),
      avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: 104),
      avatarImageView.heightAnchor.constraint(equalToConstant: 104),
      
      nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
      nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -(tagLabel.bounds.width + 7)),
      
      tagLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      tagLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
      
      positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
      positionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//      positionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
}
