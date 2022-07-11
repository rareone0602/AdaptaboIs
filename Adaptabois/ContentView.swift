//
//  ContentView.swift
//  Adaptabois
//
//  Created by rareone0602 on 6/27/22.
//

import SwiftUI

struct ContentView: View {
  
  @State var shareImage: ShareImage? = ShareImage(image: module.generate())
  @State private var showingSheet = false
  @State private var isPerformingTask = false
  
  func newSample () async -> Void {
    self.shareImage = ShareImage(image: module.generate())
  }
  
  var body: some View {
    if let image = shareImage?.image {
      VStack {
        Spacer()
        Image(uiImage: image)
            .resizable()
            .cornerRadius(10)
            .frame(width: 700, height: 700)
            .padding()
        Spacer()
        
        HStack {
          
          Spacer()
          
          Button(action: {
            showingSheet.toggle()
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
          }) {
            Label("領 養 (´･ω･`)", systemImage: "square.and.arrow.up")
              .frame(height: 20)
              .font(.system(size: 40))
              .foregroundColor(.white)
          }.sheet(isPresented: $showingSheet) {
            ActivityView(image: image)
          }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .background(.blue)
            .cornerRadius(10)
          
          Spacer()
          
          Button(action: {
            isPerformingTask = true
            Task {
              await newSample()
              isPerformingTask = false
            }
            
          }) {
            Label("下 一 隻 (⁎⁍̴̛ᴗ⁍̴̛⁎)", systemImage: "paintpalette")
              .opacity(isPerformingTask ? 0 : 1)
              .frame(height: 20)
              .font(.system(size: 40))
              .foregroundColor(.white)
          }
          .buttonStyle(PlainButtonStyle())
          .padding()
          .background(.blue)
          .cornerRadius(10)
          .disabled(isPerformingTask)
          
          Spacer()
          
        }
        
        Spacer()
        Text("Powered by Nvidia styleGAN2-ada for non-commercial usage")
          .foregroundColor(.gray)
          .frame(height: 10)
          .font(.system(size: 8))
          .padding()
      } // VStack
      
    } // if let image = shareImage?.image
  } // body
}
/*
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
 */
