//
//  pickerView.swift
//  WeSplit2
//
//  Created by Nick Deda on 5/18/23.
//

import Foundation

// TODO: kdeda
// Move this to its own file.
enum TipType {
  case ten
  case fifteen
  case twenty
  case twentyFive
  case custom(tip: Double)
  
  static var allCases: [TipType] {
    [.ten, .fifteen, .twenty, .twentyFive, .custom(tip: 0)]
  }
}

extension TipType: Identifiable {
  var id: String {
    switch self {
    case .ten:
      return "ten"
    case .fifteen:
      return "fifteen"
    case .twenty:
      return "twenty"
    case .twentyFive:
      return "twentyFive"
    case .custom:
      return "custom"
    }
  }
}

extension TipType: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension TipType {
  var pickerString: String {
    switch self {
    case .ten:
      return "10%"
    case .fifteen:
      return "15%"
    case .twenty:
      return "20%"
    case .twentyFive:
      return "25%"
    case .custom:
      return "Other"
    }
  }
    
  func totalTip(_ billAmount: Double) -> Double {
    switch self {
      
    case .ten:
      return billAmount * 0.1
    case .fifteen:
      return billAmount * 0.15
    case .twenty:
      return billAmount * 0.2
    case .twentyFive:
      return billAmount * 0.25
    case let .custom(manualTip):
      return manualTip
    }
  }
  
  /**
   Given the input return the amount each person has to pay.
   Chapter 5: Where to put code.
   */
  func totalPerPerson(_ numberOfPeople: Int, _ billAmount: Double) -> Double {
    switch self {
    case .ten:
      return (billAmount * 1.1) / Double(numberOfPeople + 2)
    case .fifteen:
      return (billAmount * 1.15) / Double(numberOfPeople + 2)
      
    case .twenty:
      return (billAmount * 1.2) / Double(numberOfPeople + 2)
      
    case .twentyFive:
      return (billAmount * 1.25) / Double(numberOfPeople + 2)
      
    case let .custom(manualTip):
      return (manualTip + billAmount) / Double(numberOfPeople + 2)
    }
  }
}
