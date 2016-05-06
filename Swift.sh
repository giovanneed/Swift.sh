#!/bin/sh

#  Script.sh
#  Ponto
#
#  Created by Giovanne Dias on 5/3/16.
#  Copyright © 2016 IDS Tecnologia. All rights reserved.

    
FILE="/path/to/file"


echo $1

typeOfClass="$1"

if [ $typeOfClass == "view" ]; then

/bin/cat <<EOF > $2ViewController.swift

import UIKit

class $2ViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

EOF

fi

if [ $typeOfClass == "table" ]; then

/bin/cat <<EOF > $2ViewController.swift

import UIKit

class $2ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var arrayOfEntities : [Entity] = []
    var arrayOfHeaders : [Entity] = []


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfEntities.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        let entity = arrayOfEntities[indexPath.row] as Entity

        return cell;

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if arrayOfHeaders.count < 1 {
            return 1
        }

        return arrayOfHeaders.count;
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 0
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SegueIdentifier", sender: arrayOfEntities[indexPath.row])

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }


}

class Entity {


}

EOF

fi


if [ $typeOfClass == "webservice" ]; then

/bin/cat <<EOF > $2Webservice.swift

import Foundation


public class Webservice {
    class var sharedInstance: Webservice {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Webservice? = nil
        }

        dispatch_once(&Static.onceToken){
            Static.instance = Webservice()
        }

        return Static.instance!
    }

    func login(username: String, password: String, completionHandler:((error: Bool?,user: User?)->Void)?){

        let request = NSMutableURLRequest(URL:NSURL(string: "http://url.com:1337/api/login?login=" + username + "&password=" + password)!)
        request.HTTPMethod = "GET"

        let session = NSURLSession.sharedSession()
        let task  = session.dataTaskWithRequest(request) { (data, response, error) in
            print(data)

            do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    print(jsonResult)
                    let user = User(model:jsonResult)
                    completionHandler!(error: false, user: user)

            } catch {

                    completionHandler!(error: true, user: nil)
            }

        }

        task.resume()
    }


    func getListParameter(parameter: String!, completionHandler:((error: Bool?,list: Array<Object>?)->Void)?) {

        let formattedParameter = parameter.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)

        let URLString =  "http://url.com:1337/api/list/?parameter=" + parameter
        let URL = NSURL(string: URLString)!

        let request = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "GET"

        let session = NSURLSession.sharedSession()
        let task  = session.dataTaskWithRequest(request) { (data, response, error) in
            print(data)

            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray
                print(jsonResult)

                var listOfObjects : [Object] = []

                for model in jsonResult! {
                    let object = Object(model:model as! NSDictionary)
                    listOfObjects.append(object)
                }

                completionHandler!(error: false, list: listOfObjects)


            } catch {

                completionHandler!(error: true, list: nil)
            }
        }

        task.resume()


    }


    class User {


        var name = String()
        var password = String()
        var login = String()

        init(model: NSDictionary!){

            self.name = model.valueForKeyPath("name") as! String
            self.password = model.valueForKeyPath("password") as! String
            self.login = model.valueForKeyPath("login") as! String
        }

        func description() -> String {
            return "name: " + name
        }
    }

    class Object {


        var name = String()

        init(model: NSDictionary!){

            self.name = model.valueForKeyPath("name") as! String
        }

        func description() -> String {
            return "name: " + name
        }
    }

}

EOF

fi





