//
//  GraphView.swift
//  Calculator
//
//  Created by Nathan on 21/04/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    private var ad = AxesDrawer()
    
    var oringin : CGPoint = CGPoint(x: 207.0,y: 368.0) { didSet{ setNeedsDisplay() } }
    
    var centerPoint: CGPoint {
        get{
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
        set{
            oringin.x = newValue.x
            oringin.y = newValue.y
        }
    }
    
    @IBInspectable
    var pixelPerUnit = 25.0 { didSet{ setNeedsDisplay() } }
    @IBInspectable
    var lineWidth : CGFloat = 1.0 { didSet{ setNeedsDisplay() } }
    
    var formulaDraw : String = "sin"
    
    private var operations: Dictionary<String,(Double) -> Double> = [
        "√" : sqrt,
        "sin" : sin,
        "cos" : cos,
        "tan" : tan,
//        "✕" : Operation.BinaryOperation({$0 * $1}), //closures
//        "÷" : Operation.BinaryOperation({$0 / $1}),
//        "+" : Operation.BinaryOperation({$0 + $1}),
//        "−" : Operation.BinaryOperation({$0 - $1}),
        ]
    
//    private enum Operation{
//        case UnaryOperation((Double) -> Double) //represent function
////        case BinaryOperation((Double,Double) -> Double)
//    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {
        case .changed,.ended:
            pixelPerUnit *= Double(pinchRecognizer.scale)
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    

    let steps = 200                 // Divide the curve into steps
    
    var stepX : CGFloat{
        return frame.width / CGFloat(steps) // find the horizontal step distance
    }
    
    private func pathForFunction() ->UIBezierPath
    {
        let path = UIBezierPath()
        // Start in the lower left corner
        path.move(to: CGPoint(x: 0, y: oringin.y))
        
        // Loop and draw steps in straingt line segments
        for i in 0...steps {
            let x = CGFloat(i) * stepX
            let y = Double(oringin.y) - operations[formulaDraw]!(Double(x - oringin.x) / pixelPerUnit) * pixelPerUnit
            path.addLine(to: CGPoint(x: x, y: CGFloat(y)))
        }
        
        UIColor.red.set()
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        ad.drawAxes(in: bounds, origin: oringin, pointsPerUnit: CGFloat(pixelPerUnit))
        pathForFunction().stroke()

    }
}
