//
//  NewCustomerView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/23/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI
import Combine


struct NewCustomerView: View {
    
    var activeStatus = ["Active","InActive"]
    
    @State
    var status: String = "0"
    
    @State
    var lastName: String = ""
    
    @State
    var firstName: String = ""
    
    @State
    var address1: String = ""
    
    @State
    var address2: String = ""
    
    @State
    var city: String = ""
    
    @State
    var state: String = ""
    
    @State
    var zip: String = ""
    
    @State
    var homePhone: String = ""
    
    @State
    var cellPhone: String = ""
    
    @State
    var email: String = ""
    
    @State
    var comment: String = ""
    
    var onDismiss: () -> ()
    
    
    @State
    var showingAlert: Bool = false
    
    
    @State
    var alertMessage = ""
    
    @State
    var notificationShown: Bool = false
    
    @State
    private var results = [NewCustomer.NewRecord]()
    
    func isRequired() -> Bool {
        var isEmpty: Bool = false
        
        if lastName == "" {
            self.alertMessage = "Last Name cannot be blank!"
            isEmpty = true
            return isEmpty
        }
        if firstName == "" {
            self.alertMessage = "First Name cannot be blank!"
            isEmpty = true
            return isEmpty
        }
        if address1 == "" {
            self.alertMessage = "Address cannot be blank!"
            isEmpty = true
            return isEmpty
        }
        if city == "" {
            self.alertMessage = "City cannot be blank!"
            isEmpty = true
            return isEmpty
        }
        if state == "" {
            self.alertMessage = "State cannot be blank!"
            isEmpty = true
            return isEmpty
        }
        if zip == "" {
            self.alertMessage = "Zip Code cannot be blank!"
            isEmpty = true
            return isEmpty
        }
        // Both phones cannot be blank
        if (homePhone == "") && (cellPhone == "") {
            self.alertMessage = "Must have either Home or Cell phone!"
            isEmpty = true
            return isEmpty
        }
        
        return isEmpty
    }
    
    func saveNewCustomerRecord() -> Bool {
        
        //var committed: Bool = false
          
        let newComment = comment.RFC3986UnreservedEncoded
        
        // Build the url string for sending data to the SQL database
        let url = "http://www.pureandsoftwater.com/IpadAddNewCustomer.aspx?Status=\(String(status))&LastName=\(lastName)&FirstName=\(firstName)&Address1=\(address1)&Address2=\(address2)&City=\(city)&State=\(state)&Zip=\(zip)&HomePhone=\(homePhone)&CellPhone=\(cellPhone)&Email=\(email)&Comments=\(newComment)".replacingOccurrences(of: " ", with: "%20")
             
        let newURL = URL(string: url)
        
        print(url)
        
        // Convert url string to URL
        let request = URLRequest(url: newURL!)
        
        // Create the URL session to send the data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(NewCustomer.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.newCustomer
                    }
                    
                    //print(self.results)
                    // everything is good, so we can exit
                    //return committed = true
                }
            }
            
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
        return true
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            List {
                VStack(alignment: .center) {
                    PageHeaderView(typePage: "Add New Customer", foregroundColor: Color.white, bgColor: Color.green)
                        .padding(.init(top: 20, leading: 0, bottom: -10, trailing: 0))
                    
                    HStack {
                        Button(action: {
                            
                            if self.isRequired() {
                                
                                self.notificationShown = true
                            } else {
                                
                                if self.saveNewCustomerRecord() {
                                    self.alertMessage = "Your Data Has Been Saved"
                                    self.showingAlert = true
                                    self.onDismiss()
                                    
                                }
                            }
                        }) {
                            Text("Save")
                                .foregroundColor(.green)
                        }.buttonStyle(BorderlessButtonStyle())
                        .padding(.init(top: 0, leading: 25, bottom: 5, trailing: 0))
                        .alert(isPresented: $showingAlert) {
                            
                            Alert(title: Text("Important message"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK"), action: {onDismiss()}))
                            
                        }
                        //.padding(.init(top: 5, leading: 30, bottom: 5, trailing: 0))
                        
                        Spacer()
                        
                        Button(action: {
                            self.onDismiss()
                        }) {
                            Text("Cancel")
                                .foregroundColor(.red)
                        }.buttonStyle(BorderlessButtonStyle())
                        .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 30))
                    }.frame(height: 30)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Group {
                            Form {
                                
                                if self.notificationShown {
                                    VStack(alignment: .center, spacing: 5) {
                                        if self.notificationShown {
                                            NotificationView {
                                                Text("\(self.alertMessage)")
                                                
                                                Button("Ok!") {
                                                    self.notificationShown.toggle()
                                                }
                                            }
                                        }
                                        
                                    }.padding(.init(top: 5, leading: 200, bottom: 5, trailing: 5))
                                    
                                } else {
                                    EmptyView()
                                }
                                
                                HStack {
                                    Text("Status: ")
                                    Picker(selection: $status, label: Text("Status: ")) {
                                        ForEach(activeStatus, id: \.self) { status in
                                            Text(status).tag(status)
                                        }
                                    } .pickerStyle(SegmentedPickerStyle())
                                }
                                HStack {
                                   // Text("Last Name: ")
                                    TextField("Last Name", text: $lastName)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                                
                                HStack {
                                    //Text("First Name: ")
                                    TextField("First Name", text: $firstName)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                                
                                HStack {
                                    //Text("Address1: ")
                                    TextField("Address1", text: $address1)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                                
                                HStack {
                                    //Text("Address2: ")
                                    TextField("Address2", text: $address2)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                                
                                HStack {
                                    //Text("City: ")
                                    TextField("City", text: $city)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                                
                                HStack {
                                    //Text("State: ")
                                    TextField("State", text: $state)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                                
                                HStack {
                                    //Text("Zip: ")
                                    TextField("Zip", text: $zip)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                            }
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 3, y: 3)
                            .padding(.bottom)
                        }.frame(height: 580)
                        
                        Group {
                            Form {
                                
                                HStack {
                                    
                                    TextField("Home Phone", text: $homePhone)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                        .onReceive(Just(self.homePhone)) { (newValue: String) in
                                            self.homePhone = newValue.prefix(12).filter { "1234567890-".contains($0)  }}
                                }
                                
                                HStack {
                                    
                                    TextField("Cell Phone", text: $cellPhone)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                        .onReceive(Just(self.cellPhone)) { (newValue: String) in
                                            self.cellPhone = newValue.prefix(12).filter { "1234567890-".contains($0)  }}
                                }
                                
                                HStack {
                                    
                                    TextField("Email", text: $email)
                                        .lineLimit(nil)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                }
                                
                                HStack {
                                    
                                    MultilineTextField("Enter comment text here", text: $comment, onCommit: {
                                        print("Final text: \(self.comment)")
                                    }).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray).opacity(0.5))
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                                    
                                }
                            }
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 3, y: 3)
                            .padding(.bottom)
                        }.frame(height: 300)
                        
                    }.padding(.init(top: 10, leading: 20, bottom: 5, trailing: 20))
                    Spacer()
                }
            }
        }
    }
}

struct NewCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        NewCustomerView(status: "0", lastName: "Dolson", firstName: "Thomas", address1: "16 Homestead Street", address2: "2nd House on right", city: "Hillsdale", state: "NJ", zip: "07642", homePhone: "201-358-4046", cellPhone: "201-406-8958", email: "tomdolson@gmail.com", comment: "The comment goes here.", onDismiss: {Binding.constant(false)})
    }
}
