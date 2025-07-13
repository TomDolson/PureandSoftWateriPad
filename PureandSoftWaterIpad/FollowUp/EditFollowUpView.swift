//
//  EditFollowUpView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/24/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import UIKit
import SwiftUI
import Combine



struct EditFollowUpView: View {
    
    
    @State
    var ID: Int = 226
    
    @State
    var name: String = "Dolson, Tom & Dina"
    
    @State
    var address: String = "16 Homestead Street, Hillsdale, NJ 07642"
    
    @State
    var showingAlert: Bool = false
    
    @State
    var dateEntered: String = "02/24/2020"
    
    @State
    var alertMessage: String = "Cancel Follow-up?"
    
    var onDismiss: () -> ()
    
    @State
    var followUpText: String = ""
    
    @State
    var followUpDate = Date()
    
    @State
    private var results = [FollowUpSave.Save]()
    
    @State
    private var followUpData = [FollowUp.FollowUpRecord]()
    
    @State
    var followUpPerson: String? = "TD"
    
    @State
    var fuPerson: [String] = ["TD", "DD"]
    
    @State
    var personNumber = 0
    
    @State
    private var notificationShown = false
    
    private var followUpDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM, dd YYYY"
        return formatter
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    func getPickerPerson(initials: String) -> Int {
        
        var perInt = 0
        
        if initials == "TD" {
            perInt = 0
        }
        if initials == "DD" {
            perInt = 1
        }
        
        return perInt
    }
    
    func getFollowUpData(id: String) {

        let leadListURL = "http://www.pureandsoftwater.com/ipadGetFollowUpRecord.aspx?ID=\(id)"

        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: leadListURL)!) { (data, _, _) in

            do {

                let fetch = try JSONDecoder().decode(FollowUp.self, from: data!)

                DispatchQueue.main.async {

                    //print(fetch.customers.count)
                    self.followUpData = fetch.getFollowUp
                    //print(callActive(active: self.active))

                }
            }
            catch {
                print(error)
            }

        }.resume()

    }

    struct FollowUpSave: Codable {
        var editFollowUp: [Save]
        
        init(editFollowUp: [Save]) {
            self.editFollowUp = editFollowUp
        }
        struct Save: Codable {
            var ID: Int
        }
    }
    
    struct FollowUp: Codable {
        let getFollowUp: [FollowUpRecord]
        
        init(getFollowUp: [FollowUpRecord]) {
            self.getFollowUp = getFollowUp
        }
        
        struct  FollowUpRecord: Identifiable, Codable, Hashable {
            
            var id: Int
            var enterDate, followUpDate, followUpPerson, comment: String?
                
            enum CodingKeys: String, CodingKey {
                case id = "ID"
                case enterDate = "EnterDate"
                case followUpDate = "FollowUpDate"
                case followUpPerson = "FollowUpPerson"
                case comment = "Comment"
               
            }
        }
    }

    
    func editFollowUpData(ID: String, followUpDate: String, followUpText: String) -> Bool {
        // This funtion will be used to save the follow-up data to the database
        
        var committed: Bool = false
        
        var followUpStr: String = ""
        
        //print(ID)
        //print(followUpDate)
        //print(followUpPerson!)
       // print(followUpText)
        
        
        followUpStr = followUpText.RFC3986UnreservedEncoded    //.replacingOccurrences(of: " ", with: "%20")
        
        // Build the url string for sending data to the SQL database
        let url = "http://www.pureandsoftwater.com/IpadEditFollowUp.aspx?ID=\(ID)&FollowUpDate=\(followUpDate)&FollowUpPerson=\(fuPerson[personNumber])&Comment=\(followUpStr)"
        
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
                        self.results = decodedResponse.editFollowUp
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
            
            PageHeaderView(typePage: "Edit Follow-Up", foregroundColor: Color.white, bgColor: Color.purple)
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
                            
                            if self.editFollowUpData(ID: String(self.ID), followUpDate: self.changeDateToString(date: self.followUpDate), followUpText: self.followUpText) {
                                
                                self.alertMessage = "Your data has not been saved!"
                                self.showingAlert.toggle()
                                
                                
                            } else {
                                //self.showToast(controller: CustomerFollowUpView, message: "Your Data Has Been Saved", seconds: 3)
                                self.onDismiss()
                                //Alert(title: Text("Important message"), message: Text("Your data has been saved!"), dismissButton: .default(Text("Ok!")))
                            }
                        }
                        else {
                            self.alertMessage = "You must fill in text for follow-up!"
                            //self.showingAlert.toggle()
                            self.notificationShown = true
                        }
                            
                    }) {
                        Text("Save")
                            .foregroundColor(.green)
                    }
                    .alert(isPresented: $showingAlert) {
                        
                        Alert(title: Text("Important message"), message: Text("\(self.alertMessage)"), primaryButton: .destructive(Text("Yes"), action: { self.onDismiss()
                        }), secondaryButton: .cancel(Text("No")))
                        
                    }
                    .padding(.init(top: 5, leading: 30, bottom: 5, trailing: 0))
                    
                    Spacer()
                    
                    
                    // CANCEL BUTTON
                    Button(action: {
                        self.onDismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }.padding(.init(top: 5, leading: 0, bottom: 5, trailing: 30))
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
                        Text("\(self.dateEntered)")
                            .bold()
                            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 20))
                    }
                    
                    //  *******************************************************************************
                    
                    HStack {
                        Text("Person To Follow Up:   ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 10))
                        Text("\(self.fuPerson[personNumber])").foregroundColor(.blue).bold()
                            .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 40))
                        
                        Picker(selection: self.$personNumber, label: Text("")) {
                            
                            ForEach(0 ..< self.fuPerson.count) {
                                Text("\(self.fuPerson[$0])")
                                    .foregroundColor(.blue).bold()
                                
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            
                            
                            .frame(width: 200)
                        
                    }
                    .onAppear() {
                        self.personNumber = self.getPickerPerson(initials: self.followUpPerson!)
                        //print(self.personNumber)
                        //print(self.followUpPerson!)
                    }
                    
                    //  *******************************************************************************
                    
                    HStack(alignment: .center, spacing: 5) {
                        
                        DatePicker(selection: self.$followUpDate, displayedComponents: .date) {
                            Text("Follow Up Date:\n\(followUpDate, formatter: followUpDateFormatter)").foregroundColor(.purple)
                        }
                        .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 40))
                        
                    }
                    
                    HStack {
                        Text("Follow-up Text: ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        
                        MultilineTextField("Enter follow-up text here", text: $followUpText, onCommit: {
                            print("Final text: \(self.followUpText)")
                        }).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray).opacity(0.5))
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                    }
                    
                }
            }
            
            Spacer()
            
            
            
            
            
        }//.onAppear() { self.getFollowUpData(id: String(self.ID))}
        
        
    }
    
    
}


struct EditFollowUpView_Previews: PreviewProvider {
    static var previews: some View {
        EditFollowUpView(ID: 266, name: "Dolson", address: "16 Homestead Street", showingAlert: false, dateEntered: "02/24/2020", alertMessage: "HELP!", onDismiss: {Binding.constant(false)}, followUpText: "Just some text to fill in space.")
    }
}
