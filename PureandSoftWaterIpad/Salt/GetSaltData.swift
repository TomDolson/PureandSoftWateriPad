//
//  GetSaltData.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/28/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

let saltURL = "http://www.pureandsoftwater.com/ipadsaltcalendar.aspx"

class saltData: ObservableObject {
    @Published var jsonSaltData = [Calls.SaltCalendar]()
    @Published var saltDateGroup: [String] = [""]
    
    var isLoading: Bool = true
    
    var saltDate: String = ""
    
    init() {
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: saltURL)!) { (data, _, _) in
            
            do {
                
                let fetch = try JSONDecoder().decode(Calls.self, from: data!)
                
                DispatchQueue.main.async {
                                      
                    //print(fetch.saltCalendar.count)
                    self.jsonSaltData = fetch.saltCalendar
                    //print(fetch.saltCalendar)
                    
                    
                    for call in self.jsonSaltData {
                        
                        self.saltDate = call.DeliveryDate!
                        
                        if !self.saltDateGroup.contains(self.saltDate) {
                            self.saltDateGroup.append(self.saltDate)
                        }
                    }
                    
                    self.saltDateGroup.remove(at: 0)
                    //print(self.saltDateGroup)
                }
            }
            catch {
                print(error)
            }
            self.isLoading = false
        }.resume()
    }
}

struct Calls: Codable {
    let saltCalendar: [SaltCalendar]

    init(saltCalendar: [SaltCalendar]) {
        self.saltCalendar = saltCalendar
    }

    struct  SaltCalendar: Identifiable, Codable, Hashable {

        let id: Int?
        let CustID: String?
        let LastName: String?
        let FirstName: String?
        let Address1: String?
        let City: String?
        let State: String?
        let Zip: String?
        let Email: String?
        let CellPhone: String?
        let HomePhone: String?
        let NumberOfBags: String?
        let PricePerBag: String?
        let SubTotal: String?
        let SalesTax: String?
        let TotalSale: String?
        let OrderDate: String?
        let DeliveryDate: String?
        let Comments: String?
        let SaltComments: String?
        
        var Name: String? {
            return "\(LastName ?? "Unknown"), \(FirstName ?? "Unknown")"
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "OrderID"
            case CustID
            case LastName = "LastName"
            case FirstName = "FirstName"
            case Address1 = "Address1"
            case City = "City"
            case State = "State"
            case Zip = "Zip"
            case Email = "Email"
            case CellPhone = "CellPhone"
            case HomePhone = "HomePhone"
            case NumberOfBags = "NumberBags"
            case PricePerBag = "PricePerBag"
            case SubTotal = "SubTotal"
            case SalesTax = "SalesTax"
            case TotalSale = "TotalSale"
            case OrderDate = "OrderDate"
            case DeliveryDate = "DeliveryDate"
            case Comments = "Comments"
            case SaltComments = "SaltComments"
            
        }
    }
}

//func changeDateStringFormat(date: String) -> String {
//
// let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM/dd/yyyy"
//    guard let date = dateFormatter.date(from: date) else { return "01/01/2001" }
//    dateFormatter.dateFormat = "EEEE -> MM/dd/yyyy"
//    return  dateFormatter.string(from: date)
//
//}
