//
//  AddServiceCallData.swift
//  WaterWorks
//
//  Created by Tom Dolson on 3/29/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct AddServiceCall: Codable {
    let serviceCall: [ServiceCall]

    init(serviceCall: [ServiceCall]) {
        self.serviceCall = serviceCall
    }

    struct  ServiceCall: Identifiable, Codable, Hashable {

        let id: Int?
        let CustID: String?
        let OrderDate: String?
        let FutureServiceDate: String?
        let Originator: String?
        let Tech: String?
        let ServiceDate: String?
        let ServiceTime: String?
        let ServiceType: String?
        let DescribeProblem: String?
        let Serviced: Bool?
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case CustID
            case OrderDate = "OrderDate"
            case FutureServiceDate = "FutureServiceDate"
            case Originator = "Originator"
            case Tech = "Tech"
            case ServiceDate = "ServiceDate"
            case ServiceTime = "ServiceTime"
            case ServiceType = "ServiceType"
            case DescribeProblem = "DescribeProblem"
            case Serviced = "Serviced"
        }
    }
}
