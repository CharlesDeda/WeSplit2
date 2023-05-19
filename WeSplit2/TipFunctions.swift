//
//  TipFunctions.swift
//  WeSplit2
//
//  Created by Nick Deda on 5/18/23.
//

import Foundation


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
  case .custom:
    return billAmount * 0.1
  }
}

/**
 Given the input return the amount each person has to pay.
 Chapter 5: Where to put code.
 */
func totalPerPerson(_ numberOfPeople: Int, _ billAmount: Double) -> Double {
  // TODO: kdeda_1
  // implement me, adjust to custom(Double) enum case
  switch self {
    
  case .ten:
    return (billAmount * 1.1) / Double(numberOfPeople + 2)
  case .fifteen:
    return (billAmount * 1.15) / Double(numberOfPeople + 2)
    
  case .twenty:
    return (billAmount * 1.2) / Double(numberOfPeople + 2)
    
  case .twentyFive:
    return (billAmount * 1.25) / Double(numberOfPeople + 2)
    
  case .custom:
    return (manualTip + billAmount) / Double(numberOfPeople + 2)
  }
}
}
