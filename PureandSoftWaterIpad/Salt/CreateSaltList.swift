//
//  CreateSaltList.swift
//  WaterWorks
//
//  Created by Tom Dolson on 3/4/21.
//  Copyright © 2021 Tom Dolson. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import PDFKit
import WebKit


func printSaltReport(deliveryDate: String, shortDeliveryDate: String) {
    
    
    let saltURL = "http://www.pureandsoftwater.com/ipadsaltcalendarinfotoday.aspx?DeliveryDate=\(shortDeliveryDate)"
    
    var jsonData = [Calls.SaltCalendar]()
   
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: URL(string: saltURL)!) { (data, _, _) in
        
        do {
            
            let fetch = try JSONDecoder().decode(Calls.self, from: data!)
            
            DispatchQueue.main.async {
                
                jsonData = fetch.saltCalendar
                
            }
            
        }
        catch {
            print(error)
        }
        
        
        //print("Short Delivery Date: \(shortDeliveryDate)")
//        print(jsonData)
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Tom Dolson",
            kCGPDFContextAuthor: "pureandsoftwater.com"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // Int
        let pHeight = 1008
        let pWidth = 612
        
        // Double
        let pageWidth = 8.5 * 72.0
        let pageHeight = 14 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let titlePosition: [Double] = [180.0,20.0]
        let subTitlePosition: [Double] = [120.0,47.0]
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let italicBoldFontAttributes = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 12)]
        
        func addBodyText(pageRect: CGRect, x: CGFloat, y: CGFloat, height: CGFloat, width: CGFloat, problem: String?) {
          let textFont = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
          
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.alignment = .natural
          paragraphStyle.lineBreakMode = .byWordWrapping
          
          let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
          ]
          let attributedText = NSAttributedString(
            string: problem ?? "",
            attributes: textAttributes
          )
          
          let textRect = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
          )
          attributedText.draw(in: textRect)
        }
        
        func addBackgroundColor(pageRect: CGRect, x: CGFloat, y: CGFloat, height: CGFloat, width: CGFloat, string: String?) {
            let textFont = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
            
            let textAttributes = [
                NSAttributedString.Key.backgroundColor: UIColor.yellow,
              NSAttributedString.Key.font: textFont
            ]
            
            let attributedText = NSAttributedString(
              string: string ?? "",
              attributes: textAttributes
            )
            
            let textRect = CGRect(
              x: x,
              y: y,
              width: width,
              height: height
            )
            attributedText.draw(in: textRect)
        }
        
        let data = renderer.pdfData { (context) in
            
            context.beginPage()
            
            // Build the title
            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
            let title = "Pure and Soft Water, LLC"
            
            title.draw(at: CGPoint(x: titlePosition[0], y: titlePosition[1]), withAttributes: titleAttributes)
            
            // Build the subtitle
            let subTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let subTitle = "SALT DELIVERY SCHEDULE FOR: \(deliveryDate)"
            
            subTitle.draw(at: CGPoint(x: subTitlePosition[0], y: subTitlePosition[1]), withAttributes: subTitleAttributes)
            
            // Build the frame around the page
            let lineAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let sideLine = "|"
            let topLine = "-"
            let bottomLine = "_"
            let middleLine = "|"
            
            // Build the sides of the frame around the page
            for i in 15..<pHeight-40 {
                sideLine.draw(at: CGPoint(x: 19, y: i), withAttributes: lineAttributes)
                sideLine.draw(at: CGPoint(x: 20, y: i), withAttributes: lineAttributes)
                sideLine.draw(at: CGPoint(x: Int(pageRect.width)-19, y: i), withAttributes: lineAttributes)
                sideLine.draw(at: CGPoint(x: Int(pageRect.width)-20, y: i), withAttributes: lineAttributes)
            }
            
            // Build the top and bottom of the frame around the page
            for i in 21..<pWidth-23 {
                topLine.draw(at: CGPoint(x: i, y: 10), withAttributes: lineAttributes)
                topLine.draw(at: CGPoint(x: i, y: 11), withAttributes: lineAttributes)
                bottomLine.draw(at: CGPoint(x: i, y: Int(pageRect.height)-39), withAttributes: lineAttributes)
                bottomLine.draw(at: CGPoint(x: i, y: Int(pageRect.height)-40), withAttributes: lineAttributes)
            }
            
            // Build the header bar
            let headerBarAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let headerLine = "-"
            for i in 21..<pWidth-23 {
                headerLine.draw(at: CGPoint(x: i, y: 58), withAttributes: headerBarAttributes)
                bottomLine.draw(at: CGPoint(x: i, y: 72), withAttributes: headerBarAttributes)
                bottomLine.draw(at: CGPoint(x: i, y: 73), withAttributes: headerBarAttributes)
            }
            
            // Build the Footer Lines
            let footerLineAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let footerLine = "-"
            for i in 21..<pWidth-23 {
                footerLine.draw(at: CGPoint(x: i, y: Int(pageRect.height)-58), withAttributes: footerLineAttributes)
                footerLine.draw(at: CGPoint(x: i, y: Int(pageRect.height)-61), withAttributes: footerLineAttributes)
            }
            
            // Put yellow background in subHeader
            var headerBackground = " "
            for _ in 1...167 {
                headerBackground.append(" ")
            }
            addBackgroundColor(pageRect: pageRect, x: 22, y: 68, height: 26, width: 550, string: headerBackground)
            
            
            // Add Delivery Person
            let techTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
            let techNameTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
            let techTitle = "Delivery Person: "
            let techNameTitle = "Tom Dolson"
            
            techTitle.draw(at: CGPoint(x: 28, y: 69), withAttributes: techTitleAttributes)
            techNameTitle.draw(at: CGPoint(x: 110, y: 69), withAttributes: techNameTitleAttributes)
            
            // Add Short Date
            let dateTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
            let dateTitle = "\(shortDeliveryDate)"
            
            // Position Date to the left of the right margin
            let dateWidth = dateTitle.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 10))
            dateTitle.draw(at: CGPoint(x: Int(pageRect.width)-25-dateWidth, y: 69), withAttributes: dateTitleAttributes)
            

            // Build each box with customer salt delivery content
            
            var num = 1
            
            var totalBags = 0
            
            var totalSales = 0.00
            
            for call in jsonData {
                //let end = jsonData.count
                
                // Line spacing for Name, Address, Phone, Etc.
                
                let firstLine = 38
                let secondLine = 26
                let thirdLine = 14
                let fourthLine = 2
                let fifthLine = -10
                let sixthLine = -22
                let seventhLine = -54
                let eighthLine = -68
                let ninthLine = -71
                //let hBox = 150
                
                // Line spacing for next customer
                
                let lineSpace = 124
                
                
                
                // Attributes for normal and bold fonts to be used throughout
                
                let smallerFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8)]
                let normalFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
                let boldFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
                let largeBoldFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                
                
                
                // Build the number of the salt delivery
                
                let countAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                let count = "(\(num))"
                
                
                count.draw(at: CGPoint(x: 24, y: (num*lineSpace)-firstLine), withAttributes: countAttributes)
                
                
                
                // Draw the text for name(s)
                
                let fName = "Name: "
                
                
                fName.draw(at: CGPoint(x: 48, y: (num*lineSpace)-firstLine), withAttributes: normalFontAttributes)
                
                
                let firstName = "\(call.LastName!), \(call.FirstName!)"
                
                
                firstName.draw(at: CGPoint(x: 86, y: (num*lineSpace)-firstLine), withAttributes: boldFontAttributes)
                
                
                // Draw the text for address
                
                let address = "Address: "
                
                
                address.draw(at: CGPoint(x: 36, y: (num*lineSpace)-secondLine), withAttributes: normalFontAttributes)
                
                
                let boldAddress = "\(call.Address1!), \(call.City!), \(call.State!) \(call.Zip!)"
                
                
                addBodyText(pageRect: pageRect, x: 86, y: CGFloat((num*lineSpace)-secondLine), height: 20, width: 240, problem: boldAddress)
                //boldAddress.draw(at: CGPoint(x: 86, y: (num*hBox)-thirdLine+92), withAttributes: boldFontAttributes)
                
                
                // Draw the text for home phone
                
                let hPhone = "Home: "
                
                
                hPhone.draw(at: CGPoint(x: 47, y: (num*lineSpace)-thirdLine), withAttributes: normalFontAttributes)
                
                
                let homePhone = "\(call.HomePhone!)"
                
                
                homePhone.draw(at: CGPoint(x: 86, y: (num*lineSpace)-thirdLine), withAttributes: boldFontAttributes)
                
                
                // Draw the text for cell phone
                
                let cPhone = "Cell: "
                
                
                cPhone.draw(at: CGPoint(x: 175, y: (num*lineSpace)-thirdLine), withAttributes: normalFontAttributes)
                
                
                let cellPhone = "\(call.CellPhone!)"
                
                
                cellPhone.draw(at: CGPoint(x: 202, y: (num*lineSpace)-thirdLine), withAttributes: boldFontAttributes)
                
                
                
                // Draw the text for Email Address
                
                let email = "Email: "
                
                
                email.draw(at: CGPoint(x: 49, y: (num*lineSpace)-fourthLine), withAttributes: normalFontAttributes)
                
                
                
                let emailAddress = "\(call.Email! )"
                
                
                emailAddress.draw(at: CGPoint(x: 86, y: (num*lineSpace)-fourthLine), withAttributes: boldFontAttributes)
                
                
                
                // Draw Salt Comments
                
                let saltComments = "Salt Comments: "
                let underline = "______________"
                
                
                saltComments.draw(at: CGPoint(x: 332, y: (num*lineSpace)-firstLine), withAttributes: normalFontAttributes)
                underline.draw(at: CGPoint(x: 332, y: (num*lineSpace)-firstLine), withAttributes: normalFontAttributes)
                
                
                //              Draw Bags Requested
                
                let bagsRequested = "Bags Requested: "
                
                //
                
                bagsRequested.draw(at: CGPoint(x: (Int(pageWidth)-55)-bagsRequested.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-firstLine), withAttributes: normalFontAttributes)
                
                
                
                // Build the number of bags to be delivered
                
                let boldBagsAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)]
                
                let boldNumberOfBags = "(\(call.NumberOfBags!))"
                
                totalBags = Int(call.NumberOfBags!)! + totalBags
                
                
                boldNumberOfBags.draw(at: CGPoint(x: (Int(pageWidth)-28)-boldNumberOfBags.widthOfString(usingFont: UIFont.systemFont(ofSize: 13)), y: (num*lineSpace)-firstLine-2), withAttributes: boldBagsAttributes)
                
                
                //              Draw Bags Delivered
                
                let bagsDelivered = "Bags Delivered: "
                let bagsDeliveredUnderline = "_____"
                //
                
                bagsDelivered.draw(at: CGPoint(x: (Int(pageWidth)-55)-bagsDelivered.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-secondLine+4), withAttributes: normalFontAttributes)
                bagsDeliveredUnderline.draw(at: CGPoint(x: (Int(pageWidth)-23)-bagsDeliveredUnderline.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-secondLine+4), withAttributes: normalFontAttributes)
                
                
                //              Draw Price Per Bag
                
                let pricePerBagText = "Price Per Bag: "
                let pricePerBag = "\(call.PricePerBag!)"
                //
                
                pricePerBagText.draw(at: CGPoint(x: (Int(pageWidth)-55)-pricePerBagText.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-thirdLine+8), withAttributes: normalFontAttributes)
                pricePerBag.draw(at: CGPoint(x: (Int(pageWidth)-23)-pricePerBag.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-thirdLine+8), withAttributes: boldFontAttributes)
                
                
                
                //              Draw Sub Total
                
                let subTotalText = "Sub Total: "
                let subTotal = "\(call.SubTotal!)"
                //
                
                subTotalText.draw(at: CGPoint(x: (Int(pageWidth)-55)-subTotalText.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-fourthLine+13), withAttributes: normalFontAttributes)
                subTotal.draw(at: CGPoint(x: (Int(pageWidth)-23)-subTotal.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-fourthLine+13), withAttributes: boldFontAttributes)
                
                
                //              Draw Sales Tax
                
                let salesTaxText = "Sales Tax: "
                let salesTax = "\(call.SalesTax!)"
                
                
                salesTaxText.draw(at: CGPoint(x: (Int(pageWidth)-55)-salesTaxText.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-fifthLine+18), withAttributes: normalFontAttributes)
                salesTax.draw(at: CGPoint(x: (Int(pageWidth)-23)-salesTax.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-fifthLine+18), withAttributes: boldFontAttributes)
                
                
                let subTotalUnderline = "___________________"
                //
                
                
                subTotalUnderline.draw(at: CGPoint(x: (Int(pageWidth)-23)-subTotalUnderline.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-fifthLine+22), withAttributes: normalFontAttributes)
                subTotalUnderline.draw(at: CGPoint(x: (Int(pageWidth)-23)-subTotalUnderline.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: (num*lineSpace)-fifthLine+24), withAttributes: normalFontAttributes)
                
                //              Draw Total Sale
                
                let totalSaleText = "Total Sale: "
                let totalSale = "\(call.TotalSale!)"
                //
                
                totalSaleText.draw(at: CGPoint(x: (Int(pageWidth)-64)-totalSaleText.widthOfString(usingFont: UIFont.systemFont(ofSize: 12)), y: (num*lineSpace)-sixthLine+24), withAttributes: largeBoldFontAttributes)
                totalSale.draw(at: CGPoint(x: (Int(pageWidth)-25)-totalSale.widthOfString(usingFont: UIFont.systemFont(ofSize: 12)), y: (num*lineSpace)-sixthLine+24), withAttributes: largeBoldFontAttributes)
                
                totalSales = Double(call.TotalSale!)! + totalSales
                
                // Draw customer comments
                
                let customerComments = "Comments: "
                let commentUnderline = "__________"
                
                
                customerComments.draw(at: CGPoint(x: 30, y: (num*lineSpace)-fifthLine), withAttributes: normalFontAttributes)
                commentUnderline.draw(at: CGPoint(x: 30, y: (num*lineSpace)-fifthLine), withAttributes: normalFontAttributes)
                
                
                // Draw the text for Lead List Comment
                
                
                addBodyText(pageRect: pageRect, x: 30, y: CGFloat((num*lineSpace)-sixthLine), height: 40, width: 290, problem: call.Comments!)
                
                
                // Draw the text for Salt Comment
                
                
                addBodyText(pageRect: pageRect, x: 332, y: CGFloat((num*lineSpace)-secondLine), height: 100, width: 140, problem: call.SaltComments!)
                
                
                
                let payment = "Payment:      Check #_________      C/C       Cash       Sent Invoice       Send Invoice       $_________________ Amount "
                
                // Build the top and bottom of the frame around the box
                
                for i in 21..<pWidth-23 {

                        bottomLine.draw(at: CGPoint(x: i, y: (num*lineSpace)-seventhLine), withAttributes: smallerFontAttributes)
                        
                        // Draw payment options
                        payment.draw(at: CGPoint(x: 30, y: (num*lineSpace)-eighthLine), withAttributes: normalFontAttributes)
                        
                        bottomLine.draw(at: CGPoint(x: i, y: (num*lineSpace)-ninthLine), withAttributes: boldFontAttributes)
                        bottomLine.draw(at: CGPoint(x: i, y: (num*lineSpace)-ninthLine+1), withAttributes: boldFontAttributes)
                   
                    
                }
                
                
                 //Build the center line inside the box

                
                for i in 21..<pHeight-22 {

                    
                        if (i > ((num)*lineSpace)-44 && i < ((num)*lineSpace)+54) {
                            middleLine.draw(at: CGPoint(x: 325, y: i), withAttributes: smallerFontAttributes)
                        }
                    

                }
                
              num += 1
                
                if num > 7 {
                    context.beginPage()
                }
                
            }
            
            // Footer Information Summary
            
            // Total Deliveries
            
            let totalDeliveriesText = "Total Deliveries: "
            let ttlDeliveries = "(" + String(num-1) + ")"
            
            totalDeliveriesText.draw(at: CGPoint(x: 40, y: Int(pageRect.height)-48), withAttributes: italicBoldFontAttributes)
            ttlDeliveries.draw(at: CGPoint(x: 140, y: Int(pageRect.height)-48), withAttributes: footerLineAttributes)
        
            //Total Number of Bags
        
            let totalBagsText = "Total Bags: "
            let ttlBags = "(" + String(totalBags) + ")"
            
            totalBagsText.draw(at: CGPoint(x: 270, y: Int(pageRect.height)-48), withAttributes: italicBoldFontAttributes)
            ttlBags.draw(at: CGPoint(x: 340, y: Int(pageRect.height)-48), withAttributes: footerLineAttributes)
            
            //Total Sales
        
            let totalSalesText = "Total Sales: "
            
            let result = NumberFormatter.localizedString(from: NSNumber(value: totalSales), number: .currency)
            
            let ttlSales = String(result)
            
            totalSalesText.draw(at: CGPoint(x: Int(pageWidth)-155, y: Int(pageRect.height)-48), withAttributes: italicBoldFontAttributes)
            ttlSales.draw(at: CGPoint(x: Int(pageWidth)-40-ttlSales.widthOfString(usingFont: UIFont.systemFont(ofSize: 10)), y: Int(pageRect.height)-48), withAttributes: footerLineAttributes)
            
        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentPath = " \(paths[0])Daily Salt Report.pdf"
            //let documentsDirectory = paths[0]
            //print(documentPath)
            return URL(fileURLWithPath: documentPath)
            
        }
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
        isDirectory: true)
        
        let url = temporaryDirectoryURL.appendingPathComponent("Daily Salt Report.pdf")
        print("\(url)")
        try? data.write(to:  url)
        
        
    }.resume()
}


// Demo of possible usage
struct PDFSaltPreview: View {
    @State private var showPreview = false // state activating preview
    
    var body: some View {
        VStack {
            Button("Show Preview") { self.showPreview = true }
                .background(DocumentPreview($showPreview, // no matter where it is, because no content
                    url: Bundle.main.url(forResource: "Daily Salt Report", withExtension: "pdf")!))
            
        }
    }
}


