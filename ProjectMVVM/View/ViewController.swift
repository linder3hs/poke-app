//
//  ViewController.swift
//  ProjectMVVM
//
//  Created by Linder Anderson Hassinger Solano    on 22/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let pokeViewModel: PokeViewModel = PokeViewModel()
    
    // Creamos un array del filtro
    var filterData: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // para poder usar una funcion async dentro de nuestro viewDidLoad
        // vamos a a usar a la clase Task
        // recueden que una buena paractica es crear microfunciones que separen
        // el trabajo que se haga en el viewDidLoad
        Task {
            await setUpData()
        }
        setUpView()
    }
    
    func setUpView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragInteractionEnabled = true
        searchBar.delegate = self
    }
    
    func setUpData() async {
        await pokeViewModel.getDataFromAPI()
        filterData = pokeViewModel.pokemons
        // Nota: Siempre despues de traer la informacion de mi API debemos hacer que la tabla
        // se refresque
        tableView.reloadData()
    }
    
}

// creamos un extension de ViewController
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // La primera retorna el numero de filas, ojo puede identificarla porque retorna siempre un entero
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    // La que retorna la celda es decir aca vamos a setear el textos y/o imgenes de nuestra celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Nota: Este identifier es el que definimos en la vista, recuerden que el texto debe ser el mismo
        // en este caso lo llamos cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        // Nota: La forma en la cual vamos a saber la posicion de la celda es con el indexPath.row nos
        // va a retorn la posicion actual de la celda
        cell.textLabel?.text = filterData[indexPath.row].name.capitalized
        // Nota: Recuerden que setImage retorna un objeto de tipo imagen por eso podemos igualar el imageView.image al helper
        cell.imageView?.image = HelperImage.setImage(id: HelperString.getIdFromUrl(url: filterData[indexPath.row].url))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(HelperString.getIdFromUrl(url: pokeViewModel.pokemons[indexPath.row].url))
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(pokeViewModel.pokemons[sourceIndexPath.row].name)
    }
}

// Extension para SearchBar
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = searchText.isEmpty
        ? pokeViewModel.pokemons
        : pokeViewModel.pokemons.filter({ (item: Result) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        // para que despues de la busqueda la table se reinicie
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
