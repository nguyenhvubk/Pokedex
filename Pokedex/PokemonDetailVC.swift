//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by HOANGVU on 1/10/17.
//  Copyright © 2017 HOANGVU. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetails {
            //whatever we write will only be called after the network call is complete!
            //print("came here")
            self.updateUI()
        }
        
    }

    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvoId == "" {
            evoLbl.text = "No evolution"
            nextEvoImg.isHidden = true
        }else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            let str = "Next Evolution: \(pokemon.nextEvoName) - LVL \(pokemon.nextEvoLvl)"
            evoLbl.text = str
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
