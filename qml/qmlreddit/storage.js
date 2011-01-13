

/*
  Usage:

  import "myjavascript.js" as MyJS

  Storage {
    id: whatever
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


var isArray = function(o) {
    return (o !== undefined && o !== null && typeof o === 'object' && o.constructor === Array)
}

var isQtListModel = function(o) {
    return (o !== undefined && o !== null && typeof o === 'object' && typeof o.append === 'function' && typeof o.count === 'number' && typeof o.get === 'function' && typeof o.set === 'function')
}

var getType = function(o) {
    if (isArray(o)) {
        return 'array';
    } else if (isQtListModel(o)){
        return 'listmodel'
    } else {
        return typeof o;
    }
}

var makeTableName = function(a, b) {
    if (a === undefined || b === undefined) throw("Error making table name");
    return a+"_"+b;
}

var executeSQL = function(tx, command) {
//    console.log(command);
    return tx.executeSql(command);
}


// TODO null, NaN, undefined
// TODO: Analyse cyclic graphs


/////////////////////////////////////////////////////////////////////////////////////////////////
// In the QML version, the objects are already in place, except for the listModel -  a special case
// However this works also for any Javascript object

var db;
// console.log("defining db");
var maxDepth = 5;

var init = function(name, size) {
    if (name === undefined || !name) {
        console.log("Error: Storage property 'name' undefined");
        throw("Storage { name: undefined }");
    }

    try {
//        console.log("opening database '"+name+"', size: "+size);
        db = openDatabaseSync(name, "1.0", "QtQuick Storage "+name, (size !== undefined && size > 0) ? size : 500000);
    } catch (e) {
        console.log("Database '"+v+"' open failed: "+e);
    }
}

var jsStore = {} // For storing additional JS side vars to Storage (for persistence)
/*
 * pattern: with Storage.onInit: { Storage.add("myObject", YourJsModule.myObject); }
 */
var add = function(name, ob) {
    jsStore[name] = ob;
}


/*
 * write object obj[member] and all subobjects to table tableName. code design is a bit ugly as we need to loop thru arrays, ListModes and objects and to check hasOwnProperty and I did not bother to make iterators...
 * Special case - if "member" is undefined, then write the whole object
 */
var writeObject = function (db, tableName, obj, member) {
    db.transaction(
                function (tx) {
                    /*
                     * tx: transaction,
                     * fullName: the hosting object full tablename
                     * hostObject: hosting object (or if memberName is undefined, then just the object)
                     * memberName: the member name as a string
                     * depth: maximum recursion levels allowed from here
                     */
                    var writeMember = function writeMember(tx, depth, hostObject, fullName, memberName) {
                        var p, x;
                        var o;
                        var type;
                        var myName;
                        var topLevel;

                        var storeValue = function(o, tablename) {   // Small helper
                            return (typeof o == 'object') ? tablename : o;
                        }

                        /*
                         * Special case: if "memberName" is empty, the hostObject is not hostObject but the top level object
                         */
                        if (memberName === undefined) {  // not a member but just write obj
                            o = hostObject    // if no memberName, this is top level o
                            type = typeof o;
                            myName = fullName;   // Top level table
                            topLevel = true;
                        } else {    // The usual case - a member of an object
                            if (isQtListModel(hostObject)) {
                                o = hostObject.get(memberName);
                            } else {
                                o = hostObject[memberName];
                            }
                            if (o === undefined) {
                                return;
                            }

                            type = typeof o;
                            myName = makeTableName(fullName, memberName);
                            if (type === 'function') {
                                return; // skip functions
                            }

                            if (!isQtListModel(hostObject) && hostObject.hasOwnProperty !== undefined && !hostObject.hasOwnProperty(memberName)) {
                                return; // skip protype members
                            }
                            if (typeof memberName !== 'number' && memberName.substring(0, 3) === '___') {
                                return; // skip ___members
                            }
                            topLevel = false;
                        }
                        if (depth < 0) {
                            throw("Error: Data structure "+myName+" is too deep");
                        }

                        if (type === 'object') {  // a compound object, create table and do its members
                            x = executeSQL(tx, 'DROP TABLE IF EXISTS "'+myName+'"');    // delete any old (potentionally deleted) members
                            /*
                             * write the object members depending on the type: Object, array or QtListElement (eg. a generic List component)
                             * with getter, setter, count, delete and append (instead of [], push and length)
                             */
                            if (isQtListModel(o)) {
                                type = 'listmodel';
                                x = executeSQL(tx, 'CREATE TABLE "'+myName+'"(member INTEGER UNIQUE NOT NULL, type TEXT NOT NULL, value TEXT )');
                                for (p = 0; p < o.count; p++) {
                                    writeMember(tx, depth-1, o, myName, p);
                                }
                            } else if (isArray(o)) {
                                type = 'array';
                                x = executeSQL(tx, 'CREATE TABLE "'+myName+'"(member INTEGER UNIQUE NOT NULL, type TEXT NOT NULL, value TEXT )');
                                for (p = 0; p < o.length; p++) {
                                    writeMember(tx, depth-1, o, myName, p);
                                }
                            } else {
                                x = executeSQL(tx, 'CREATE TABLE "'+myName+'"(member TEXT UNIQUE NOT NULL, type TEXT NOT NULL, value TEXT )');
                                for (p in o) {
                                    writeMember(tx, depth-1, o, myName, p);
                                }
                            }
                        }
                        // Write the member row itself (clean order -> top level pointer exists only if subobjects exist)
                        // Do not write if this is toplevel as toplevel tablenames are implicit
                        if(!topLevel) {
                            x = executeSQL(tx, 'SELECT value FROM "'+fullName+'" WHERE member="'+memberName+'"');
                            if (x.rows.length) { // member has been Valued earlier
                                x = executeSQL(tx, 'UPDATE "'+fullName+'" SET type="'+type+'", value="'+storeValue(o, myName)+'" WHERE member="'+memberName+'"');
                            } else { // create new entry
                                x = executeSQL(tx, 'INSERT INTO "'+fullName+'" VALUES("'+memberName+'", "'+type+'", "'+storeValue(o, myName)+'")');
                            }
                        }
                    }

                    writeMember(tx, maxDepth, obj, tableName, member);
                }

                );
}

