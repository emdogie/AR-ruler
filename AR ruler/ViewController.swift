//
//  ViewController.swift
//  AR ruler
//
//  Created by Marek Garczewski on 11/08/2019.
//  Copyright © 2019 Marek Garczewski. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchlocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchlocation, types: .featurePoint)
            
            if let hitTest = hitTestResults.first {
                addDot(at: hitTest)
            }
        }
    }
    
    func addDot(at hitTest: ARHitTestResult) {
        let dotSphere = SCNSphere(radius: 0.005)
        
        let dotNode = SCNNode()
        
        dotNode.position = SCNVector3(x: hitTest.worldTransform.columns.3.x, y: hitTest.worldTransform.columns.3.y, z: hitTest.worldTransform.columns.3.z)
        
        let dotMaterial = SCNMaterial()
        
        dotMaterial.diffuse.contents = UIColor.red
        
        dotSphere.materials = [dotMaterial]
        
        dotNode.geometry = dotSphere
        
        sceneView.scene.rootNode.addChildNode(dotNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
