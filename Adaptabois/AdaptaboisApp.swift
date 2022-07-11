//
//  AdaptaboisApp.swift
//  Adaptabois
//
//  Created by rareone0602 on 6/27/22.
//

import SwiftUI

let module: TorchModule = {
  if let filePath = Bundle.main.path(forResource: "YuanStyleGAN", ofType: "pt"),
     let module = TorchModule(fileAtPath: filePath) {
    return module
  }
  else {
    fatalError("Can't find the model file!")
  }
}()

@main
struct AdaptaboisApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
