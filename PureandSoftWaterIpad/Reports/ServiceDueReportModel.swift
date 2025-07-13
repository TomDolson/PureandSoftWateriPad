//
//  ServiceReportDueModel.swift
//  WaterWorks
//
//  Created by Tom Dolson on 5/26/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import SwiftUI


// MARK: - ServiceDue
struct ServiceDue: Decodable {
    var serviceDueCustomers: [ServiceDueCustomer]
    
    
    // MARK: - ServiceDueCustomer
    struct ServiceDueCustomer: Decodable, Identifiable, Hashable {
        var id: Int
        var lastName: String?
        var firstName: String?
        var address1, city: String?
        var state: String?
        var zip: String?
        var homePhone, cellPhone: String?
        var serviceDate: String?
        var nextServiceDate: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case lastName = "LastName"
            case firstName = "FirstName"
            case address1 = "Address1"
            case city = "City"
            case state = "State"
            case zip = "Zip"
            case homePhone = "HomePhone"
            case cellPhone = "CellPhone"
            case serviceDate = "ServiceDate"
            case nextServiceDate = "NextServiceDate"
        }
    }
}

    

