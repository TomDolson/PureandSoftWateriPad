//
//  FollowUpRowView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/19/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct FollowUpRowView: View {
    
    @State var showingFollowUp = false
    @State var showingServiceHistory = false
    @State var showingSaltHistory = false
    @State var showingEditFollowUp = false
    
    var id: Int = 0
    var custId: String = "1063"
    var name: String? = "Dolson, Tom"
    var enterDate: String? = "01/09/2020"
    var followUpDate: String? = "01/20/2020"
    var followUpPerson: String? = "TD"
    var address: String? = "16 Homested Avenue, Hillsdale, NJ 07642"
    var cell: String? = "201-755-6132"
    var home: String? = "201-358-4046"
    var email: String? = "tdolson@pureandsoftwater.com"
    var comment: String? = "This is a sales call. I need to see the customer and sell them on a water softener."
    
    var showDetails = false
    
    var alertMessage = ""
    
    func changeStringToDate(dateString: String) -> Date {
        
        let newDate: String
        if dateString == "" {
            newDate = "02/19/2020"
        } else {
            newDate = dateString
        }
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.date(from: newDate)!
    }
    
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
                Text("\(self.name!)")
                    .font(.system(size: 18))
                    .bold()
                    .lineLimit(2)
                    .padding(.init(top: 5, leading: 40, bottom: 7, trailing: 0))
                
                Text("\(self.address!)")
                    .font(.system(size: 17))
                    .lineLimit(2)
                    .padding(.init(top: 5, leading: 40, bottom: 0, trailing: 0))
                HStack {
                    HStack {
                        Image("home_phone").resizable().frame(width: 30, height: 30)
                            .clipped()
                            .clipShape(Circle())
                            .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 0))
                        Text("\(self.home!)")
                            .bold()
                            .foregroundColor(.green)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .frame(width: 140.0)
                    }
                    HStack {
                        Image("cell_phone").resizable().frame(width: 30, height: 30)
                            .clipped()
                            .clipShape(Circle())
                            .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
                        Text("\(self.cell!)")
                            .bold()
                            .foregroundColor(.green)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .frame(width: 140.0)
                    }
                }
                HStack {
                    Image("email").resizable().frame(width: 30, height: 30)
                        .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 0))
                        .clipped()
                    if "\(self.email!)" != "" {
                        Text("\(self.email!)")
                            .bold()
                            .foregroundColor(.green)
                            .padding(.init(top: 0, leading: 3, bottom: 0, trailing: 0))
                    }
                }
                Text("Follow-up:")
                .foregroundColor(Color.blue)
                .padding(.init(top: 4, leading: 40, bottom: 2, trailing: 5))
               Text("\(self.comment!)")
                    .bold()
                    .italic()
                    .lineLimit(nil)
                    .font(.system(size: 18))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.init(top: 5, leading: 40, bottom: 15, trailing: 0))
                
                HStack(alignment: .center, spacing: 5) {
                    
                    
                    Button(action: {
                        self.showingEditFollowUp.toggle()
                    }) {
                        Text("  Edit  ")
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                            .background(Color.green)
                            .cornerRadius(5)
                            .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                            .padding(.init(top: 2, leading: 10, bottom: 5, trailing: 5))
                    }.buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showingEditFollowUp)  {
                            EditFollowUpView(ID: self.id, name: self.name!, address: self.address!, showingAlert: false, dateEntered: self.enterDate!, alertMessage: "HELP!", onDismiss: {self.showingEditFollowUp = false}, followUpText: self.comment!, followUpDate: self.changeStringToDate(dateString: self.followUpDate!), followUpPerson: self.followUpPerson!)
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
               HStack {
                   ExDivider()
               }
            }
           
        }
    }
}

struct FollowUpRowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowUpRowView(showingFollowUp: false, showingServiceHistory: false, showingSaltHistory: false, showingEditFollowUp: false, id: 1063, custId: "1063", name: "Dolson, Tom & Dina", enterDate: "02/19/2020", followUpDate: "02/29/2020", address: "16 Homestead Street, Hillsdale, NJ 07642", cell: "201-406-8958", home: "201-358-4046", email: "tomdolson@gmail.com", comment: "This is where the follow-up text goes. It should expand across several lines if necessary.", showDetails: true)
    }
}
