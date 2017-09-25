//
//  InformationViewController.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 02.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Alamofire
import AlamofireImage

class InformationViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var imageInformation: UIImageView!
    var initLabel: String = ""
    var lableTestTest: String = ""
    var imageString: String = ""
    
    var searchResultsFilms = try! Realm().objects(Films.self)
    var searchResultsArt = try! Realm().objects(Artists.self)
    
    let data = ["Информация", "Другие фильмы"]
    var views = [UIView]()
    var animator:UIDynamicAnimator!
    var gravity:UIGravityBehavior!
    var snap:UISnapBehavior!
    var previosTouchPoint:CGPoint!
    var viewDragging = false
    var viewPinned = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        filterContent(initLabel)
        
        Alamofire.request(imageString).responseImage
            {
                response in
                if let image = response.result.value
                {
                    self.imageInformation.image = image
                }
        }
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        animator.addBehavior(gravity)
        gravity.magnitude = 4
        
        var offset:CGFloat = 100
        
        for i in 0..<data.count
        {
            if let view = addViewController(atOffset: offset, dataForVC: data[i] as AnyObject?)
            {
                views.append(view)
                offset -= 50
            }
        }
    }
    
    
    func filterContent(_ searchText: String){
        let predicate = NSPredicate(format: "name BEGINSWITH [c] %@", searchText)
        let realm = try! Realm()
        searchResultsFilms = realm.objects(Films.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        searchResultsArt = realm.objects(Artists.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        if searchResultsFilms.count != 0{
        lableTestTest = searchResultsFilms[0].desc
        imageString = searchResultsFilms[0].image
        }else if searchResultsFilms.count == 0{
        lableTestTest = searchResultsArt[0].desc
        imageString = searchResultsArt[0].image
        }
    }
    

    
    func addViewController (atOffset offset:CGFloat, dataForVC:AnyObject?) -> UIView?
    {
        let frameForView = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
        
        let slideUpViewController = SlideUpViewController()
        if let view = slideUpViewController.view
        {
            view.frame = frameForView
            view.layer.cornerRadius = 5
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowColor = UIColor.white.cgColor
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 3
            
            if let labelString = dataForVC as? String
            {
                slideUpViewController.labelOne.text = labelString
                if searchResultsFilms.count != 0{
                    slideUpViewController.textDesc.text = searchResultsFilms[0].desc
                    slideUpViewController.textSearchName = searchResultsFilms[0].name
                }else{
                    slideUpViewController.textDesc.text = searchResultsArt[0].desc
                    slideUpViewController.textSearchName = searchResultsArt[0].name
                }
                
            }
            
            self.addChildViewController(slideUpViewController)
            self.view.addSubview(view)
            slideUpViewController.didMove(toParentViewController: self)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(InformationViewController.handlePan(gestureRecognizer:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
            let collision = UICollisionBehavior(items: [view])
            collision.collisionDelegate = self
            animator.addBehavior(collision)
            

            let boundary = view.frame.origin.y + view.frame.size.height
            
            // lower boundary
            var boundaryStart = CGPoint(x: 0, y: boundary)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundary)
            collision.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            // upper boundary
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundary(withIdentifier: 2 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            gravity.addItem(view)
            
            let itemBehevior = UIDynamicItemBehavior(items: [view])
            animator.addBehavior(itemBehevior)
            
            return view
            
        }
        
        return nil
    }
    
    func handlePan (gestureRecognizer:UIPanGestureRecognizer)
    {
        
        let touchPoint = gestureRecognizer.location(in: self.view)
        let draggedView = gestureRecognizer.view!
        
        if gestureRecognizer.state == .began{
            let dragStartPoint = gestureRecognizer.location(in: draggedView)
            
            if dragStartPoint.y < 200 {
                viewDragging = true
                previosTouchPoint = touchPoint
            }
        } else if gestureRecognizer.state == .changed && viewDragging{
            let yOffset = previosTouchPoint.y - touchPoint.y
            
            draggedView.center = CGPoint(x: draggedView.center.x, y: draggedView.center.y - yOffset)
            previosTouchPoint = touchPoint
        }else if gestureRecognizer.state == .ended && viewDragging{
            
            pin(view: draggedView)
            addVelocity(toView: draggedView, fromGestureRecognizer: gestureRecognizer)
            
            animator.updateItem(usingCurrentState: draggedView)
            viewDragging = false
        }
        
    }
    
    func pin (view:UIView)
    {
        let viewHasReachedPinLocation = view.frame.origin.y < 100
        
        if viewHasReachedPinLocation
        {
            if !viewPinned
            {
                var snapPosition = self.view.center
                snapPosition.y += self.navigationController!.navigationBar.frame.maxY
                
                snap = UISnapBehavior(item: view, snapTo: snapPosition)
                animator.addBehavior(snap)
                
                setVisibility(view: view, alpha: 0)
                
                viewPinned = true
            }
        }else{
            if viewPinned
            {
                animator.removeBehavior(snap)
                setVisibility(view: view, alpha: 1)
                viewPinned = false
            }
        }
        
    }
    
    func setVisibility (view:UIView, alpha: CGFloat)
    {
        for aView in views
        {
            if aView != view
            {
                aView.alpha = alpha
            }
        }
    }
    
    func addVelocity (toView view:UIView, fromGestureRecognizer panGesture:UIPanGestureRecognizer)
    {
        var velocity = panGesture.velocity(in: self.view)
        velocity.x = 0
        
        if let behavior = itemBehavior(forView: view)
        {
            behavior.addLinearVelocity(velocity, for: view)
        }
        
    }
    
    func itemBehavior (forView view: UIView) -> UIDynamicItemBehavior?
    {
        for behavior in animator.behaviors
        {
            if let itemBehavior = behavior as? UIDynamicItemBehavior
            {
                if let possibleView = itemBehavior.items.first as? UIView , possibleView == view
                {
                    return itemBehavior
                }
            }
        }
        return nil
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        if NSNumber(integerLiteral: 2).isEqual(identifier)
        {
            let view = item as! UIView
            pin(view: view)
        }
        
    }
    
    
    
    func initSelf (label: String){
        initLabel = label
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
