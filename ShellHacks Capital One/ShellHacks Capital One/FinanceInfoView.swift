//
//  FinanceInfoView.swift
//  ShellHacks Capital One
//
//  Created by Peter Khouly on 9/25/21.
//

import SwiftUI

struct FinanceInfoView: View {
    @AppStorage ("firstTime?") var firstTime = true

    @State var income = ""
    @State var expenses = ["","","","","","",""]
    //@State var ECategories = ["Rent/Mortgage", "Groceries", "Cell Phone Bill", "Subscriptions", "Entertainment", "Investing", "Miscellaneous"]
    @State var savings = ""
    
    @Binding var fromWhere: String

    @Environment(\.presentationMode) var presentationMode
    @Binding var activeSheet: ContentView.Sheets?

    
    func saveToUserDefaults(balance: Double) {
        UserDefaults.standard.set(income, forKey: "income")
        
        UserDefaults.standard.set(expenses, forKey: "expensesArray")
        
        UserDefaults.standard.set(savings, forKey: "savings")
        
        UserDefaults.standard.set(balance, forKey: "balance")
        
        firstTime = false
        activeSheet = nil
    }
    var body: some View {
        let totalExpenses = String.backToDouble(expenses[0])() + String.backToDouble(expenses[1])() + String.backToDouble(expenses[2])() + String.backToDouble(expenses[3])() + String.backToDouble(expenses[4])() + String.backToDouble(expenses[5])() + String.backToDouble(expenses[6])() + String.backToDouble(savings)()
        let totalExpensesPerHour = totalExpenses / 173.928571429
        let doubleIncome = String.backToDouble(income)()
        
        let balance = (doubleIncome - totalExpensesPerHour)
        Form {
            Section(header: Text("First, lets start with your income"), footer: Text("")){
                HStack {
                    Text("Salary: ")
                    TextField("0.00", text: $income)
                    .keyboardType(.decimalPad).foregroundColor(.green)
                    Text("per hour")
                }
            }
            .onChange(of: income) {newValue in
                income = String.currency(newValue)()
            }
            Section(header: Text("Next, are your monthly expenses")) {
                HStack {
                    Text("Rent/Mortgage: ")
                    TextField("0.00", text: $expenses[0])
                    .keyboardType(.decimalPad).foregroundColor(.red)
                }.onChange(of: expenses[0]) {newValue in
                    expenses[0] = String.currency(newValue)()
                }
                HStack {
                    Text("Groceries: ")
                    TextField("0.00", text: $expenses[1])
                    .keyboardType(.decimalPad).foregroundColor(.red)
                }.onChange(of: expenses[1]) {newValue in
                    expenses[1] = String.currency(newValue)()
                }
                HStack {
                    Text("Cell Phone Bill: ")
                    TextField("0.00", text: $expenses[2])
                    .keyboardType(.decimalPad).foregroundColor(.red)
                }.onChange(of: expenses[2]) {newValue in
                    expenses[2] = String.currency(newValue)()
                }
                HStack {
                    Text("Subscriptions: ")
                    TextField("0.00", text: $expenses[3])
                    .keyboardType(.decimalPad).foregroundColor(.red)
                }.onChange(of: expenses[3]) {newValue in
                    expenses[3] = String.currency(newValue)()
                }
                HStack {
                    Text("Entertainment: ")
                    TextField("0.00", text: $expenses[4])
                    .keyboardType(.decimalPad).foregroundColor(.red)
                }.onChange(of: expenses[4]) {newValue in
                    expenses[4] = String.currency(newValue)()
                }
                HStack {
                    Text("Investing: ")
                    TextField("0.00", text: $expenses[5])
                    .keyboardType(.decimalPad).foregroundColor(.red)
                }.onChange(of: expenses[5]) {newValue in
                    expenses[5] = String.currency(newValue)()
                }
                HStack {
                    Text("Miscellaneous: ")
                    TextField("0.00", text: $expenses[6])
                    .keyboardType(.decimalPad).foregroundColor(.red)
                }.onChange(of: expenses[6]) {newValue in
                    expenses[6] = String.currency(newValue)()
                }
            }
            Section(header: Text("Finally, how much do you put as savings per month")) {
                HStack {
                    Text("Savings: ")
                    TextField("0.00", text: $savings)
                    .keyboardType(.decimalPad).foregroundColor(.blue)
                }.onChange(of: savings) {newValue in
                    savings = String.currency(newValue)()
                }
            }
            
        }.toolbar(content: {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {saveToUserDefaults(balance: balance)
                        self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Done")
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Group {
                    if fromWhere == "profile" {
                        Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                            Text("Cancel")
                        }
                    }
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Text("Remaining Balance: ") + Text("$\(balance, specifier: "%.2f")").foregroundColor((balance < 0) ? .red : .green) + Text(" per hour")
            }
        })
        .navigationBarTitle("Financial Info")
    }
}

struct FinanceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FinanceInfoView(fromWhere: .constant(""), activeSheet: .constant(ContentView().activeSheet))
    }
}
