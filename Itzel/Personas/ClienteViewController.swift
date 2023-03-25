//
//  ClienteViewController.swift
//  Itzel
//
//  Created by Luis Angel Magaña on 25/03/23.
//

import UIKit
import CoreData

class ClienteViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tablaClientes: UITableView!
    
    var listaClientes = [Cliente]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaClientes.delegate = self
        tablaClientes.dataSource = self
        
        bdClientes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaClientes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tablaClientes.dequeueReusableCell(withIdentifier: "celdaCliente", for: indexPath)
            
            let cliente = listaClientes[indexPath.row]
            celda.textLabel?.text = cliente.nombre
            celda.detailTextLabel?.text = cliente.ubicacion
            
            return celda
        }
    
    //Funcion que guarda registro
    func guardar(){
        do{
            try contexto.save()
        }catch{
            print(error.localizedDescription)
        }
        
        self.tablaClientes.reloadData()
    }
    
    //Funcion para agregar registro
    @IBAction func nuevoCliente(_ sender: UIBarButtonItem) {
        var nombreCliente = UITextField()
        var ubicacionCliente = UITextField()
        
        let alerta = UIAlertController(title: "Nuevo", message: "Cliente", preferredStyle: .alert)
        let accionAcept = UIAlertAction(title: "Agregar", style: .default){ _ in
            let nuevoCliente = Cliente(context: self.contexto)
            nuevoCliente.nombre = nombreCliente.text
            nuevoCliente.ubicacion = ubicacionCliente.text
            
            self.listaClientes.append(nuevoCliente)
            
            self.guardar()
        }
        alerta.addTextField{ textFieldNombre in
            textFieldNombre.placeholder = "Ingresar nombre del Cliente"
            nombreCliente = textFieldNombre
        }
        alerta.addTextField{ textFieldUbicacion in
            textFieldUbicacion.placeholder = "Ingresar ubicacion del cliente"
            ubicacionCliente = textFieldUbicacion
        }
        alerta.addAction(accionAcept)
        present(alerta, animated: true)
        
    }
    
    //Funcion que obtiene los registros
    func bdClientes(){
        let solicitud : NSFetchRequest<Cliente> = Cliente.fetchRequest()
        
        do{
            listaClientes = try contexto.fetch(solicitud)
        }catch{
            print(error.localizedDescription )
        }
    }
    
    //Funcion para eliminar registro
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminar = UIContextualAction(style: .normal, title: "Eliminar") { _, _, _ in
            self.contexto.delete(self.listaClientes[indexPath.row ])
            self.listaClientes.remove(at: indexPath.row)
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
