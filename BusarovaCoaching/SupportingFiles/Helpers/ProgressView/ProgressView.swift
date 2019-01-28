//
//  ProgressView.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    // MARK: - private properties
    private var progressedShape = ProgressShapeLayer()
    private var unprogressedShape = ProgressShapeLayer()
    
    lazy private var progressValueLabel: UILabel = {
        $0.frame = self.bounds
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.layer.cornerRadius = halfSize
        $0.textAlignment = .center
        $0.textColor = self.progressedColor
        $0.font = UIFont.boldSystemFont(ofSize: halfSize)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.0
        $0.numberOfLines = 1
        $0.sizeToFit()
        
        $0.backgroundColor = self.backgroundColor
        
        return $0
    }(UILabel())
    
    // MARK: - public properties
    var minimumProgress: Int = 0 {
        didSet {
            if !newMinimumIsCorrect(minimumProgress) {
                minimumProgress = oldValue
            } else {
                progressedShape.minimumProgress = minimumProgress
                unprogressedShape.minimumProgress = minimumProgress
            }
        }
    }
    
    var maximumProgress: Int = 1 {
        didSet {
            if !newMaximimIsCorrect(maximumProgress) {
                maximumProgress = oldValue
            } else {
                progressedShape.maximumProgress = maximumProgress
                unprogressedShape.maximumProgress = maximumProgress
            }
        }
    }
    
    var progressedColor: UIColor = UIColor.blue {
        didSet {
            if progressedColor != unprogressedColor {
                progressedShape.strokeColor = progressedColor.cgColor
                progressValueLabel.textColor = progressedColor
            }
        }
    }
    
    var unprogressedColor: UIColor = UIColor.lightGray {
        didSet {
            if unprogressedColor != progressedColor {
                unprogressedShape.strokeColor = unprogressedColor.cgColor
            }
        }
    }
    
    var borderThickness: CGFloat = 2.0 {
        didSet {
            progressedShape.lineWidth = borderThickness
            unprogressedShape.lineWidth = borderThickness
        }
    }
    
    var spacePercent: CGFloat = 0.1 {
        didSet {
            progressedShape.spacePercent = spacePercent
            unprogressedShape.spacePercent = spacePercent
        }
    }
    
    var currentProgress: Int {
        get {
            guard
                let valueString = progressValueLabel.text,
                let valueInt = Int(valueString)
                else { return minimumProgress }
            
            return valueInt
        }
        set (newProgress) {
            let newValue: Int
            if newProgress > maximumProgress {
                newValue = maximumProgress
            } else if newProgress < minimumProgress {
                newValue = minimumProgress
            } else {
                newValue = newProgress
            }
            
            progressValueLabel.text = "\(newValue)"
            
            calculatePath(for: newValue)
        }
    }
    
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        setup(shape: progressedShape)
        progressedShape.strokeColor = progressedColor.cgColor
        setup(shape: unprogressedShape)
        unprogressedShape.strokeColor = unprogressedColor.cgColor
        
        self.layer.cornerRadius = min(frame.width, frame.height) / 2
        self.backgroundColor = UIColor.clear
        
        self.progressValueLabel.text = "\(minimumProgress)"
        self.currentProgress = minimumProgress
        
        self.addSubview(progressValueLabel)
        layoutProgressValueLabel()
        
        self.layer.addSublayer(progressedShape)
        self.layer.addSublayer(unprogressedShape)
    }
    
    // MARK: - computed properties
    private var halfSize: CGFloat {
        return min(self.frame.width, self.frame.height) / 2
    }
    
    // MARK: - ProgressValue Label Layout
    private func layoutProgressValueLabel() {
        NSLayoutConstraint.activate([
            self.progressValueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            self.progressValueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            self.progressValueLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.0),
            self.progressValueLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0.0),
            ])
    }
    
    // MARK: - setup shapes and calculate paths
    private func setup(shape: CAShapeLayer) {
        shape.bounds = CGRect(x: 0.0,
                              y: 0.0,
                              width: self.frame.width,
                              height: self.frame.height
        )
        shape.position = shape.shapeCenterPosition
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = self.borderThickness
    }
    
    private func calculatePath(for currentProgress: Int) {
        switch currentProgress {
        case minimumProgress:
            progressedShape.path = nil
            unprogressedShape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: halfSize).cgPath
        case maximumProgress:
            unprogressedShape.path = nil
            progressedShape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: halfSize).cgPath
        default:
            progressedShape.path = progressedShape.getPath(for: currentProgress, isProgressed: true)
            unprogressedShape.path = unprogressedShape.getPath(for: currentProgress, isProgressed: false)
        }
    }
}

// MARK: - control of extremum values
extension ProgressView {
    private func newMinimumIsCorrect(_ newValue: Int) -> Bool {
        return newValue >= maximumProgress ? false : true
    }
    
    private func newMaximimIsCorrect(_ newValue: Int) -> Bool {
        return newValue <= minimumProgress ? false : true
    }
}
