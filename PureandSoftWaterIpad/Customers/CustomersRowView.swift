//
//  CustomersRowView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/11/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation

struct CustomersRowView: View {
    
    var id: Int
    var name, address, homePhone, cellPhone, email, comment: String
    
    @State var showingCustomerMapView: Bool = false
    
    @State var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.0016818, longitude: -74.020898)
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Text("\(name)")//-> CustID: \(id)")
                        .font(.system(size: 19))
                        .bold()
                        .lineLimit(2)
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 0))
                }
                HStack {
                    
                    Button(action: {
                        
                        self.showingCustomerMapView.toggle()
                        
                    }) {
                        Image("ad_address")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipped()
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                        
                    }.buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showingCustomerMapView) {
                            
                            //CustomerMapView(name: name, address: address)
                            MapView(name: name, address: address)
                        }
                    
                    Text("\(address)")
                        .bold()
                        .font(.system(size: 17))
                        .foregroundColor(.blue)
                        .lineLimit(2)
                        .padding(.init(top: 3, leading: 7, bottom: 0, trailing: 0))
                }
                VStack {
                    HStack {
                        Image("ad_home.phone").resizable().frame(width: 40, height: 40)
                            .clipped()
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                        Text("\(homePhone)")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.green)
                            .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 0))
                            .frame(width: 140.0)
                    }
                    HStack {
                        Image("ad_cell.phone").resizable().frame(width: 40, height: 40)
                            .clipped()
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                        Text("\(cellPhone)")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.green)
                            .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 0))
                            .frame(width: 140.0)
                    }
                }
                HStack {
                    Image("ad_email")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                        
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    if "\(email)" != "" {
                        Text("\(email)")
                            .bold()
                            .foregroundColor(.blue)
                            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                }
                
                
                HStack(alignment: .top) {
                    if comment != "" {
                        VStack(alignment: .leading) {
                            Text("Comment:")
                                .foregroundColor(Color.blue)
                                .padding(.init(top: 4, leading: 10, bottom: 2, trailing: 5))
                            Text("\(comment)")
                                .lineLimit(nil)
                                .padding(.init(top: 2, leading: 13, bottom: 4, trailing: 5))
                            
                        }
                    } else {
                        EmptyView()
                    }
                    
                }
                
            }

            Spacer()
            // Area for buttons
            
            
            //HStack {
            CustomerButtons(custID: id, name: name, address: address, email: email)
                .frame(width: 150)
            //}
        }
    }
    
}

struct CustomerButtons: View {
    
    @State var showingFollowUp = false
    @State var showingServiceHistory = false
    @State var showingSaltHistory = false
    @State var showingCustomerDetail = false
    @State var showingNewServiceView = false
    @State var showingNewSaltView = false
    @State var showingEditCustomerView = false
    
    var custID: Int
    var name: String
    var address: String
    var email: String
  
    var body: some View {
       
        VStack(alignment: .center, spacing: 5) {
     
            HStack {
                
                ZStack {
                    Button(action: {
                        
                        self.showingEditCustomerView.toggle()
                        
                    }) {
                        Image(systemName: "pencil")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 35, height: 35)
                            .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 10))
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)

                    }.buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showingEditCustomerView) {
                            EditCustomerView( onDismiss: {self.showingEditCustomerView = false})
                    }
                    
                }
                
                ZStack {
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
                              
                            NewServiceView(onDismiss: {self.showingNewServiceView = false}, custID: String(self.custID), name: self.name, address: self.address, email: self.email, orderDate: formatDateString(date: Date()), serviceTime: "10:00 am")
                           }
                }
                
                ZStack {
                    Button(action: {
                        self.showingNewSaltView.toggle()
                    }) {
                        Image(systemName: "snow")
                            .resizable()
                            .foregroundColor(.yellow)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .frame(width: 35, height: 35)
                            .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 25))
                            
                    }.buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showingNewSaltView) {
                            NewSaltView( onDismiss: {self.showingNewSaltView = false})
                    }
                }
            }
            ZStack {
                Button(action: {
                    self.showingCustomerDetail.toggle()
                }) {
                    Text(" Details  ")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(Color.green)
                        .cornerRadius(5)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
                }
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showingCustomerDetail) {
                    CustomerDetailView(custID: String(self.custID), name: String(self.name), onDismiss: {self.showingCustomerDetail = false})
                }
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
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
                }
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showingServiceHistory) {
                    ServiceHistoryView(showingServiceHistory: $showingServiceHistory, custID: self.custID, name: self.name, address: self.address)
                   
                }
                
                Button(action: {
                    self.showingSaltHistory.toggle()
                }) {
                    Text(" Salt   ")
                        .bold()
                        .foregroundColor(Color.black)
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
                }
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showingSaltHistory) {
                    SaltHistoryView(showingSaltHistory: $showingSaltHistory, custID: self.custID, name: self.name, address: self.address)
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
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
                }
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showingFollowUp) {
                    NewFollowUpView(custID: Int(self.custID), name: self.name, address: self.address, onDismiss: {self.showingFollowUp = false}, followUpText: "")
                }
            }
        
    }
}

func formatDateString(date: Date) -> String {
    
    //let newDate : String
    
    let formatter = DateFormatter()
    formatter.locale = .current
    
    formatter.dateFormat = "MM/dd/yyyy"
    
    return formatter.string(from: date)
}

struct CommentView: View {
    @State var comment: String = "A little bit of text to see how this will look."
    var body: some View {
        VStack {
            Color.white
            VStack(alignment: .leading, spacing: 2) {
                
                HStack(alignment: .top) {
                    Text("\(self.comment)")
                        .frame(width: 225, height: 180)
                        .background(RoundedRectangle(cornerRadius: 25)
                            .fill(Color.offWhite)
                            .frame(width: 250, height: 200)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5))
                }
                Spacer()
                
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension Color {

    static let offWhite = Color(red:  232 / 255, green: 232 / 255, blue: 232 / 255)

}

struct CustomersRowView_Previews: PreviewProvider {
    static var previews: some View {
        CustomersRowView(id: 1063, name: "Dolson, Tom", address: "16 Homestead Street, Hillsdale, NJ 07642", homePhone: "201-358-4046", cellPhone: "201-406-8958", email: "tomdolson@gmail.com", comment: "This is the comment area...")
    }
}
