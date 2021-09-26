//
//  ProfileView.swift
//  ShellHacks Capital One
//
//  Created by Peter Khouly on 9/25/21.
//

import SwiftUI

struct ProfileView: View {
    
    enum Sheets: Identifiable {
           case info

           var id: Int {
               self.hashValue
           }
    }
    @State var activeSheet: Sheets?
    
    var body: some View {
        Form {
            Section(header: Text("Your Information"), footer: Text("Time Cost does not collect any of your information.")) {
                Button(action: {activeSheet = .info}) {
                    Label(
                        title: { Text("Financial Info").foregroundColor(.primary).bold() },
                        icon: { Image(systemName: "info.circle").foregroundColor(.green) }
                    )
                }
            }
            
            Section(header: Text("Reach Out")) {
                Link(destination: URL(string: "mailto:my@email.com")!) {
                    Label(
                        title: { Text("Email").bold().foregroundColor(.primary) },
                        icon: { Image(systemName: "envelope").foregroundColor(.blue) }
                    )
                }
                Link(destination: URL(string: "www.twitter.com/peterkhouly")!) {
                    Label(
                        title: { Text("twitter").bold().foregroundColor(.primary) },
                        icon: { Image(systemName: "hammer").foregroundColor(.gray) }
                    )
                }
            }

        }.sheet(item: $activeSheet, onDismiss: { activeSheet = nil }) { item in
            switch item {
            case .info:
                NavigationView{
                    FinanceInfoView(income: UserDefaults.standard.string(forKey: "income") ?? "", expenses: (UserDefaults.standard.array(forKey: "expensesArray") as? [String]) ?? ["","","","","","",""], savings: UserDefaults.standard.string(forKey: "savings") ?? "", fromWhere: .constant("profile"), activeSheet: .constant(ContentView().activeSheet))
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
