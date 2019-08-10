//
//  NumericLabel.swift
//  Toast
//
//  Created by ParkSungJoon on 07/07/2019.
//  Copyright © 2019 DDD. All rights reserved.
//

import UIKit

class NumericLabel: UIView {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var animationTimer: Timer?
    var targetValue: Double = 0.0
    var currentValue: Double = 0.0
    var stepSize: Double = 0.0
    
    var label: UILabel!
    open var textFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    open var textAlignment: NSTextAlignment = NSTextAlignment.center {
        didSet {
            label.textAlignment = textAlignment
        }
    }
    
    @IBInspectable open var labelTextColor: UIColor = UIColor.black {
        didSet {
            label.textColor = labelTextColor
        }
    }
    
    open var formatString: String = "%.2f"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        label.textColor = labelTextColor
        label.textAlignment = textAlignment
        label.font = textFont
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(label, toView: self, attribute: .top, constant: 0.0)
        self.addConstraint(label, toView: self, attribute: .leading, constant: 0.0)
        self.addConstraint(label, toView: self, attribute: .bottom, constant: 0.0)
        self.addConstraint(label, toView: self, attribute: .trailing, constant: 0.0)
        
    }
    
    func addConstraint(_ newView: UIView, toView: UIView, attribute: NSLayoutConstraint.Attribute, constant: CGFloat) {
        let constraint =  NSLayoutConstraint(item: newView,
                                             attribute: attribute,
                                             relatedBy: .equal,
                                             toItem: toView,
                                             attribute: attribute,
                                             multiplier: 1.0,
                                             constant: constant)
        toView.addConstraint(constraint)
    }
    
    func updateView() {
        self.clipsToBounds = true
        label = UILabel(frame: self.frame)
        self.addSubview(label)
    }
    
    public func setValue(value: Double) {
        if animationTimer != nil {
            animationTimer?.invalidate()
        }
        
        targetValue = value
        stepSize = (targetValue - currentValue) / 20.0
        
        animationTimer = Timer.scheduledTimer(timeInterval: (1/40.0),
                                              target: self,
                                              selector: #selector(onAnimationTimer),
                                              userInfo: nil,
                                              repeats: true)
        
    }
    
    @objc func onAnimationTimer() {
        currentValue += stepSize
        updateCurrentValue(value: currentValue)
        if stepSize < 0 {
            if currentValue < targetValue {
                //done decreasing
                currentValue = targetValue
                updateCurrentValue(value: targetValue)
                if (animationTimer) != nil {
                    animationTimer?.invalidate()
                    animationTimer = nil
                }
            }
        } else {
            if currentValue > targetValue {
                //done increasing
                currentValue = targetValue
                updateCurrentValue(value: targetValue)
                if (animationTimer) != nil {
                    animationTimer?.invalidate()
                    animationTimer = nil
                }
            }
        }
    }
    
    func updateCurrentValue(value: Double) {
        self.label.text = String(format: self.formatString, value)
    }
    
}
