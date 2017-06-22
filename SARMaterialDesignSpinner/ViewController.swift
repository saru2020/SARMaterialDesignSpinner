//
//  ViewController.swift
//  SARMaterialDesignSpinner
//
//  Created by Saravanan on 16/02/16.
//  Copyright © 2016 Saravanan. All rights reserved.
//

import UIKit

public extension Float {
    public static func random(_ lower: Float, upper: Float) -> Float {
        let r = Float(arc4random()) / Float(UInt32.max)
        return (r * (upper - lower)) + lower
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var spinner: SARMaterialDesignSpinner!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupSpinner()

    }

    override func awakeFromNib() {
    }
    //    mark: -Setup Methods
    func setupSpinner() {
        self.spinner.strokeColor = UIColor.blue
        self.spinner.startAnimating()
    }

    //    mark: -Action Methods
    @IBAction func randomColorButtonTapped(_ sender: AnyObject) {
        self.spinner.strokeColor = self.randomColor()
    }

    @IBAction func lineWidthButtonTapped(_ sender: AnyObject) {
        self.spinner.lineWidth = CGFloat(Float.random(2, upper: 10))
        //        if self.spinner.lineWidth == 0 { self.spinner.lineWidth = 2 }
    }

    @IBAction func googleColorButtonTapped(_ sender: AnyObject) {
        self.spinner.enableGoogleMultiColoredSpinner = !self.spinner.enableGoogleMultiColoredSpinner
    }

    func randomColor() -> UIColor {
        let hue = Float.random(0, upper: 1)
        let saturation = Float.random(0.5, upper: 1)
        let brightness = Float.random(0.5, upper: 1)
        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1)
    }

    //    mark: -Memory Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
