//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by HOANGVU on 1/10/17.
//  Copyright © 2017 HOANGVU. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        
    }

    
}
