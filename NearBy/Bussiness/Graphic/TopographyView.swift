//
//  TopographyView.swift
//  topographyDemo
//
//  Created by zx on 10/28/16.
//  Copyright © 2016 zx. All rights reserved.
//

import UIKit

struct TopoPoint {
    var x: CGFloat
    var y: CGFloat
    var id: String
}

class TopographyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.masksToBounds = false
        clipsToBounds = false
        updatePoints()
    }
    func updatePoints() {
        pointViews.forEach { (l) in
            l.removeFromSuperview()
        }
        pointViews.removeAll()
        let mutiplier: CGFloat = CGFloat(30)
        for (i, p) in points.enumerated() {
            let xCoord = p.x * mutiplier
            let yCoord = p.y * mutiplier
            let label = UILabel()
            label.text = p.id
            label.backgroundColor = UIColor.clear
            label.clipsToBounds = true
            label.frame = CGRect(x: xCoord, y: yCoord, width: 200, height: 25)
            addSubview(label)
            
            let pot = UIView(frame: CGRect(x: label.frame.minX, y: label.frame.minY, width: 10, height: 10))
            pot.layer.cornerRadius = 5
            pot.backgroundColor = UIColor.red
            addSubview(pot)
            pointViews.append(label)
        }
    }

    var pointViews: [UILabel] = []
    var points: [TopoPoint] = [] {
        didSet {
            updatePoints()
        }
    }
}
