//
//  Pokemon.swift
//  Pokedex
//
//  Created by HOANGVU on 12/28/16.
//  Copyright © 2016 HOANGVU. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _defense: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    
    private var _nextEvoTxt: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    
    private var _pokemonURL: String!
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoTxt: String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
        
    }
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails (completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String,String>], types.count > 0 {
                    
                    if let type = types[0]["name"] {
                        self._type  = "\(type.capitalized)"
                    }
                    
                    var x = 1
                    while x < types.count {
                        if let type = types[x]["name"] {
                            self._type! += "/\(type.capitalized)"
                            x += 1
                        }
                    }
                    
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    //print(newDescription)
                                    self._description = newDescription
                                    
                                }
                            }
                            completed()
                        }
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvoName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] as? Int {
                                    
                                    self._nextEvoLvl = "\(lvlExist)"
                                    
                                } 
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
//                print(self._nextEvoLvl)
//                print(self._nextEvoId)
//                print(self._nextEvoName)
                
            }
         completed()
        }
        
    }
    
    
}
