//
//  CrujiaViewController.swift
//  Itzel
//
//  Created by Luis Angel Magaña on 25/03/23.
//

import UIKit
import CoreData

class CrujiaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tablaCrujia: UITableView!
    var listaProductosCrujia = [ProductoCrujia]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaCrujia.delegate = self
        tablaCrujia.dataSource = self
        bdCrujia()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProductosCrujia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaCrujia.dequeueReusableCell(withIdentifier: "celdaCrujia", for: indexPath)
        
        let productoCrujia = listaProductosCrujia[indexPath.row]
        celda.textLabel?.text = productoCrujia.tipo
        celda.detailTextLabel?.text = productoCrujia.cantidad
        
        return celda
    }
    
    //Funcion para agregar registro
    @IBAction func nuevoProductoCrujia(_ sender: UIBarButtonItem) {
        var tipoProducto = UITextField()
        var cantidadProducto = UITextField()
        
        let alerta = UIAlertController(title: "Nuevo", message: "Producto", preferredStyle: .alert)
        let accionAcept = UIAlertAction(title: "Agregar", style: .default){ _ in
            let nuevoProducto = ProductoCrujia(context: self.contexto)
            nuevoProducto.tipo = tipoProducto.text
            nuevoProducto.cantidad = cantidadProducto.text
            
            self.listaProductosCrujia.append(nuevoProducto)
            
            self.guardar()
        }
        alerta.addTextField{ textFieldTipo in
            textFieldTipo.placeholder = "¿Qué producto es?"
            tipoProducto = textFieldTipo
        }
        alerta.addTextField{ textFieldCantidad in
            textFieldCantidad.placeholder = "¿Cuantos son"
            cantidadProducto = textFieldCantidad
        }
        alerta.addAction(accionAcept)
        present(alerta, animated: true)
    }
    
    //Funcion que guarda registro
    func guardar(){
        do{
            try contexto.save()
        }catch{
            print(error.localizedDescription)
        }
        
        self.tablaCrujia.reloadData()
    }
    
    //Funcion que obtiene los registros
    func bdCrujia(){
        let solicitud : NSFetchRequest<ProductoCrujia> = ProductoCrujia.fetchRequest()
        
        do{
            listaProductosCrujia = try contexto.fetch(solicitud)
        }catch{
            print(error.localizedDescription )
        }
    }
    
    //Funcion para eliminar registro
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaProductosCrujia[indexPath.row ])
            self.listaProductosCrujia.remove(at: indexPath.row)
            self.guardar()
        }
        eliminar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [eliminar])
    }
    
    //Funcion cancelar registro
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
