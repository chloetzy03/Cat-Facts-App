//
//  ViewController.swift
//  Cat Facts App
//
//  Created by Chloe Tay on 22/10/26.
//

import UIKit

class ViewController: UIViewController {

    let button = UIButton(type: .system) //the "get fact" button
    let factLabel = UILabel() //shows the cat fact text
    let catImageView = UIImageView() //shows the cat photo
    let spinner = UIActivityIndicatorView(style: .medium) //loading spinner
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    
    private func setupUI(){
        // label
        factLabel.text = "Tap the button to get a cat fact"
        factLabel.numberOfLines = 0
        factLabel.textAlignment = .center
        factLabel.font = .preferredFont(forTextStyle: .headline)
        
        // cat image
        catImageView.contentMode = .scaleAspectFit
        catImageView.clipsToBounds = true     //don't let the image draw outside its box
        catImageView.backgroundColor = .secondarySystemBackground
        
        // button
        var config = UIButton.Configuration.filled()
        config.title = "Get Cat Fact"
        button.configuration = config
        
        // spinner
        spinner.hidesWhenStopped = true      //invisible whenever it isn't spinning
        
        //stack view
        //add subviews
        let stack = UIStackView(arrangedSubviews: [catImageView, factLabel, button, spinner])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            catImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

}


#Preview {
    ViewController()
}

