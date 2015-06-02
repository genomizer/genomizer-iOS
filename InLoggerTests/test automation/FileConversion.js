#import "tuneup/tuneup.js"

//Test converting files
test("FileConversion", function(target, app) {
     var window = app.mainWindow();
     
     window.buttons()[1].tap();
     //TODO Search and convert
     window.tableViews()[0].cells()[3].switches()[0].tap();
     
     target.delay(2);
     window.logElementTree();
     window.pickers()["PickerView"].logElementTree();
     
     
     
     });

