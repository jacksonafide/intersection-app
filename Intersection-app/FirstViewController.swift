//
//  FirstViewController.swift
//  Intersection-app
//
//  Created by Jacek Chojnacki on 15/02/2020.
//  Copyright © 2020 Jacek Chojnacki. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate {
    @IBOutlet weak var xa: UITextField!
    @IBOutlet weak var ya: UITextField!
    @IBOutlet weak var bx: UITextField!
    @IBOutlet weak var by: UITextField!
    @IBOutlet weak var xc: UITextField!
    @IBOutlet weak var yc: UITextField!
    @IBOutlet weak var xd: UITextField!
    @IBOutlet weak var yd: UITextField!
    @IBOutlet weak var labelX: UILabel!
    @IBOutlet weak var labelY: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var PointA = CGPoint(x: 0, y: 0)
    var PointB = CGPoint(x: 0, y: 0)
    var PointC = CGPoint(x: 0, y: 0)
    var PointD = CGPoint(x: 0, y: 0)
    var PointP = CGPoint(x: 0, y: 0)
    let line1 = CAShapeLayer()
    let linePath1 = UIBezierPath()
    let line2 = CAShapeLayer()
    let linePath2 = UIBezierPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        self.imgView.image = UIImage(named: "image")
    }
    
    func clearImage() {
        self.imgView.image = nil
        self.imgView.layer.sublayers = nil
        self.imgView.setNeedsDisplay()
    }
    
    @IBAction func compute(_ sender: UIButton) {
        if sender.tag == 9{
            PointA.x = CGFloat((String(xa.text!) as NSString).doubleValue)
            PointA.y = CGFloat((String(ya.text!) as NSString).doubleValue)
            PointB.x = CGFloat((String(bx.text!) as NSString).doubleValue)
            PointB.y = CGFloat((String(by.text!) as NSString).doubleValue)
            PointC.x = CGFloat((String(xc.text!) as NSString).doubleValue)
            PointC.y = CGFloat((String(yc.text!) as NSString).doubleValue)
            PointD.x = CGFloat((String(xd.text!) as NSString).doubleValue)
            PointD.y = CGFloat((String(yd.text!) as NSString).doubleValue)

            let dXab: Double = Double(PointB.x - PointA.x)
            let dYab: Double = Double(PointB.y - PointA.y)
            let dXac: Double = Double(PointC.x - PointA.x)
            let dYac: Double = Double(PointC.y - PointA.y)
            let dXcd: Double = Double(PointD.x - PointC.x)
            let dYcd: Double = Double(PointD.y - PointC.y)
            
            let nominator: Double = (dXac * dYcd) - (dYac * dXcd)
            let denominator: Double = (dXab * dYcd) - (dYab * dXcd)
            
            let t1 = nominator / denominator
            
            let px = Double(PointA.x) + (t1 * dXab)
            let py = Double(PointA.y) + (t1 * dYab)
            
            let px_r = Double(round(1000*px)/1000)
            let py_r = Double(round(1000*py)/1000)
            
            labelX.text = String(px_r)
            labelY.text = String(py_r)
            
            PointP.x = CGFloat(px_r)
            PointP.y = CGFloat(py_r)
            
            let sPa: CGPoint = scalePoints(x: Float(PointA.x), y: Float(PointA.y))
            let sPb: CGPoint = scalePoints(x: Float(PointB.x), y: Float(PointB.y))
            let sPc: CGPoint = scalePoints(x: Float(PointC.x), y: Float(PointC.y))
            let sPd: CGPoint = scalePoints(x: Float(PointD.x), y: Float(PointD.y))
            let sPp: CGPoint = scalePoints(x: Float(PointP.x), y: Float(PointP.y))
            
            clearImage()
            
            addLine(fromPoint: sPa, toPoint: sPb, line: line1, linePath: linePath1)
            addLine(fromPoint: sPc, toPoint: sPd, line: line2, linePath: linePath2)
            addPoint(pt: sPa)
            addPoint(pt: sPb)
            addPoint(pt: sPc)
            addPoint(pt: sPd)
            addPoint(pt: sPp)
            addText(text: "A", pt: sPa)
            addText(text: "B", pt: sPb)
            addText(text: "C", pt: sPc)
            addText(text: "D", pt: sPd)
            addText(text: "P", pt: sPp)
        }
    }
    
    func addLine(fromPoint start: CGPoint, toPoint end: CGPoint, line: CAShapeLayer, linePath: UIBezierPath) {
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.black.cgColor
        line.lineWidth = 2
        line.lineJoin = CAShapeLayerLineJoin.round
        self.imgView.layer.addSublayer(line)
    }
    
    func addPoint(pt: CGPoint) {
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: pt.x-5, y: pt.y-5, width: 10, height: 10)).cgPath
        self.imgView.layer.addSublayer(circleLayer)
    }
    
    func addText(text: String, pt: CGPoint) {
        let frame = CGRect(x: pt.x - 7, y: pt.y + 10, width: 15, height: 15)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.font = UIFont(name: "San Francisco", size: 12)
        label.text = text
        label.textColor = .black
        self.imgView.addSubview(label)
    }
    
    func scalePoints(x: Float, y: Float) -> (CGPoint) {
        let canMaxX: Float = 330
        let canMaxY: Float = 330
        
        let arrayX = [PointA.x, PointB.x, PointC.x, PointD.x]
        let arrayY = [PointA.y, PointB.y, PointC.y, PointD.y]
        
        let maxX = Float(arrayX.max()!)
        let minX = Float(arrayX.min()!)
        let maxY = Float(arrayY.max()!)
        let minY = Float(arrayY.min()!)
        
        let sX = canMaxX / (maxY - minY)
        let sY = canMaxY / (maxX - minX)
        
        let scaledX = 25 + sX * (y - minY)
        let scaledY = 25 + canMaxY - (sY * (x - minX))
        
        let sP = CGPoint(x: CGFloat(scaledX), y: CGFloat(scaledY))
        return sP
    }
    
    @IBAction func saveImg(_ sender: UIButton) {
        guard let selectedImg = getImgFromVyuFnc() else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func getImgFromVyuFnc() -> UIImage?
    {
        UIGraphicsBeginImageContext(imgView.frame.size)

        imgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return image!
    }
    
    @IBAction func thicc(_ sender: UIButton) {
        switch line1.lineWidth{
        case 2:
            line1.lineWidth = 4
        case 4:
            line1.lineWidth = 2
        default:
            line1.lineWidth = 2
        }
    }
    
    @IBAction func thicc2(_ sender: UIButton) {
        switch line2.lineWidth{
        case 2:
            line2.lineWidth = 4
        case 4:
            line2.lineWidth = 2
        default:
            line2.lineWidth = 2
        }
    }
    
    @IBAction func color1(_ sender: UIButton) {
        switch line1.strokeColor{
        case UIColor.black.cgColor:
            line1.strokeColor = UIColor.red.cgColor
        case UIColor.red.cgColor:
            line1.strokeColor = UIColor.green.cgColor
        case UIColor.green.cgColor:
            line1.strokeColor = UIColor.blue.cgColor
        case UIColor.blue.cgColor:
            line1.strokeColor = UIColor.black.cgColor
        default:
            line1.strokeColor = UIColor.black.cgColor
        }
    }
    
    @IBAction func color2(_ sender: UIButton) {
        switch line2.strokeColor{
        case UIColor.black.cgColor:
            line2.strokeColor = UIColor.red.cgColor
        case UIColor.red.cgColor:
            line2.strokeColor = UIColor.green.cgColor
        case UIColor.green.cgColor:
            line2.strokeColor = UIColor.blue.cgColor
        case UIColor.blue.cgColor:
            line2.strokeColor = UIColor.black.cgColor
        default:
            line2.strokeColor = UIColor.black.cgColor
        }
    }
}
