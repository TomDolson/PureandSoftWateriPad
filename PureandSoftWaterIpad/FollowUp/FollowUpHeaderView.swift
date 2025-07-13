//
//  FollowUpHeaderView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 2/20/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct FollowUpHeaderView: View {
    var count: Int = 1
    var enterDate: String = "02/20/2020"
    var followUpDate: String = "02/27/2020"
    var followUpPerson: String = "TD"
    var name: String = "Dolson, Tom & Dina"
    var comment: String = "Area where the follow-up text will go."
    
    // Format the color of the FollwoUpPerson.
    
    func backgroundColorForFollowUpPerson(followUpPerson: String) ->  Color {
        
        if followUpPerson == "TD" {
            return Color.green
        }
        else 
        
        if followUpPerson == "DD" {
            return Color.yellow
        }
        
        return Color.blue
    }
    
    func foregroundColorForFollowUpPerson(followUpPerson: String) ->  Color {
        
        if followUpPerson == "TD" {
            return Color.white
        }
        else
        
        if followUpPerson == "DD" {
            return Color.black
        }
        
        return Color.white
    }
    
    // Format the color of the Follow-up Date based on the number of days the Follow Up Date is from today.
       func dateColorChange(followUpDate: String) -> Color {
           // Change String to date format to compare dates
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.dateFormat = "MM/dd/yyyy"
           let fmtDate = formatter.date(from: followUpDate)
           let todaysDate = Date()
           var color = Color.blue
           
           if fmtDate! < todaysDate-604800 {  // Minus 7 Days
               // print("Red: FollowUpDate = \(String(describing: fmtDate)) and Today's Date = \(todaysDate-604800) ")
               color = Color.red
           }
           if fmtDate! == todaysDate || fmtDate! < todaysDate && fmtDate! > todaysDate-604800 {
               // print("Yellow : FollowUpDate = \(String(describing: fmtDate)) and Today's Date = \(todaysDate-604800) ")
               color = Color.yellow
           }
           if fmtDate! > todaysDate {
               // print("White : FollowUpDate = \(String(describing: fmtDate)) and Today's Date = \(todaysDate) ")
               color = Color.blue
           }
           return color
       }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(count)")
                    .bold()
                    .foregroundColor(Color.white)
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .fixedSize()
                    .frame(width: 30)
                    .background(Color.black)
                    .cornerRadius(5)
                    .shadow(color: Color.gray, radius: 5)
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                Text("\(followUpPerson)")
                    .bold()
                    .foregroundColor(foregroundColorForFollowUpPerson(followUpPerson: followUpPerson))
                    .padding(.init(top: 2, leading: 3, bottom: 2, trailing: 5))
                    .fixedSize()
                    .frame(width: 30)
                    .background(backgroundColorForFollowUpPerson(followUpPerson: followUpPerson))
                    .cornerRadius(5)
                    .shadow(color: Color.gray, radius: 5)
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                Text("\(enterDate)")
                    .bold()
                    .foregroundColor(Color.white)
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .fixedSize()
                    .frame(width: 120)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .shadow(color: Color.gray, radius: 5)
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 15))
                Text("\(followUpDate)")
                    .bold()
                    .foregroundColor(Color.white)
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .fixedSize()
                    .frame(width: 120)
                    .background(dateColorChange(followUpDate: followUpDate))
                    .cornerRadius(5)
                    .shadow(color: Color.gray, radius: 5)
                    .padding(.init(top: 2, leading: 0, bottom: 2, trailing: 10))
                    Text("\(name)")
                        .bold()
                        .frame(width: 200, alignment: .leading)
                Text("\(comment)")
                    .font(.system(size: 14))
                    .bold()
                    .italic()
            }
        }
    }
    
}

struct FollowUpHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        FollowUpHeaderView()
    }
}
