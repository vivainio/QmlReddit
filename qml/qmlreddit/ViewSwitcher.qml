import Qt 4.7

QtObject {
    property Item currentView
    property Item previousView

    property Item root

    property int duration: 700
    property bool running: switchAnimation.running
    property bool direction

    function switchView(newView, leftToRight, extra) {
        if (newView != currentView && !switchAnimation.running) {
            // if the new view has a loadView() function, call it to make sure the view is loaded
            if (newView.loadView != undefined)
                newView.loadView();
            newView.x = leftToRight ? -root.width : root.width
            direction = leftToRight;
            previousView = currentView;
            currentView = newView;
            newView.opacity = 1;            
            switchAnimation.start();
            if (extra == "instant") {
                switchAnimation.complete()
            }

        }
    }

    property variant switchAnimation : 
        SequentialAnimation {
            NumberAnimation { target: previousView; property: "x"; easing.type: Easing.InOutSine
                              to: direction ? root.width : -root.width;  }
            NumberAnimation { target: currentView; property: "x"; easing.type: Easing.InOutSine; to: 0 }


        onRunningChanged:  {
            if (!running && previousView) {
                previousView.opacity = 0;
                if (previousView.deactivationComplete != undefined) previousView.deactivationComplete();
                if (currentView.activationComplete != undefined) currentView.activationComplete();
            }
        }
    }
}
