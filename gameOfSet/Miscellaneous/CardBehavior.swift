//
//  CardBehavior.swift
//  gameOfSet
//
//  Created by Dylan Smith on 3/26/18.
//  Copyright © 2018 Me. All rights reserved.
//

import UIKit
// TODO: Comment and re-organize this object

//this is a class that inherits from UIDynamicBehavior protocol and allows for the collection of behaviors into one item
class CardBehavior: UIDynamicBehavior {
    
    //these classes inherit protocols that are collection views.  To add the item to that collection simply addItem() and to remove it do removeItem.
    //collision Behavior dictates how the items react when they hit each other.  This is just a simple behavior
    lazy var collisionBehavior : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        //ensures that the views don't overlap each other
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    //dynamicItemBehavior relates to how they move.  This creates a dynamic item
    lazy var dynamicBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        //1.0 means interactions are completely elastic, 0.0 is inelastic interactions
        behavior.elasticity = 1.0
        //resistance means behavior damping.
        behavior.resistance = 0.0
        return behavior
    }()
    
    //this is a behavior that relates to the push instance of an item.
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.magnitude = CGFloat(3.0)
        push.angle = (2*CGFloat.pi).arcFloat4random
        //this script takes out the push affect in the dynamic action and stops the object in its place.
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        //when this function gets called it adds the push to the group behavior of CardBehavior.
        addChildBehavior(push)
    }
    
    func removeItem(_ item: UIDynamicItem){
        dynamicBehavior.removeItem(item)
        collisionBehavior.removeItem(item)
    }
    
    func addItem(_ item: UIDynamicItem){
        dynamicBehavior.addItem(item)
        collisionBehavior.addItem(item)
        push(item)
    }
    
    override init() {
        //when this behavior is initialized then it adds the child behavior to the DynamicBehavior class.
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(dynamicBehavior)
    }
    
    //convenience initializers are a secondary initializer that is not necessarily called. This initializer allows the animated properties to take place within this reference view.  This provides context for the animations
    convenience init(in animator: UIDynamicAnimator){
        self.init()
        //adds this dynamic behavior to the dynamic animator referenced in the view controller (Controls where the animations stay)
        animator.addBehavior(self)
    }
}

//need to extend CGFloat to include a random calculator as well
extension CGFloat {
    var arcFloat4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
