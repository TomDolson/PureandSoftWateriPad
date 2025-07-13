//
//  FollowUpView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 1/21/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI
import Combine


struct FollowUpReport: Codable {
    let followUp: [FollowUp]
    
    init(followUp: [FollowUp]) {
        self.followUp = followUp
    }
    
    struct  FollowUp: Identifiable, Codable, Hashable {
        
        var id, custID: Int
        var customerName, address, homePhone, cellPhone, email: String?
        var enterDate, followUpDate, followUpPerson, comment: String?
        var active: Bool
            
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case custID = "CustID"
            case customerName = "CustomerName"
            case address = "Address"
            case homePhone = "HomePhone"
            case cellPhone = "CellPhone"
            case email = "Email"
            case enterDate = "EnterDate"
            case followUpDate = "FollowUpDate"
            case followUpPerson = "FollowUpPerson"
            case comment = "Comment"
            case active = "Active"
        }
    }
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

struct FollowUpView: View {
    
    @State var showingFollowUp = false
    @State var showingServiceHistory = false
    @State var showingSaltHistory = false
    @State var showingServiceEdit = false
    
    @State private var results = [FollowUpReport.FollowUp]()
    
    @State private var removeResults = [RemoveFollowUp.FollowUp]()

    @State var sectionState: [Int: Bool] = [:]
    
    @State var deleteRow: Bool = false
    
    @State var isLoading = true
    
    func LoadData() {
        
        guard let url = URL(string: "http://www.pureandsoftwater.com/IpadFollowUpReport.aspx") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        //print(request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(FollowUpReport.self, from: data) {
                    // we have good data – go back to the main thread
                    //print(decodedResponse)
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.followUp
                    }
                    self.isLoading = false
                    // everything is good, so we can exit
                    return
                }
            }
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    @State var myCount: Int = 1
    
    var body: some View {
        VStack {
            PageHeaderView(typePage: "Follow-Up List", foregroundColor: .white, bgColor: .purple)
                .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
            
            Button("Refresh", action: {self.LoadData()})
   
                HStack {
                    Text("Who:")
                        .font(.system(size: 16))
                        .bold()
                         .padding(.init(top: 2, leading: 60, bottom: 0, trailing: 5))
                    Text("Date Entered:  ")
                       .font(.system(size: 16))
                       .bold()
                        .padding(.init(top: 2, leading: 8, bottom: 0, trailing: 20))
                    Text("Follow-up Date:  ")
                                   .font(.system(size: 16))
                                   .bold()
                                .padding(.init(top: 2, leading: 5, bottom: 0, trailing: 0))
                    Spacer()
                    
                }
                
            //  NavigationView {
            VStack(alignment: .leading, spacing: 5) {
                
                LoadingView(isShowing: self.$isLoading) {
                    
                    List {

                        ForEach(self.results, id: \.self) {cust in
                            
                            let index = results.firstIndex(of: cust)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                //Text("\(cust)")
                                Section(header: FollowUpHeaderView(count: index!+1, enterDate: cust.enterDate!, followUpDate: cust.followUpDate!, followUpPerson: cust.followUpPerson!, name: cust.customerName!, comment: cust.comment!).onTapGesture {
                                    self.sectionState[cust.id] = !self.isExpanded(cust.id)
                                    print(cust)
                        
                                    })
                                {
                             
                                    if self.isExpanded(cust.id) {
                                        
                                        FollowUpRowView(showingFollowUp: self.showingFollowUp, showingServiceHistory: self.showingServiceHistory, showingSaltHistory: self.showingSaltHistory, id: cust.id, custId: String(cust.custID), name: cust.customerName!, enterDate: cust.enterDate!, followUpDate: cust.followUpDate!, followUpPerson: cust.followUpPerson! , address: cust.address!, cell: cust.cellPhone!, home: cust.homePhone!, email: cust.email!, comment: cust.comment!, showDetails: false)
                                    }
                                }
                            }
                            
                        }.onDelete(perform: self.deleteRow)
                        
                    }.padding(.init(top: -5, leading: 0, bottom: 0, trailing: 0))
                        .onAppear(perform: {self.LoadData()})
                    
                        .environment(\.defaultMinListRowHeight, 60)
                        .listStyle(GroupedListStyle())
                }
                
            }
            
        }
        
    }
    
    private func deleteRow(at indexSet: IndexSet) {
        
        removeFollowUp(id: String(self.results[indexSet.first!].id))
        //print(String(self.results[indexSet.first!].id))
        self.results.remove(atOffsets: indexSet)
    }
    
    func isExpanded(_ section:Int) -> Bool {
        sectionState[section] ?? false
    }
    
    struct RemoveFollowUp: Codable {
        let delete_FUR: [FollowUp]
        
        init(delete_FUR: [FollowUp]) {
            self.delete_FUR = delete_FUR
        }
        
        struct  FollowUp: Identifiable, Codable, Hashable {
            
            var id: Int
            //var custID: String
            
            
            enum CodingKeys: String, CodingKey {
                case id = "ID"
                //case custID = "CustID"
                
            }
        }
    }
    
     // This function is used to remove the follow-up record from the list by making it inactive in the database
    
    func removeFollowUp(id: String) {
        guard let url = URL(string: "http://www.pureandsoftwater.com/IpadDeleteFollowUpReport.aspx?ID=\(id)") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(RemoveFollowUp.self, from: data) {
                    // we have good data – go back to the main thread
                    print(decodedResponse)
                    DispatchQueue.main.async {
                        // update our UI
                        self.removeResults = decodedResponse.delete_FUR
                    }
                    // everything is good, so we can exit
                    return
                }
            }
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}

struct FollowUpView_Previews: PreviewProvider {
    static var previews: some View {
        FollowUpView()
    }
}
