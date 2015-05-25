#import "Loginsetup.js"

function search() {
    var target = UIATarget.localTarget();
    login();
    target.frontMostApp().mainWindow().tableViews()[0].cells()["Experiment"].textFields()["Experiment"].textFields()["Experiment"].tap();
    target.frontMostApp().windows()[1].pickers()[0].wheels()[0].tapWithOptions({tapOffset:{x:0.47, y:0.39}});
    target.frontMostApp().windows()[1].toolbar().buttons()["Done"].tap();
    target.frontMostApp().mainWindow().buttons()["Search"].tap();
    
    
}


