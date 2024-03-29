//
//  RealGravityBehavior.swift
//  Bouncer
//
//  Created by Julien Hémono on 09/06/15.
//  Copyright © 2015 Julien Hémono. All rights reserved.
//

import UIKit
import CoreMotion

class RealGravityBehavior: UIDynamicBehavior {
    
    private let gravity = UIGravityBehavior()
    
    private var collision: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    private var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 0.60
        behavior.friction = 0
        behavior.resistance = 0
        behavior.density = 2
        return behavior
    }()
    
    private let motionManager = CMMotionManager()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collision)
        addChildBehavior(itemBehavior)
        motionManager.accelerometerUpdateInterval = 0.1
    }
    
    func addItem(item: UIDynamicItem) {
        gravity.addItem(item)
        collision.addItem(item)
        itemBehavior.addItem(item)
    }
    
    var realGravity: Bool = false {
        didSet {
            if realGravity != oldValue {
                if realGravity && motionManager.accelerometerAvailable {
                    motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { [unowned self] (data, error) in
                        if let acceleration = data?.acceleration {
                            self.gravity.gravityDirection = CGVector(dx: acceleration.x, dy: -acceleration.y)
                        }
                    }
                } else {
                    motionManager.stopAccelerometerUpdates()

                }
            }
        }
    }

    private var willResignObserver: NSObjectProtocol?
    private var willActivateObserver: NSObjectProtocol?
    private let notificationCenter: NSNotificationCenter = { NSNotificationCenter.defaultCenter() }()
    
    override func willMoveToAnimator(dynamicAnimator: UIDynamicAnimator?) {
        super.willMoveToAnimator(dynamicAnimator)
        
        if dynamicAnimator != nil {
            realGravity = true
        } else {
            realGravity = false
        }
    }

}
