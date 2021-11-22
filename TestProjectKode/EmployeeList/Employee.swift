//
//  Employee.swift
//  TestProjectKode
//
//  Created by Rodianov on 11/16/21.
//

import Foundation

struct RequestResult: Codable {
  var items: [Employee]
}

struct Employee: Codable {
  var id: String
  var avatarUrl: String
  var firstName: String
  var lastName: String
  var userTag: String
  var department: Department
  var position: String
  var birthday: String
  var phone: String
}

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
