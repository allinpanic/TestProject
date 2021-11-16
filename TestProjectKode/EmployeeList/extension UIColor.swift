//
//  extension UIColor.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/16/21.
//

import UIKit

public extension UIImage {
     convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
       let rect = CGRect(origin: .zero, size: size)
       UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
       color.setFill()
       UIRectFill(rect)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       
       guard let cgImage = image?.cgImage else { return nil }
       self.init(cgImage: cgImage)
     }
  
  static func render(size: CGSize, _ draw: () -> Void) -> UIImage? {
          UIGraphicsBeginImageContext(size)
          defer { UIGraphicsEndImageContext() }
          
          draw()
          
          return UIGraphicsGetImageFromCurrentImageContext()?
              .withRenderingMode(.alwaysTemplate)
      }
   }
