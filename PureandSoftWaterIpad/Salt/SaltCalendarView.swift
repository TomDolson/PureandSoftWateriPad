//
//  ContentView.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI
import Combine



struct SaltCalendarView : View {
    
    @State var singleIsPresented = false
    @State var startIsPresented = false
    @State var multipleIsPresented = false
    @State var deselectedIsPresented = false
    
    @ObservedObject var getSaltData = saltData()
    
    @State
    var saltDate = Date()
    
    @State var numberOfBagsTotal = 0
    @State var numberOfCustomers = 0
    
    // @State private var daySaltData = saltData()
    
    func startUp() {
        
        var jsonSaltData = [Calls.SaltCalendar]()
        
        var saltDateGroup: [String] = [""]
        
        var saltDate: String = ""
                
                let session = URLSession(configuration: .default)
                
                session.dataTask(with: URL(string: saltURL)!) { (data, _, _) in
                    
                    do {
                        
                        let fetch = try JSONDecoder().decode(Calls.self, from: data!)
                        
                        DispatchQueue.main.async {
               
                            jsonSaltData = fetch.saltCalendar
                          
                            for call in jsonSaltData {
                                
                                saltDate = call.DeliveryDate!
                                //print(" Salt Date: \(saltDate)")
                                if !saltDateGroup.contains(saltDate) {
                                    saltDateGroup.append(saltDate)
                                }
                         
                            }
                          
                            saltDateGroup.remove(at: 0)
                    
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yyyy"
                            
                            
                            //print("\(jsonData)")
                        }
                        
                    }
                    catch {
                        print(error)
                    }
                      
                }.resume()

    }
    
    func move(from source: IndexSet, to destination: Int) {
        
        var daySaltData = getSaltData.jsonSaltData.filter { cust in cust.DeliveryDate == formatSaltDate(date: self.saltDate) }
        
        daySaltData.move(fromOffsets: source, toOffset: destination)
        
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM, dd YYYY"
        return formatter
    }
    
    @State var showView: Bool = false
    @State var showPreview = false
    
    
    func getDocumentsDirectory() -> URL {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
        isDirectory: true)
        
        let url = temporaryDirectoryURL.appendingPathComponent("Daily Salt Report.pdf")
        
        print("Created document path: \(url)")
        
