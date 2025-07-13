//
//  ExtraView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 1/22/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct CalculationsView: View {
    
    @State var hardness: Int = 10
    @State var people: Int = 3
    
    @State var gpd: Int = 0
    @State var GPD = [75, 100]
    
    var softenerSize: Double {
        var first: Int = 1
        var second: Int = 6000
        let totalHardness: Int = {(people*GPD[gpd]*hardness)}()
        var size: Double = 1.0
        
        outerLoop: for i in 0..<1000 {
            
            if totalHardness >= first && totalHardness < second {
                
                //print(first)
                //print(second)
                
                break outerLoop
                
            } else {
                size += 0.5
            }
            
            if i == 0 {
                first += 5999
            } else {
                first += 3000
            }
            second += 3000
        }
        
        return size
    }
    
    var maxGallons: Double {
        
        var maxGallons: Double = 0.00
        
        maxGallons = (softenerSize*24000)/Double(hardness)
        //print(softenerSize)
        //print(hardness)
        //print(maxGallons)
        
        return maxGallons.rounded()
    }
    
    struct ExDivider: View {
        let color: Color = .gray
        let height: CGFloat = 8
        var body: some View {
            Rectangle()
                .fill(color)
                .frame(height: height)
                .edgesIgnoringSafeArea(.horizontal)
                .cornerRadius(3)
        }
    }
    
    // Used for calculating pricing for salt bags
    var salesTaxArray = [1.08375, 1.08125, 1.06625]
    
    @State var saltPricePerBag: Double = 14.50
    
    @State var salesTax = 1.08375
    
    public var taxLabel = ["Rockland", "Orange", "New Jersey"]
    
    //--------------------------------------------------------------------------------
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 5) {
            
            VStack {
                PageHeaderView(typePage: "Calculations", foregroundColor: Color.white, bgColor: Color.black)
                
                Form {
                    VStack(alignment: .leading, spacing: 5) {
                        ExDivider()
                        Text("Sizing for Water Softener System:")
                            .bold()
                            .font(.system(size: 20))
                            .padding(.init(top: 2, leading: 10, bottom: 10, trailing: 0))
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text("Gallons per Person per Day:")
                                    Picker(selection: self.$gpd, label: Text("Gallons per Person per Day:")) {
                                        
                                        ForEach(0 ..< self.GPD.count, id: \.self) {
                                            Text("\(self.GPD[$0])")
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                        .frame(width: 100)
                                }//.frame(width: 385, height: 40)
                                    .padding(.init(top: 5, leading: 15, bottom: 0, trailing: 0))
                                
                                Stepper(value: self.$people, in: 1...200) {
                                    Text("Number of People: ")
                                    Text("\(people)")
                                        .bold()
                                        .frame(width: 50, height: 20)
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                                        .background(Color.purple)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                    
                                }.frame(width: 400, height: 50)
                                    .padding(.init(top: 2, leading: 15, bottom: 5, trailing: 0))
                                
                                HStack {
                                    Text("Number of Gallons/Day: ")
                                        .padding(.init(top: 5, leading: 15, bottom: 5, trailing: 5))
                                    
                                    Text("\((people)*self.GPD[gpd])")
                                        .bold()
                                        .frame(width: 70, height: 20)
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                                        .background(Color.yellow)
                                        .foregroundColor(Color.black)
                                        .cornerRadius(10)
                                }
                                
                                Stepper(value: self.$hardness, in: 1...100) {
                                    Text("Grains of Hardness (GPG): ")
                                    Text("\(hardness)")
                                        .bold()
                                        .frame(width: 50, height: 20)
                                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                                        .background(Color.green)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                    
                                }.frame(width: 400, height: 40)
                                    .padding(.init(top: 5, leading: 15, bottom: 2, trailing: 0))
                                
                            }
                            VStack(alignment: .center) {
                                
                                HStack {
                                    Text("\(softenerSize, specifier: "%0.1f")")
                                        .bold()
                                        .frame(width: 50, height: 20)
                                        .padding(.init(top: 5, leading: 2, bottom: 5, trailing: 2))
                                        .background(Color.blue)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                    
                                    Text("cube softener:")
                                        .bold()
                                        .font(.system(size: 20))
                                        .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
                                    
                                }.frame(width: 325, height: 40)
                                    .padding(.init(top: 5, leading: 10, bottom: 2, trailing: 0))
                                
                                HStack {
                                    
                                    Text("At \(self.hardness) grains of hardness will yield \(maxGallons, specifier: "%0.f") gallons capacity before regeneration.")
                                        .padding(.init(top: 5, leading: 10, bottom: 2, trailing: 5))
                                }
                                Spacer()
                            }
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                                
                            .cornerRadius(10)
                            .padding(.init(top: 0, leading: 10, bottom: 10, trailing: 0))
                            .shadow(color: Color.gray, radius: 5)
                            
                        }
                        
                        HStack {
                            Text("Based on the above information, you will need a")
                                .bold()
                                .font(.system(size: 20))
                                .padding(.init(top: 10, leading: 10, bottom: 5, trailing: 2))
                            Text("\(softenerSize, specifier: "%0.1f")")
                                .bold()
                                .frame(width: 50, height: 20)
                                .padding(.init(top: 5, leading: 2, bottom: 5, trailing: 2))
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                            
                            Text("cube softener.")
                                .bold()
                                .font(.system(size: 20))
                                .padding(.init(top: 10, leading: 2, bottom: 5, trailing: 2))
                        }
                        
                        ExDivider()
                    }
                    HStack {
                        Text("Pricing for salt bags:")
                            .bold()
                            .font(.system(size: 20))
                            .padding(.init(top: 2, leading: 10, bottom: 2, trailing: 0))
                        Spacer()
                        Text("Sales Tax: ").bold()
                        
                        Picker(selection: self.$salesTax, label: Text("Sales Tax:")) {
     
                            ForEach(self.salesTaxArray, id: \.self) { tax in
                                Text("\(taxLabel[salesTaxArray.firstIndex(of: tax)!])").tag(tax)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            .frame(width: 250)
                        Spacer()
                        Text("Price Per Bag: ").bold()
                        Text("$\(saltPricePerBag, specifier: "%0.2f")")
                    }
                    SaltPricingView(salesTax: salesTax, saltPricePerBag: saltPricePerBag)
      
                }
  
                Spacer(minLength: 0)
            }
        }
    }
    struct SaltPricingView: View {
        
        var salesTax = 0.00
        
        var saltPricePerBag = 0.00

        let items = 1...63
        
        let columns = [
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100))
        ]
        
        var body: some View {
            ScrollView(.horizontal) {
                
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            
                            Text("\(item)").bold()
                                .padding(.init(top: 3, leading: 2, bottom: 2, trailing: 2))
                                .font(.system(size: 20))
                                
                                .frame(idealWidth: 50, maxWidth: .infinity, minHeight: 0, idealHeight: 25, maxHeight: .infinity, alignment: .center)
                                .background(Color.yellow)
                                .cornerRadius(8.0)
                                .padding(.init(top: 3, leading: 2, bottom: 2, trailing: 2))
                            
                            VStack(alignment: .trailing, spacing: 2){
                                Text("$\(saltPricePerBag*Double(item), specifier: "%0.2f")")
                                
                                HStack {
                                    Text("(tx)").font(.footnote)
                                    
                                    Text(" $\((saltPricePerBag*Double(item))*(salesTax-1), specifier: "%0.2f")")
                                }
                                
                                Text("========")
                                Text("$\((Double(item)*saltPricePerBag)*(salesTax), specifier: "%0.2f")")
                                    .font(.system(size: 20))
                                    .bold()
                            }
                        }
                    }
                }
            }
        }
    }
}



struct CalculationsView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationsView()
    }
}
