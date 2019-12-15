//
//  JCGGProgressBar.swift
//  JCGGProgressBar
//
//  Created by Jacob Gold on 23/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

@IBDesignable
open class JCGGProgressBar: NSView {
    
    // Progress bar color
    @IBInspectable public var barColor: NSColor = NSColor.labelColor
    // Track color
    @IBInspectable public var trackColor: NSColor = NSColor.secondaryLabelColor
    // Progress bar thickness
    @IBInspectable public var barThickness: CGFloat = 10
    // Progress amount
    @IBInspectable public var progressValue: CGFloat = 0 {
        didSet {
            progressValue = min(max(progressValue, 0), 100)
            needsDisplay = true
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = NSGraphicsContext.current?.cgContext else {return}
        let beginPoint = CGPoint(x: (barThickness / 2), y: frame.size.height / 2)
        
        // Progress Track
        context.setStrokeColor(trackColor.cgColor)
        context.beginPath()
        context.setLineWidth(barThickness)
        context.move(to: beginPoint)
        context.addLine(to: CGPoint(x: frame.size.width - (barThickness / 2), y: frame.size.height / 2))
        context.strokePath()
        
        // Progress Bar
        context.setStrokeColor(barColor.cgColor)
        context.beginPath()
        context.move(to: beginPoint)
        context.addLine(to: CGPoint(x: (barThickness / 2) + percentage(), y: frame.size.height / 2))
        context.strokePath()
    }
    
    private func percentage() -> CGFloat {
        let screenWidth = frame.size.width - barThickness
        return ((progressValue / 100) * screenWidth)
    }
    
}
