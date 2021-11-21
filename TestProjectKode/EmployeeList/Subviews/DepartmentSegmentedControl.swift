//
//  DepartmentSegmentedControl.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/16/21.
//

import UIKit

final class DepartmentSegmentedControl: UISegmentedControl {

  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func setAppearance() {
    
    let tintColorImage = selectedBackground(color: tintColor , size: CGSize(width: self.frame.width, height: self.frame.height + 6))
    
    let dividerImage = UIImage(color: backgroundColor ?? .clear, size: CGSize(width: 2, height: 10))
    
    setBackgroundImage(UIImage(color: backgroundColor ?? .clear, size: CGSize(width: self.bounds.width, height: 10)), for: .normal, barMetrics: .default)
    
    setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)    
    setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
    
    setTitleTextAttributes([.foregroundColor: UIColor(named: "ContentPrimary") as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)], for: .normal)
    setTitleTextAttributes([.foregroundColor: UIColor(named: "TextPrimary") as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)], for: .selected)
    
    setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
  }
  
  func selectedBackground(color: UIColor, size: CGSize) -> UIImage? {
    let lineWidth: CGFloat = 2
    return UIImage.render(size: size) {
      color.setFill()
      UIRectFill(CGRect(x: 0, y: size.height-lineWidth, width: size.width, height: lineWidth))
    }
  }
}
