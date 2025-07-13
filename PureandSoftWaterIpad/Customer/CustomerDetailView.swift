//
//  CustomerDetailView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 3/12/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//
import Foundation
import SwiftUI
import Combine
import UIKit




struct CustomerDetailView: View {
    
    var mainURL: String = "http://www.pureandsoftwater.com/"
    
    var custID: String = "1063"
    
    @State
    var name: String = ""
    
    @State
    var custData = [Customers.CustomerRecord]()
    
    var onDismiss: () -> ()
    
    var custType = ["Salt","Service","Sales","Rental","RO","Plumbing","UV","Other"]
    
    var imageIndex: [Int] = [1,2,3,4,5]
    
    @State
    var jsonData = [Customers.CustomerRecord]()
    
    @State
    var picNumber: Int = 1
    
    
    @State
    var showDetailImage: Bool = false
    
    
    func GetCustomerData(ID: String) {
        
        let customerURL = "\(self.mainURL)ipadcustomerspecific.aspx?ID=\(ID)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: customerURL)!) { (data, _, _) in
            
            do {
                
                let fetch = try JSONDecoder().decode(Customers.self, from: data!)
                
                DispatchQueue.main.async {
                    
                    //print(fetch.customer.count)
                    self.jsonData = fetch.customer
                   // print(self.jsonData)
                    
                }
            }
            catch {
                print(error)
            }
            isLoading = false
        }.resume()
    }
    
    @State
    var custImage = Data()
    
    func GetCustomerPics(ID: String) {
        
        let customerURL = "\(self.mainURL)manager/pics/1063_1.jpg"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: customerURL)!) { (data, _, _) in
            
            do {
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    
                    self.imageCache.set(forKey: customerURL, image: UIImage(data: data)!)
                    self.custImage = data
                    //print(self.jsonData)
                    
                }
            }
            isLoading = false
        }.resume()
    }
    
    //    @State
    //    var isLoading: Bool = true
    
    var imageURLString: String? = "http://www.pureandsoftwater.com/manager/installation_pics/1063_\(String(1)).jpg"
    
    var imageCache = ImageCache.getImageCache()
    
    func loadImageFromCache() -> Bool {
        guard let imageURLString = imageURLString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: imageURLString) else {
            return false
        }
        
        ImageLoader().downloadImage = cacheImage
            return true
    }
    
    var body: some View {
    
        VStack(alignment: .center, spacing: 5) {
            
            PageHeaderView(typePage: "Customer Details", foregroundColor: Color.white, bgColor: Color.green)
                .padding(.init(top: 20, leading: 0, bottom: -10, trailing: 0))
            
            List {
                HStack {
                    
                    ForEach(self.jsonData, id: \.self) { cust in
                        
                        VStack {
                            
                            Group   {
                                Form {
                                    
                                    HStack {
                                        Text("Name: ")
                                        Text("\(cust.Name!)").bold().italic().foregroundColor(.green).font(.system(size: 19))
                                    }
                                    HStack {
                                        Text("Address: ")
                                        Text("\(cust.Address!)").bold().italic().foregroundColor(.green).font(.system(size: 19))
                                    }
                                    HStack {
                                        Text("Last Name: ")
                                        Text("\(cust.LastName!)").bold()
                                    }
                                    HStack {
                                        Text("First Name: ")
                                        Text("\(cust.FirstName!)").bold()
                                    }
                                    HStack {
                                        Text("Address1: ")
                                        Text("\(cust.Address1!)").bold()
                                    }
                                    HStack {
                                        Text("Address2: ")
                                        Text("\(cust.Address2 ?? "")").bold()
                                    }
                                    HStack {
                                        Text("City: ")
                                        Text("\(cust.City ?? "")").bold()
                                    }
                                    HStack {
                                        Text("State: ")
                                        Text("\(cust.State ?? "")").bold()
                                    }
                                    HStack {
                                        Text("Zip: ")
                                        Text("\(cust.Zip ?? "")").bold()
                                    }
                                    
                                }
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 4, x: 3, y: 3)
                                .padding(.bottom)
                            }.frame(height: 510)
                            
                            Group   {
                                Form {
                                    
                                    HStack {
                                        Text("Home Phone: ")
                                        Text("\(cust.HomePhone!)").bold()
                                    }
                                    HStack {
                                        Text("Cell Phone: ")
                                        Text("\(cust.CellPhone!)").bold()
                                    }
                                    HStack {
                                        Text("Email: ")
                                        Text("\(cust.Email!)").bold()
                                    }
                                    HStack {
                                        Text("Comments: ")
                                        Text("\(cust.Cmt!)").bold()
                                    }
                                }
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 4, x: 3, y: 3)
                                .padding(.bottom)
                            }.frame(height: 350)
                            
                            Group {
                                Form {
                                    HStack {
                                        VStack(alignment: .center, spacing: 5) {
                                            Text("HARDNESS").underline()
                                                .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                                            Text("\(cust.Hardness!)").bold()
                                                .padding(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
                                        }
                                        VStack {
                                            Text("PH").underline()
                                                .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                                            Text("\(cust.PH!)").bold()
                                                .padding(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
                                        }
                                        VStack {
                                            Text("IRON").underline()
                                                .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                                            Text("\(cust.Iron!)").bold()
                                                .padding(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
                                        }
                                        VStack {
                                            Text("TDS").underline()
                                                .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                                            Text("\(cust.TDS!)").bold()
                                                .padding(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
                                        }
                                    }
                                }
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 4, x: 3, y: 3)
                                .padding(.bottom)
                            }.frame(height: 160)
                            
                            
                            HStack(alignment: .center, spacing: 5){
                                
                                ForEach(self.imageIndex, id: \.self) {index in
                                    
                                    HStack(spacing: 5) {
                                     
                                        VStack(alignment: .center, spacing: 1) {
                                            
                                            Button(action: {
                                                self.picNumber = index
                                                self.showDetailImage = true
                                                
                                            }) {
                                                
                                                AsyncImage(url: URL(string: "http://www.pureandsoftwater.com/manager/installation_pics/\(custID)_\(index).jpg")) { img in
                                                    img.resizable()

                                                } placeholder: {
                                                    HStack {
                                                        Text("No\nImage\nAvailable")
                                                            .bold()
                                                            .padding(15)
                                                            .background(.blue)
                                                            .cornerRadius(15)
                                                            .foregroundColor(.white)
                                                    }
                                                    .frame(width: 110, height: 110, alignment: .center)
                                                }
                                                .cornerRadius(16)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                                .shadow(color: .gray, radius: 4, x: 3, y: 3)
                                                .padding(.bottom)
                                                .padding(.trailing)
                                                .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                                                .frame(width: 125, height: 250, alignment: .center)
                                            }.buttonStyle(BorderlessButtonStyle())
                                         
                                        }
                                    }
                                    
                            }.sheet(isPresented: self.$showDetailImage, content: {
                                
                                DetailImageView(urlString: "\(self.mainURL)manager/installation_pics/\(self.custID)_\(String(self.picNumber)).jpg")
                            })
                        }
                    }
                    
                }
                
            }
                
                Spacer()
            }.onAppear(perform: {self.GetCustomerData(ID: self.custID)})
        }
 
    }
    
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}







struct CustomerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        CustomerDetailView(custID: "1063", name: "Dolson, Thomas and Dina", onDismiss: {Binding.constant(false)})
        
        //        CustomerDetailView(custID: "1063", name: "Dolson, Thomas and Dina", onDismiss: {Binding.constant(false)})
    }
}
