#import "tuneup/tuneup.js"

// Test changing server, logging in with no given information and log in.

//Start from login screen
test("LoginTest", function(target, app) {
     var window = app.mainWindow();
     
     UIATarget.onAlert = function onAlert(alert){
     var title = alert.name();
     if (title == "Settings") {
     return true;
     }
     return false; // use default handler
     }
     
     window.buttons()["Setting"].tap();
     target.delay(2);
     //app.alert().scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].setValue("http://bellatrix.cs.umu.se:7005/");
     app.alert().scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].setValue("http://130.239.192.110:7005");
     app.alert().buttons()["Done"].tap();
     
     window.buttons()["Signin"].tap();
     
     
     UIALogger.logMessage( "Select settings" );
     
     window.textFields()["User"].tap();
     target.delay(2);
     app.keyboard().typeString("testuser");
     
     window.secureTextFields()["Pass"].tap();
     app.keyboard().typeString("baguette");
     window.buttons()["Signin"].tap();
     
     });
