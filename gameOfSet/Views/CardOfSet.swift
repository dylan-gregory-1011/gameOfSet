//
//  CardOfSet.swift
//  gameOfSet
//
//  Created by Dylan Smith on 2/26/18.
//  Copyright © 2018 Me. All rights reserved.
//

import UIKit

class CardOfSet: UIView {
    /// Called when the layout changes in the view
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    // MARK: - Draw Function
    
    override func draw(_ rect: CGRect) {
        if count == 2 {
            for xOffset in [2*(bounds.maxX/3),bounds.maxX/3] {
                xOffsetForDrawingShapes = xOffset
                drawShapes(rect)
            }
        } else {
            xOffsetForDrawingShapes = bounds.midX
            drawShapes(rect)
            if count == 3 {
                for xOffset in [bounds.maxX/4, 3*bounds.maxX/4] {
                    xOffsetForDrawingShapes = xOffset
                    drawShapes(rect)
                }
            }
        }
    }
    
    // MARK: - Properties

    private(set) var card: SetCard
    /// Index in the view of the card
    var indexInScreen: Int
    /// Sets the card to 0 if face down and 1 if the card has been flipped over.
    var flippedOver: Int = 0
    /// Used for drawing the shapes in the views. This is set by the count of shapes in the view
    private var xOffsetForDrawingShapes: CGFloat = 0
    private var count: Int
    /// Sets the corner radius for the view
    private var cornerRadius: CGFloat {
        return bounds.size.height*SizeRatio.cornerRadiusToBoundsHeight
    }
    
    /// Sets the shape width for each shape in the view and ensures that all shapes will fit.
    private var shapeWidth: CGFloat {
        return bounds.width*SizeRatio.xWidthFactor
    }
    
