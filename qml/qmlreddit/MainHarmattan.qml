import QtQuick 1.1
import com.meego 1.0

PageStackWindow {

    Page {
	id: mainpage

	function setOrientation(or) {
	    if (or == "landscape") {
		orientationLock = PageOrientation.LockLandscape

	    } else {
		orientationLock = PageOrientation.Automatic
	    }

	}

	//Component.onCompleted: console.log("Using Harmattan components")
	MainRect {}

    }
    initialPage: mainpage

}

