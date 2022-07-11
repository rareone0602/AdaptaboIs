//
//  ShareView.swift
//  AdaptaboIs
//
//  Created by rareone0602 on 7/9/22.
//

import UIKit
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
