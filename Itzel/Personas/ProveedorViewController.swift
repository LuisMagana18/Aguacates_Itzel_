//
//  ProveedorViewController.swift
//  Itzel
//
//  Created by Luis Angel Magaña on 25/03/23.
//

import UIKit
import CoreData

class ProveedorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tablaProveedores: UITableView!
    
    var listaProveedores = [Proveedor]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaProveedores.delegate = self
        tablaProveedores.dataSource = self
        
        bdProveedores()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProveedores.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tablaProveedores.dequeueReusableCell(withIdentifier: "celdaProveedor", for: indexPath)
            
            let proveedor = listaProveedores[indexPath.row]
            celda.textLabel?.text = proveedor.nombre
            celda.detailTextLabel?.text = proveedor.ubicacion
            
            return celda
        }
    
    //Funcion que guarda registro
    func guardar(){
        do{
            try contexto.save()
        }catch{
            print(error.localizedDescription)
        }
        
        self.tablaProveedores.reloadData()
    }
    
    //Funcion para agregar registro
    @IBAction func nuevoProveedor(_ sender: UIBarButtonItem) {
        var nombreProveedor = UITextField()
        var ubicacionProveedor = UITextField()
        
        let alerta = UIAlertController(title: "Nuevo", message: "Proveedor", preferredStyle: .alert)
        let accionAcept = UIAlertAction(title: "Agregar", style: .default){ _ in
            let nuevoProveedor = Proveedor(context: self.contexto)
            nuevoProveedor.nombre = nombreProveedor.text
            nuevoProveedor.ubicacion = ubicacionProveedor.text
            
            self.listaProveedores.append(nuevoProveedor)
            
            self.guardar()
        }
        alerta.addTextField{ textFieldNombre in
            textFieldNombre.placeholder = "Ingresar nombre del Proveedor"
            nombreProveedor = textFieldNombre
        }
        alerta.addTextField{ textFieldUbicacion in
            textFieldUbicacion.placeholder = "Ingresar ubicacion del Proveedor"
            ubicacionProveedor = textFieldUbicacion
        }
        alerta.addAction(accionAcept)
        present(alerta, animated: true)
    }
    
    //Funcion que obtiene los registros
    func bdProveedores(){
        let solicitud : NSFetchRequest<Proveedor> = Proveedor.fetchRequest()
        
        do{
            listaProveedores = try contexto.fetch(solicitud)
        }catch{
            print(error.localizedDescription )
        }
    }
    
    //Funcion para eliminar registro
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaProveedores[indexPath.row ])
            self.listaProveedores.remove(at: indexPath.row)
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
