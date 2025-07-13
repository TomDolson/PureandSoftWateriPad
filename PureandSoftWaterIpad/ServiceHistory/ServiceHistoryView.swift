import SwiftUI
import Combine

struct History: Codable {
    let serviceHistory: [ServiceHistory]

    init(serviceHistory: [ServiceHistory]) {
        self.serviceHistory = serviceHistory
    }

    struct  ServiceHistory: Identifiable, Codable, Hashable {

        let id = UUID()
        let CustID: String?
        let ServiceDate: String?
        let ServiceType: String?
        let DescribeProblem: String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case CustID = "CustID"
            case ServiceDate = "ServiceDate"
            case ServiceType = "ServiceType"
            case DescribeProblem = "DescribeProblem"
        }
    }
}

struct ServiceHistoryView: View {
    
    @State private var results = [History.ServiceHistory]()
    @Binding var showingServiceHistory: Bool
    
    @State var custID: Int
    @State var name: String
    @State var address: String
    
    @Environment(\.colorScheme) var colorScheme // Add colorScheme
    
    func loadServiceHistory(id: Int) {
        guard let url = URL(string: "http://www.pureandsoftwater.com/IpadServiceHistory.aspx?CustID=\(id)") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(History.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.serviceHistory
                    }
                    print("All good!")
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 2) {
                PageHeaderView(typePage: "Service History", foregroundColor: colorScheme == .dark ? .yellow : .white, bgColor: Color.blue)
                    .padding(.init(top: 10, leading: 3, bottom: 0, trailing: 0))
                
                Text("\(self.name) - \(self.address)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.blue, radius: 3)
            }
            
            HStack(spacing: 0) {
                Text("Service Date")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .yellow : .white) // Adapt to colorScheme
                    .frame(maxWidth: 150)
                    .padding(10)
                    .background(Color.blue)
                
                Text("Service Type")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .yellow : .white) // Adapt to colorScheme
                    .frame(maxWidth: 175)
                    .padding(10)
                    .background(Color.blue)
                
                Text("Comment")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .yellow : .white) // Adapt to colorScheme
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.blue)
            }.cornerRadius(5)
                .padding(.init(top: 10, leading: 15, bottom: 0, trailing: 15))
            
            List {
                ForEach(self.results, id: \.self) { hist in
                    VStack(alignment: .leading) {
                        ServiceHistoryRow(serviceDate: hist.ServiceDate, serviceType: hist.ServiceType, comment: hist.DescribeProblem)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding()
        .onAppear {
            self.loadServiceHistory(id: self.custID)
        }
    }
}

struct ServiceHistoryRow: View {
    @Environment(\.colorScheme) var colorScheme // Add colorScheme
    
    var serviceDate: String?
    var serviceType: String?
    var comment: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("\(self.serviceDate ?? "Service Date")")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: 150)
                
                Text("\(self.serviceType ?? "Service Type")")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .bold()
                    .lineLimit(nil)
                    .padding(10)
                    .frame(maxWidth: 250)
                
                Text("\(self.comment ?? "No comments")")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .bold()
                    .lineLimit(nil)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                
            }
            .background(Color.white)
            .cornerRadius(5)
            .shadow(color: Color.blue, radius: 3)
        }
    }
}

struct ServiceHistoryView_Previews: PreviewProvider {
   

    static var previews: some View {
        ServiceHistoryView(showingServiceHistory: {Binding.constant(false)}(), custID: 1063, name: "Dolson, Tom", address: "16 Homestead Street, Hillsdale, NJ 07642")
    }
}

