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
    
	var showName: Bool = true {
		didSet {
			pointViews.forEach { (p) in
                p.showName = showName
			}
		}
	}
	
	var pointViews: [PointView] = []
    var isShake = true {
        didSet {
            pointViews.forEach { (p) in
                p.isShake = isShake
            }
        }
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
	
	func clearAllPoints() {
		points = []
	}
	
	func updatePoints() {
		pointViews.forEach { (l) in
			l.removeFromSuperview()
		}
		pointViews.removeAll()
		
		let mutiplier: CGFloat = CGFloat(30)
		for (_, p) in points.enumerated() {
			let xCoord = p.x * mutiplier
			let yCoord = p.y * mutiplier
			
            let pointView = PointView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
			pointView.name = p.id.stripePrefix()
			pointView.isMe = p.id == BLEManager.default().advertisingName
            pointView.center = CGPoint(x: xCoord, y: yCoord)
			
            addSubview(pointView)
            pointView.shake()
			pointViews.append(pointView)
		}
	}
	
	var points: [TopoPoint] = [] {
		didSet {
			updatePoints()
		}
	}
}

class PointView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        // setup tap
//        let tap = UITapGestureRecognizer(target: self, action: #selector(PointView.tapped(g:)))
//        addGestureRecognizer(tap)
        // setup clipbounds
        clipsToBounds = false
    }
    
    func tapped(g: UITapGestureRecognizer) {
        showName = !showName
    }
    
	var name: String = "" {
		didSet {
			label.text = name
		}
	}
	var showName = true {
		didSet {
			label.isHidden = !showName
		}
	}
	var isMe = false {
		didSet {
            widthConstraint?.offset(isMe ? 10 : -10)
		}
	}
    
    var isShake = true {
        didSet {
            if isShake {
                shake()
            } else {
                stopShake()
            }
        }
    }
	
	lazy var label: UILabel = { [unowned self] in
		let result = UILabel()
		result.isHidden = true
        result.textColor = UIColor.black
		result.font = UIFont.systemFont(ofSize: 6)
		result.backgroundColor = UIColor.clear
		result.clipsToBounds = true
//		result.verticalAlignment = UPVerticalAlignmentMiddle
		self.addSubview(result)
        result.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.pointView.snp.trailing).offset(8)
            make.centerY.equalTo(self.pointView)
        })
        return result
	}()
    
    var widthConstraint: ConstraintMakerEditable!
    
	lazy var pointView: UIView = { [unowned self] in
		let pointSize: CGFloat = 10
		let result = UIView(frame: .zero)
		result.layer.cornerRadius = pointSize / 2
		result.backgroundColor = UIColor.red
		self.addSubview(result)
        result.snp.makeConstraints({ (make) in
            make.top.leading.equalTo(self)
            self.widthConstraint = make.width.height.equalTo(10)
        })
		return result
	}()
}

extension UIView {
    func shake() {
        let vertical = CABasicAnimation(keyPath: "position.y")
        vertical.fromValue = layer.position.y
        vertical.toValue = layer.position.y + CGFloat(arc4random() % 10 + 3)
        let horizontal = CABasicAnimation(keyPath: "position.x")
        horizontal.fromValue = layer.position.x
        horizontal.toValue = layer.position.x + CGFloat(arc4random() % 10 + 3)
        
        let group = CAAnimationGroup()
        group.repeatCount = HUGE
        group.autoreverses = true
        group.duration = Double(arc4random() % 10) / Double(10) + 0.25
        group.animations = [vertical, horizontal]
        layer.add(group, forKey: "shake")
    }
    
    func stopShake() {
       layer.removeAnimation(forKey: "shake")
    }
}
