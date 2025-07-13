//
//  ContentView.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI
//import GoogleMaps
import Combine
import CoreLocation

struct ServiceCalendarView : View {
    
    @State private var count: Int = 0
    
    @State var singleIsPresented = false
    @State var startIsPresented = false
    @State var multipleIsPresented = false
    @State var deselectedIsPresented = false
    
    @ObservedObject var getData = serviceData()
    
    @State var serviceDate = Date()
    
    @State private var showMapAnnotations = false
    
    var custIDToIndexMap = [String: Int]()
    
    func startUp() async {
        
        var jsonData = [ServiceCalls.ServiceCalendar]()
        
        var serviceDateGroup: [String] = [""]
        
        var serviceDate: String = ""
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: serviceURL)!) { (data, _, _) in
            
            do {
                
                let fetch = try JSONDecoder().decode(ServiceCalls.self, from: data!)
                
                DispatchQueue.main.async {
                    
                    jsonData = fetch.serviceCalendar
                    
                    for call in jsonData {
                        
                        serviceDate = call.ServiceDate!
                        
                        if !serviceDateGroup.contains(serviceDate) {
                            serviceDateGroup.append(serviceDate)
                        }
                    }
                    
                    serviceDateGroup.remove(at: 0)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                }
                
            }
            catch {
                print(error)
            }
            
        }.resume()
        
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM, dd YYYY"
        return formatter
    }
    
    @State var showView: Bool = false
    @State var showPreview = false
    //@Binding var showingServiceHistory: Bool
    
    
    func getDocumentsDirectory() -> URL {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                                        isDirectory: true)
        
        let url = temporaryDirectoryURL.appendingPathComponent("Daily Service Report.pdf")
        
        print("Created document path: \(url)")
        
        return url
    }
    
    @State private var showPDF: Bool = false
    
//    private var exampleAnnotations: [CustomerAnnotation] = [
//            CustomerAnnotation(count: 1, name: "Alice", address: "123 Apple Street", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
//            CustomerAnnotation(count: 2, name: "Bob", address: "456 Berry Boulevard", coordinate: CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4180)),
//            CustomerAnnotation(count: 3, name: "Charlie", address: "789 Cherry Crescent", coordinate: CLLocationCoordinate2D(latitude: 37.7760, longitude: -122.4170))
//        ]
//    
    
    var body: some View {
        
        VStack {
            
            PageHeaderView(typePage: "Service Calendar", foregroundColor: Color.white, bgColor: Color.blue)
            HStack {
                VStack {
                    
                    Form {
                        DatePicker(selection: $serviceDate, displayedComponents: .date, label: {
                            
                            Text("         Service Date: ").foregroundColor(.blue) })
                    }
                    .frame(width: 350, height: 350)
                    
                    Button("Show customers on a map") {
                        // Here is the code to display the service customers on a map
                       
                        showMapAnnotations.toggle()
                                    // Other UI components here
                        if showMapAnnotations {
                            
                            //GoogleMapView(annotations: exampleAnnotations)
                            
                        }
                                        //.frame(height: 300) // Set the desired frame for the map
                                
                    }
      
                    Form {
                        
                        VStack(alignment: .center, spacing: 5) {
                            
                            Button("Print Daily Service Report") {
                                printServiceReport(serviceDate: changeDateToString(date: self.serviceDate), shortServiceDate: formatServiceDate(date: self.serviceDate)); self.showPreview = true;
                                self.showPDF = true
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            .background(DocumentPreview($showPreview, url: self.getDocumentsDirectory()))
                            .padding(.init(top: 0, leading: 45, bottom: 0, trailing: 0))
                            
                        }
                        
                    }
                    .frame(width: 350, height: 120)
                    
                    Spacer()
                }
                
                VStack {
                    
                    Text("\(changeDateToString(date: serviceDate))")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                        .background(Color.blue)
                        .cornerRadius(5)
                        .shadow(color: Color.gray, radius: 5)
                        .padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                    
                    LoadingView(isShowing: self.$getData.isLoading) {
                        
                        List {
                            
                            
                            // Filter and count services for the selected date
                            let servicesForSelectedDate = self.getData.jsonData.filter { service in
                                service.ServiceDate == formatServiceDate(date: self.serviceDate)
                            }
                            
                            ForEach(servicesForSelectedDate.indices, id: \.self) { index in
                                let service = servicesForSelectedDate[index]
                                
                                
                                
                                // Render the service row view
                                ServiceRowView(
                                    count: index + 1, // Use the counter value
                                    id: service.id!,
                                    orderDate: service.OrderDate!,
                                    custId: service.CustID!,
                                    name: service.Name!,
                                    futureServiceDate: service.FutureServiceDate!,
                                    serviceDate: service.ServiceDate!,
                                    serviceTime: service.ServiceTime!,
                                    address: service.Address1!,
                                    city: service.City!,
                                    state: service.State!,
                                    zip: service.Zip!,
                                    cell: service.CellPhone!,
                                    home: service.HomePhone!,
                                    email: service.Email!,
                                    serviceType: service.ServiceType!,
                                    describeProblem: service.DescribeProblem!,
                                    serviced: service.Serviced!,
                                    service: service.Service!
                                )
                            }
                            
                        }
                        
                    }
                    
                    
                }.task {
                    await startUp()
                }
                .refreshable {
                    await startUp()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}



func changeServiceDateToString(date: Date?) -> String {
    let newDate: Date?
    if date == nil {
        newDate = Date()
    } else {
        newDate = date
    }
    let formatter = DateFormatter()
    formatter.locale = .current
    
    formatter.dateFormat = "EEEE, MMM, dd yyyy"
    return formatter.string(from: newDate!)
}


func formatServiceDate(date: Date) -> String {
    
    //let newDate : String
    
    let formatter = DateFormatter()
    formatter.locale = .current
    
    formatter.dateFormat = "MM/dd/yyyy"
    
    return formatter.string(from: date)
}

//#if DEBUG
struct ServiceCalendarView_Previews : PreviewProvider {
    
    @Binding var showingServiceHistory: Bool
    
    static var previews: some View {
        ServiceCalendarView()
        
    }
}
//#endif
/* Create a separate struct that can be used to map customer locations on google maps
 with annotations noting the customer name, address and count number. */
// MARK: - CodeAI Output
struct CustomerLocation {
    var customerName: String
    var address: String
    var countNumber: Int
}

/* Build a page that when opened from this page can bring up the customers for this day and map them on a google maps page using SwiftUI. */
