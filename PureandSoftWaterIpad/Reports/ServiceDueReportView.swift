//
//  ServiceDueReportView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 5/26/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import SwiftUI

struct ServiceDueReportView: View {
    
  @ObservedObject var reportVM = ContentViewModel()
    
    @State var showingServiceHistory: Bool = false
    @State var showingNewServiceView: Bool = false
    
    var id: Int = 0
    var custID: String = "1063"
    var name: String? = "Dolson, Tom"
    var address: String? = "16 Homested Avenue, Hillsdale, NJ 07642"
    var email: String
    
    var onDismiss: () -> ()
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5) {
            PageHeaderView(typePage: "SERVICE DUE REPORT", foregroundColor: .white, bgColor: .blue)
                .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
            Button("Refresh", action: {self.reportVM.fetchServiceData()})
            
            List {
                ForEach(reportVM.serviceData, id: \.self) { serviceData in
                    VStack (alignment: .leading) {
                        HStack {
                            Text("\(String(serviceData.id))").bold()
                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .foregroundColor(Color.white)
                                .frame(width: 60)
                                .background(Color.blue)
                                .cornerRadius(5)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            Text("\(serviceData.lastName!), \(serviceData.firstName!)")
                                .font(.system(size: 19))
                                .bold()
                                .padding(.init(top: -5, leading: 10, bottom: 0, trailing: 0))
                            Spacer()
                            Text("Next Service Date: ")
                            Text("\(formatStringDate(date: serviceData.nextServiceDate!))")
                                
                                .bold()
                                .foregroundColor(Color.black)
                                .frame(width: 110)
                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .background(Color.yellow)
                                .cornerRadius(5)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 3, leading: 0, bottom: 2, trailing: 0))
                        }
                        HStack {
                            HStack {
                                Image("ad_address").resizable().frame(width: 20, height: 20)
                                    .clipped()
                                    .clipShape(Circle())
                                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                    .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                                Text(" \(serviceData.address1!), \(serviceData.city!), \(serviceData.state!), \(serviceData.zip!)").bold()
                                .foregroundColor(.blue)
                            }
                            Spacer()
                            Text("Last Service Date: ")
//                            Text("\(serviceData.nextServiceDate!)")
                            Text("\(formatStringDate(date: serviceData.serviceDate!))")
                                .bold()
                                .foregroundColor(Color.white)
                                .frame(width: 110)
                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .background(Color.green)
                                .cornerRadius(5)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 1, leading: 0, bottom: 2, trailing: 0))
                        }
                        HStack {
                            Image("ad_home.phone").resizable().frame(width: 20, height: 20)
                                .clipped()
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 0))
                            Text("\(serviceData.homePhone!)")
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
                                ServiceHistoryView(showingServiceHistory: {Binding.constant(false)}(), custID: Int(self.custID)!, name: self.name!, address: self.address!)                            }
                        }
                        HStack {
                            Image("ad_cell.phone").resizable().frame(width: 20, height: 20)
                                .clipped()
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 0, leading: 30, bottom: 5, trailing: 0))
                            Text("\(serviceData.cellPhone!)")
                                .bold()
                                .font(.system(size: 17))
                                .foregroundColor(.green)
                                .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 0))
                                .frame(width: 140.0)
                            Spacer()
                            
                            Button(action: {
                                
                                self.showingNewServiceView.toggle()
                                
                            }) {
                                Image(systemName: "wrench")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 10))
                                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                
                            }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingNewServiceView) {
                                 
                                NewServiceView(onDismiss: {self.showingNewServiceView = false}, custID: String(self.custID), name: self.name! , address: self.address!, email: self.email, orderDate: formatDateString(date: Date()), serviceTime: "10:00 am")
                            }  
                        }
                    }
                }
            }
            .onAppear {
                self.reportVM.fetchServiceData()
            }
        }
    }
    
    func formatStringDate(date: String?) -> String {

        if (date != nil) && (date != " ") && (date?.isEmpty == false) {
            let dateFormat = DateFormatter()
                dateFormat.dateFormat = "mm/dd/yyyy"
            let newDate = dateFormat.date(from: date!)
            return dateFormat.string(from: newDate!)
        }
        
        return "Need Date"
    }
}

struct ServiceDueReportView_Previews: PreviewProvider {
    
    static var previews: some View {
        ServiceDueReportView(showingServiceHistory: false, custID: "1063", name: "Dolson, Tom", address: "16 Homestead Street", email: "tomdolson@pureandsoftwater.com", onDismiss: {Binding.constant(false)})
    }
}
