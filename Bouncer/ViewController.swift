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
        addBlock(center: sender.locationInView(view))
    }
    
    private func addBlock(center center: CGPoint) {
        let block = UIView()
        block.frame.size = blockSize
        block.center = center
        block.backgroundColor = UIColor.redColor()
        
        view.addSubview(block)
        let panGesture = UIPanGestureRecognizer(target: self, action: "panView:")
        block.addGestureRecognizer(panGesture)
        attachments[panGesture] = (view: block, attachment: nil)
        realGravityBehavior.addItem(block)
    }
    
    private var attachments = [UIPanGestureRecognizer: (view: UIView, attachment: UIAttachmentBehavior?)]()

    @IBAction func panView(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        if let (view, attachment) = attachments[sender] {
            switch sender.state {
            case .Began :
                let attachment1 = UIAttachmentBehavior(item: view, attachedToAnchor: location)
                animator.addBehavior(attachment1)
                attachments[sender] = (view, attachment1)
            case .Changed:
                attachment!.anchorPoint = location
            default:
                animator.removeBehavior(attachment!)
                attachments[sender] = (view, nil)
            }
        }
    }
}
