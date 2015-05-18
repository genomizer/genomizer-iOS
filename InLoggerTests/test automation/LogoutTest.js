#import "tuneup/tuneup.js"

//Test switching to the settings tab and logging out.
test("LogoutTest", function(target, app) {
     var window = app.mainWindow();
     //window.logElementTree();
     window.buttons()[4].tap();
     app.logElementTree();
     window.buttons()["Logout"].tap();
     
     });