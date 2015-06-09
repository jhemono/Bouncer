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
    
    var blocks = [UIView]()
    
    func addBlock() {
        let block = UIView()
        block.frame.size = blockSize
        block.center = view.bounds.center
        block.backgroundColor = UIColor.redColor()
        
        view.addSubview(block)
        blocks.append(block)
        realGravityBehavior.addItem(block)
    }
    
    var attachments = [UIAttachmentBehavior]()

    @IBAction func panView(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        
        switch sender.state {
        case .Began :
            let targetedBlocks = blocks.filter { $0.frame.contains(location) }
            attachments = targetedBlocks.map {
                let attachment = UIAttachmentBehavior(item: $0, attachedToAnchor: location)
                animator.addBehavior(attachment)
                return attachment
            }
        case .Changed:
            for attachment in attachments {
                attachment.anchorPoint = location
            }
        default:
            if !attachments.isEmpty {
                for attachment in attachments {
                    animator.removeBehavior(attachment)
                }
                attachments.removeAll()
            }
        }
    }
}

private extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.origin.x + (self.size.width / 2), y: self.origin.y + (self.size.height / 2))
    }
}
