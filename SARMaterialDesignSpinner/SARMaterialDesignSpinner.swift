//
//  SARMaterialDesignSpinner.swift
//  SARMaterialDesignSpinner
//
//  Created by Saravanan on 16/02/16.
//  Copyright © 2016 Saravanan. All rights reserved.
//

import Foundation
import UIKit

let kSARRingStrokeAnimationKey = "sarmaterialdesignspinner.stroke"
let kSARRingRotationAnimationKey = "sarmaterialdesignspinner.rotation"
let kSARRingStrokeAnimationDuration = 1.5

class SARMaterialDesignSpinner: UIView {
    let progressLayer = CAShapeLayer()
    var timingFunction: CAMediaTimingFunction!
    var isAnimating = false
    var enableGoogleMultiColoredSpinner = true
    var count = 0
    let googleColorsArray = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.green]
    var timer: Timer!

    //    mark: -Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    override func layoutSubviews() {
        self.progressLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.updateProgressLayerPath()
    }

    //    mark: -Setup Methods
    func setup() {
        timer = Timer.scheduledTimer(timeInterval: kSARRingStrokeAnimationDuration,
                                     target: self,
                                     selector: #selector(SARMaterialDesignSpinner.handleGoogleMultiColoredTimer),
                                     userInfo: nil,
                                     repeats: true)
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        setupProgressLayer()
    }

    func setupProgressLayer() {
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.fillColor = nil
        progressLayer.lineWidth = 2.0
        self.layer.addSublayer(progressLayer)
        self.updateProgressLayerPath()
    }

    func updateProgressLayerPath() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.bounds.width / 2, self.bounds.height / 2) - self.progressLayer.lineWidth / 2
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2*CGFloat(Double.pi)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle,
                                endAngle: endAngle, clockwise: true)
        self.progressLayer.path = path.cgPath

        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = 0.0
    }

    @objc func handleGoogleMultiColoredTimer() {
        count += 1
        if !enableGoogleMultiColoredSpinner {
            return
        }

        let index = count % self.googleColorsArray.count
        let color = self.googleColorsArray[index]
        self.progressLayer.strokeColor = color.cgColor
    }

    //    mark: -Accessors
    var lineWidth: CGFloat {
        get {
            return self.progressLayer.lineWidth
        }
        set(newValue) {
            self.progressLayer.lineWidth = newValue
            self.updateProgressLayerPath()
        }
    }

    var strokeColor: UIColor {
        get {
            return UIColor(cgColor: self.progressLayer.strokeColor!)
        }
        set(newValue) {
            self.progressLayer.strokeColor = newValue.cgColor
        }
    }

    //    mark: -Animation Methods
    func startAnimating() {
        if self.isAnimating {
            return
        }

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 4
        animation.fromValue = 0
        animation.toValue = (2 * Double.pi)
        animation.repeatCount = Float.infinity
        self.progressLayer.add(animation, forKey: kSARRingRotationAnimationKey)

        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.duration = 1
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction

        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.duration = 1
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.timingFunction = self.timingFunction

        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.beginTime = 1
        endHeadAnimation.duration = 0.5
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1
        endHeadAnimation.timingFunction = self.timingFunction

        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.beginTime = 1
        endTailAnimation.duration = 0.5
        endTailAnimation.fromValue = 1
        endTailAnimation.toValue = 1
        endTailAnimation.timingFunction = self.timingFunction

        let animations = CAAnimationGroup()
        animations.duration = kSARRingStrokeAnimationDuration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        self.progressLayer.add(animations, forKey: kSARRingStrokeAnimationKey)

        self.isAnimating = true

    }

    func stopAnimating() {
        if !self.isAnimating {
            return
        }

        self.progressLayer.removeAnimation(forKey: kSARRingRotationAnimationKey)
        self.progressLayer.removeAnimation(forKey: kSARRingStrokeAnimationKey)
        self.isAnimating = false
    }

    //    mark: -Memory Methods
    deinit {
        //        Release the timer here
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
}
