//
//  CALayerView.swift
//  CameraSample_SwiftUI
//
//  Created by koji torishima on 2020/02/21.
//  Copyright © 2020 koji torishima. All rights reserved.
// CALayerをSwiftUIで利用できるようにする

import SwiftUI

struct CALayerView: UIViewControllerRepresentable {
    var caLayer: CALayer
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CALayerView>) -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame
        
        return viewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}
