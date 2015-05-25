/*
This function does the searching sequence from the search view. The sequence consists of;
Selecting Human as species in pickerview and press done, and press search.
 
 IMPORTANT: The Search view must be loaded before running this function.
*/

function search() {
    var target = UIATarget.localTarget();
    target.delay(0.1);
    target.frontMostApp().mainWindow().tableViews()[0].cells()["Experiment"].tap();
    target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.40, y:0.86}});
    target.frontMostApp().mainWindow().tableViews()[0].cells()["Experiment"].textFields()["Experiment"].textFields()["Experiment"].tap();
    target.frontMostApp().windows()[1].pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.41, y:0.56}});
    target.delay(0.4);
    target.frontMostApp().windows()[1].toolbar().buttons()["Done"].tap();
    target.frontMostApp().mainWindow().buttons()["Search"].tap();
}

