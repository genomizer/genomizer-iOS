#import "tuneup/tuneup.js"
#import "Loginsetup.js"
#import "Searchsetup.js"

// Test select file.
test("Test 1", function(target, app) {
     login();
     target.delay(0.1);
     search();
     target.frontMostApp().mainWindow().tableViews()[0].cells()[" "].tap();
     target.delay(1);
     target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.89, y:0.11}});
     target.frontMostApp().mainWindow().buttons()[3].tap();
     target.frontMostApp().logElementTree();
     var file = target.frontMostApp().mainWindow().tableViews()[0].cells()[0].name();
     assertEquals("Dummy file", file);
     });