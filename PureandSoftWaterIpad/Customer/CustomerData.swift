//
//  GetCustomerData.swift
//  WaterWorks
//
//  Created by Tom Dolson on 3/12/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

var isLoading: Bool = true

struct Customers: Codable {
    let customer: [CustomerRecord]

    init(customer: [CustomerRecord]) {
        self.customer = customer
    }

    struct  CustomerRecord: Identifiable, Codable, Hashable {

        let id: Int
        let Status: String?
        let LastName: String?
        let FirstName: String?
        let Address1: String?
        let Address2: String?
        let City: String?
        let State: String?
        let Zip: String?
        let HomePhone: String?
        let CellPhone: String?
        let LastCalledDate: String?
        let Email: String?
        let Hardness: String?
        let PH: String?
        let Iron: String?
        let TDS: String?
        let Cmt: String?
        
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
            case Address2 = "Address2"
            case City = "City"
            case State = "State"
            case Zip = "Zip"
            case HomePhone = "HomePhone"
            case CellPhone = "CellPhone"
            case LastCalledDate = "LastCalledDate"
            case Email = "Email"
            case Hardness = "Hardness"
            case PH = "PH"
            case Iron = "Iron"
            case TDS = "TDS"
            case Cmt = "CMT"
            //case Name = "Name"
            
        }
    }
}


struct NewCustomer: Codable {
    let newCustomer: [NewRecord]

    init(newCustomer: [NewRecord]) {
        self.newCustomer = newCustomer
    }

    struct  NewRecord: Codable {
        
        let Status: String
        let LastName: String?
        let FirstName: String?
        let Address1: String?
        let Address2: String?
        let City: String?
        let State: String?
        let Zip: String?
        let HomePhone: String?
        let CellPhone: String?
        let Email: String?
        let Comments: String?
              
        enum CodingKeys: String, CodingKey {
           
            case Status = "Status"
            case LastName = "LastName"
            case FirstName = "FirstName"
            case Address1 = "Address1"
            case Address2 = "Address2"
            case City = "City"
            case State = "State"
            case Zip = "Zip"
            case HomePhone = "HomePhone"
            case CellPhone = "CellPhone"
            case Email = "Email"
            case Comments = "Comments"
            
        }
    }
}
