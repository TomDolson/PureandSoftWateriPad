//
//  CustomerFollowUpView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/10/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//
import UIKit
import SwiftUI
import Combine

struct NewFollowUpView: View {
    
    @State
    var custID: Int = 1063
    @State
    var name: String = "Dolson, Tom & Dina"
    @State
    var address: String = "16 Homestead Street, Hillsdale, NJ 07642"
    
    @State
    var showingAlert: Bool = false
    
    @State
    var alertMessage: String = "Cancel Follow-up?"
    
    var onDismiss: () -> ()
    
    @State
    var followUpText: String = ""
    
    @State
    private var followUpDate = Date()
    
    @State
    private var results = [FollowUpSave.Save]()
    
    @State
    var showToast: Bool = false
    
    @State
    var notificationShown: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @State
    var followUpPerson: String = "TD"
    
    var fuPerson: [String] = ["TD", "DD"]

    @State
    var personNumber = 0
    
    private var followUpDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM, dd YYYY"
        return formatter
    }
    
    struct FollowUpSave: Codable {
        var insertFollowUp: [Save]
        
        init(insertFollowUp: [Save]) {
            self.insertFollowUp = insertFollowUp
        }
            struct Save: Codable {
            var ID: Int
        }
    }
    
    
    func saveFollowUpData(custID: String, currentDate: String, followUpDate: String, followUpPerson: String , followUpText: String) -> Bool {
        // This function will be used to save the follow-up data to the database
        
        var committed: Bool = false
        
        var followUpStr: String = ""
        
        followUpStr = followUpText.RFC3986UnreservedEncoded
        
        // Build the url string for sending data to the SQL database
        let url = "http://www.pureandsoftwater.com/IpadInsertFollowUp.aspx?CustID=\(custID)&EnterDate=\(currentDate)&FollowUpDate=\(followUpDate)&FollowUpPerson=\(self.fuPerson[personNumber])&Comment=\(followUpStr)"
        
        //let encodedString  = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
             
        let newURL = URL(string: url)
        
       // Convert url string to URL
        let request = URLRequest(url: newURL!)
        
        // Create the URL session to send the data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(FollowUpSave.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.insertFollowUp
                    }

                    //print(self.results)
                    // everything is good, so we can exit
                    return committed = true
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
        
        return committed
        
    }

    // CHANGE DATE TO STRING
    func changeDateToString(date: Date?) -> String {
        let newDate: Date?
        if date == nil {
            newDate = Date()
        } else {
            newDate = date
        }
         let formatter = DateFormatter()
        formatter.locale = .current
        
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: newDate!)
    }
    
    var body: some View {
  
        VStack(alignment: .center, spacing: 5) {
            
            PageHeaderView(typePage: "Add New Follow-Up", foregroundColor: Color.white, bgColor: Color.purple)
                .padding()
            

            HStack(alignment: .top, spacing: 5) {
                Text("\(self.name)  -  \(self.address)")
                    .font(.system(size: 16))
                    .bold()
                    .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.purple, radius: 3)
                    .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 0))
                
            }
            VStack(alignment: .trailing, spacing: 5) {
                HStack(alignment: .top, spacing: 5) {
                    
                    // SAVE BUTTON
                    Button(action: {
                        
                        if self.followUpText != "" {
                            
                            if self.saveFollowUpData(custID: String(self.custID), currentDate: self.changeDateToString(date: Date()), followUpDate: self.changeDateToString(date: self.followUpDate), followUpPerson: self.fuPerson[self.personNumber],  followUpText: self.followUpText) {
                                
                                self.alertMessage = "Your data has not been saved!"
                                self.showingAlert.toggle()
                                self.onDismiss()
                                
                            } else {
                                
                                self.alertMessage = "Your data has been saved!"
                                self.showingAlert.toggle()
                                //print("\(self.showingAlert)")
                                self.onDismiss()
                                
                                //self.onDismiss()
                                //Alert(title: Text("Important message"), message: Text("Your data has been saved!"), dismissButton: .default(Text("Ok!")))
                            }
                        }
                        else {
                            self.alertMessage = "You must fill in text for follow-up!"
                            self.notificationShown = true
                        }
                    }) {
                        Text("Save")
                            .foregroundColor(.green)
                    }.buttonStyle(BorderlessButtonStyle())
                    .alert(isPresented: $showingAlert) {
                        
                        Alert(title: Text("Important message"), message: Text("\(self.alertMessage)"), primaryButton: .destructive(Text("Ok"), action: { self.onDismiss()
                        }), secondaryButton: .cancel(Text("Yes")))
                        
                    }
                    .padding(.init(top: 5, leading: 30, bottom: 5, trailing: 0))
                    
                    Spacer()
                    
                    
                    // CANCEL BUTTON
                    Button(action: {
                        self.onDismiss()
                        
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }.buttonStyle(BorderlessButtonStyle())
                    .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 30))
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                
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
                    
                    HStack(alignment: .top, spacing: 5) {
                        
                        Text("Date Entered: ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        Text("\(changeDateToString(date: Date()))")
                            .bold()
                            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 20))
                    }
                    
                    // PROBLEM *******************************************************************************
                    
                    HStack {
                        Text("Person To Follow Up:   ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 10))
                        Text("\(self.fuPerson[personNumber])").foregroundColor(.blue).bold()
                            .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 40))
                        
                        Picker(selection: self.$personNumber, label: Text("")) {
                            
                            ForEach(0 ..< self.fuPerson.count) {
                                Text("\(self.fuPerson[$0])").foregroundColor(.blue).bold()
                                
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            
                            .frame(width: 200)
                        
                    }
                    
                    // END PROBLEM *************************************************************************
                    
                    HStack(alignment: .center, spacing: 5) {
                        
                        DatePicker(selection: $followUpDate, displayedComponents: .date) {
                            
                            Text("Follow Up Date:\n\(followUpDate, formatter: followUpDateFormatter)").foregroundColor(.purple)
                        }
                        .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 40))
                        
                    }
                    
                    HStack {
                        Text("Follow-up Text: ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        
                        MultilineTextField("Enter comment text here", text: $followUpText, onCommit: {
                            //print("Final text: \(self.followUpText)")
                        }).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray).opacity(0.5))
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                    }
                }
                
            }
            
            Spacer()
        }
        
    }
    
}

extension String {

    var RFC3986UnreservedEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharsSet: CharacterSet = CharacterSet(charactersIn: unreservedChars)
        let encodedString: String = self.addingPercentEncoding(withAllowedCharacters: unreservedCharsSet)!
        return encodedString
    }
}

struct NewFollowUpView_Previews: PreviewProvider {

    static var previews: some View {
        
        NewFollowUpView(custID: 1063, name: "Dolson, Tom & Dina", address: "16 Homestead Street, Hillsdale, NJ 07642", onDismiss: {Binding.constant(true)}, followUpText: "")
    }
}
