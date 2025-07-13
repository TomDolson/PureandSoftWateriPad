//
//  EditServiceView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/22/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI
import Combine

struct EditServiceView: View {
    
    
    @State
    var ID: Int = 64256
    
    @State
    var orderDate: String = "02/29/2020"
    
    @State
    var futureServiceDate: String = "04/13/2021"
    
    @State
    var describeProblem: String = "This is the information to describe the problem. THE PROBLEM HAS BEEN RESOLVED."
    
    @State
    var serviced: Bool = false
    
    @State
    var service: Bool = false
    
    @State
    var name: String = "Tom & Dina Dolson"
    
    @State
    var address: String = "16 Homestead Street, Hillsdale, NJ 07642"
    
    @State
    var nextServiceDate = "Leave"
    
    @State
    var showingAlert: Bool = false
    
    @State
    var alertMessage: String = "Cancel Editing?"
    
    var onDismiss: () -> ()
    
    var nextServiceDateArray: [String] = ["Leave", "None", "1 Month", "2 Months", "3 Months", "4 Months", "5 Months", "6 Months", "7 Months", "8 Months", "9 Months", "10 Months", "11 Months", "1 Year"]
     
    @State
    private var results = [ServiceEditSave.Save]()
    
    @State
    private var serviceCallData = [Service.ServiceCallRecord]()
    
    @State
    private var notificationShown = false
    
 
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    struct ServiceEditSave: Codable {
        var editService: [Save]
        
        init(editService: [Save]) {
            self.editService = editService
        }
            struct Save: Codable {
                var ID: Int
                var orderDate: String
                //var futureServiceDate: String
                var nextServiceDate: String
                var describeProblem: String
                var serviced: String
        }
    }
    
    struct Service: Codable {
        let getServiceCall: [ServiceCallRecord]
        
        init(getServiceCall: [ServiceCallRecord]) {
            self.getServiceCall = getServiceCall
        }
        
        struct  ServiceCallRecord: Identifiable, Codable, Hashable {
            
            var id, serviced, service: Int
            var orderDate, futureServiceDate, serviceDate, describeProblem : String?
                
