//
//  ViewController.swift
//  Cat Facts App
//
//  Created by Chloe Tay on 22/10/26.
//

import UIKit

struct CatFact: Codable {
    var fact: String
    var length: Int
}


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
        button.addAction(UIAction { [weak self] _ in
            self?.getFactTapped()
        }, for: .touchUpInside)
        
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
    
    
    //api networking
    func fetchCatFact() async throws -> CatFact{
        //get url
        let apiURL = URL(string: "https://catfact.ninja/fact")!
        //fetches the data from url
        let (data, _) = try await URLSession.shared.data(from: apiURL)
        //decode raw data into swift
        let catFact = try JSONDecoder().decode(CatFact.self, from: data)
        return catFact
    }
    
    func fetchCatImage() async throws -> UIImage {

        // "?t=..." adds the current time to the URL so every request looks "new". Without it, iOS may reuse the cached (saved) photo and you'd see the same cat every tap.
        let url = URL(string: "https://cataas.com/cat?t=\(Date().timeIntervalSince1970)")!

        let (data, _) = try await URLSession.shared.data(from: url)

        // Turn the bytes into a picture
        // UIImage(data:) returns an optional (the bytes might not be a valid image), so "guard let" means: "if it worked, continue; if not, stop and throw an error".
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        return image
    }
    
    //when button is tapped
    func getFactTapped(){
        Task {
            //show the spinner spinning
            spinner.startAnimating()
            //show grey button so user can't tap it again when loading
            button.isEnabled = false
            // defer means "run this block when we leave this scope" Without it, an error would leave the spinner spinning forever.
            defer {
                spinner.stopAnimating()    // hide the spinner
                button.isEnabled = true    // let the user tap again
            }
            
            // "do/catch" = try this; if anything throws an error, jump to "catch".
            do {
                let catFact = try await fetchCatFact()   // wait for the fact
                factLabel.text = catFact.fact            // show it on screen
                
                let catImage = try await fetchCatImage()
                catImageView.image = catImage
            } catch {
                factLabel.text = "Something went wrong: \(error.localizedDescription)"
            }
        }
    }
    
    

}


#Preview {
    ViewController()
}

