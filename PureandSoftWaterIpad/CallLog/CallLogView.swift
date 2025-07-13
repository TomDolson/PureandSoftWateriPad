//
//  CallLogView.swift
//  CallLogView
//
//  Created by Tom Dolson on 12/1/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import SwiftUI

struct CallLog: Codable {
    var calls: [Call]
    
    init(calls: [Call]) {
        self.calls = calls
    }
}

struct Call: Codable, Identifiable {
    let id: Int
    let CustID: Int?
    let TypeCall: String?
    let WhosCall: String?
    let DateCalled: String?
    let CustomerName: String?
    let Address: String?
    let HomePhone: String?
    let CellPhone: String?
    let Email: String?
    let Message: String?
    let Notes: String?
    let Done: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case CustID = "CustID"
        case TypeCall = "TypeCall"
        case WhosCall = "WhosCall"
        case DateCalled = "DateCalled"
        case CustomerName = "CustomerName"
        case Address = "Address"
        case HomePhone = "HomePhone"
        case CellPhone = "CellPhone"
        case Email = "Email"
        case Message = "Message"
        case Notes = "Notes"
        case Done = "IDone"
        
    }
}

struct CallLogView: View {
    
    @State private var calls = [Call]()
    
    @State var showingServiceHistory = false
    
    @State var showingSaltHistory = false
    
    @State var showingNewServiceView = false
    
    @State private var searchCustomer = ""
    