            enum CodingKeys: String, CodingKey {
                case id = "ID"
                case orderDate = "OrderDate"
                case futureServiceDate = "NextServiceDate"
                case serviceDate = "ServiceDate"
                case describeProblem = "DescribeProblem"
                case serviced = "Serviced"
                case service = "Service"
               
            }
        }
    }
    
    
    // This function is used to fetch the service call data from the database
    func getServiceCallData(id: String) {

        let leadListURL = "http://www.pureandsoftwater.com/ipadGetServiceCallRecord.aspx?ID=\(id)"

        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: leadListURL)!) { (data, _, _) in

            do {

                let fetch = try JSONDecoder().decode(Service.self, from: data!)

                DispatchQueue.main.async {

                    self.serviceCallData = fetch.getServiceCall

                }
            }
            catch {
                print(error)
            }

        }.resume()

    }
    
    // This function will be used to save the service call data to the database
    func updateServiceData(ID: String, nextServiceDate: String, describeProblem: String, serviced: Bool, service: Bool) -> Bool {
        
        var committed: Bool = false
        
        var serviceEditStr: String = ""
        
        var servicedStr = "0"
        
        var serviceStr = "0"
        
        serviceEditStr = describeProblem.RFC3986UnreservedEncoded
        
        if serviced {servicedStr = "1" }
        
        if service {serviceStr = "1" }
        
        // Build the url string for sending data to the SQL database
        let url = "http://www.pureandsoftwater.com/IpadServiceEdit.aspx?ID=\(ID)&NextServiceDate=\(nextServiceDate.replacingOccurrences(of: " ", with: "%20"))&DescribeProblem=\(serviceEditStr)&Serviced=\(String(servicedStr))&Service=\(String(serviceStr))"
    
        print(url)
        
        let newURL = URL(string: url.replacingOccurrences(of: " ", with: "%20"))
        
       // Convert url string to URL
        let request = URLRequest(url: newURL!)
        
        //print(newURL!)
        // Create the URL session to send the data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ServiceEditSave.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.editService
                    }

                    print(self.results)
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
            
            PageHeaderView(typePage: "Service Data Edit", foregroundColor: Color.white, bgColor: Color.green)
                .padding()
            

            HStack(alignment: .top, spacing: 5) {
                Text("\(self.name)  -  \(self.address)")
                    .font(.system(size: 16))
                    .bold()
                    .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.green, radius: 3)
                    .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 0))
                
            }
            VStack(alignment: .trailing, spacing: 5) {
                HStack(alignment: .top, spacing: 5) {
                    
                    // SAVE BUTTON
                    Button(action: {
                        
                        if self.describeProblem != "" {
                            
                            if self.updateServiceData(ID: String(self.ID), nextServiceDate: self.nextServiceDate, describeProblem: self.describeProblem, serviced:  self.serviced, service:  self.service) {
                                
                                self.alertMessage = "Your data has not been saved!"
                                self.showingAlert.toggle()
                                
                                
                            } else {
                                //self.showToast(controller: CustomerFollowUpView, message: "Your Data Has Been Saved", seconds: 3)
                                self.onDismiss()
                                //Alert(title: Text("Important message"), message: Text("Your data has been saved!"), dismissButton: .default(Text("Ok!")))
                            }
                        }
                        else {
                            self.alertMessage = "You must fill in text for Describe Problem!"
                            self.notificationShown.toggle()
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
            }//.onAppear(perform: getServiceCallData(id: String(ID)))
            
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
                        
                        Text("Ordered Date: ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        Text("\(self.orderDate)").foregroundColor(.blue)
                            .bold()
                            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 40))
                        
                        Text("Next Service Date: ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        Text("\(self.futureServiceDate)").foregroundColor(.blue)
                            .bold()
                            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 40))
                    }
                    
                    HStack(alignment: .center, spacing: 5) {
                        
                        Toggle(isOn: $serviced) {
                            Text("Serviced: ")
                        }.padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        //.background(serviced ? Color.green : Color.red)
                    }
                    
                    HStack(alignment: .center, spacing: 5) {
                        
                        Toggle(isOn: $service) {
                            Text("Should customer get periodic service? ")
                        }.padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        //.background(serviced ? Color.green : Color.red)
                    }
                    
                    HStack {
                        
                        Text("Next Service Date: ")
                            .padding(.init(top: -45, leading: 40, bottom: 5, trailing: 0))
                        
                        Picker(selection: $nextServiceDate, label: Text("Next Service Date:").foregroundColor(.blue)) {
                            ForEach(nextServiceDateArray, id: \.self) { months in
                                Text("\(months)")
                            }//.onAppear { serviceTime = "10:00 am" }
                        }.frame(width: 260, height: 210, alignment: .center)
                        .clipped()
                        .pickerStyle(WheelPickerStyle())
                        
                        .padding(.init(top: -30, leading: 0, bottom: 40, trailing: 100))
                        // }.frame(width: 560, height: 110, alignment: .center)
                    }
                    
                    
                    HStack {
                        Text("Describe Problem: ")
                            .padding(.init(top: 5, leading: 40, bottom: 5, trailing: 5))
                        MultilineTextField("Enter problem here.", text: self.$describeProblem, onCommit: {
                            //print("Final text: \(self.describeProblem)")
                        }).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray).opacity(0.5))
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                    }
                    
                }
            }

            Spacer()
        }
    }
    
}

struct NotificationView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        
        content
            .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(Color(.tertiarySystemBackground))
            
            .cornerRadius(16)
            .shadow(color: Color.red, radius: 3)
            .transition(.move(edge: .top))
            .animation(.spring())
            
    }
}


struct ServiceEditView_Previews: PreviewProvider {

    static var previews: some View {
        
//        EditServiceView(ID: 64256, describeProblem: "This is a problem!", serviced: true, name: "Dolson, Tom & Dina", address: "16 Homestead Street, Hillsdale, NJ 07642", orderDate: "03/07/2020", showingAlert: false, alertMessage: "Your data has been saved!", onDismiss: {Binding.constant(false)})
        
        EditServiceView(ID: 64256, name: "Dolson, Tom & Dina", address: "16 Homestead Street, Hillsdale, NJ 07642", onDismiss: {Binding.constant(true)})
    }
}
