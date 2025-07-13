//
//  CreateDailyService.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/8/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import PDFKit
import WebKit


func printServiceReport(serviceDate: String, shortServiceDate: String) {
    
    
    let serviceURL = "http://www.pureandsoftwater.com/ipadservicecalendarinfotoday.aspx?ServiceDate=\(shortServiceDate)"
    
    var jsonData = [ServiceCalls.ServiceCalendar]()
   
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: URL(string: serviceURL)!) { (data, _, _) in
        
        do {
            
            let fetch = try JSONDecoder().decode(ServiceCalls.self, from: data!)
            
            DispatchQueue.main.async {
                
                jsonData = fetch.serviceCalendar
                
            }
            
        }
        catch {
            print(error)
        }
        
        
        //print(shortServiceDate)
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
        let subTitlePosition: [Double] = [150.0,47.0]
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
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
        
        var num = 1
        var customerCount = 0
        
        let data = renderer.pdfData { (context) in
            
            context.beginPage()
            

            // Build the title
            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
            let title = "Pure and Soft Water, LLC"
            
            title.draw(at: CGPoint(x: titlePosition[0], y: titlePosition[1]), withAttributes: titleAttributes)
            
            // Build the subtitle
            let subTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let subTitle = "SERVICE SCHEDULE FOR: \(serviceDate)"
            
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
            
            // Build the header bar with service person and date
            let headerBarAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let headerLine = "-"
            for i in 21..<pWidth-23 {
                headerLine.draw(at: CGPoint(x: i, y: 58), withAttributes: headerBarAttributes)
                bottomLine.draw(at: CGPoint(x: i, y: 72), withAttributes: headerBarAttributes)
                bottomLine.draw(at: CGPoint(x: i, y: 73), withAttributes: headerBarAttributes)
            }
            
            // Put yellow background in subHeader
            var headerBackground = " "
            for _ in 1...167 {
                headerBackground.append(" ")
            }
            addBackgroundColor(pageRect: pageRect, x: 22, y: 68, height: 26, width: 550, string: headerBackground)
            
            
            // Add Service Tech
            let techTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
            let techNameTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
            let techTitle = "Service Tech: "
            let techNameTitle = "Tom Dolson"
            
            techTitle.draw(at: CGPoint(x: 28, y: 69), withAttributes: techTitleAttributes)
            techNameTitle.draw(at: CGPoint(x: 100, y: 69), withAttributes: techNameTitleAttributes)
            
            // Add Date
            let dateTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
            let dateTitle = "\(shortServiceDate)"
            
            // Position Date to the left of the right margin
            let dateWidth = dateTitle.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 10))
            dateTitle.draw(at: CGPoint(x: Int(pageRect.width)-25-dateWidth, y: 69), withAttributes: dateTitleAttributes)
            

            // Build each box with customer service call content
            
            
            
            for call in jsonData {
                let end = jsonData.count
                
                customerCount += 1
                
                let firstLine = 88
                let secondLine = 105
                let thirdLine = 122
                let fourthLine = 139
                let fifthLine = 156
                let sixthLine = 173
                let hBox = 153
                
                // Attributes for normal and bold fonts to be used throughout
                
                let smallerFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8)]
                let normalFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
                let boldFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
                let largeBoldFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                
                // Build the number of service
                
                let countAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                let count = "(\(customerCount))"
                
                if num == 1 || num == 6 || num == 12 {
                    count.draw(at: CGPoint(x: 28, y: firstLine), withAttributes: countAttributes)
                } else {
                    if num > 6 { num = num - 5}
                    count.draw(at: CGPoint(x: 28, y: (num*hBox)-firstLine+24), withAttributes: countAttributes)
                }
                
                // Build the time of service
                
                let timeAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
                let time = "Time: "
                
                if num == 1 || num == 6 || num == 12 {
                    time.draw(at: CGPoint(x: 52, y: firstLine), withAttributes: timeAttributes)
                } else {
                    time.draw(at: CGPoint(x: 52, y: (num*hBox)-firstLine+24), withAttributes: timeAttributes)
                }
                
                let boldTimeAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                
                let boldTime = "\(call.ServiceTime!)"
                
                if num == 1 || num == 6 || num == 12 {
                    boldTime.draw(at: CGPoint(x: 86, y: firstLine), withAttributes: boldTimeAttributes)
                } else {
                    boldTime.draw(at: CGPoint(x: 86, y: (num*hBox)-firstLine+24), withAttributes: boldTimeAttributes)
                }
                
                
                // Draw the text for the originator of the service call
                
                let originatorNormal = "Originator: "
                
                if num == 1 || num == 6 || num == 12 {
                    originatorNormal.draw(at: CGPoint(x: 155, y: firstLine), withAttributes: normalFontAttributes)
                } else {
                    originatorNormal.draw(at: CGPoint(x: 155, y: (num*hBox)-firstLine+24), withAttributes: normalFontAttributes)
                }
                
                
                let originatorBold = "\(call.Originator!)"
                
                if num == 1 || num == 6 || num == 12 {
                    originatorBold.draw(at: CGPoint(x: 213, y: firstLine), withAttributes: boldFontAttributes)
                } else {
                    originatorBold.draw(at: CGPoint(x: 213, y: (num*hBox)-firstLine+24), withAttributes: boldFontAttributes)
                }
                
                
                // Draw the text for name(s)
                
                let fName = "Name: "
                
                if num == 1 || num == 6 || num == 12 {
                    fName.draw(at: CGPoint(x: 48, y: secondLine), withAttributes: normalFontAttributes)
                } else {
                    fName.draw(at: CGPoint(x: 48, y: (num*hBox)-secondLine+58), withAttributes: normalFontAttributes)
                }
                
                let firstName = "\(call.LastName!), \(call.FirstName!)"
                
                if num == 1 || num == 6 || num == 12 {
                    firstName.draw(at: CGPoint(x: 86, y: secondLine), withAttributes: boldFontAttributes)
                } else {
                    firstName.draw(at: CGPoint(x: 86, y: (num*hBox)-secondLine+58), withAttributes: boldFontAttributes)
                }
                
                // Draw the text for address
                
                let address = "Address: "
                
                if num == 1 || num == 6 || num == 12 {
                    address.draw(at: CGPoint(x: 36, y: thirdLine), withAttributes: normalFontAttributes)
                } else {
                    address.draw(at: CGPoint(x: 36, y: (num*hBox)-thirdLine+92), withAttributes: normalFontAttributes)
                }
                
                let boldAddress = "\(call.Address1!), \(call.City!), \(call.State!) \(call.Zip!)"
                
                if num == 1 || num == 6 || num == 12 {
                    addBodyText(pageRect: pageRect, x: 86, y: CGFloat(thirdLine), height: 20, width: 240, problem: boldAddress)
                    //boldAddress.draw(at: CGPoint(x: 86, y: thirdLine), withAttributes: boldFontAttributes)
                } else {
                    addBodyText(pageRect: pageRect, x: 86, y: CGFloat((num*hBox)-thirdLine+92), height: 20, width: 240, problem: boldAddress)
                    //boldAddress.draw(at: CGPoint(x: 86, y: (num*hBox)-thirdLine+92), withAttributes: boldFontAttributes)
                }
                
                // Draw the text for home phone
                
                let hPhone = "Home: "
                
                if num == 1 || num == 6 || num == 12 {
                    hPhone.draw(at: CGPoint(x: 47, y: fourthLine), withAttributes: normalFontAttributes)
                } else {
                    hPhone.draw(at: CGPoint(x: 47, y: (num*hBox)-fourthLine+126), withAttributes: normalFontAttributes)
                }
                
                let homePhone = "\(call.HomePhone!)"
                
                if num == 1 || num == 6 || num == 12 {
                    homePhone.draw(at: CGPoint(x: 86, y: fourthLine), withAttributes: boldFontAttributes)
                } else {
                    homePhone.draw(at: CGPoint(x: 86, y: (num*hBox)-fourthLine+126), withAttributes: boldFontAttributes)
                }
                
                // Draw the text for cell phone
                
                let cPhone = "Cell: "
                
                if num == 1 || num == 6 || num == 12 {
                    cPhone.draw(at: CGPoint(x: 175, y: fourthLine), withAttributes: normalFontAttributes)
                } else {
                    cPhone.draw(at: CGPoint(x: 175, y: (num*hBox)-fourthLine+126), withAttributes: normalFontAttributes)
                }
                
                let cellPhone = "\(call.CellPhone!)"
                
                if num == 1 || num == 6 || num == 12 {
                    cellPhone.draw(at: CGPoint(x: 202, y: fourthLine), withAttributes: boldFontAttributes)
                } else {
                    cellPhone.draw(at: CGPoint(x: 202, y: (num*hBox)-fourthLine+126), withAttributes: boldFontAttributes)
                }
                
                
                // Draw problem and solution
                
                let problem = "Problem: "
                let solution = "Solution: "
                let underline = "_________"
                
                if num == 1 || num == 6 || num == 12 {
                    problem.draw(at: CGPoint(x: 332, y: firstLine), withAttributes: normalFontAttributes)
                    underline.draw(at: CGPoint(x: 332, y: firstLine), withAttributes: normalFontAttributes)
                    
                    solution.draw(at: CGPoint(x: 332, y: 147), withAttributes: normalFontAttributes)
                    underline.draw(at: CGPoint(x: 332, y: 147), withAttributes: normalFontAttributes)
                } else {
                    problem.draw(at: CGPoint(x: 332, y: (num*hBox)-firstLine+24), withAttributes: normalFontAttributes)
                    underline.draw(at: CGPoint(x: 332, y: (num*hBox)-firstLine+24), withAttributes: normalFontAttributes)
                    
                    solution.draw(at: CGPoint(x: 332, y: (num*hBox)-sixthLine+167), withAttributes: normalFontAttributes)
                    underline.draw(at: CGPoint(x: 332, y: (num*hBox)-sixthLine+167), withAttributes: normalFontAttributes)
                }
                
                
                // Draw service type
                
                let serviceType = "Service Type: "
                
                if num == 1 || num == 6 || num == 12 {
                    serviceType.draw(at: CGPoint(x: 390, y: firstLine), withAttributes: normalFontAttributes)
                } else {
                    serviceType.draw(at: CGPoint(x: 390, y: (num*hBox)-firstLine+24), withAttributes: normalFontAttributes)
                }
                
                let serviceTypeBold = "\(call.ServiceType!)"
                
                if num == 1 || num == 6 || num == 12 {
                    serviceTypeBold.draw(at: CGPoint(x: 460, y: firstLine), withAttributes: boldFontAttributes)
                } else {
                    serviceTypeBold.draw(at: CGPoint(x: 460, y: (num*hBox)-firstLine+24), withAttributes: boldFontAttributes)
                }
                
                
                // Draw customer comments
                
                let customerComments = "Comments: "
                let commentUnderline = "____________"
                
                if num == 1 || num == 6 || num == 12 {
                    customerComments.draw(at: CGPoint(x: 30, y: fifthLine), withAttributes: normalFontAttributes)
                    commentUnderline.draw(at: CGPoint(x: 30, y: fifthLine), withAttributes: normalFontAttributes)
                } else {
                    customerComments.draw(at: CGPoint(x: 30, y: (num*hBox)-fifthLine+160), withAttributes: normalFontAttributes)
                    commentUnderline.draw(at: CGPoint(x: 30, y: (num*hBox)-fifthLine+160), withAttributes: normalFontAttributes)
                }
                
                
                if num == 1 || num == 6 || num == 12 {
                    addBodyText(pageRect: pageRect, x: 30, y: CGFloat(sixthLine-3), height: 50, width: 290, problem: call.Comments!)
                } else {
                    addBodyText(pageRect: pageRect, x: 30, y: CGFloat((num*hBox)-sixthLine+189), height: 50, width: 290, problem: call.Comments!)
                }
                
                
                // Draw the text for problem
                
                if num == 1 || num == 6 || num == 12 {
                    addBodyText(pageRect: pageRect, x: 335, y: CGFloat(secondLine-3), height: 50, width: 250, problem: call.DescribeProblem!)
                } else {
                    addBodyText(pageRect: pageRect, x: 335, y: CGFloat((num*hBox)-secondLine+55), height: 50, width: 250, problem: call.DescribeProblem!)
                }
                
                
                let payment = " Check #_________    C/C      Cash      Sent Invoice      Send Invoice      $_________________ Amount          INPUT:"
                
                // Build the top and bottom of the frame around the box
                
                for i in 21..<pWidth-23 {
                    
                    if num == 1 || num == 6 || num == 12 {
                        
                        if i > 325 { // Draw lines for solution
                            bottomLine.draw(at: CGPoint(x: i, y: 150), withAttributes: smallerFontAttributes)
                            bottomLine.draw(at: CGPoint(x: i, y: 165), withAttributes: smallerFontAttributes)
                            bottomLine.draw(at: CGPoint(x: i, y: 180), withAttributes: smallerFontAttributes)
                            bottomLine.draw(at: CGPoint(x: i, y: 195), withAttributes: smallerFontAttributes)
                        }
                        
                        // Draw short line for top of "INPUT" box
                        if i > pWidth-38 { // Draw lines for solution
                            bottomLine.draw(at: CGPoint(x: i, y: 206), withAttributes: largeBoldFontAttributes)
                            
                        }
                        
                        bottomLine.draw(at: CGPoint(x: i, y: 210), withAttributes: smallerFontAttributes)
                        
                        // Draw payment options
                        payment.draw(at: CGPoint(x: 30, y: 224), withAttributes: normalFontAttributes)
                        
                        bottomLine.draw(at: CGPoint(x: i, y: 225), withAttributes: lineAttributes)
                        bottomLine.draw(at: CGPoint(x: i, y: 226), withAttributes: lineAttributes)
                        
                    } else {
                        
                        if i > 325 { // Draw lines for solution
                            bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)-3), withAttributes: smallerFontAttributes)
                            bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+12), withAttributes: smallerFontAttributes)
                            bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+27), withAttributes: smallerFontAttributes)
                            bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+42), withAttributes: smallerFontAttributes)
                        }
                        
                        // Draw short line for top of "INPUT" box
                        if i > pWidth-38 { // Draw lines for solution
                            bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+53), withAttributes: largeBoldFontAttributes)
                            
                        }
                        
                        bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+57), withAttributes: smallerFontAttributes)
                        
                        // Draw payment options
                        payment.draw(at: CGPoint(x: 30, y: (num*hBox)+71), withAttributes: normalFontAttributes)
                        
                        bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+72), withAttributes: lineAttributes)
                        bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+73), withAttributes: lineAttributes)
                    }
                    
                }
                
                
                // Build the center line inside the box

                
                for i in 21..<pHeight-22 {
                    
                    if num == 1 || num == 6 || num == 12 {
                        if (i > 81 && i < 210) {
                            middleLine.draw(at: CGPoint(x: 325, y: i), withAttributes: smallerFontAttributes)
                        }
                    } else {
                        if (i > ((num-1)*hBox)+81 && i < ((num-1)*hBox)+210) {
                            middleLine.draw(at: CGPoint(x: 325, y: i), withAttributes: smallerFontAttributes)
                        }
                    }
                    
                }
                
                // Build the sides for the "INPUT" the box

                
                for i in 21..<pHeight-22 {
                    
                    if num == 1 || num == 6 || num == 12 {
                        if (i > 215 && i < 227) {
                            middleLine.draw(at: CGPoint(x: pWidth-38, y: i), withAttributes: largeBoldFontAttributes)
                        }
                    } else {
                        if (i > ((num-1)*hBox)+215 && i < ((num-1)*hBox)+227) {
                            middleLine.draw(at: CGPoint(x: pWidth-38, y: i), withAttributes: largeBoldFontAttributes)
                        }
                    }
                    
                }
                
                //Draw extra lines at the end for notes
                
                if customerCount == end {
                    if num <= 5 {num = num}
                    if num > 5 && num <= 10 {num = num - 5}
                    if num > 10 && num <= 15 {num = num - 10}
                    for lHeight in 1...6 {
                        for i in 28..<pWidth-28 {
                            
                            let noteLineAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
                            bottomLine.draw(at: CGPoint(x: i, y: (num*hBox)+72+(lHeight*20)), withAttributes: noteLineAttributes)
                        }
                        if lHeight == 1 {  // First line of notes add "NOTES: " text
                            let notesAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
                            let notes = "NOTES: "
                            notes.draw(at: CGPoint(x: 28, y: (num*hBox)+72+(lHeight*16)), withAttributes: notesAttributes)
                            
                        }
                    }
                    
                }
                
                num += 1
                
                if num == 6 || num == 12 {
                    context.beginPage()
                    // Build the title
                    let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
                    let title = "Pure and Soft Water, LLC"
                    
                    title.draw(at: CGPoint(x: titlePosition[0], y: titlePosition[1]), withAttributes: titleAttributes)
                    
                    // Build the subtitle
                    let subTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                    let subTitle = "SERVICE SCHEDULE FOR: \(serviceDate)"
                    
                    subTitle.draw(at: CGPoint(x: subTitlePosition[0], y: subTitlePosition[1]), withAttributes: subTitleAttributes)
                    
                    // Build the frame around the page
                    let lineAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                    let sideLine = "|"
                    let topLine = "-"
                    let bottomLine = "_"
                    //let middleLine = "|"
                    
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
                    
                    // Build the header bar with service person and date
                    let headerBarAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
                    let headerLine = "-"
                    for i in 21..<pWidth-23 {
                        headerLine.draw(at: CGPoint(x: i, y: 58), withAttributes: headerBarAttributes)
                        bottomLine.draw(at: CGPoint(x: i, y: 72), withAttributes: headerBarAttributes)
                        bottomLine.draw(at: CGPoint(x: i, y: 73), withAttributes: headerBarAttributes)
                    }
                    
                    // Put yellow background in subHeader
                    var headerBackground = " "
                    for _ in 1...167 {
                        headerBackground.append(" ")
                    }
                    addBackgroundColor(pageRect: pageRect, x: 22, y: 68, height: 26, width: 550, string: headerBackground)
                    
                    
                    // Add Service Tech
                    let techTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
                    let techNameTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
                    let techTitle = "Service Tech: "
                    let techNameTitle = "Tom Dolson"
                    
                    techTitle.draw(at: CGPoint(x: 28, y: 69), withAttributes: techTitleAttributes)
                    techNameTitle.draw(at: CGPoint(x: 100, y: 69), withAttributes: techNameTitleAttributes)
                    
                    // Add Date
                    let dateTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
                    let dateTitle = "\(shortServiceDate)"
                    
                    // Position Date to the left of the right margin
                    let dateWidth = dateTitle.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 10))
                    dateTitle.draw(at: CGPoint(x: Int(pageRect.width)-25-dateWidth, y: 69), withAttributes: dateTitleAttributes)
                    
                }
                
            }
            
        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentPath = " \(paths[0])Daily Service Report.pdf"
            
            return URL(fileURLWithPath: documentPath)
        }
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
        isDirectory: true)
        
        let url = temporaryDirectoryURL.appendingPathComponent("Daily Service Report.pdf")
        print("\(url)")
        try? data.write(to:  url)
        
    }.resume()
}

