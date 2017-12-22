import UIKit

class ViewController: UIViewController {
    
    let subjectPickerView = SubjectPickerView()
    var height: CGFloat = 0.0
    var toggled: Bool = true
    let constraintName = "PickerBottomConst"
    
    @IBAction func selectSubject(_ sender: Any) {
        toggled = !toggled
        UIView.animate(withDuration: 0.3) {
            if self.toggled {
                print("hided")
                self.updateConstraint(identifier: self.constraintName, constantValue: self.height)
            } else{
                print("opened")
                self.updateConstraint(identifier: self.constraintName, constantValue: 0)
            }
        }
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func updateConstraint(identifier: String, constantValue: CGFloat){
        for constraint in self.view.constraints {
            if constraint.identifier == identifier {
                constraint.constant = constantValue
            }
        }
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = subjectPickerView
        pickerView.dataSource = subjectPickerView
        subjectPickerView.dataModel = Data.getData()
        height = pickerView.bounds.height
        updateConstraint(identifier: self.constraintName, constantValue: height)
        
    }
    
}

class SubjectPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var dataModel = [Model]()
    var customHeight: CGFloat = 100
    var customWidth: CGFloat = 1.0
    var selected: Model?
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataModel.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = dataModel[row]
        print("Model Selected: \(dataModel[row].name)")
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return customHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        customWidth = UIScreen.main.bounds.width
        
        let view = UIView(frame: CGRect(x:0, y:0, width: customWidth, height: customHeight))
        view.isUserInteractionEnabled = true
        
        view.backgroundColor = UIColor.blue
        
        let label = UILabel(frame: CGRect(x:40, y:30, width: customWidth-55, height: 40))
        label.textColor = UIColor.white
        label.text = dataModel[row].name
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 20.0)
        view.addSubview(label)
        
        // here is the problem; this is not working!
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("tapped")))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func tapped(_ sender: UITapGestureRecognizer) {
        print("please help!")
    }

}


class Model {
    var name = ""
    init(name: String){
        self.name = name
    }
}

class Data {
    class func getData() -> [Model]{
        var data = [Model]()
        data.append(Model(name: "Swift 4.0"))
        data.append(Model(name: "Swift 3.2"))
        data.append(Model(name: "Swift 2.0"))
        data.append(Model(name: "Swift 1.0"))
        return data
    }
}

