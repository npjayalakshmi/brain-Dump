//
//  NoteCell.swift
//  brain Dump
//
//  Created by natarajan k on 02/08/19.
//  Copyright © 2019 natarajan k. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var noteBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
 }

    func populate(with note:Note){
        categoryLabel.text = note.category?.name
        noteBodyLabel.text = note.body
    }

}