    /// Allows the card to switch between colors based on the value initialized on the cards properties
    private var colorOfShape: UIColor {
        switch color {
        case 0: return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        case 1: return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case 2: return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        default: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    private var color: Int
    
    /// Draws the shape in the view based on the value initialized in the card and also how many shapes are on the view
    private var shapeInCard: UIBezierPath {
        switch shape {
        case 0: return createDiamond(xOffsetForDrawingShapes)
        case 1: return createTriangle(xOffsetForDrawingShapes)
        case 2: return createEllipse(xOffsetForDrawingShapes)
        default: return UIBezierPath()
        }
    }
    private var shape: Int
    
    /// Assign's the shading in the shape based on the value initialized in the card
    private var fillInCard: CGContext {
        switch fill {
        case 0: return createFilling(fillColor: colorOfShape, backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), rect: bounds)
        case 1: return createFilling(fillColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), rect: bounds)
        case 2: return createFilling(fillColor: colorOfShape, backgroundColor: colorOfShape, rect: bounds)
        default: return createFilling(fillColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), rect: bounds)
        }
    }
    private var fill: Int
    
    private var xOffset: CGFloat {
        return bounds.width*(1 - SizeRatio.shapeWidthComparedToView)
    }
    
    private var yOffset: CGFloat {
        return bounds.height*(1 - SizeRatio.shapeHeightComparedToView)
    }
    
    // MARK: -Initialization and Framing
    init(card: SetCard, frame: CGRect, index:Int) {
        self.color = card.color.rawValue
        self.fill = card.shading.rawValue
        self.count = card.amountOfSymbols.rawValue
        self.shape = card.shape.rawValue
        self.card = card
        self.indexInScreen = index
        
        super.init(frame: frame.insetBy(dx: frame.width*SizeRatio.insetFactor, dy: frame.height*SizeRatio.insetFactor))
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = bounds.width*0.03
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardOfSet {
    
    // MARK: - Private Draw Methods
    
    /// Draws the shapes in the view.  This function resets and sets the context to allow for multiple shapes to be drawn in the same view without overlapping them.
    private func drawShapes(_ rect:CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        let path = shapeInCard
        path.addClip()
        fillInCard.fill(rect)
        path.fill()
        path.lineWidth = SizeRatio.lineWidth
        colorOfShape.setStroke()
        path.stroke()
        context.restoreGState()
    }
    /// creates the ellipse shape using the x offset as the initial starting point to draw the correct shape
    private func createEllipse(_ xDrawOffset:CGFloat) -> UIBezierPath {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: xDrawOffset - shapeWidth, y: bounds.height - bounds.height*SizeRatio.shapeHeightComparedToView, width: shapeWidth*SizeRatio.ellipseFactor, height: bounds.height - 2*(bounds.height - bounds.height*SizeRatio.shapeHeightComparedToView)))
        return ovalPath
    }
    
    /// creates the diamond shape using the x offset as the initial starting point to draw the correct shape
    private func createDiamond(_ xDrawOffset:CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xDrawOffset, y: bounds.maxY - bounds.maxY*SizeRatio.shapeHeightComparedToView ))
        path.addLine(to: CGPoint(x: xDrawOffset + shapeWidth , y: bounds.midY))
        path.addLine(to: CGPoint(x: xDrawOffset, y: bounds.maxY*SizeRatio.shapeHeightComparedToView ))
        path.addLine(to: CGPoint(x: xDrawOffset - shapeWidth , y: bounds.midY))
        path.close()
        return path
    }
    
    /// creates the triangle shape using the x offset as the initial starting point to draw the correct shape
    private func createTriangle(_ xDrawOffset:CGFloat) ->UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xDrawOffset, y: bounds.minY + yOffset))
        path.addLine(to: CGPoint(x: xDrawOffset + shapeWidth, y: bounds.height*SizeRatio.shapeHeightComparedToView ))
        path.addLine(to: CGPoint(x: xDrawOffset - shapeWidth, y: bounds.height*SizeRatio.shapeHeightComparedToView ))
        path.close()
        return path
    }
    
    //Creates the filling for the shapes.  This utilizes the different shading options to color in the area that is filled by the shape drawn from above.
    private func createFilling(fillColor:UIColor, backgroundColor: UIColor, rect:CGRect) -> CGContext {
        let context = UIGraphicsGetCurrentContext()!
        
        if backgroundColor == fillColor {
            backgroundColor.setFill()
            return context
        }
        let color1 = fillColor
        let color1Width: CGFloat = SizeRatio.stripesSize
        let color1Height: CGFloat = SizeRatio.stripesSize
        
        let color2 = backgroundColor
        let color2Width: CGFloat = SizeRatio.stripesSize
        let color2Height: CGFloat = SizeRatio.stripesSize
        
        
        /// Set pattern tile orientation vertical.
        let patternWidth: CGFloat = min(color1Width , color2Width )
        let patternHeight: CGFloat = (color1Height + color2Height)
        
        /// Set pattern tile size.
        let patternSize = CGSize(width: patternWidth, height: patternHeight)
        
        //// Draw pattern tile
        UIGraphicsBeginImageContextWithOptions(patternSize, false, 0.0)
        
        let color1Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: color1Width, height: color1Height))
        color1.setFill()
        color1Path.fill()
        
        let color2Path = UIBezierPath(rect: CGRect(x: color1Width, y: 0, width: color2Width, height: color2Height))
        color2.setFill()
        color2Path.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        /// Draw pattern in view
        UIColor(patternImage: image).setFill()
        return context
    }
    
    //MARK: - Public Method
    
    /// Public function that allows the view controller to change the frame of the individual card.
    func changeFrame(frame: CGRect) {
        self.frame = frame.insetBy(dx: frame.width*SizeRatio.insetFactor, dy: frame.height*SizeRatio.insetFactor)
    }
}

extension CardOfSet {
    // MARK: - Constants
    private struct SizeRatio {
        static let shapeHeightComparedToView : CGFloat = 0.9
        static let shapeWidthComparedToView : CGFloat  = 0.6
        static let lineWidth: CGFloat = 3
        static let stripesSize: CGFloat = 2
        static let cornerRadiusToBoundsHeight: CGFloat = 0.1
        static let xWidthFactor: CGFloat = 0.1
        static let ellipseFactor: CGFloat = 2
        static let insetFactor: CGFloat = 0.05
    }
}


