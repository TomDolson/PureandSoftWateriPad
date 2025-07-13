//
//  IntroductionView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 12/28/19.
//  Copyright © 2019 Tom Dolson. All rights reserved.
//

import SwiftUI
import Combine

struct IntroductionView: View {
    
    @EnvironmentObject var user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                Spacer(minLength: 20)
                
                TitleView()

                if user.loginStatus {
                    
                    VStack(alignment: .center) {
                        Text("Hi \(user.user)").font(.headline)
                        Text(" You are logged in!").font(.subheadline)
                        Button(action: {
                            
                            self.user.loginStatus = false
                            
                            self.user.user = ""
                            self.user.password = ""
                            
                            let loggedIn = UINotificationFeedbackGenerator()
                            loggedIn.notificationOccurred(.success)
                        }) {
                            Text("Log out")
                                .customButton()
                        }
                        .padding(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                } else {
                    LoginView()
                }
                
                InformationContainerView()

                Spacer(minLength: 50)
 
            }
        }
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
