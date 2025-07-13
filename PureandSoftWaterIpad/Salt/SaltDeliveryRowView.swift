//
//  SaltDeliveryRowView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 3/5/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

//
//  ServiceRowView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 1/5/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct SaltDeliveryRowView: View {
    
    @State var showingFollowUp = false
    @State var showingServiceHistory = false
    @State var showingSaltHistory = false
    @State var showingServiceEdit = false
    
    var id: Int = 0
    var custId: String = "1063"
    var name: String? = "Dolson, Tom"
    var address: String? = "16 Homestead Avenue"
    var orderDate: String? = "02/29/2020"
    var city: String? = "Hillsdale"
    var state: String? = "NJ"
    var zip: String? = "07642"
    var email: String? = "tdolson@pureandsoftwater.com"
    var cell: String? = "201-755-6132"
    var home: String? = "201-358-4046"
    var numberOfBags: String? = "10"
    var comments: String? = "This is the Lead List comments. We need to show the saly comments here."
    var saltComments: String? = "This is the salt comments. We need to see the customer's special requests here."
    //var serviced: Bool = false
    
    var showDetails = false
    
    var showingAlert: Bool = false
    
    var alertMessage: String = "Test"
    
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
                    
                    Text("\(self.numberOfBags!) Bags")
                        .bold()
                        .foregroundColor(Color.black)
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .shadow(color: Color.gray, radius: 5)
                        .padding(.init(top: 1, leading: 3, bottom: 1, trailing: 5))
                    
                    Text("\(self.name!)")
                        .font(.system(size: 19))
                        .bold()
                        .lineLimit(2)
                        .padding(.init(top: 5, leading: 2, bottom: 4, trailing: 0))
                }
                HStack {
                    Image("ad_address").resizable().frame(width: 35, height: 35)
                        .clipped()
                        .clipShape(Circle())
                        .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
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
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
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
                        .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                    if "\(self.email!)" != "" {
                        Text("\(self.email!)")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.blue)
                            .padding(.init(top: 0, leading: 3, bottom: 0, trailing: 0))
                    }
                }
                
                if !(String(self.comments!.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty) {
                    
                    HStack {
                        Text("\(self.comments!)")
                            .font(.system(size: 17))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 0))
                    }
                } else
                {
                    
                }
                
                
                HStack(alignment: .center, spacing: 5) {
                    
//
//                    Button(action: {
//                        self.showingServiceEdit.toggle()
//                    }) {
//                        Text("  Edit  ")
//                            .bold()
//                            .foregroundColor(Color.white)
//                            .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
//                            .background(Color.green)
//                            .cornerRadius(5)
//                            .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
//                            .padding(.init(top: 2, leading: 5, bottom: 5, trailing: 5))
//                    }.buttonStyle(BorderlessButtonStyle())
//                        .sheet(isPresented: $showingServiceEdit) {
//
//                            //Text("Find The Problem")
//                            EditServiceView(ID: self.id, describeProblem: self.describeProblem!, serviced: self.serviced, name: self.name!, address: self.address!, orderDate: self.orderDate!, showingAlert: self.showingAlert, alertMessage: self.alertMessage, onDismiss: {
//                                                        self.showingServiceEdit = false})
//                    }
//
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
                            .padding(.init(top: 2, leading: 10, bottom: 5, trailing: 5))
                    }.buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showingServiceHistory)  {
                            ServiceHistoryView(showingServiceHistory: {Binding.constant(false)}(), custID: Int(self.custId)!, name: self.name!, address: self.address!)
                    }
                    Button(action: {
                        self.showingSaltHistory.toggle()
                    }) {
                        Text("  Salt  ")
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
//                    Button(action: {
//                        self.showingFollowUp.toggle()
//                    }) {
//                        Text("Follow-Up")
//                            .bold()
//                            .foregroundColor(Color.white)
//                            .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
//                            .background(Color.purple)
//                            .cornerRadius(5)
//                            .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
//                            .padding(.init(top: 2, leading: 3, bottom: 5, trailing: 0))
//                    }.buttonStyle(BorderlessButtonStyle())
//                    .sheet(isPresented: $showingFollowUp)  {
//                        NewFollowUpView(custID: Int(self.custId)!, name: self.name!, address: self.address!, onDismiss: {self.showingFollowUp = false}, followUpText: "")
//                    }
                }
               //ExDivider()
            }
           
        }
    }
}


struct SaltDeliveryRowView_Previews: PreviewProvider {
    static var previews: some View {
     Group {

        SaltDeliveryRowView(showingFollowUp: false, showingServiceHistory: false, showingSaltHistory: false, showingServiceEdit: false, id: 1063, custId: "1063", name: "Dolson, Tom",  address: "16 Homestead Street", city: "Hillsdale", state: "NJ", zip: "07642", email: "tomdolson@gmail.com", cell: "201-406-8958", home: "201-358-4046", numberOfBags: "10", comments: "Nothing major, just a little leak.", saltComments:  "This is a salt customer. We need to see the customer's special requests here.", showDetails: false)
                    }
                }
}

