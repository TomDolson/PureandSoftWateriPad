//
//  ContentView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 12/28/19.
//  Copyright © 2019 Tom Dolson. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var user: User
    
    //@State private var tabsText = ["INTRODUCTION VIEW", "CUSTOMERS VIEW", "SERVICE VIEW", "SALT VIEW", "FOLLOW-UP VIEW", "EXTRA VIEW"]
    
    @State private var selected = 0
    //@Binding var showingServiceHistory: Bool
    
   @ObservedObject var selectedDate = SelectedDate()
    
    var body: some View {
        VStack(alignment: .center) {
            
            TabView(selection: $selected) {
                VStack(alignment: .center) {
                    IntroductionView()
                }
                .tabItem {
                    Image(systemName: (selected == 0 ? "star" : "star"))
                    Text("INTRODUCTION")
                }.tag(0)
                
                if user.loginStatus {
                    
                    CustomersView()
                        .tabItem {
                            Image(systemName: (selected == 1 ? "person.3.fill" : "person.3.fill"))
                            Text("CUSTOMERS")
                    }.tag(1)

                    ServiceCalendarView()
                        .tabItem {
                            Image(systemName: (selected == 2 ? "wrench" : "wrench"))
                            Text("SERVICE")
                    }.tag(2)
                    SaltCalendarView()
                        .tabItem {
                            Image(systemName: (selected == 3 ? "snow" : "snow"))
                            Text("SALT")
                    }.tag(3)
                    FollowUpView()
                        .tabItem {
                            Image(systemName: (selected == 4 ? "list.dash" : "list.dash"))
                            Text("FOLLOW-UP")
                    }.tag(4)
                    ServiceDueReportView(email: "", onDismiss: {Binding.constant(false)})
                        .tabItem {
                            Image(systemName: (selected == 5 ? "list.bullet.rectangle" : "list.bullet.rectangle"))
                            Text("SERVICE DUE")
                        }.tag(5)
                    CallLogView()
                        .tabItem {
                            Image(systemName: (selected == 6 ? "phone" : "phone"))
                            Text("CALL LOG")
                    }.tag(6)
                    CalculationsView()
                        .tabItem {
                            Image(systemName: (selected == 7 ? "calendar" : "calendar"))
                            Text("CACULATIONS")
                    }.tag(7)
                    
                }
                
            }
        }
       
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
       Group {
           ContentView()
               .environmentObject(User())
                }
    }
}
