/*
** Copyright (C) 2011 Jyrki Yli-Nokari
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** The code below is for example only and subject to change without notice
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
*/


import Qt 4.7
//import "log.js" as Log
import "storage.js" as Js

/*
  Usage:

  import "myjavascript.js" as MyJS

  Storage {
    id: db
    writeOnExit: true
    readOnInit: true
    property int a: 15
    property string b: "hello"
    property ListModel c: ListModel {}
    onInit: {
        add("myobject", MyJS.myobject);
    }
  }

 */
QtObject {
    id: store
    signal init();  // Signaled before the automatic load - typically ised for Aadd()ing members to database
    signal loaded(bool isDataAvailable); // Signaled after the database has been read in with the flag if data is available
    property string name
    property bool writeOnExit: true // bad design, these properties get saved to the disk too
    property bool readOnStart: true
    function read() {   // read vars from storage
        var ret;
        var w = writeOnExit;    // These must not be read from db (bad design)
        var r = readOnStart;    // -"-
        ret = Js.read(store);
        writeOnExit = w;
        readOnStart = r;
        loaded(ret);
    }
    function write() {  // write to storage
        Js.write(store);
    }
    function clear() {  // clear local storage (does not touch variables)
        Js.clear(store);
    }
    function add(name, ob) { // variables to add -- NOTE: to be used only in onInit: slot
        Js.add(name, ob);
    }

    function dump() {
  //      Log.dump("storage.js", Js);
    }

    Component.onCompleted: {
//        console.log("Storage completing going to write on exit:"+writeOnExit)
        init();    // emit signal onInit() for application to construct whatever they want to do on the Js side -- typically add(members)
        Js.init(name);  // open the database
        if (readOnStart) read(store);   // Read it in

    }
    Component.onDestruction: {
//        console.log("Storage finishing, will write: "+writeOnExit);
        if (writeOnExit) write(store);
    }
}
