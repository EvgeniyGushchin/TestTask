//
//  CurrencyCell.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//  Copyright © 2018 Evgeniy Gushchin. All rights reserved.
//

import UIKit
import RxSwift

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyAmountField: UITextField!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        currencyAmountField.keyboardType = .decimalPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

}
