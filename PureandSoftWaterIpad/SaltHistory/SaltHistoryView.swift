//
//  SaltHistoryView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/12/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI
import Combine

struct HistorySalt: Codable {
    let Salt: [SaltHistory]
    
    init(Salt: [SaltHistory]) {
        self.Salt = Salt
    }
    
    struct  SaltHistory: Identifiable, Codable, Hashable {
        
        let id = UUID()
        let deliveryDate: String?
        let numberBags: String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case deliveryDate = "DeliveryDate"
            case numberBags = "NumberBags"

        }
    }
}

struct SaltHistoryView: View {
    
    @State private var results = [HistorySalt.SaltHistory]()
    
    @Binding var showingSaltHistory: Bool
    
    @State var custID: Int
    @State var name: String
    @State var address: String
    
    
    func LoadData(id: Int) {
        
        guard let url = URL(string: "http://www.pureandsoftwater.com/IpadSaltHistory.aspx?ID=\(id)") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(HistorySalt.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.Salt
                    }
                    // everything is good, so we can exit
                    return
                }
            }
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            PageHeaderView(typePage: "Salt History", foregroundColor: Color.black, bgColor: Color.yellow)
                .padding()
             
            VStack(alignment: .center, spacing: 5) {
                HStack(alignment: .center, spacing: 5) {
                    Text("\(self.name)  -  \(self.address)")
                        .font(.system(size: 16))
                        .bold()
//                        .shadow(color: Color.yellow, radius: 3)
                        .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(color: Color.yellow, radius: 3)
                        .padding(.init(top: -10, leading: 0, bottom: 5, trailing: 0))
                    
                }
                VStack(alignment: .trailing, spacing: 5) {
                    
                    Button(action: {
                        //presentationMode.wrappedValue.dismiss()
                        showingSaltHistory = false
                        print("Close")
                    }) {
                        Text("Close")
                    }
                    .padding(.init(top: 5, leading: 600, bottom: 15, trailing: 0))
                }
                
            }
            
            Section {
                GeometryReader {geo in
                    HStack(spacing: 5) {
                        
                        Text("Delivery Date         |")
                            .font(.system(size: 16))
                            .bold()
                            .padding(.init(top: 5, leading: -50, bottom: 7, trailing: 20))
                            .frame(width: geo.size.width / 3, height: 30)
                        
                        Text("Number of Bags")
                            .font(.system(size: 16))
                            .bold()
                            .lineLimit(2)
                            .padding(.init(top: 5, leading: -85, bottom: 7, trailing: 25))
                            .frame(width: geo.size.width / 2, height: 30)
                    }
         
                }.foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(3)
                    .padding(.init(top: 0, leading: 5, bottom: 5, trailing: 5))
            }.frame(height: 40)
            
            List {
                
                ForEach(self.results, id: \.self) { hist in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            SaltHistoryRow(deliveryDate: hist.deliveryDate, numberBags: hist.numberBags)
                        }
                    }
                }
                
            }.onAppear(perform: {self.LoadData(id: self.custID)})
                .environment(\.defaultMinListRowHeight, 30)
        }
        //.interactiveDismissDisabled()
    }
        
    
}

struct SaltHistoryRow: View {
    
    var deliveryDate: String?
    var numberBags: String?
    
    func formatDeliveryDate (stringDate: String) -> String {
        
        
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/yyyy"
        
        let newDate = formatter.date(from: stringDate)
        
        return formatter.string(from: newDate!)
        
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Section {
                GeometryReader {geo in
                    HStack(alignment: .center) {
                        Text("\(self.formatDeliveryDate(stringDate: self.deliveryDate!))")
                            .font(.system(size: 16))
                            .bold()
                            .padding(.init(top: 5, leading: -105, bottom: 5, trailing: 2))
                            .frame(width: geo.size.width / 3, height: 30,  alignment: .center)
                        
                        Text("\(self.numberBags!)")
                            .font(.system(size: 16))
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .padding(.init(top: 5, leading: -65, bottom: 5, trailing: 35))
                            .frame(width: geo.size.width / 2, height: 30,  alignment: .center)
                        
                    }
                }
            }
            .frame(height: 26)
        }
    }
    
}

struct SaltHistoryView_Previews: PreviewProvider {

    static var previews: some View {
        SaltHistoryView(showingSaltHistory: {.constant(false)}(), custID: 1063, name: "Dolson, Tom", address: "16 Homestead Street, Hillsdale, NJ 07642")
    }
}

