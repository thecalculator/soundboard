//
//  ViewController.swift
//  Sound Board
//
//  Created by Trilok Behere on 8/4/17.
//  Copyright © 2017 Cool Apps. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var sounds : [Sound] = []
    var audioPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do{
        try audioPlayer = AVAudioPlayer(data: sounds[indexPath.row].audio! as Data)
        }catch{
            print("error in getting audio")
        }
        
        audioPlayer.play()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
        try sounds = context.fetch(Sound.fetchRequest())
        } catch{
            print("error in reading core data")
        }
        
        tableView.reloadData()
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = sounds[indexPath.row].name
        return cell
        
    }


}

