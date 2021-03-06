//
//  EmployeeTableViewCell.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/16/21.
//

import UIKit
import Kingfisher

final class EmployeeTableViewCell: UITableViewCell {
  
  static let identifier = "employeeCell"
  
  var employee: Employee! {
    didSet {
      guard let url = URL(string: employee.avatarUrl) else {return}      
      KingfisherManager.shared.downloader.downloadTimeout = 600
      
      avatar.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
      nameLabel.text = employee.firstName + " " + employee.lastName
      tagLabel.text = employee.userTag
      positionLabel.text = employee?.position
      
      let birthDay = getBirthday(from: employee.birthday)
      
      birthdayLabel.text = birthDay
    }
  }
  
  var sortingStyle: SortingStyle! {
    didSet {
      switch sortingStyle {
      case .byAlphabet:
        birthdayLabel.isHidden = true
      case .byBirthday:
        birthdayLabel.isHidden = false
      case .none:
        birthdayLabel.isHidden = true
      }
    }
  }
  
  private let avatar: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 36
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.isSkeletonable = true
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(named: "TextPrimary")
    label.font = UIFont(name: "Inter", size: 16)
    label.isSkeletonable = true
    label.linesCornerRadius = 10
    label.text = "Name LongSurname"
    return label
  }()
  
  private let tagLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(named: "TextTetriary")
    label.font = UIFont(name: "Inter", size: 14)
    label.isSkeletonable = true
    label.isHiddenWhenSkeletonIsActive = true
    return label
  }()
  
  private let positionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(named: "TextSecondary")
    label.font = UIFont(name: "Inter", size: 13)
    label.isSkeletonable = true
    label.linesCornerRadius = 10
    label.text = "Positionlabel"
    return label
  }()
  
  private let birthdayLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isHidden = true
    label.textColor = UIColor(named: "TextSecondary")
    label.font = UIFont(name: "Inter", size: 15)
    return label
    }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    contentView.isSkeletonable = true
    self.isSkeletonable = true
    
    let views = [avatar, nameLabel, tagLabel, positionLabel, birthdayLabel]
    views.forEach({contentView.addSubview($0)})
    
    NSLayoutConstraint.activate([
      avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
      avatar.heightAnchor.constraint(equalToConstant: 72),
      avatar.widthAnchor.constraint(equalToConstant: 72),
      avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
      
      nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
      
      tagLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
      tagLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
      
      positionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
      
      birthdayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      birthdayLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
    ])
  }
  
  private func getBirthday(from string: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: string) else {return ""}
    dateFormatter.dateFormat = "dd"
    let day = dateFormatter.string(from: date)
    dateFormatter.dateFormat = "MMMM"
    let month = dateFormatter.string(from: date).prefix(3)
    let birthDay = day + " " + month
    return birthDay
  }
}
