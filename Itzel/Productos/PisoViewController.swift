//
//  PisoViewController.swift
//  Itzel
//
//  Created by Luis Angel Magaña on 25/03/23.
//

import UIKit
import CoreData

class PisoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tablaPiso: UITableView!
        
    
    var listaProductosPiso = [ProductoPiso]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPiso.delegate = self
        tablaPiso.dataSource = self
        bdPiso()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProductosPiso.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tablaPiso.dequeueReusableCell(withIdentifier: "celdaPiso", for: indexPath)
            
            let productoPiso = listaProductosPiso[indexPath.row]
            celda.textLabel?.text = productoPiso.tipo
            celda.detailTextLabel?.text = productoPiso.cantidad
            
            return celda
        }
    
    //Funcion para agregar registro
    @IBAction func nuevoProductoPiso(_ sender: UIBarButtonItem) {
        var tipoProducto = UITextField()
        var cantidadProducto = UITextField()
        
        let alerta = UIAlertController(title: "Nuevo", message: "Producto", preferredStyle: .alert)
        let accionAcept = UIAlertAction(title: "Agregar", style: .default){ _ in
            let nuevoProducto = ProductoPiso(context: self.contexto)
            nuevoProducto.tipo = tipoProducto.text
            nuevoProducto.cantidad = cantidadProducto.text
            
            self.listaProductosPiso.append(nuevoProducto)
            
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
        
        self.tablaPiso.reloadData()
    }
    
    //Funcion que obtiene los registros
    func bdPiso(){
        let solicitud : NSFetchRequest<ProductoPiso> = ProductoPiso.fetchRequest()
        
        do{
            listaProductosPiso = try contexto.fetch(solicitud)
        }catch{
            print(error.localizedDescription )
        }
    }
    
    //Funcion para eliminar registro
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaProductosPiso[indexPath.row ])
            self.listaProductosPiso.remove(at: indexPath.row)
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