var write = function(ob) {
    if (db === undefined || !db) {
        throw ("Database not init()ialised");
    }
    writeObject(db, "D", ob);
    writeObject(db, "S", jsStore);
}

// Mapping a table to an object:
// member name = 'member', typeof member, 'type', member value as string-unless object. If (typeof === 'object') then create table object.member and store there.

// TODO null, NaN, undefined
// TODO: Analyse cyclic graphs

var newListModel = function(parent) {
    return Qt.createQmlObject("import Qt 4.7; ListModel {}", parent);
}
/*
 * reads the table "tableName" to the existing object
 */
var readObject = function(db, tableName, obj) {
    db.readTransaction(
                function(tx) {
                    var p;
                    var readTable = function readTable(tx, ob, fullName) {
                        var r, select, row;
                        var newOb;
                        var setMember = function(ob, member, value) {   // A simple ob[member] = value; but to mitigate ListModel
                            if (!isQtListModel(ob)) {
                                ob[member] = value;
                            } else {
                                if (member < ob.count) {
                                    ob.set(member, value);
                                } else {
                                    if (member != ob.count) throw("Error augmenting ListModel "+fullName+", model size is "+ob.count+" and trying to append item #"+member);
                                    ob.append(value);
                                }
                            }
                        }
                        select = executeSQL(tx, 'SELECT * FROM "'+fullName+'" ORDER BY member');
                        for (r = 0; r < select.rows.length; r++) {
                            row = select.rows.item(r);
//                            for (p in row) console.log("row["+p+"]: '"+row[p]+"'");
                            if (isQtListModel(ob) || ob[row.member] === undefined) {  // Note: if (isQtListModel(ob)) then row.type === "object"
                                newOb = (row.type === "array") ? [] : row.type === "listmodel" ? newListModel(ob) : {};    // Note: newListModel() is just a placeholder, it shouln't be called as th Litsmode shoud have been written nd the data mode shoud be static
                                if (!isQtListModel(ob)) ob[row.member] = newOb; // Initialise the member in case it hapens to be an array or object
                            }
                            // Now the ob[row.member] is in place unless of course it is a listModel - in which case newOb is set properly as empty object o receive subobjects
                            if (row.type == "number") {
                                setMember(ob, row.member, row.value*1);
                            } else if (row.type == "string") {
                                setMember(ob, row.member, row.value+"");
                            } else if (row.type == "boolean") {
                                setMember(ob, row.member, row.value === 'true');
                            } else if (row.type == "object" || row.type == "array" || row.type == 'listmodel') {
                                readTable(tx, isQtListModel(ob) ? newOb : ob[row.member], row.value);
                                if (isQtListModel(ob)) { // then we have read the member to a fresh object and need to add it to the list
                                    if (row.member != r) {
                                        throw("Error in read order of ListModel members, "+r+"th read pulled item #"+row.member);
                                    }
                                    setMember(ob, row.member, newOb);
                                }
                            }
                        }
                    }
                    readTable(tx, obj, tableName);
                }
                );
}

// For now ignoreas all read errors as initial read always fails - just logs them to console

var read = function(ob) {
    var isDataAvailable = false;
    try {
        readObject(db, "D", ob);
        isDataAvailable = true;
        readObject(db, "S", jsStore);
    } catch (e) {
        console.log("Warning: Storage database read failed: "+e);
    }
    return isDataAvailable;
}

/*
 * Delete the tabel tableName and descendants. obj is ignored (untouched) but this might change
 */
var deleteObject = function(db, tableName, obj) {
    db.transaction(
                function(tx) {
                    var deleteTable = function deleteTable(tx, ob, fullName) {
                        var r, select, row;
                        select = executeSQL(tx, 'SELECT * FROM "'+fullName+'" ORDER BY member DESC');
                        for (r = 0; r < select.rows.length; r++) {
                            row = select.rows.item(r);
                            if (row.type == "object" || row.type == "array" || row.type == 'listmodel') {
                                deleteTable(tx, isQtListModel(ob) ? ob.get(row.member) : ob[row.member], row.value);
                            }
                        }
                        select = executeSQL(tx, 'DROP TABLE "'+fullName+'"');
//                        if (isQtListModel(ob)) ob.clear();
                    }
                    deleteTable(tx, obj, tableName);
                }
                );
}

/*
 * Clear the database ** But do not delete the in memory data structures
 */
var clear = function(ob) {
    if (db === undefined || !db) {
        throw ("Database not init()ialised");
    }
    try {
 //       console.log("clearing D");
        deleteObject(db, "D", ob);
//        console.log("clearing S");
        deleteObject(db, "S", jsStore);
    } catch (e) {
        console.log("Warning: Storage database clear failed: "+e);
    }
}
