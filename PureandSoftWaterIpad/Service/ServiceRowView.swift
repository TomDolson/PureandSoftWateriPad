//
//  ServiceRowView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 1/5/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI


struct ServiceRowView: View {
    
    @State var showingFollowUp = false
    @State var showingServiceHistory = false
    @State var showingSaltHistory = false
    @State var showingServiceEdit = false
    var count : Int 
    var id: Int
    var orderDate: String? = "02/29/2020"
    var custId: String = "1063"
    var name: String? = "Dolson, Tom"
    var futureServiceDate: String? = "04/12/2021"
    var serviceDate: String? = "01/09/2020"
    var serviceTime: String? = "12:00am"
    var address: String? = "16 Homested Avenue"
    var city: String? = "Hillsdale"
    var state: String? = "NJ"
    var zip: String? = "07642"
    var cell: String? = "201-755-6132"
    var home: String? = "201-358-4046"
    var email: String? = "tdolson@pureandsoftwater.com"
    var serviceType: String? = "Sales Call"
    var describeProblem: String? = "This is a sales call. I need to see the customer and sell them on a water softener."
    var serviced: Bool = false
    var service: Bool = false
    
    var showDetails = false
    
    var showingAlert: Bool = false
    
    var alertMessage: String = "Test"
    
    @State var showingCustomerMapView: Bool = false
    
    struct ExDivider: View {
        let color: Color = .gray
        let height: CGFloat = 8
        var body: some View {
            Rectangle()
                .fill(color)
                .frame(height: height)
                .cornerRadius(3)
                .edgesIgnoringSafeArea(.horizontal)
        }
    }
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    ExDivider()
                }
                HStack {
                    
                    Text("\(count)")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(Color.black)
                        .cornerRadius(5)
                        .shadow(color: Color.gray, radius: 5)
                        .padding(.init(top: 2, leading: 3, bottom: 2, trailing: 5))
                    
                    Text("\(self.serviceTime!)")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(Color.blue)
                        .cornerRadius(5)
                        .shadow(color: Color.gray, radius: 5)
                        .padding(.init(top: 2, leading: 3, bottom: 2, trailing: 5))
                    
                    Text("\(self.name!)")
                        .font(.system(size: 19))
                        .bold()
                        .lineLimit(2)
                        .padding(.init(top: 10, leading: 2, bottom: 7, trailing: 0))
                }
                HStack {
                    
                    Button(action: {
                        
                        self.showingCustomerMapView.toggle()
                        
                    }) {
                        Image("ad_address").resizable().frame(width: 35, height: 35)
                            .clipped()
                            .clipShape(Circle())
                            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                            .buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingCustomerMapView) {
                                
                                MapView(name: name!, address: address!)
                            }
                    }
                        Text("\(self.address!), \(self.city!), \(self.state!) \(self.zip!)")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.blue)
                            .lineLimit(2)
                            .padding(.init(top: 5, leading: 5, bottom: 0, trailing: 0))
                    }
                    HStack {
                        HStack {
                            Image("ad_home.phone").resizable().frame(width: 35, height: 35)
                                .clipped()
                                .clipShape(Circle())
                                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                            Text("\(self.home!)")
                                .bold()
                                .font(.system(size: 17))
                                .foregroundColor(.green)
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .frame(width: 140.0)
                        }
                        HStack {
                            Image("ad_cell.phone").resizable().frame(width: 35, height: 35)
                                .clipped()
                                .clipShape(Circle())
                                .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                            Text("\(self.cell!)")
                                .bold()
                                .font(.system(size: 17))
                                .foregroundColor(.green)
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .frame(width: 140.0)
                        }
                    }
                    HStack {
                        Image("ad_email").resizable().frame(width: 35, height: 35)
                            .clipped()
                            .clipShape(Circle())
                            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                        if "\(self.email!)" != "" {
                            Text("\(self.email!)")
                                .bold()
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                                .padding(.init(top: 0, leading: 3, bottom: 0, trailing: 0))
                        }
                    }
                    Text("\(self.serviceType!)")
                        .bold()
                        .foregroundColor(.blue)
                        .padding(.init(top: 5, leading: 10, bottom: 0, trailing: 5))
                    
                    Text("\(self.describeProblem!)")
                        .font(.system(size: 17))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 0))
                    
                    HStack(alignment: .center, spacing: 5) {
                        
                        
                        Button(action: {
                            self.showingServiceEdit.toggle()
                        }) {
                            Text("  Edit  ")
                                .bold()
                                .foregroundColor(Color.white)
                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .background(Color.green)
                                .cornerRadius(5)
                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 2, leading: 5, bottom: 5, trailing: 5))
                        }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingServiceEdit) {
                                
                                EditServiceView(ID: self.id, orderDate: self.orderDate!, futureServiceDate: self.futureServiceDate!, describeProblem: self.describeProblem!, serviced: self.serviced, service: self.service, name: self.name!, address: self.address!, showingAlert: self.showingAlert, alertMessage: self.alertMessage, onDismiss: {
                                    self.showingServiceEdit = false})
                            }
                        
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
                                .padding(.init(top: 2, leading: 3, bottom: 5, trailing: 5))
                        }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingServiceHistory)  {
                                ServiceHistoryView(showingServiceHistory: $showingServiceHistory, custID: Int(self.custId)!, name: self.name!, address: self.address!)
                            }
                        Button(action: {
                            self.showingSaltHistory.toggle()
                        }) {
                            Text(" Salt  ")
                                .bold()
                                .foregroundColor(Color.black)
                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .background(Color.yellow)
                                .cornerRadius(5)
                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 2, leading: 3, bottom: 5, trailing: 5))
                        }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingSaltHistory)  {
                                SaltHistoryView(showingSaltHistory: $showingSaltHistory, custID: Int(self.custId)!, name: self.name!, address: self.address!)
                            }
                        Button(action: {
                            self.showingFollowUp.toggle()
                        }) {
                            Text("Follow-Up")
                                .bold()
                                .foregroundColor(Color.white)
                                .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .background(Color.purple)
                                .cornerRadius(5)
                                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                                .padding(.init(top: 2, leading: 3, bottom: 5, trailing: 0))
                        }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingFollowUp)  {
                                NewFollowUpView(custID: Int(self.custId)!, name: self.name!, address: self.address!, onDismiss: {self.showingFollowUp = false}, followUpText: "")
                            }
                    }
                    //               ExDivider()
                }
                
            }
        }
    }
    
    
    struct ServiceRowView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                
                ServiceRowView(showingFollowUp: false, showingServiceHistory: false, showingSaltHistory: false, showingServiceEdit: false, count: 1, id: 1063, custId: "1063", name: "Dolson, Tom", serviceDate: "02/13/2020", serviceTime: "12:00am", address: "16 Homestead Street", city: "Hillsdale", state: "NJ", zip: "07642", cell: "201-406-8958", home: "201-358-4046", email: "tomdolson@gmail.com", serviceType: "Other...", describeProblem: "Nothing major, just a little leak.", showDetails: false)
            }
        }
    }
