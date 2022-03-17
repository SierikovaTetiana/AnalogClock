//
//  ViewController.swift
//  AnalogClock
//
//  Created by Tetiana Sierikova on 17.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var digitalTime: UILabel!
    @IBOutlet weak private var clock: UIImageView!
    @IBOutlet weak private var hours: UIImageView!
    @IBOutlet weak private var minutes: UIImageView!
    @IBOutlet weak private var seconds: UIImageView!
    
    private let second = CGFloat(Date().second * (360 / 60))
    private let minute = CGFloat(Date().minute * (360 / 60))
    private let hour = (CGFloat(Date().hour * (360/12)) + (CGFloat(Date().minute) * (1.0 / 60) * (360 / 12)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        digitalTimer()
        
        drawLine(onView: seconds, from: CGPoint(x: seconds.bounds.width / 2, y: seconds.bounds.height / 2), to: CGPoint(x: seconds.bounds.width / 2, y: 0), colorLine: .red, widthLine: 1)
        drawLine(onView: minutes, from: CGPoint(x: minutes.bounds.width / 2, y: minutes.bounds.height / 2), to: CGPoint(x: minutes.bounds.width / 2, y: 35), colorLine: .black, widthLine: 3)
        drawLine(onView: hours, from: CGPoint(x: hours.bounds.width / 2, y: hours.bounds.height / 2), to: CGPoint(x: hours.bounds.width / 2, y: 60), colorLine: .black, widthLine: 7)
        
        animatePointers(duration: 60, time: second, pointer: seconds)
        animatePointers(duration: 60 * 60, time: minute, pointer: minutes)
        animatePointers(duration: 60 * 60 * 12, time: hour, pointer: hours)
    }
    
    private func degree2Radian(floatNumber: CGFloat) -> CGFloat {
        let radian = CGFloat(Double.pi) * floatNumber / 180
        return radian
    }
    
    private func drawLine(onView: UIImageView, from fromPoint: CGPoint, to toPoint: CGPoint, colorLine: UIColor, widthLine: CGFloat) {
        UIGraphicsBeginImageContext(onView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        onView.image?.draw(in: onView.bounds)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(.butt)
        context.setBlendMode(.normal)
        context.setLineWidth(widthLine)
        context.setStrokeColor(colorLine.cgColor)
        context.strokePath()
        onView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func animatePointers(duration: CFTimeInterval, time: CGFloat, pointer: UIImageView) {
        pointer.layer.add(setUpLayerAnimation(duration: duration, isRemovedOnCompletion: false, timingFunction: CAMediaTimingFunction(name: .linear), fromValue: degree2Radian(floatNumber: time), byValue: 2 * Double.pi),
                          forKey: "transform.rotation.z")
    }
    
    private func setUpLayerAnimation(keyPath: String = "transform.rotation.z", repeatCount: Float = .infinity, duration: CFTimeInterval, isRemovedOnCompletion: Bool, timingFunction: CAMediaTimingFunction?, fromValue: Any?, byValue: Any?) -> CABasicAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = keyPath
        animation.repeatCount = repeatCount
        animation.duration = duration
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        animation.timingFunction = timingFunction
        animation.fromValue = fromValue
        animation.byValue = byValue
        return animation
    }
    
    // MARK: - Set Digital Clock
    
    private func digitalTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss"
            let currentTime = dateFormatter.string(from: date)
            self.digitalTime.text = currentTime
        }
    }
}

extension Date {
    var dateComponents: DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponenets = calendar.dateComponents([.year, .month, .day, .second, .minute, .hour], from: self)
        return dateComponenets
    }
    var second: Int {
        return dateComponents.second ?? 0
    }
    var minute: Int {
        return dateComponents.minute ?? 0
    }
    var hour: Int {
        return dateComponents.hour ?? 0
    }
}
