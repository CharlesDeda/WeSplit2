//
//  ContentView.swift
//  WeSplit2
//
//  Created by Nick Deda on 5/16/23.
//

import SwiftUI



//If the manual tip > 0, disable tip selector
struct ContentView: View {
  @State private var checkAmount = 0.0
  @State private var numberOfPeople = 2
  @State private var tipPercentage = 20
  //Adding a variable to select your own tip percentage
  @State private var manualTip: Double = 0
  @FocusState private var amountIsFocused: Bool
  
  let tipPercentages = [10, 15, 20, 25, 0]
  
  /// if there is a tip entered, the tip becomes the percentage
  var totalPerPerson: Double {
    let peopleCount = Double(numberOfPeople + 2)
    let tipSelection = Double(tipPercentage)
//    let tipValue: Double = (manualTip > 0)? manualTip : (checkAmount/100 * tipSelection)
    let tipValue = 10.0
    let grandTotal = checkAmount + tipValue
    let amountPerPerson = grandTotal/peopleCount
    return amountPerPerson
  }
  
  var tipAmount: Double {
    let peopleCount = Double(numberOfPeople + 2)
    let tipSelection = Double(tipPercentage)
    let tipValue = manualTip ?? checkAmount/100 * tipSelection
    return tipValue
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          //amount is a placeholder, $checkAmount is a read and write
          //format shows its a double storing money
          TextField("Amount", value: $checkAmount, format:
              .currency(code: Locale.current.currency?.identifier ?? "USD"))
          .keyboardType(.decimalPad)
          .focused($amountIsFocused)
          
          Picker("Number of people", selection: $numberOfPeople) {
            ForEach(2..<100) {
              Text("\($0) people")
            }
          }
        }
        
        //section contains picker for tip percentages, header to prompt user
        Section {
          Picker("Tip percentage", selection: $tipPercentage) {
            ForEach(tipPercentages, id: \.self) {
              Text($0, format: .percent)
            }
          }
          .pickerStyle(.segmented)
          .onChange(of: tipPercentage) { tipPercentage in
            self.manualTip = 0.0
      
          }
          
        } header: {
          Text("Tip Percentage")
        }
        
        Section {
          TextField("Or enter your own tip", value: $manualTip, format:
              .currency(code: Locale.current.currency?.identifier ?? "USD"))
          .keyboardType(.decimalPad)
          .onChange(of: manualTip) { manualTip in
            self.tipPercentage = 0
          }
        } header: {
          Text("Tip Amount")
        }
        
//        Section {
//          Text(tipAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD") )
//        } header: {
//          Text("Tip Amount")
//        }
        
        Section {
          Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
