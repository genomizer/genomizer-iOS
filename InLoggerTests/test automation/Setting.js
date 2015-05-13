#import "tuneup/tuneup.js"

// Test if settings will show.
test("Test 1", function(target, app) {
     var window = app.mainWindow();
     var didChangeUrl = false;
     UIALogger.logDebug("Now setting up the alert function");

     UIATarget.onAlert = function onAlert(alert){
        var title = alert.name();
        alert.logElementTree();
        var url = alert.scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].value();
     if (title = "Settings") {
        if (url == "Test1/") {
            didChangeUrl = true;
        }
        return true;
     }
            return false; // use default handler
        }
     
     app.logElementTree();
     UIALogger.logMessage( "Select settings" );
     window.buttons()["Setting"].tap();
     target.delay(2);
     
     app.alert().scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].setValue("Test1/");
     app.alert().buttons()["Done"].tap();
     
     window.buttons()["Setting"].tap();
     target.delay(2);
     app.alert().buttons()["Done"].tap();
     assertTrue(didChangeUrl);
});

test("Test 2", function(target, app) {
     var window = app.mainWindow();
     var didChangeUrl = false;
     UIALogger.logDebug("Now setting up the alert function");
     
     UIATarget.onAlert = function onAlert(alert){
     var title = alert.name();
     alert.logElementTree();
     var url = alert.scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].value();
     if (title = "Settings") {
     if (url == "Test1/") {
     didChangeUrl = true;
     }
     return true;
     }
     return false; // use default handler
     }
     
     app.logElementTree();
     UIALogger.logMessage( "Select settings" );
     window.buttons()["Setting"].tap();
     target.delay(2);
     
     app.alert().scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].setValue("");
     app.alert().buttons()["Cancel"].tap();
     
     window.buttons()["Setting"].tap();
     target.delay(2);
     app.alert().buttons()["Done"].tap();
     assertTrue(didChangeUrl);
});


