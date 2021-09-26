//
//  TCCalculatorView.swift
//  ShellHacks Capital One
//
//  Created by Peter Khouly on 9/25/21.
//

import SwiftUI

struct TCCalculatorView: View {
    @State var itemCost: String = ""
    @State var productName: String = ""

    
    private var currencyFormatter: NumberFormatter = {
            let f = NumberFormatter()
            // allow no currency symbol, extra digits, etc
            f.isLenient = true
            f.numberStyle = .currency
            return f
        }()
    
    var body: some View {
        let timeCost = String.backToDouble(String.currency(itemCost)())() / UserDefaults.standard.double(forKey: "balance")
        Form {
            Section(header: Text("Please Input the Price of the Product that you would like to purchase")) {
                FloatingTextField(title: "Product Name (Optional)", text: $productName)
                HStack {
                    Text("Price: ")
                    TextField("0.00", text: $itemCost)
                    .keyboardType(.decimalPad).foregroundColor(.blue)
                }
                .onChange(of: itemCost) {newValue in
                    itemCost = String.currency(newValue)()
                }
            }
            Section {
                if !itemCost.isEmpty && itemCost != "$" {
                    if productName.isEmpty {
                        Group {
                            Text("That new product won't cost you ") + Text("\(String.currency(itemCost)())").bold().foregroundColor(.red) + Text(", it'll cost you ") + Text("\(timeCost, specifier: "%.2f") hours!").bold().foregroundColor(.red)
                        }
                    } else {
                        Group {
                            Text("That new \(productName) won't cost you ") + Text("\(String.currency(itemCost)())").bold().foregroundColor(.red) + Text(", it'll cost you ") + Text("\(timeCost, specifier: "%.2f") hours!").bold().foregroundColor(.red)
                        }
                    }
                }
            }.id(timeCost).id(productName).id(itemCost).fixedSize(horizontal: false, vertical: true)
        }
    }
}
extension String {
    func backToDouble() -> Double {
        let double = self.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        return Double(double) ?? 0.00
        //(String.backToDouble(itemCost)()
    }
}

extension String {
    func currency() -> String {
        var string = self.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "..", with: ".").replacingOccurrences(of: "...", with: ".").replacingOccurrences(of: ",", with: "").filter { "1234567890.".contains($0) }
        
        var coin = ""
        if let range = string.range(of: ".") {
            var coins = string[range.upperBound...]
 
            if coins.contains(".") {
                coins = coins.filter { "1234567890".contains($0) }
            }
            if coins.count == 3 {
                coins = coins.dropLast()
            }
            coin = "."+coins
            string.removeSubrange(range.upperBound...)
            string = string.replacingOccurrences(of: ".", with: "")
            
            if coin.count > 3 {
                coin = String(coin.dropLast())
                string.append(coin)
                return string
            }

        }
        if string.count > 0 {
            switch string.count {
                case 4:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 1))
                case 5:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 2))
                case 6:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 3))
                case 7:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 1))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 5))
                case 8:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 2))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 6))
                case 9:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 3))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 7))
                case 10:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 1))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 5))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 9))
                case 11:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 2))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 6))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 10))
                case 12:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 3))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 7))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 11))
                case 13:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 1))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 5))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 9))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 13))
                case 14:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 2))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 6))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 10))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 14))
                case 15:
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 3))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 7))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 11))
                    string.insert(",", at: string.index(string.startIndex, offsetBy: 15))
                default:
                    break
            }
            string.insert("$", at: string.startIndex)
        }
        string.append(coin)
        string = string.replacingOccurrences(of: " ", with: "")
        return string
    }
}

struct TCCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        TCCalculatorView()
    }
}
