
import UIKit
import UserNotifications//module for scheduling notifications
class ViewController: UIViewController {
    
    @IBOutlet var table:UITableView!
    
    var models:[MyReminder]{
        get
        {
            guard let data=UserDefaults.standard.data(forKey: "reminders"),let reminders = try? JSONDecoder().decode([MyReminder].self, from: data) else
            {
                return []
            }
            return reminders
        }
        set
        {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
                    UserDefaults.standard.setValue(data, forKey: "reminders")
                }
        }//list of reminders the user creates. It is of type struct that is created in line 60.
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate=self //always set the delegate and datasource for the tableview object after providing the extensions.
        table.dataSource=self
    }
    @IBAction func didTapAdd()
    {
        guard let vc=storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else
        {
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion={title,body,date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new=MyReminder(title:title,date:date,identifier:"id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                let content=UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching:Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate) , repeats: false)
                
                let request = UNNotificationRequest(identifier: "someId", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request,withCompletionHandler: {error in
                    if error != nil
                    {
                        print("Something went wrong.")
                    }
                })
                
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func didTapTest()
    {
        //instantiating notification and setting what the notifications are allowed to do.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound],completionHandler: {success,error in
            if success
            {
                self.scheduleTest()
            }
            else if let error=error
            {
                print("error occurred:\(error)")
            }
        })
    }
    
    func scheduleTest()
    {
        let content=UNMutableNotificationContent()
        content.title = "Hello world"
        content.sound = .default
        content.body = "My long body. My long body"
        
        let targetDate = Date()
        let trigger = UNCalendarNotificationTrigger(dateMatching:Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate) , repeats: false)
        
        let request = UNNotificationRequest(identifier: "someId", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request,withCompletionHandler: {error in
            if error != nil
            {
                print("Something went wrong.")
            }
        })
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //setting number of cells for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    //setting what the cell should represent. Here it represents the reminders set by the user.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        
        let format=DateFormatter()
        format.dateFormat="MMM, dd, YYYY"
        cell.detailTextLabel?.text = format.string(from: date)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.00
    }
    
    
}

struct MyReminder:Codable
{
    let title:String
    let date:Date
    let identifier:String
}

