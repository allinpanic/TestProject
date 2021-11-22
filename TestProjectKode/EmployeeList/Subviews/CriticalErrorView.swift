//
//  CriticalErrorView.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/22/21.
//

import UIKit

final class CriticalErrorView: UIView {
  
  private let ufoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "saucer")
    return imageView
  }()
  
  private let errorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Какой-то сверхразум все сломал"
    label.font = UIFont(name: "Inter", size: 17)
    label.textColor = UIColor(named: "TextSecondary")
    return label
  }()
  
  private let repairLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Постараемся все починить"
    label.font = UIFont(name: "Inter", size: 16)
    label.textColor = UIColor(named: "TextTetriary")
    return label
  }()
  
  var tryAgainButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Попробовать снова", for: .normal)
    button.setTitleColor(UIColor(named: "ButtonPrimary"), for: .normal)
    button.titleLabel?.font = UIFont(name: "Inter", size: 16)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    addSubview(ufoImageView)
    addSubview(errorLabel)
    addSubview(repairLabel)
    addSubview(tryAgainButton)
    
    NSLayoutConstraint.activate([
      ufoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      ufoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 347),
      ufoImageView.heightAnchor.constraint(equalToConstant: 56),
      ufoImageView.widthAnchor.constraint(equalToConstant: 56),
      
      errorLabel.topAnchor.constraint(equalTo: ufoImageView.bottomAnchor, constant: 8),
      errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      repairLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      repairLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 12),
      
      tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      tryAgainButton.topAnchor.constraint(equalTo: repairLabel.bottomAnchor, constant: 12)
    ])
  }
}
