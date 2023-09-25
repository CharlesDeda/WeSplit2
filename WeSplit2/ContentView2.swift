//
//  ContentView2.swift
//  WeSplit2
//
//  Created by Nick Deda on 5/17/23.
//

import SwiftUI
import Foundation
import SwiftUINavigation

/// Navigation
/// 1. import poiint free swifitui navigation
/// 2. create a destination enum
/// 3. add cases too the enum that represent a destinatiino
/// 4. you can add a associated value which represents the state to power your destination
/// 5. you can use this enum for all navigation apis (sheet, alert, fullscreen, navigatinoDestination, etc)
/// 6. all the apis look identical
/// 7. naviigationo is now a single sorce of truth, one variable to rule them all
/// 8. deep link
///
///
/// Light/DarkMode
///   - in the simulator you can use a keybooard command to switch b/w ligh and dark mode
///


final class ViewModel: ObservableObject {
  @Published var billAmount = 10.0
  @Published var numberOfPeople = 2
  @Published var manualTip: Double = 0 {
    didSet {
      tipType = .custom(tip: manualTip)
    }
  }
  @Published var tipType: TipType = .twentyFive {
    didSet {
      NSLog("")
    }
  }
  
  @Published var destination: Destination? = nil
  
  init(
    billAmount: Double = 10.0,
    numberOfPeople: Int = 2,
    manualTip: Double = 0,
    tipType: TipType = .twentyFive,
    destination: Destination? = nil
  ) {
    self.billAmount = billAmount
    self.numberOfPeople = numberOfPeople
    self.manualTip = manualTip
    self.tipType = tipType
    self.destination = destination
  }
  
  
  
  /**
   Derived attribute
   */
  var totalPerPerson: Double {
    tipType.totalPerPerson(numberOfPeople, billAmount)
  }
  
  var totalTip: Double {
    tipType.totalTip(billAmount)
  }
  
  func tipTypeOptionSelected(_ tipType: TipType) {
    self.tipType = tipType
    if case .custom(tip: _) = tipType {
      destination = .other
    }
  }
  
  func doneButtonTapped() {
    destination = nil
  }
  
  func customTipSubmitKeyPressed() {
    destination = nil
  }
  
}

extension ViewModel {
  enum Destination {
    case alert
    case sheetJesse
    case sheetNick
    case other
  }
}

struct ContentView2: View {
  @ObservedObject var vm = ViewModel()
  @FocusState private var amountIsFocused: Bool
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Amount", value: $vm.billAmount, format:
              .currency(code: Locale.current.currency?.identifier ?? "USD"))
          .keyboardType(.decimalPad)
          .focused($amountIsFocused)
          Picker("Number of people", selection: $vm.numberOfPeople) {
            ForEach(2..<100) {
              Text("\($0) people")
            }
          }
        } header: {
          Text("Bill Amount")
        }
        
        Section {
          Picker("Tip percentage", selection: .init(
            get: { vm.tipType },
            set: { vm.tipTypeOptionSelected($0) })
          ) {
            ForEach(TipType.allCases, id: \.self) {
              Text($0.pickerString)
            }
          }
          .pickerStyle(.segmented)
        } header: {
          Text("Tip Percentage")
        }
        
        
        Section {
          Text(vm.totalTip, format: .currency(code: Locale.current.currency?.identifier ?? "USD") )
        } header: {
          Text("Tip Amount")
        }
        
        Section {
          Text(vm.totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        } header: {
          Text("Total per person")
        }
        
        .navigationTitle("WeSplit")
      }
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          
          Button("Done") {
            amountIsFocused = false
          }
        }
      }
      .navigationDestination(
        unwrapping: $vm.destination,
        case: /ViewModel.Destination.other
      ) { _ in
        CustomTipView(vm: vm)
      }
    }
  }
  
  struct CustomTipView: View {
    @ObservedObject var vm: ViewModel
    @FocusState private var amountIsFocused: Bool
    
    
    // TODO: kdeda
    // on enter keyboard navigate away from here
    var body: some View {
      NavigationStack {
        Form {
          Section {
            TextField("Amount", value: $vm.manualTip, format:
                .currency(code: Locale.current.currency?.identifier ?? "USD"))
            .onSubmit(vm.customTipSubmitKeyPressed)
            .keyboardType(.decimalPad)
            .focused($amountIsFocused)
          }
        }
      }
      .navigationTitle("Add a Tip")
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          
          Button("Done") {
            vm.doneButtonTapped()
          }
        }
      }
    }
  }
  
  
  struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
      ContentView2().preferredColorScheme(.dark)
      ContentView2(vm: .init(destination: nil))
      CustomTipView(vm: ViewModel())
    }
  }
}
