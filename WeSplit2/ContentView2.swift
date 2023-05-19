//
//  ContentView2.swift
//  WeSplit2
//
//  Created by Nick Deda on 5/17/23.
//

import SwiftUI
import Foundation


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
  

  
  /**
   Derived attribute
   */
  var totalPerPerson: Double {
    tipType.totalPerPerson(numberOfPeople, billAmount)
  }
  
  var totalTip: Double {
    tipType.totalTip(billAmount)
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
        }
        
        Section {
          NavigationLink(destination: CustomTipView(vm: vm)) {
          Picker("Tip percentage", selection: $vm.tipType) {
              ForEach(TipType.allCases, id: \.self) {
                Text($0.pickerString)
              }
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
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            
            Button("Done") {
              amountIsFocused = false
            }
          }
        }
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
            amountIsFocused = false
          }
        }
      }
    }
  }
                         
                         
  struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
      ContentView2()
      CustomTipView(vm: ViewModel())
    }
  }
}
