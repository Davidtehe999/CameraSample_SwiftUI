//
//  ContentView.swift
//  CameraSample_SwiftUI
//
//  Created by koji torishima on 2020/02/16.
//  Copyright © 2020 koji torishima. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showImagePicker: Bool = false
    @State private var image: Image? = nil
    
    var body: some View {
        VStack {
            image?.resizable()
                .scaledToFit()
            Button("Open camera") {
                self.showImagePicker = true
            }.padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
        }.sheet(isPresented: self.$showImagePicker) {
            PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
