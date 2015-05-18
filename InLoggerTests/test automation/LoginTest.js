#import "tuneup/tuneup.js"

// Test if settings will show.
test("Test 1", function(target, app) {
     var window = app.mainWindow();
     var didShowAlert = false;
     UIALogger.logDebug("Now setting up the alert function");
     
     UIATarget.onAlert = function onAlert(alert){
     var title = alert.name();
     if (title == "Settings") {
     return true;
     }
     return false; // use default handler
     }
     
     window.buttons()["Setting"].tap();
     target.delay(2);
     app.alert().scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].setValue("http://bellatrix.cs.umu.se:7005/");
     app.alert().buttons()["Done"].tap();
     
     window.buttons()["Signin"].tap();
     
     
     UIALogger.logMessage( "Select settings" );
     
     window.textFields()["User"].tap();
     target.delay(2);
     app.keyboard().typeString("testuser");
     
     window.secureTextFields()["Pass"].tap();
     app.keyboard().typeString("baguette");
     window.buttons()["Signin"].tap();
     
     window.buttons()["Star tabbar"].tap();
     target.delay(0.005);
     window.buttons()["Search"].tap();
     window.buttons()["Process"].tap();
     window.buttons()["Settings"].tap();
     target.delay(2);
     app.logElementTree();
     window.buttons()["Logout"].tap();
     
     });
