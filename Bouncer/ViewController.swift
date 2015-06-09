//
//  ViewController.swift
//  Bouncer
//
//  Created by Julien Hémono on 09/06/15.
//  Copyright © 2015 Julien Hémono. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private struct Constants {
        static let widthDivider: CGFloat = 8
    }
    
    private var blockSize: CGSize {
        let sideLength = view.bounds.size.width / Constants.widthDivider
        return CGSize(width: sideLength, height: sideLength)
    }
    
    private let realGravityBehavior = RealGravityBehavior()
    
    private var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animator.addBehavior(realGravityBehavior)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        animator.removeBehavior(realGravityBehavior)
    }
    
    @IBAction func tappedView(sender: UITapGestureRecognizer) {
        addBlock()
    }
    
    func addBlock() {
        let block = UIView()
        block.frame.size = blockSize
        block.center = view.bounds.center
        block.backgroundColor = UIColor.redColor()
        
        view.addSubview(block)
        realGravityBehavior.addItem(block)
    }

}

private extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.origin.x + (self.size.width / 2), y: self.origin.y + (self.size.height / 2))
    }
}
