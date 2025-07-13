//
//  NewServiceView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 4/5/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct NewServiceView: View {
    
    func timeArray() -> Array<String> {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        var timeSlots = [Double]()
        let firstTime: Double = 6
        let lastTime: Double = 20 // 8pm
        let slotIncrement = 0.25
        let numberOfSlots = Int((lastTime - firstTime) / slotIncrement)

        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .positional
        
        var i: Double = 0
        while timeSlots.count <= numberOfSlots {
            
            if (firstTime + i * slotIncrement < (13)) {
                timeSlots.append(firstTime + i * slotIncrement)
            } else {
                timeSlots.append((firstTime + i * slotIncrement) - 12)
            }
            i += 1
            //print(timeSlots)
        }
       
        var times = timeSlots.compactMap{dateComponentsFormatter.string(from: $0 * 60)}
        
    
        for i in 0..<times.count {
            
            if (i < 24) {
              times[i].append(" am")
            } else
            {
                times[i].append(" pm")
            }
            //print("Return: \(i) and \(times[i])")
        }
        //print(times)
        return times
    }
    
     
    var onDismiss: () -> ()
    
    @State
    var custID: String = "1063"
    
    @State
    var name: String = "Tom & Dina Dolson"
    
    @State
    var address: String = "16 Homestead Street, Hillsdale, NJ 07642"
    
    @State
    var email: String = "tomdolson@gmail.com"
    
    @State
    var orderDate: String = formatServiceDate(date: Date())
    
    @State
    var originator: String = "Dina Dolson"
    
    @State
    var serviceTech: String = "Doug Dolson"
    
    @State
    var serviceDate: Date = Date()
    
    @State
    var serviceTime: String = "10:00 am"
    
    @State
    var serviceType: String = "Sales Call"
    
    @State
    var describeProblem: String = ""
    
    @State
    var showingAlert: Bool = false
    
    @State
    var alertMessage: String = "Cancel Editing?"
    
    @State
    private var notificationShown = false
    
    @State
    private var results = [AddServiceCall.ServiceCall]()
    
    private var serviceDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM, dd YYYY"
        return formatter
    }
    @State
    var serviceTypeArray: [String] =
    ["Replace Filters",
    "Replace UV Bulb",
    "Service Leak",
    "Sales Call",
    "Softener Making Noise",
    "Install Neutralizer",
    "Install Other",
    "Install Softener",
    "Install Softener & Filter",
    "Install Softener & RO",
    "Install Softener, RO & Filter",
    "Other..."]
    
    @State
    var originatorArray: [String] =
        ["Dina Dolson",
         "Tom Dolson"]
    
    @State
    var techArray: [String] =
        ["Doug Dolson",
         "Tom Dolson"]
    
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
    
    func addNewServiceCall(custID: String, orderDate: String, originator: String, serviceTech: String , serviceDate: String, serviceTime: String, serviceType: String, describeProblem: String) -> Bool {
        // This function will be used to save the new service call data to the database
        
        var committed: Bool = false
        
        var comments: String = ""
        
            comments = describeProblem.RFC3986UnreservedEncoded

        // Build the url string for sending data to the SQL database

        let url = "http://www.pureandsoftwater.com/IpadAddNewServiceCall.aspx?orderDate=\(orderDate)&CustID=\(custID)&Originator=\(originator)&Tech=\(serviceTech)&ServiceDate=\(serviceDate)&ServiceTime=\(serviceTime)&ServiceType=\(serviceType)&DescribeProblem=\(comments)"
        
        guard let newURL = URL(string: url.replacingOccurrences(of: " ", with: "%20")) else {
            print("Invalid URL")
            return true
        }
        
       // Convert url string to URL
        let request = URLRequest(url: newURL)
        
        
        // Create the URL session to send the data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(AddServiceCall.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        results = decodedResponse.serviceCall
                    }

                    //print(results)
                    // everything is good, so we can exit
                    return committed = true
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
        
        return committed
        
    }

    
    var body: some View {
        VStack(alignment: .center) {
            PageHeaderView(typePage: "New Service Ticket", foregroundColor: Color.white, bgColor: Color.blue)
                .padding(.init(top: 20, leading: 0, bottom: -20, trailing: 0))
            
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .top, spacing: 2) {
                    
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(self.name)  -  \(self.address)")
            
                            .font(.system(size: 16))
                            .bold()
                            .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(color: Color.blue, radius: 3)
                            .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
                        
                        Text("Email: \(self.email)")
            
                            .font(.system(size: 16))
                            .bold()
                            .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(color: Color.blue, radius: 3)
                            .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
                    }
                }
            }
            
            HStack {
                
                // SAVE BUTTON
                saveButton
                
                Spacer()

                // CANCEL BUTTON
                cancelButton
                
            }.frame(height: 20)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Form {
                    
                    if self.notificationShown {
                        VStack(alignment: .center, spacing: 5) {
                            //if self.notificationShown {
                                NotificationView {
                                    Text("\(self.alertMessage)")
                                    
                                    Button("Ok!") {
                                        self.notificationShown.toggle()
                                    }
                                }
                            //}
                            
                        }.padding(.init(top: 5, leading: 200, bottom: 5, trailing: 5))
                        
                    } else {
                        EmptyView()
                    }
                    
                    HStack(alignment: .top, spacing: 5) {
                        
                        Text("Customer Id: ")
                            .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 5))
                        Text("\(custID)")
                            .bold()
                            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 20))
                    }
                    
                    HStack(alignment: .top, spacing: 5) {
                        
                        Text("Ordered Date: ")
                            .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 5))
                        Text("\(orderDate)")
                            .bold()
                            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 20))
                    }
                    
                    
                    HStack {
                        
                        // Originator Picker
                        Text("Originator: ").foregroundColor(.blue)
                            .padding(.init(top: -35, leading: 10, bottom: 5, trailing: 0))
                        
                        Picker(selection: $originator, label: Text("Originator:").foregroundColor(.blue)) {
                            ForEach(originatorArray, id: \.self) { orig in
                                Text("\(orig)")
                            }
                        }.frame(width: 220)
                        .clipped()
                        .pickerStyle(WheelPickerStyle())
                        
                        .padding(.init(top: -10, leading: 20, bottom: 40, trailing: 0))
                        
                        
                        // Tech Picker
                        Text("Tech: ").foregroundColor(.blue)
                            .padding(.init(top: -35, leading: 0, bottom: 5, trailing: 0))
                        
                        Picker(selection: $serviceTech, label: Text("Originator:").foregroundColor(.blue)) {
                            ForEach(techArray, id: \.self) { tech in
                                Text("\(tech)")
                            }
                        }.frame(width: 220)
                        .clipped()
                        .pickerStyle(WheelPickerStyle())
                        
                        .padding(.init(top: -10, leading: 0, bottom: 40, trailing: 0))
                        
                        
                    }.frame(width: 750, height: 90, alignment: .leading)
                    
                    HStack {
                        
                        // DatePicker to select "service date"
                        
                        DatePicker(selection: self.$serviceDate, displayedComponents: .date) {
                            Text("Service Date:      \( self.serviceDate, formatter: serviceDateFormatter)").foregroundColor(.blue)
                        }
                        .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 150))
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 5){
                        
                        // Picker to select "service time"
                        
                        HStack {
                            
                            Text("Service Time: ").foregroundColor(.blue)
                                .padding(.init(top: -45, leading: 10, bottom: 5, trailing: 0))
                            
                            Picker(selection: $serviceTime, label: Text("Service Time:").foregroundColor(.blue)) {
                                ForEach(timeArray(), id: \.self) { time in
                                    Text("\(time)")
                                }//.onAppear { serviceTime = "10:00 am" }
                            }.frame(width: 260, height: 210, alignment: .center)
                            .clipped()
                            .pickerStyle(WheelPickerStyle())
                            
                            .padding(.init(top: -30, leading: 0, bottom: 40, trailing: 100))
                            // }.frame(width: 560, height: 110, alignment: .center)
                            
                            
                        }
                        
                        
                        
                        //      VStack(alignment: .trailing, spacing: 5) {
                        
                        // Picker to select "service type"
                        
                        HStack {
                            
                            Text("Service Type: ").foregroundColor(.blue)
                                .padding(.init(top: -45, leading: 10, bottom: 5, trailing: 0))
                            
                            Picker(selection: $serviceType, label: Text("Service Type:").foregroundColor(.blue)) {
                                
                                ForEach(serviceTypeArray, id: \.self) { type in
                                    Text("\(type)")
                                    
                                }
                            }.frame(width: 260, height: 210, alignment: .center)
                            .clipped()
                            .pickerStyle(WheelPickerStyle())
                            
                            .padding(.init(top: -30, leading: 0, bottom: 40, trailing: 100))
                        }//.frame(width: 660, height: 110, alignment: .center)
                        
                    }
                    //    }.frame(width: 560, height: 110, alignment: .trailing)
                    
                    
                    HStack {
                        Text("Describe Problem: ").foregroundColor(.blue)
                            .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 5))
                        MultilineTextField("Enter problem here", text: self.$describeProblem, onCommit: {
                            //print("Final text: \(self.describeProblem)")
                        }).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray).opacity(0.5))
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                    }
                    
                }
            }
            
            Spacer()
        }
    }
    
    var saveButton: some View {
        Button(action: {
            
            if self.describeProblem != "" {
                
                if self.addNewServiceCall(custID: custID, orderDate: orderDate, originator: originator, serviceTech: serviceTech, serviceDate: self.changeDateToString(date: serviceDate), serviceTime: serviceTime, serviceType: serviceType, describeProblem: describeProblem) == true {
                    
                    self.alertMessage = "Your Record HAS Been Added!"
                    self.showingAlert.toggle()
                    //self.onDismiss()
                    
                    
                } else {
                    
                    self.alertMessage = "Your Record HAS Been Added!"
                    self.showingAlert.toggle()
                    //self.onDismiss()
                }
            }
            else {
                self.alertMessage = "You must fill in text for Describe Problem!"
                self.notificationShown = true
            }
        }) {
            Text("Save")
                .foregroundColor(.green)
        }.buttonStyle(BorderlessButtonStyle())
        .alert(isPresented: $showingAlert) {
            
            Alert(title: Text("Important message"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK"), action: {onDismiss()}))
            
        }
        .padding(.init(top: 5, leading: 30, bottom: 5, trailing: 0))
    }
    
    var cancelButton: some View {
        Button(action: {
            self.onDismiss()
        }) {
            Text("Cancel")
                .foregroundColor(.red)
        }.buttonStyle(BorderlessButtonStyle())
        .padding(.init(top: 5, leading: 0, bottom: 0, trailing: 50))
    }
}

struct NewServiceView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NewServiceView(onDismiss: {Binding.constant(false)})
    }
}
