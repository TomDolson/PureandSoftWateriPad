//
//  CustomerView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 1/18/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct CustomersView: View {
    
    @ObservedObject
    var getData = leadListData()
    
    @State
    private var searchTerm: String = ""
    
    @State
    var totalActive: Int = 0
    
    @State
    var totalRecordsInList: Int = 0
    
    @State
    var showingNewCustomerView: Bool = false
    
    var activeArray: [String] = ["All", "Active", "InActive"]
    
    struct ExDivider: View {
        let color: Color = .gray
        let height: CGFloat = 6
        var body: some View {
            Rectangle()
                .fill(color)
                .frame(height: height)
                .cornerRadius(3)
                .edgesIgnoringSafeArea(.horizontal)
        }
    }
    
    var body: some View {
        VStack {
            PageHeaderView(typePage: "Customer Search", foregroundColor: Color.white, bgColor: Color.green)
            
            HStack{
                Spacer()
                
                Text ("Total Active/Inactive: \(self.getData.jsonData.count)")
                    .font(.system(size: 16))
                    .bold()
                    .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.green, radius: 3)
                    .padding(.init(top: -10, leading: 50, bottom: 5, trailing: 0))
                
                Spacer()
                
                ZStack {
                    Button(action: {
                        
                        self.showingNewCustomerView.toggle()
                        
                    }) {
                        
                        Image(systemName: "plus.circle")
                            .resizable()
                            .foregroundColor(.green)
                            .cornerRadius(30)
                            .frame(width: 40, height: 40)
                            .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 30))
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        
                    }.buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showingNewCustomerView) {
                            NewCustomerView( onDismiss: {self.showingNewCustomerView = false})
                    }
                    
                }
            }
            
            VStack {
                
                GeometryReader { geo in
                    HStack {
                        
                        SearchBar(text: self.$searchTerm)
                            .frame(width: geo.size.width / 2 , height: 25)
 
                        Picker(selection: self.$getData.active, label: Text("Active")) {
                            ForEach(0 ..< self.activeArray.count, id: \.self) {
                                Text(self.activeArray[$0])
                            }
                            
                        }.pickerStyle(SegmentedPickerStyle())
                            .frame(width: 200)
                    }
                }
                
            }.frame(height: 50)
                .padding(.init(top: 4, leading: 10, bottom: 4, trailing: 5))
            
            LoadingView(isShowing: self.$getData.isLoading) {
                
                List {

                    if self.getData.activeArray[self.getData.active] == "All" {
                        ForEach(self.getData.jsonData.filter { cust in
                            self.searchTerm.isEmpty ? true :
                                (cust.Name!.localizedStandardContains(self.searchTerm) || cust.Address!.localizedStandardContains(self.searchTerm) || cust.HomePhone!.localizedStandardContains(self.searchTerm) || cust.CellPhone!.localizedStandardContains(self.searchTerm))
                            
                        }, id: \.self) {call in
                            
                            LazyVStack(alignment: .leading) {
                                ExDivider()
                                
                                CustomersRowView(id: call.id, name: call.Name!, address: call.Address!, homePhone: call.HomePhone!, cellPhone: call.CellPhone!, email: call.Email!, comment: call.Cmt)
                                
                            }
                            
                        }
                    } else {
                        ForEach(self.getData.jsonData.filter { cust in
                            self.searchTerm.isEmpty ? true : cust.Status == (self.getData.activeArray[self.getData.active]) &&  (cust.Name!.localizedStandardContains(self.searchTerm) || cust.Address!.localizedStandardContains(self.searchTerm) || cust.HomePhone!.localizedStandardContains(self.searchTerm) || cust.CellPhone!.localizedStandardContains(self.searchTerm))
                            
                        }, id: \.self) {call in
                            
                            LazyVStack(alignment: .leading) {
                                ExDivider()
                                
                                CustomersRowView(id: call.id, name: call.Name!, address: call.Address!, homePhone: call.HomePhone!, cellPhone: call.CellPhone!, email: call.Email!, comment: call.Cmt)
                                
                            }
                            
                        }
                    }
                    ExDivider()
                }   //.onAppear(perform: {self.isLoading = false})
                   // .id(UUID())
            }
        }
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomersView()
    }
}
