//
//  HorizontalScrollBar.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 01.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import UIKit


@objc protocol HorizontalScrollDelegate {
    
    func numberOfScrollViewElementsFilms() -> Int
    
    func numberOfScrollViewElementsArt() -> Int
    
    func elementAtScrollViewIndex(index: Int) -> UIView
    
    func elementAtScrollViewIndexArtist(index: Int) -> UIView
    
}

class HorizontalScroll: UIView{
    var flagClass: Int = 0
    var delegate: HorizontalScrollDelegate?
    let PADDING: Int = 10
    var scroller: UIScrollView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpScroll()
    }
    
    required init(frame: CGRect, flag: Int){
        super.init(frame: frame)
        flagClass = flag
        setUpScroll()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpScroll()
    }
    
    func setUpScroll(){
        scroller = UIScrollView()
        self.addSubview(scroller)
        
        scroller.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["scroller": scroller]
        
        let constraint1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scroller]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        
        let constraint2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scroller]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        
        self.addConstraints(constraint1)
        self.addConstraints(constraint2)
        self.addSubview(scroller)
    }
    
    override func didMoveToSuperview() {
        if flagClass == 0{
            reload()
        } else {
            reloadArtist()
        }
        flagClass = 0
    }
    
    func reload()
    {
        if let del = delegate{
            var xOffset: CGFloat = 0
            for index in 0..<del.numberOfScrollViewElementsFilms(){
                let view = del.elementAtScrollViewIndex(index: index)
                view.frame = CGRect(x: xOffset, y: CGFloat(PADDING), width: CGFloat(100.0), height: CGFloat(100.0))
                xOffset = xOffset + CGFloat(PADDING) + view.frame.size.width
                scroller.addSubview(view)
            }
            scroller.contentSize = CGSize(width: xOffset, height: self.frame.height)
        }
    }
    
    func reloadArtist()
    {
        if let del = delegate{
            var xOffset: CGFloat = 0
            for index in 0..<del.numberOfScrollViewElementsArt(){
                let view = del.elementAtScrollViewIndexArtist(index: index)
                view.frame = CGRect(x: xOffset, y: CGFloat(PADDING), width: CGFloat(100.0), height: CGFloat(100.0))
                xOffset = xOffset + CGFloat(PADDING) + view.frame.size.width
                scroller.addSubview(view)
            }
            scroller.contentSize = CGSize(width: xOffset, height: self.frame.height)
        }
    }
}
