//
//  GraphViewController.swift
//  Calculator
//
//  Created by Nathan on 21/04/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    
//    @IBOutlet weak var scrollView: UIScrollView!{
//        didSet{
//            scrollView.delegate = self as! UIScrollViewDelegate
//            scrollView.minimumZoomScale = 0.03
//            scrollView.maximumZoomScale = 1.0
//            scrollView.contentSize = graphView.frame.size
//            scrollView.addSubview(graphView)
//        }
//    }
    
    @IBOutlet weak var graphView: GraphView!
    {
        didSet{
            let handler = #selector(GraphView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: handler)
            graphView.addGestureRecognizer(pinchRecognizer)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleBigger(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
            
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panWhere(byReactingTo:)))
            graphView.addGestureRecognizer(panRecognizer)
            
            updateUI()
        }
    }
    
    func panWhere(byReactingTo panRecgnizer: UIPanGestureRecognizer)
    {
        let point : CGPoint = panRecgnizer.translation(in: nil)
        graphView.centerPoint = point

    }
    
    func toggleBigger(byReactingTo tapRecgnizer: UITapGestureRecognizer)
    {
        if tapRecgnizer.state == .ended{
            let point : CGPoint = tapRecgnizer.location(in: nil)
            graphView.centerPoint = point
        }
    }
    
    var formula = MathFormula(symbol: "sin"){
        didSet{
            updateUI()
        }
    }
    
    private func updateUI()
    {
        graphView?.formulaDraw = formula.symbol
    }
}
