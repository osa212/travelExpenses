//
//  extension + imageView.swift
//  report
//
//  Created by osa on 13.07.2021.
//

import UIKit

extension UIImageView {
    func enableZoom() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
    }
    
    @objc private func zoom(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale,
                                                          y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.b > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}
