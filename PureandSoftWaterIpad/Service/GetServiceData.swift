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

let serviceURL = "http://www.pureandsoftwater.com/get_ipadservicecalendarinfotodayforward.aspx"

class serviceData: ObservableObject {
    @Published var jsonData = [ServiceCalls.ServiceCalendar]()
    @Published var serviceDateGroup: [String] = [""]
    
    var isLoading: Bool = true
    
    var serviceDate: String = ""
    
    init() {
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: serviceURL)!) { (data, _, _) in
            
            do {
                
                let fetch = try JSONDecoder().decode(ServiceCalls.self, from: data!)
                
                DispatchQueue.main.async {
                                      
                    //print(fetch.serviceCalendar.count)
                    self.jsonData = fetch.serviceCalendar
                    //print(fetch.serviceCalendar)
                    
                    
                    for call in self.jsonData {
                        
                        self.serviceDate = call.ServiceDate!
                        
                        if !self.serviceDateGroup.contains(self.serviceDate) {
                            self.serviceDateGroup.append(self.serviceDate)
                        }
                    }
                    
                    self.serviceDateGroup.remove(at: 0)
 
                }
            }
            catch {
                print(error)
            }
            self.isLoading = false
        }.resume()
    }
}

struct ServiceCalls: Codable {
    let serviceCalendar: [ServiceCalendar]

    init(serviceCalendar: [ServiceCalendar]) {
        self.serviceCalendar = serviceCalendar
    }

    struct  ServiceCalendar: Identifiable, Codable, Hashable {

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
        let OrderDate: String?
        let FutureServiceDate: String?
        let ServiceDate: String?
        let ServiceTime: String?
        let ServiceType: String?
        let DescribeProblem: String?
        let Originator: String?
        let Comments: String?
        let Serviced: Bool?
        let Service: Bool?
        
        var Name: String? {
            return "\(LastName ?? "Unknown"), \(FirstName ?? "Unknown")"
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
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
            case OrderDate = "OrderDate"
            case FutureServiceDate = "FutureServiceDate"
            case ServiceDate = "ServiceDate"
            case ServiceTime = "ServiceTime"
            case ServiceType = "ServiceType"
            case DescribeProblem = "DescribeProblem"
            case Originator = "Originator"
            case Comments = "Comments"
            case Serviced = "Serviced"
            case Service = "Service"
        }
    }
}

func changeDateStringFormat(date: String) -> String {
    
 let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    guard let date = dateFormatter.date(from: date) else { return "01/01/2001" }
    dateFormatter.dateFormat = "EEEE -> MM/dd/yyyy"
    return  dateFormatter.string(from: date)
    
}
