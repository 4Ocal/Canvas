//
//  ViewController.swift
//  Canvas
//
//  Created by Calvin Chu on 3/14/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        trayCenterWhenOpen = CGPoint(x: trayView.frame.midX, y: trayView.frame.midY)
        trayCenterWhenClosed = CGPoint(x: trayView.frame.midX, y: trayView.frame.midY + trayView.frame.height - 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parentView
        //let location = sender.location(in: self.view)

        if (sender.state == .began) {
            //NSLog("Gesture began at: %@", NSStringFromCGPoint(location))
            trayOriginalCenter = CGPoint(x: trayView.frame.midX, y: trayView.frame.midY)
        } else if (sender.state == .changed) {
            //NSLog("Gesture changed at: %@", NSStringFromCGPoint(location))
            //trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + sender.translation(in: self.view).y)
            let velocity = sender.velocity(in: self.view)
            if velocity.y > 0 {
                // moving down
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.trayView.center = self.trayCenterWhenClosed
                }, completion: nil)
            } else {
                // moving up
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.trayView.center = self.trayCenterWhenOpen
                }, completion: nil)
            }
        } else if (sender.state == .ended) {
            //NSLog("Gesture ended at: %@", NSStringFromCGPoint(location))
        }
    }
    
    @IBAction func onTrayTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if trayView.center.y < self.view.frame.height {
                // moving down
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.trayView.center = self.trayCenterWhenClosed
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.trayView.center = self.trayCenterWhenOpen
                }, completion: nil)
            }
        }
    }
    
    @IBAction func onFacePanGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            // Gesture recognizers know the view they are attached to
            let imageView: UIImageView = sender.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the tray's parent view.
            self.view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            let faceCenter = newlyCreatedFace.center
            newlyCreatedFace.center = CGPoint(x: faceCenter.x, y: faceCenter.y + trayView.frame.origin.y)
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            let translation = sender.translation(in: self.view)
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        
        
    }

}