//
//  ServiceHistoryView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/10/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//
//
//import SwiftUI
//import Combine
//
//struct History: Codable {
//    let serviceHistory: [ServiceHistory]
//
//    init(serviceHistory: [ServiceHistory]) {
//        self.serviceHistory = serviceHistory
//    }
//
//    struct  ServiceHistory: Identifiable, Codable, Hashable {
//
//        let id = UUID()
//        let CustID: String?
//        let ServiceDate: String?
//        let ServiceType: String?
//        let DescribeProblem: String?
//
//        enum CodingKeys: String, CodingKey {
//            case id = "id"
//            case CustID = "CustID"
//            case ServiceDate = "ServiceDate"
//            case ServiceType = "ServiceType"
//            case DescribeProblem = "DescribeProblem"
//        }
//    }
//}
//
//struct ServiceHistoryView: View {
//
//    @State private var results = [History.ServiceHistory]()
//    @Binding var showingServiceHistory : Bool
//
//    @State var custID: Int
//    @State var name: String
//    @State var address: String
//
//    //let onDismiss: () -> ()
//
//    func LoadServiceHistory(id: Int) {
//
//        guard let url = URL(string: "http://www.pureandsoftwater.com/IpadServiceHistory.aspx?CustID=\(id)") else {
//            print("Invalid URL")
//            return
//        }
//
//        let request = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode(History.self, from: data) {
//                    // we have good data – go back to the main thread
//                    DispatchQueue.main.async {
//                        // update our UI
//                        self.results = decodedResponse.serviceHistory
//                    }
//                    // everything is good, so we can exit
//                    print("All good!")
//                    return
//                }
//            }
//            // if we're still here it means there was a problem
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//        }.resume()
//    }
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 2) {
//            PageHeaderView(typePage: "Service History", foregroundColor: Color.white, bgColor: Color.blue)
//                .padding()
//
//            VStack(alignment: .center, spacing: 5) {
//                HStack(alignment: .top, spacing: 5) {
//                    Text("\(self.name)  -  \(self.address)")
//                        .font(.system(size: 16))
//                        .bold()
////                        .shadow(color: Color.blue, radius: 3)
//                        .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
//                        .foregroundColor(Color.black)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .shadow(color: Color.blue, radius: 3)
//                        .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 0))
//
//                }
//                VStack(alignment: .trailing, spacing: 5) {
//
//                    Button(action: {
//                        //presentationMode.wrappedValue.dismiss()
//                        showingServiceHistory = false
//                        print("Close")
//                    }) {
//                        Text("Close")
//                    }
//                    .padding(.init(top: 5, leading: 600, bottom: 15, trailing: 0))
//                }
//
//            }
//
//            Section {
//
//                GeometryReader {geo in
//                    HStack(spacing: 5) {
//
//                        Text(" Service Date    |   Service Type   |")
//                            .font(.system(size: 16))
//                            .bold()
//                            .padding(.init(top: 5, leading: 10, bottom: 7, trailing: -30))
//                            .frame(width: geo.size.width / 3, height: 30)
//
//                        Text("Comment")
//                            .font(.system(size: 16))
//                            .bold()
//                            .lineLimit(2)
//                            .padding(.init(top: 5, leading: 0, bottom: 7, trailing: 5))
//                            .frame(width: (geo.size.width / 2)+30, height: 30)
//                    }
//
//                }.foregroundColor(Color.white)
//                    .background(Color.black)
//                    .cornerRadius(3)
//                    .padding(.init(top: 0, leading: 5, bottom: 5, trailing: 5))
//            }.frame(height: 40)
//            Section {
//                GeometryReader {geo in
//                    List {
//                        ForEach(self.results, id: \.self) { hist in
//                            VStack(alignment: .leading, spacing: 15) {
//                                HStack {
//
//                                    ServiceHistoryRow(serviceDate: hist.ServiceDate, serviceType: hist.ServiceType, comment: hist.DescribeProblem)
//                                }.frame(minWidth: geo.size.width-10, idealWidth: geo.size.width-10, minHeight: 50, maxHeight: 150, alignment: .leading)
//
//                              }
//                        }
//                    }.onAppear(perform: {self.LoadServiceHistory(id: self.custID)
//                        print(showingServiceHistory)
//                    })
//
//                    //.environment(\.defaultMinListRowHeight, 70)
//                    //.frame(width: geo.size.width-10)
//                }
//            }
//        }
//
//    }
//
//}
//
//struct ServiceHistoryRow: View {
//
//    var serviceDate: String?
//    var serviceType: String?
//    var comment: String?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            GeometryReader {geometry in
//                HStack(alignment: .center) {
//                    Text("\(self.serviceDate ?? "Service Date")")
//                        .font(.system(size: 15))
//                        .bold()
//                        .padding(.init(top: 5, leading: -30, bottom: 5, trailing: 2))
//                        .frame(width: geometry.size.width / 5)
//                    Text("\(self.serviceType ?? "Service Type")")
//                        .font(.system(size: 14))
//                        .bold()
//                        .fixedSize(horizontal: false, vertical: true)
//                        .lineLimit(nil)
//                        .padding(.init(top: 5, leading: -30, bottom: 5, trailing: 1))
//                        .frame(width: geometry.size.width / 6.45, alignment: .center)
//                    Text("\(self.comment ?? "No comments")")
//                        .font(.system(size: 14))
//                        .bold()
//                        .fixedSize(horizontal: false, vertical: true)
//                        .lineLimit(nil)
//                        .padding(.init(top: 7, leading: 5, bottom: 5, trailing: 55))
//                        .frame(width: geometry.size.width / 1.6, height: 40,  alignment: .leading)
//
//                }
//            }
//        }
//    }
//
//
//}
//
//struct ServiceHistoryView_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        ServiceHistoryView(showingServiceHistory: {Binding.constant(false)}(), custID: 1063, name: "Dolson, Tom", address: "16 Homestead Street, Hillsdale, NJ 07642")
//    }
//}


