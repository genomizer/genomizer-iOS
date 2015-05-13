#import "tuneup/tuneup.js"

// Test if settings will show.
test("Test 1", function(target, app) {
     var window = app.mainWindow();
     var url = "http://dumbledore.cs.umu.se:7000/";
     var didShowAlert = false;
     UIALogger.logDebug("Now setting up the alert function");
     
     UIATarget.onAlert = function onAlert(alert){
        var title = alert.name();
        //UIALogger.logWarning("Alert with title ’" + title + "’ encountered!");
        if (title == "Settings") {
            return true;
        }
            return false; // use default handler
        }
     
     app.logElementTree();
     UIALogger.logMessage( "Select settings" );
     window.buttons()["Setting"].tap();
     target.delay(2);
     //app.keyboard().keys()["Delete"].touchAndHold(3.6);
     //app.keyboard().typeString("test");
     app.alert().textFields()[0].setValue("Test");
     app.alert().buttons()["Done"].tap();
     
     window.buttons()["Setting"].tap();
     assertTrue(didShowAlert);
});