        return url
    }
    
    
    
 
    @State private var showPDF: Bool = false
    
    //let salt = getSaltData.jsonSaltData.map { Int($0.NumberOfBags) }.reduce(0, +)
    
    var body: some View {
        
        VStack {
            
            PageHeaderView(typePage: "Salt Calendar", foregroundColor: Color.black, bgColor: Color.yellow)
            HStack {
                VStack {
                    
                    Form {
                        DatePicker(selection: self.$saltDate, displayedComponents: .date, label: {
                      
                            VStack(alignment: .center) {
                                //Text("        Salt Date:\n\(self.saltDate, formatter: dateFormatter)").bold()
                                Text("             Salt Date: ")
                                    .bold()
                                    .foregroundColor(.black)
                            }
                            .labelsHidden()
                                        
                        })
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .shadow(color: Color.gray, radius: 5)
                        
                        VStack(alignment: .center, spacing: 3)
                        {
                            
                            Text("Number Of Customers")
                                .bold()
                                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                            
                            Text("\(self.getSaltData.jsonSaltData.filter {$0.DeliveryDate == formatSaltDate(date: saltDate)}.count)")
                                .bold()
                                .foregroundColor(.black)
                                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                                .background(Color.yellow)
                                .cornerRadius(10)
                                .shadow(color: Color.gray, radius: 5)
                            
                            
                            Text("Number Of Bags")
                                .bold()
                                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                            
                            Text("\(self.getSaltData.jsonSaltData.filter {$0.DeliveryDate == formatSaltDate(date: saltDate)}.map { Int($0.NumberOfBags!)! }.reduce(0, +))")
                                .bold()
                                .foregroundColor(.black)
                                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                                .background(Color.yellow)
                                .cornerRadius(10)
                                .shadow(color: Color.gray, radius: 5)
                            
                            
                            Text("Total Of Sales")
                                .bold()
                                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                            
                            Text("\(self.getSaltData.jsonSaltData.filter {$0.DeliveryDate == formatSaltDate(date: saltDate)}.map { Double($0.TotalSale!)! }.reduce(0, +))".convertDoubleToCurrency())
                                .bold()
                                .foregroundColor(.black)
                                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                                .background(Color.yellow)
                                .cornerRadius(10)
                                .shadow(color: Color.gray, radius: 5)
                            
                            
                            
                        }.frame(width: 290, height: 225)
                    }
                    .frame(width: 350, height: 350)
                    
                    
                    
                    Form {
                        
                        VStack(alignment: .center, spacing: 5) {
                            
                            Button("Print Salt Delivery Report") {
                                printSaltReport(deliveryDate: changeDateToString(date: self.saltDate), shortDeliveryDate: formatSaltDate(date: self.saltDate)); self.showPreview = true;
                                self.showPDF = true
                                
                            }   .background(DocumentPreview($showPreview, url: self.getDocumentsDirectory()))
                                .padding(.init(top: 0, leading: 45, bottom: 0, trailing: 0))
                            
                        }
                        
                    }
                    .frame(width: 350, height: 120)
                    
                    Spacer()
                    
                }
       
                VStack {
                    
                    Text("\(changeDateToString(date: saltDate))")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.black)
                        .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .shadow(color: Color.gray, radius: 5)
                        .padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                    
                    
                    
                    LoadingView(isShowing: self.$getSaltData.isLoading) {
                        
                        
                        NavigationView {
                            List {
                                //Section(header: Text("Other tasks"), footer: Text("End"))
                                ForEach(self.getSaltData.jsonSaltData.filter { cust in cust.DeliveryDate == formatSaltDate(date: self.saltDate) },
                                        
                                        id: \.self) { call in
                                    
                                       SaltDeliveryRowView(id: call.id!, custId: call.CustID!, name: call.Name!, address: call.Address1!, orderDate: call.OrderDate!, city: call.City!, state: call.State!, zip: call.Zip!, email: call.Email!, cell: call.CellPhone!, home: call.HomePhone!, numberOfBags: call.NumberOfBags!, comments: call.Comments!)
                                    
                                    //Text("Testing \(call.NumberOfBags!)")
                                }
                                .onMove(perform: move)
                            }
                            
                            .toolbar {
                                
                                EditButton()
                                  
                            }
                        }
                        //.padding(.init(top: 0, leading: 0, bottom: -105, trailing: 0))
                        
                    }
                    
                    
                }.onAppear(perform: self.startUp)
                    .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
    
    
}



func changeSaltDateToString(date: Date?) -> String {
    let newDate: Date?
    if date == nil {
        newDate = Date()
    } else {
        newDate = date
    }
     let formatter = DateFormatter()
    formatter.locale = .current
    
    formatter.dateFormat = "EEEE, MMM, dd yyyy"
    return formatter.string(from: newDate!)
}

func changeDateToString(date: Date?) -> String {
    let newDate: Date?
    if date == nil {
        newDate = Date()
    } else {
        newDate = date
    }
     let formatter = DateFormatter()
    formatter.locale = .current
    
    formatter.dateFormat = "EEEE  ->  MMM, dd  yyyy"
    return formatter.string(from: newDate!)
}

func formatSaltDate(date: Date) -> String {
    
    //let newDate : String
    
    let formatter = DateFormatter()
    formatter.locale = .current
    
    formatter.dateFormat = "M/d/yyyy"
    
    return formatter.string(from: date)
}

//#if DEBUG
struct SaltCalendarView_Previews : PreviewProvider {
    
    //@Binding var selectedDateClicked: Date?
    
     static var previews: some View {
        SaltCalendarView()
       
    }
}
//#endif

extension String{
    func convertDoubleToCurrency() -> String{
        let amount1 = Double(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        return numberFormatter.string(from: NSNumber(value: amount1!))!
    }
}
