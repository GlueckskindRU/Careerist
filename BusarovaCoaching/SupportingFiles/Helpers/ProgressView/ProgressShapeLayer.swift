//
//  ProgressShapeLayer.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

class ProgressShapeLayer: CAShapeLayer {
    // MARK: - public properties
    var minimumProgress: Int = 0 {
        didSet {
            if !newMinimumisCorrect(minimumProgress) {
                minimumProgress = oldValue
            }
        }
    }
    
    var maximumProgress: Int = 1 {
        didSet {
            if !newMaximumIsCorrect(maximumProgress) {
                maximumProgress = oldValue
            }
        }
    }
    
    var spacePercent: CGFloat = 0.1 {
        didSet {
            if !newSpacePercentIsCorrect(spacePercent) {
                spacePercent = oldValue
            }
        }
    }
    
    // MARK: - computed properties
    private var numberOfProgressedSegments: Int {
        return abs(minimumProgress) + abs(maximumProgress)
    }
    
    private var segmentAngle: CGFloat {
        return (2 * CGFloat.pi) / CGFloat(numberOfProgressedSegments)
    }
    
    private var offsetAngle: CGFloat {
        return (spacePercent * 2 * CGFloat.pi) / CGFloat(numberOfProgressedSegments)
    }
    
    // MARK: - public method
    func getPath(for currentProgress: Int, isProgressed: Bool) -> CGPath? {
        let startingSegment: Int = isProgressed  ? minimumProgress + abs(minimumProgress) + 1
            : currentProgress + abs(minimumProgress) + 1
        let finishingSegment: Int = isProgressed ? currentProgress + abs(minimumProgress)
            : maximumProgress + abs(minimumProgress)
        
        let segmentsPath = UIBezierPath()
        
        for segment in startingSegment...finishingSegment {
            segmentsPath.append(calculatePath(for: segment))
        }
        
        return segmentsPath.cgPath
    }
    
    // MARK: - private methods
    private func calculatePath(for segment: Int) -> UIBezierPath {
        let startAngle: CGFloat = (3 / 2 * CGFloat.pi) + ((CGFloat(segment) - 1) * segmentAngle) + offsetAngle
        let endAngle: CGFloat = (3 / 2 * CGFloat.pi) + (CGFloat(segment) * segmentAngle) - offsetAngle
        
        let path = UIBezierPath(arcCenter: shapeCenterPosition,
                                radius: halfSize,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true
        )
        
        return path
    }
}

// MARK: - control of properties values
extension ProgressShapeLayer {
    private func newMinimumisCorrect(_ newValue: Int) -> Bool {
        return newValue >= maximumProgress ? false : true
    }
    
    private func newMaximumIsCorrect(_ newValue: Int) -> Bool {
        return newValue <= minimumProgress ? false : true
    }
    
    private func newSpacePercentIsCorrect(_ newValue: CGFloat) -> Bool {
        return (newValue <= 0.0) || (newValue >= 1.0) ? false : true
    }
}
