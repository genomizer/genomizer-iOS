function login() {
var target = UIATarget.localTarget();

UIATarget.onAlert = function onAlert(alert){
    var title = alert.name();
    if (title = "Settings") {
        return true;
    }
    return false; // use default handler
}

target.frontMostApp().mainWindow().buttons()["Setting"].tap();
target.frontMostApp().alert().scrollViews()[0].tableViews()[0].cells()[0].textFields()[0].setValue("dummyserver/");
target.frontMostApp().alert().buttons()["Done"].tap();
target.frontMostApp().mainWindow().textFields()["User"].setValue("Test");
target.frontMostApp().mainWindow().secureTextFields()["Pass"].setValue("Test");
target.frontMostApp().mainWindow().buttons()["Signin"].tap();

}