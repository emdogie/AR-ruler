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
    
    var dotNodes = [SCNNode]()
    
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
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
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculateDistance()
        }
    }
    
    func calculateDistance() {
        let startDot = dotNodes[0]
        
        let endDot = dotNodes[1]
        
        let a = endDot.position.x - startDot.position.x
        
        let b = endDot.position.y - startDot.position.y
        
        let c = endDot.position.z - startDot.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        print(distance)
        
        updateText(text: "\(distance)", position: endDot)
    }
    
    func updateText(text: String, position dot: SCNNode) {
        
        textNode.removeFromParentNode()
        
        let text = SCNText(string: text, extrusionDepth: 1.0)
        
        text.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode()
        
        textNode.position = SCNVector3(x: dot.position.x, y: dot.position.y + 0.1, z: dot.position.z)
        
        textNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        
        textNode.geometry = text
        
        sceneView.scene.rootNode.addChildNode(textNode)
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
