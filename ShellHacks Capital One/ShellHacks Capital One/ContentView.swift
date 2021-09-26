//
//  ContentView.swift
//  ShellHacks Capital One
//
//  Created by Peter Khouly on 9/25/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage ("firstTime?") var firstTime = true
    
    enum Sheets: Identifiable {
           case info

           var id: Int {
               self.hashValue
           }
    }
    @State var activeSheet: Sheets?

    @State var selection = 1
    var body: some View {
        
        let bindingIsModal = Binding<Bool>(get: { self.firstTime == true }, set: { _ in })

        TabView(selection: $selection){
            NavigationView {
                TCCalculatorView().navigationBarTitle("Time Cost Calculator")
            }.tabItem { Image(systemName: "creditcard"); Text("Time Cost Calculator") }.tag(1)
            .navigationViewStyle(StackNavigationViewStyle())
            NavigationView {
                ProfileView().navigationBarTitle("Settings")
            }.tabItem { Image(systemName: "gear"); Text("Settings") }.tag(2)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        
        .onAppear {
            //firstTime = true
            if firstTime == true {
                activeSheet = .info
            }
        }
        .sheet(item: $activeSheet, onDismiss: {activeSheet = nil; firstTime = false
        }) { item in
            switch item {
            case .info:
                NavigationView {
                    FinanceInfoView(fromWhere: .constant("first time"), activeSheet: $activeSheet)
                }
                .presentation(isModal: bindingIsModal) {
                    print("View Locked In")
                }
            }
        }
    }
}

struct FloatingTextField: View {
    let title: String
    let text: Binding<String>
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: text.wrappedValue.isEmpty ? 0 : -25)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
            TextField("", text: text)
        }
        .padding(.top, 15)
        .animation(.spring(response: 0.4, dampingFraction: 0.3))
    }
}


struct ModalView<T: View>: UIViewControllerRepresentable {
    let view: T
    @Binding var isModal: Bool
    let onDismissalAttempt: (()->())?
    
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: view)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
        uiViewController.parent?.presentationController?.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        let modalView: ModalView
        
        init(_ modalView: ModalView) {
            self.modalView = modalView
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            !modalView.isModal
        }
        
        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            modalView.onDismissalAttempt?()
        }
    }
}

extension View {
    func presentation(isModal: Binding<Bool>, onDismissalAttempt: (()->())? = nil) -> some View {
        ModalView(view: self, isModal: isModal, onDismissalAttempt: onDismissalAttempt)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
