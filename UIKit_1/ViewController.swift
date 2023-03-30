//
//  ViewController.swift
//  UIKit_1
//
//  Created by Francesco Vezzuto on 29/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    let myView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var animationButton: UIButton!
    var isAnimating = false
    var gestureRecognizer: UITapGestureRecognizer!
    var spoilerButton: UIButton!
    var comingSoonLabel: UILabel!
    var imageApp: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let myViewController = ViewController()
//
//        let navigationController = UINavigationController(rootViewController: myViewController )
//
//        addChild(navigationController)
//        view.addSubview(navigationController.view)
//        navigationController.didMove(toParent: self)
        
        myView.backgroundColor = .gray
        myView.center = view.center
        view.addSubview(myView)
        
        animationButton = UIButton(frame: CGRect(x: (view.frame.size.width-200)/2, y: view.frame.size.height - 180, width: 200, height: 60))
        animationButton.backgroundColor = .blue
        animationButton.layer.cornerRadius = 20
        animationButton.layer.shadowColor = UIColor.gray.cgColor
        animationButton.layer.shadowOpacity = 0.7
        animationButton.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        animationButton.layer.shadowRadius = 4
        animationButton.setTitle("Start Animation", for: .normal)
        animationButton.setTitleColor(.white, for: .normal)
        animationButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        animationButton.addTarget(self, action: #selector(animationButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(animationButton)
        
        spoilerButton = UIButton(frame: CGRect(x: (view.frame.size.width-60)/2, y: view.frame.size.height - 100, width: 60, height: 60))
        spoilerButton.backgroundColor = .clear
        spoilerButton.setTitle("?", for: .normal)
        spoilerButton.setTitleColor(.blue, for: .normal)
        spoilerButton.addTarget(self, action: #selector(spoilerButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(spoilerButton)
        
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        myView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func animationButtonTapped(_ sender: UIButton) {
        if isAnimating {
            stopAnimation()
        } else {
            startAnimation()
        }
    }
    
    func startAnimation() {
        isAnimating = true
        animationButton.setTitle("Stop Animation", for: .normal)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.myView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
            self.myView.center = self.view.center
        }, completion: nil)
    }
    
    func stopAnimation() {
        isAnimating = false
        myView.layer.removeAllAnimations()
        animationButton.setTitle("Start Animation", for: .normal)
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        newView.backgroundColor = .red
        newView.center = sender.location(in: myView)
        myView.addSubview(newView)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            newView.transform = CGAffineTransform(scaleX: 2, y: 2)
            newView.alpha = 0
        }, completion: { _ in
            newView.removeFromSuperview()
        })
    }
    @objc func spoilerButtonTapped(_ sender: UIButton) {
        myView.layer.removeAllAnimations()
        
        comingSoonLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        comingSoonLabel.textAlignment = .center
        comingSoonLabel.font = UIFont.boldSystemFont(ofSize: 20)
        comingSoonLabel.textColor = .red
        comingSoonLabel.text = """
        Something will be coming Soon!
        """
        view.addSubview(comingSoonLabel)
        comingSoonLabel.alpha = 0.01 // Impostiamo l'opacità iniziale a 0.1
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.myView.alpha = 0
            self.animationButton.alpha = 0
            self.spoilerButton.alpha = 0
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIView.animate(withDuration: 1.15, delay: 1, options: [], animations: {
                    self.comingSoonLabel.alpha = 0.90 // Aumentiamo gradualmente l'opacità
                }, completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) { // Aspettiamo un altro secondo prima di far partire l'animazione dei quadrati
                        self.explodeLabel(self.comingSoonLabel)
                    }
                })
            }
        })
    }

    func explodeLabel(_ label: UILabel) {
        label.alpha = 1
        label.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        // Crea le particelle della nostra animazione
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: label.bounds.midX, y: label.bounds.midY)
        emitter.emitterShape = .rectangle
        emitter.emitterSize = label.bounds.size
        
        let gray = makeEmitterCell(color: .gray)
        let red = makeEmitterCell(color: .red)
        
        emitter.emitterCells = [gray, red]
        label.layer.addSublayer(emitter)
        
        // Anima la transizione dell'etichetta alla fine dell'esplosione
        //3, 3 pwe immagine
        UIView.animate(withDuration: 6, delay: 1, options: [], animations: {
            label.alpha = 0
            label.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
            emitter.setValue(0, forKeyPath: "emitterCells.gray.birthRate")
            emitter.setValue(0, forKeyPath: "emitterCells.red.birthRate")
            emitter.setValue(0, forKeyPath: "emitterCells.blue.birthRate")
            emitter.setValue(0, forKeyPath: "emitterCells.green.birthRate")
            emitter.setValue(0, forKeyPath: "emitterCells.yellow.birthRate")
        }, completion: { _ in
            emitter.removeFromSuperlayer()
            label.removeFromSuperview()
            
            let imageView = UIImageView(image: UIImage(named: "Watch"))
            imageView.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
            imageView.center = CGPoint(x: self.view.center.x + 30, y: self.view.center.y + 20)
            imageView.alpha = 0.0 // Set the initial alpha value of the image view to 0
            self.view.addSubview(imageView)

            let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY + 20, width: self.view.frame.width, height: 35))
            label.text = "Stay Tuned ;)"
            label.textColor = .red
            label.alpha = 0.0 // Set the initial alpha value of the label to 0
            label.font = UIFont.boldSystemFont(ofSize: 35)
            label.textAlignment = .center
            self.view.addSubview(label)

            UIView.animate(withDuration: 1.25, delay: 0.45, options: [.curveEaseInOut], animations: {
                imageView.alpha = 1.0 // Set the final alpha value of the image view to 1
                label.alpha = 0.90 // Set the final alpha value of the label to 1
            })
        }
        
    )}


    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7
        cell.color = color.cgColor
        cell.velocity = 40
        cell.velocityRange = 15
        cell.emissionLongitude = .pi * 2
        cell.emissionRange = .pi
        cell.spin = 1.5
        cell.spinRange = 2.5
        
    
            var imageForCell: UIImage?
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
            imageForCell = renderer.image { ctx in
                ctx.cgContext.setFillColor(color.cgColor)
                ctx.cgContext.fill(CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
            }
    
            cell.contents = imageForCell?.cgImage
    
            return cell
        }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//    }
    }
