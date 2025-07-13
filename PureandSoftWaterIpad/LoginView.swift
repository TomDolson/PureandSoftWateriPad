//
//  LoginView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 12/28/19.
//  Copyright © 2019 Tom Dolson. All rights reserved.
//

import SwiftUI
import Combine

class SelectedDate : ObservableObject {
    @Published var selectedDateClicked: Date = Date()
}

class User: ObservableObject {
    
    @Published var user: String = "Tom"
    @Published var password: String = "ylb123"
    @Published var email: String = ""
    @Published var loginStatus = false

}

func isLoggedIn(userName: String, password: String) -> Bool {
    
    var status = false
    
    let users = [["Tom", "ylb123"], ["Dina", "16Homestead"], ["Mike", "Lancer123"]]
    
    outerLoop: for item in users {
        
        if userName == item[0] && password == item[1] {
            status = true
            print(item)
            break outerLoop
        }
    }
    
    return status
}

struct LoginView: View {
       
    @EnvironmentObject var user: User

    @State private var showingAlert = false
    
    @State private var wrongUsernamePassword = false
    
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            HStack{
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Username:")
                        .padding(.init(top: 0, leading: 41, bottom: 0, trailing: 40))
                    TextField("Username", text: $user.user)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.init(top: 0, leading: 40, bottom: 10, trailing: 40))
                }
                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Password:")
                        .padding(.init(top: 0, leading: 41, bottom: 0, trailing: 40))
                    TextField("Password", text: $user.password)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.init(top: 0, leading: 40, bottom: 10, trailing: 40))
                }
            }
            Button(action: {
                
                if self.user.user == "" || self.user.password == "" {
                    self.alertMessage = "Username/Password must have a value!"
                    self.showingAlert = true
                    
                } else {
                    
                    self.user.loginStatus = isLoggedIn(userName: self.user.user, password: self.user.password)
                    
                    if !self.user.loginStatus {
                        
                        self.alertMessage = "Incorrect Username/Password!"
                        self.showingAlert = true
                    }
                    
                    let loggedIn = UINotificationFeedbackGenerator()
                    loggedIn.notificationOccurred(.success)
                }
            }) {
                Text("Login to System")
                    .customButton()
            }
            .padding(.horizontal)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Important message"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("Ok!")))
            }
        }
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
