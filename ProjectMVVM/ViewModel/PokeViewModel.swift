//
//  PokeViewModel.swift
//  ProjectMVVM
//
//  Created by Linder Anderson Hassinger Solano    on 22/04/22.
//

import Foundation

class PokeViewModel {
    
    let URL_API = "https://pokeapi.co/api/v2/pokemon?limit=100"
    
    var pokemons = [Result]()
    
    func getDataFromAPI() async {
        // vamos a convertir este string a un url
        guard let url = URL(string: URL_API) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decoder = try? JSONDecoder().decode(Pokemon.self, from: data) {
                // como esta data es async si yo hago esto en el primero intento va a esta vacio
                // podeomos crear un Dispatch async para poder ejecutar este forEach
                DispatchQueue.main.async(execute: {
                    decoder.results.forEach { pokemon in
                        // Nota: Recuerden que esto esta añadiendo cada pokemon al array
                        // llamado pokemons
                        self.pokemons.append(pokemon)
                    }
                })
            }
        } catch {
            print("Ivalid error")
        }
        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                // si nos aseguramos que la data existe vamos a imprimirla
//                // ojo: Recuereden que data es un parametro que estamos recibiendo
//                // de la peticion que hemos hecho al API
//                let decode = String(data: data, encoding: .utf8)
//                print(decode!)
//            }
//        }.resume()
    }
    
}
