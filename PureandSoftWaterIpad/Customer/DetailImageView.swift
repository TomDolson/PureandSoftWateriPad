//
//  DetailImageView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 3/23/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct DetailImageView: View {
    
    
    var urlString: String = "http://www.pureandsoftwater.com/manager/installation_pics/1063_1.jpg"
    
    var body: some View {
        
        VStack {
        
        PageHeaderView(typePage: "Detail Image View", foregroundColor: .white, bgColor: .black)
            .padding(.init(top: 20, leading: 0, bottom: -10, trailing: 0))
     
            GeometryReader { geo in
                
                VStack(alignment: .center, spacing: 5) {
                    
                    List {
                       // AsyncImage(url: URL(string: self.urlString))
                        ImageView(url: self.urlString)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            .shadow(color: .gray, radius: 4, x: 3, y: 3)
                            .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                            .frame(width: geo.size.width - 50)
                            //.pinchToZoom()
                    }
                }
            }
        }
    }
}


struct ImageView: View {
    
    @ObservedObject var imageLoader = ImageLoader()
    
    var placeholder: Image
    
     init(url: String, placeholder: Image = Image(systemName: "")) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
        
    }
    
    var body: some View {
        
        if let image = self.imageLoader.downloadImage {
            return Image(uiImage: image).resizable()
            
        }
        
        return  placeholder.resizable()
    }
    
}

struct DetailImageView_Previews: PreviewProvider {
    static var previews: some View {
        DetailImageView()
    }
}
