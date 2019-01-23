//
//  ConcentrationThemeChooserViewController.swift
//  gameOfSet
//
//  Created by Dylan Smith on 3/25/18.
//  Copyright © 2018 Me. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.gameEmojis = theme.0
                    cvc.gameThemeBackground = theme.1
                    cvc.gameThemeColor = theme.2
                }
            }
        }
    }
    
    /// Sets the themes for the game of concnetration and uses a dictionary to control the seques'
    let themes = [
        "Sickness": ("💩🤢🤮🤬😈🤧🧟‍♀️🧛‍♀️🤥🥥🥡🍵",#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        "Sports": ("🏑🏏🏹🏒🏀🥊🎣🏄‍♂️🤺🎽🏋️‍♂️🤽‍♂️",#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) ,#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        "Travel": ("🏕🏔🎠🏟🗿🏰🗺🛣🌆✈️🗽🎡🎢",#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)) ]
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    private var splitViewDetailConcnetrationViewController : ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    /// This function drives the manual segue from the split view controller to the detail controller.
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcnetrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme.0} }
        else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme.0
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier:"Choose Theme", sender: sender)
        }}
    
}