    var body: some View {
        
        
        VStack {
            PageHeaderView(typePage: "Call Log", foregroundColor: .white, bgColor: .black)
            
            HStack {
                TextField("Search if Customer", text: $searchCustomer)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    //self.showingServiceHistory.toggle()
                }) {
                    Text("New Call")
                        .bold()
                        .foregroundColor(Color.green)
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 15))
                    //                        .background(Color.blue)
                    //                        .cornerRadius(5)
                    //                        .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                    //                        .padding(.init(top: 1, leading: 3, bottom: 5, trailing: 0))
                }.buttonStyle(BorderlessButtonStyle())
            }
            
            List(calls, id: \.id) {customer in
                LazyVStack(alignment: .leading) {
                    
                    HStack {
                        Text(customer.CustomerName!)
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack {
                            Text("Date Called: ")
                            Text(customer.DateCalled!).bold()
                        }
                        
                    }
                    
                    HStack {
                        Image("ad_address").resizable().frame(width: 20, height: 20)
                            .clipped()
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                        
                        Text(customer.Address!)
                            .padding(.leading, 10)
                    }
                    HStack {
                        Image("ad_home.phone").resizable().frame(width: 20, height: 20)
                            .clipped()
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                        Text("\(customer.HomePhone!)")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.green)
                            .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 0))
                            .frame(width: 140.0)
                        
                        Spacer()
                        Button(action: {
                            self.showingServiceHistory.toggle()
                        }) {
                            Text("Service")
                                .bold()
                                .foregroundColor(Color.white)
                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .background(Color.blue)
                                .cornerRadius(5)
                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 1, leading: 3, bottom: 5, trailing: 0))
                        }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingServiceHistory)  {
                                //                                ServiceHistoryView(custID: Int(exactly: customer.id)!, name: customer.Name!, address: customer.Address!, onDismiss: {
                                //                                    self.showingServiceHistory = false})
                                
                            }
                    }
                    
                    HStack {
                        Image("ad_cell.phone").resizable().frame(width: 20, height: 20)
                            .clipped()
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.init(top: 0, leading: 10, bottom: 5, trailing: 0))
                        Text("\(customer.CellPhone!)")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.green)
                            .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 0))
                            .frame(width: 140.0)
                        Spacer()
                        
                        Button(action: {
                            
                            //self.showingNewServiceView.toggle()
                            
                        }) {
                            Text("Salt")
                                .bold()
                                .foregroundColor(Color.black)
                                .padding(.init(top: 2, leading: 20, bottom: 2, trailing: 20))
                                .background(Color.yellow)
                                .cornerRadius(5)
                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 1, leading: 3, bottom: 5, trailing: 0))
                        }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingSaltHistory)  {
                                //                                ServiceHistoryView(custID: Int(exactly: customer.id)!, name: customer.Name!, address: customer.Address!, onDismiss: {
                                //                                    self.showingServiceHistory = false})
                                
                            }
                    }
                }  .listRowBackground(Color.gray)
            }.listStyle(.plain)
            .task {
                await loadData()
            }
        }
        
    }
    
    func loadData() async {
        guard
            let url = URL(string: "http://www.pureandsoftwater.com/ipadcalllog.aspx") else {
                print("Invalid URL")
                return
            }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(CallLog.self, from: data) {
                calls = decodedResponse.calls
            }
            
        } catch {
            print("Invalid Data")
        }
    }
    
}
//        VStack(alignment: .center) {
//
//            PageHeaderView(typePage: "Call Log", foregroundColor: .white, bgColor: .black)
//
//            List(customers, id: \.id) {customer in
//                VStack(alignment: .leading) {
//                    Text(customer.Name!)
//                        .font(.headline)
//
//                    HStack {
//                        Image("ad_address").resizable().frame(width: 20, height: 20)
//                            .clipped()
//                            .clipShape(Circle())
//                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
//                            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
//
//                        Text(customer.Address!)
//                            .padding(.leading, 10)
//                    }
//                    HStack {
//                        Image("ad_home.phone").resizable().frame(width: 20, height: 20)
//                            .clipped()
//                            .clipShape(Circle())
//                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
//                            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
//                        Text("\(customer.HomePhone!)")
//                            .bold()
//                            .font(.system(size: 17))
//                            .foregroundColor(.green)
//                            .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 0))
//                            .frame(width: 140.0)
//                        Spacer()
//                        Button(action: {
//                            self.showingServiceHistory.toggle()
//                        }) {
//                            Text("Service")
//                                .bold()
//                                .foregroundColor(Color.white)
//                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
//                                .background(Color.blue)
//                                .cornerRadius(5)
//                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
//                                .padding(.init(top: 1, leading: 3, bottom: 5, trailing: 0))
//                        }.buttonStyle(BorderlessButtonStyle())
//                            .sheet(isPresented: $showingServiceHistory)  {
//                                                                ServiceHistoryView(custID: Int(self.custID)!, name: self.name!, address: self.address!, onDismiss: {
//                                                                self.showingServiceHistory = false})                            }
//
//                            }
//                    }
//                    HStack {
//                        Image("ad_cell.phone").resizable().frame(width: 20, height: 20)
//                            .clipped()
//                            .clipShape(Circle())
//                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
//                            .padding(.init(top: 0, leading: 10, bottom: 5, trailing: 0))
//                        Text("\(customer.CellPhone!)")
//                            .bold()
//                            .font(.system(size: 17))
//                            .foregroundColor(.green)
//                            .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 0))
//                            .frame(width: 140.0)
//                        Spacer()
//
//                        Button(action: {
//
//                            self.showingNewServiceView.toggle()
//
//                        }) {
//                            Image(systemName: "wrench")
//                                .resizable()
//                                .frame(width: 35, height: 35)
//                                .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 10))
//                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
//
//                        }.buttonStyle(BorderlessButtonStyle())
//                        .sheet(isPresented: $showingNewServiceView) {
//
////                            NewServiceView(onDismiss: {self.showingNewServiceView = false}, custID: String(self.custID), name: self.name! , address: self.address!, email: self.email, orderDate: formatDateString(date: Date()), serviceTime: "10:00 am")
//                        }
//                    }

//                }
//
//            }
//            .task {
//                await loadData()
//            }
//        }
//
//    }
//
//    func loadData() async {
//        guard
//            let url = URL(string: "http://www.pureandsoftwater.com/ipadcustomer.aspx") else {
//                print("Invalid URL")
//                return
//            }
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//
//            if let decodedResponse = try? JSONDecoder().decode(CallLog.self, from: data) {
//                customers = decodedResponse.customers
//            }
//
//        } catch {
//            print("Invalid Data")
//        }
//    }
//}
//
//
struct CallLogView_Previews: PreviewProvider {
    static var previews: some View {
        CallLogView()
    }
}
