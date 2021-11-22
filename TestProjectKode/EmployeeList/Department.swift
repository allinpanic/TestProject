//
//  Department.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/22/21.
//

import Foundation

enum Department: String, Codable {
  case all
  case android
  case ios
  case design
  case management
  case qa
  case back_office
  case frontend
  case hr
  case pr
  case backend
  case support
  case analytics
}

extension Department {
  //  enum CodingKeys: String, CodingKey {
  //    case all
  //    case android
  //    case ios
  //    case design
  //    case management
  //    case qa
  //    case backOffice = "back_office"
  //    case frontend
  //    case hr
  //    case pr
  //    case backend
  //    case support
  //    case analytics
  //  }
}
