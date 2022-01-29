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

extension Employee {
  var isBirthdayNextYear: Bool {
    guard let age = getAge() else {return false}
    
    guard let birthdayYear = Int(birthday.prefix(4)) else {return false}
    let currentYear = Calendar.current.component(.year, from: Date())    
    let yearDifference = currentYear - birthdayYear
    
    if yearDifference == age {
      return true
    }
    
    return false
  }
  
  func getBirthday() -> String? {
    guard let date = getDate() else {return nil}
    guard let prettyString = getDateFormattedString(date: date) else {return nil}
    
    return prettyString
  }
  
  func getAge() -> Int? {
    guard let date = getDate() else {return nil}
    let now = Date()
    let calendar = Calendar.current

    let ageComponents = calendar.dateComponents([.year], from: date, to: now)
    let age = ageComponents.year!
    
    return age
  }
  
  // MARK: - Private methods
  
  private func getDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date = dateFormatter.date(from: birthday)

    return date
  }
  
  private func getDateFormattedString(date: Date) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    dateFormatter.locale = Locale(identifier: "ru")
    
    let string = dateFormatter.string(from: date)
    return string
  }
  
  func getCelebration() -> String {
    guard let date = getDate() else {return birthday}
            
     let format = DateFormatter()
    format.dateFormat = "MM-dd"
    let celebration = format.string(from: date)
    
    return celebration
  }
}

