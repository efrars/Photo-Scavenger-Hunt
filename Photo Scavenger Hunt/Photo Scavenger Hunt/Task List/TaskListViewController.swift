//
//  TaskListViewController.swift
//  Photo Scavenger Hunt
//
//  Created by Efrain Rodriguez on 2/16/23.
//

import UIKit

class TaskListViewController: UIViewController {
    
 
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        
        tableView.tableHeaderView = UIView()
        
        tableView.dataSource = self
        
        tasks = Task.mockedTasks
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Will reload data in order to reflect any changes made to a task after returning from the detail screen.
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "DetailSegue" {
            if let detailViewController = segue.destination as?
                TaskDetailViewController,
               
                let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                let task = tasks[selectedIndexPath.row]
                
                detailViewController.task = task
            }
        }
    }

}

extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            fatalError("Unable to dequeue Task Cell")
        }
        
        cell.configure(with: tasks[indexPath.row])
        
        return cell
    }
}
