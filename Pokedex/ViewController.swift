//
//  ViewController.swift
//  Pokedex
//
//  Created by HOANGVU on 12/27/16.
//  Copyright © 2016 HOANGVU. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITextFieldDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
//    var text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //text.delegate = self
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
//        //cast searchBar as UITextfield
//        let v1 = searchBar.subviews[0]
//        print(v1.subviews.count)
//        
//        //this is UISearchBarTextField
//        let v3 = v1.subviews[1]
//        let tf = v3 as! UITextField
//        tf.delegate = self
//        tf.text = "em khung"
        
//        for v2 in v1.subviews{
//            print(v2)
//            if v2.isKind(of: UITextField.self) {
//                print("we came here")
//                
//                if let tf = v2 as? UITextField{
//                    //self.text = tf
//                    tf.delegate = self
//                    tf.text = "shut up"
//                    print("we came here too")
//                }
//            }
//        }
        
        parsePokemonCSV()
        initAudio()
    }
    
    
    func initAudio () {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "mp3")
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        //searchBar.endEditing(true)
//        //searchBar.resignFirstResponder()
//        searchBar.resignFirstResponder()
//        print("do it")
//        return false
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        test.endEditing(true)
//        return false
//
//    }
    
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            //print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
                
            }
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let pokemon: Pokemon!
            
            if inSearchMode {
                pokemon = filteredPokemon[indexPath.row]
            } else {
                pokemon = self.pokemon[indexPath.row]
            }
            
            cell.configureCell(pokemon)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC"{
            if let detailVC = segue.destination as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailVC.pokemon = poke
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        return pokemon.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        inSearchMode = false
        searchBar.text = ""
        collection.reloadData()
        searchBar.showsCancelButton = false
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            //view.endEditing(true)
            searchBar.resignFirstResponder()
            
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
            
        }
        
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
            
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
}

