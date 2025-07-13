//
//  ServiceDueReportViewModel.swift
//  WaterWorks
//
//  Created by Tom Dolson on 5/26/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var serviceData: [ServiceDue.ServiceDueCustomer] = []
    
    func fetchServiceData() {
        NetworkController.fetchServiceDueData { serviceData in
            DispatchQueue.main.async {
                self.serviceData = serviceData
            }
        }
    }
}


struct NetworkController {
    static func fetchServiceDueData(completion: @escaping (([ServiceDue.ServiceDueCustomer]) -> Void)) {
        if let url = URL(string: "http://www.pureandsoftwater.com/ipadserviceduecustomers.aspx") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let returnData = try? JSONDecoder().decode(ServiceDue.self, from: data)
                    completion(returnData?.serviceDueCustomers ?? [])
                }
            }.resume()
        }
    }
}
