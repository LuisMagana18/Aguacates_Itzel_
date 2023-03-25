//
//  ViewController.swift
//  Itzel
//
//  Created by Luis Angel Magaña on 24/03/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tablaFrio: UITableView!
    
    var listaProductosFrio = [Producto]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaFrio.delegate = self
        tablaFrio.dataSource = self
        
        bdFrio()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProductosFrio.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tablaFrio.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            
            let productoFrio = listaProductosFrio[indexPath.row]
            celda.textLabel?.text = productoFrio.tipo
            celda.detailTextLabel?.text = productoFrio.cantidad
            
            return celda
        }

    //Funcion para agregar registro
    @IBAction func nuevoProductoFrio(_ sender: UIBarButtonItem) {
        var tipoProducto = UITextField()
        var cantidadProducto = UITextField()
        
        let alerta = UIAlertController(title: "Nuevo", message: "Producto", preferredStyle: .alert)
        let accionAcept = UIAlertAction(title: "Agregar", style: .default){ _ in
            let nuevoProducto = Producto(context: self.contexto)
            nuevoProducto.tipo = tipoProducto.text
            nuevoProducto.cantidad = cantidadProducto.text
            
            self.listaProductosFrio.append(nuevoProducto)
            
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
        
        self.tablaFrio.reloadData()
    }
    
    //Funcion que obtiene los registros
    func bdFrio(){
        let solicitud : NSFetchRequest<Producto> = Producto.fetchRequest()
        
        do{
            listaProductosFrio = try contexto.fetch(solicitud)
        }catch{
            print(error.localizedDescription )
        }
    }
    
    //Funcion para eliminar registro
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaProductosFrio[indexPath.row ])
            self.listaProductosFrio.remove(at: indexPath.row)
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

