//
//  SelectionViewController.swift
//  Overwatch
//
//  Created by Benjamin Su on 10/21/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    
    @IBOutlet weak var stackViewWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var game: Game = Game()
    
    var heroType: HeroType! {
        didSet {
            game.heroType = heroType
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        heroType = HeroType.offense
        updateStackViewWithHeroes()
        let heroes = game.heroesForType()
        nameLabel.text = heroes[0].name.description
    }

    @IBAction func changeInHeroType(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            heroType = HeroType.offense
        case 1:
            heroType = HeroType.defense
        case 2:
            heroType = HeroType.tank
        case 3:
            heroType = HeroType.support
        default:
            heroType = HeroType.offense
        }
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        updateStackViewWithHeroes()
        animateNameLabel(index: 0)
    }
    
    func updateStackViewWithHeroes() {
        
        let heroArray = game.heroesForType()
        
        stackViewWidthContraint.isActive = false
        stackViewWidthContraint = stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(heroArray.count))
        stackViewWidthContraint.isActive = true
        self.view.layoutIfNeeded()
        
        createImageViews(heroes: heroArray)
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        stackView.reloadInputViews()
    }
    
    func createImageViews(heroes: [Hero]) {
        
        for num in 0..<heroes.count {
            let imageView = UIImageView(frame: stackView.frame)
            imageView.image = heroes[num].produceprofileImage()
            stackView.addArrangedSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.center.x = scrollView.center.x + (scrollView.frame.width * CGFloat(num))
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        let index = Int((scrollView.contentOffset.x + CGFloat(1)) / scrollView.frame.width)
        
        animateNameLabel(index: index)
    }
    
    func animateNameLabel(index: Int) {
        let heroes = game.heroesForType()
    
        UIView.animate(withDuration: 0.2, animations: {
            self.nameLabel.alpha = 0.0
            }) { (finished) in
                self.nameLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                self.nameLabel.text = heroes[index].name.description
                UIView.animateKeyframes(withDuration: 0.4, delay: 0.4, options: [.calculationModeCubic], animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6, animations: {
                        self.nameLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.nameLabel.alpha = 1.0
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                        self.nameLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                        self.nameLabel.transform = CGAffineTransform.identity
                    })
                    
                    }, completion: nil)
                
        }
        
        
        
        
        
        
    }
    
}


extension SelectionViewController: UIScrollViewDelegate { }





















