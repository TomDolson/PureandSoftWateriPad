//
//  InformationContainerView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 12/28/19.
//  Copyright © 2019 Tom Dolson. All rights reserved.
//

import SwiftUI

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Overview", subTitle: "This application was designed for water treatment dealers by a water treatment dealer. There are many features incorporated into the app designed to make every day tasks simpler and more efficient. Since it has been designed and developed by an industry professional, ", imageName: "square.and.pencil")

            InformationDetailView(title: "Content", subTitle: "We've incorporated many nice features into Water Werkz including customer search and information, service call history, salt delivery history, follow-up reports, current service call calendar, current salt delivery calendar, water treatment calculation page and more...", imageName: "cart.fill")

            InformationDetailView(title: "Feedback", subTitle: "As a dealer myself, with many of the same challenges you may have faced or will face, I am always looking for feedback from other piers. Please feel free to let me know what you would like to see new in the program or even modified for better proficiency. We are all in this together!", imageName: "perspective")
        }
        .padding(.horizontal)
    }
}