struct DocumentPreview: UIViewControllerRepresentable {
    private var isActive: Binding<Bool>
    private let viewController = UIViewController()
    private let docController: UIDocumentInteractionController
    
    init(_ isActive: Binding<Bool>, url: URL) {
        self.isActive = isActive
        self.docController = UIDocumentInteractionController(url: url)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPreview>) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DocumentPreview>) {
        if self.isActive.wrappedValue && docController.delegate == nil { // to not show twice
            docController.delegate = context.coordinator
            self.docController.presentPreview(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordintor {
        return Coordintor(owner: self)
    }
    
    final class Coordintor: NSObject, UIDocumentInteractionControllerDelegate { // works as delegate
        let owner: DocumentPreview
        init(owner: DocumentPreview) {
            self.owner = owner
        }
        func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            return owner.viewController
        }
        
        func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
            controller.delegate = nil // done, so unlink self
            owner.isActive.wrappedValue = false // notify external about done
        }
    }
}

// Demo of possible usage
struct PDFPreview: View {
    @State private var showPreview = false // state activating preview
    
    var body: some View {
        VStack {
            Button("Show Preview") { self.showPreview = true }
                .background(DocumentPreview($showPreview, // no matter where it is, because no content
                    url: Bundle.main.url(forResource: "Daily Service Report", withExtension: "pdf")!))
            
        }
    }
}

struct PDFPreview_Previews: PreviewProvider {
    static var previews: some View {
        PDFPreview()
    }
}


extension String {
    func widthOfString(usingFont font: UIFont) -> Int {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return Int(size.width)
    }
}
