#import "tuneup/tuneup.js"
#import "Loginsetup.js"
#import "Searchsetup.js"

/*
 Executes login and search function to test if login and searching for experiments work as intended.
 */
test("Test 1", function(target, app) {
     var window = app.mainWindow();
     
     
     login();
     target.delay(0.5);
     search();
                          
     
});