//
//  GetServiceData.swift
//  WaterWorks
//
//  Created by Tom Dolson on 12/31/19.
//  Copyright © 2019 Tom Dolson. All rights reserved.
//
import Foundation
import SwiftUI
import Combine

class leadListData: ObservableObject {
    @Published var jsonData = [LeadList.Customer]()
    
    @Published var activeArray: [String] = ["All", "Active", "InActive"]
    
    @Published var active: Int = 0
    
    var isLoading: Bool = true
    
    init() {
        
        let leadListURL = "http://www.pureandsoftwater.com/ipadcustomer.aspx"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: leadListURL)!) { (data, _, _) in
            
            do {
                
                let fetch = try JSONDecoder().decode(LeadList.self, from: data!)
                
                DispatchQueue.main.async {
                                     
                    //print(fetch.customers.count)
                    self.jsonData = fetch.customers
                    //print(callActive(active: self.active))
                    
                }
            }
            catch {
                print(error)
            }
            self.isLoading = false
        }.resume()
    }
}

struct LeadList: Codable {
    let customers: [Customer]

    init(customers: [Customer]) {
        self.customers = customers
    }

    struct  Customer: Identifiable, Codable, Hashable {

        var id: Int
        var Status: String?
        var LastName: String?
        var FirstName: String?
        var Address1: String?
        var City: String?
        var State: String?
        var Zip: String?
        var HomePhone: String?
        var CellPhone: String?
        var Email: String?
        var Hardness: String?
        var Ph: String?
        var Iron: String?
        var Tds: String?
        var Cmt: String
        
        var Name: String? {
            return "\(LastName ?? "Unknown"), \(FirstName ?? "Unknown")"
        }
        var Address: String? {
            return "\(Address1 ?? "Unknown"), \(City ?? "Unknown"), \(State ?? "Unknown") \(Zip ?? "Unknown")"
        }
        
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case Status = "Status"
            case LastName = "LastName"
            case FirstName = "FirstName"
            case Address1 = "Address1"
            case City = "City"
            case State = "State"
            case Zip = "Zip"
            case HomePhone = "HomePhone"
            case CellPhone = "CellPhone"
            case Email = "Email"
            case Hardness = "Hardness"
            case Ph = "PH"
            case Iron = "Iron"
            case Tds = "TDS"
            case Cmt = "CMT"
            
        }
    }
}
