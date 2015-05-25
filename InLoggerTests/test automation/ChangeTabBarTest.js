#import "tuneup/tuneup.js"
#import "Loginsetup.js"

test("Test 1", function(target, app) {
     login();
     target.frontMostApp().mainWindow().buttons()[2].tap();
     target.frontMostApp().mainWindow().buttons()[3].tap();
     target.frontMostApp().windows()[0].buttons()[3].tap();
     target.frontMostApp().mainWindow().buttons()["Logout"].tap();
});