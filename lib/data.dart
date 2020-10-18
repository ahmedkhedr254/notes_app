import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Data{
  // String table = 'notes';
  static Database _db;

  Future<Database> get db async{
    if(_db == null){
      _db = await initialDB();
      return _db;
    }else{
      return _db;
    }
  }

  initialDB() async{
    io.Directory docDirect = await getApplicationDocumentsDirectory();
    String path = join(docDirect.path,'testdb.db');
    var mydb = await openDatabase(path,version: 1,onCreate: (Database db,int version) async{
      //await db.execute('CREATE TABLE "folders" ("id"	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, "folderName"	TEXT);');
     // await db.execute('CREATE TABLE "notes" ("id"	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, "note"	TEXT,"folderId" INTEGER);');
      await db.execute('CREATE TABLE "notes" ("id"	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, "message"	TEXT,"title" TEXT,"date" Text);');
      await db.execute('CREATE TABLE "links" ("id"	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, "message"	TEXT,"title" TEXT,"date" Text);');
      await db.execute('CREATE TABLE "passwords" ("id"	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, "message"	TEXT,"title" TEXT,"date" Text);');

    });


    return mydb;
  }


  Future<int> insert(String table,Map<String,dynamic> data) async{
    var dbclient = await db;
    int insert = await dbclient.insert(table, data);
    return insert;
  }
  Future<List<Map<String,dynamic>>> getNotesOfFolderX(int id) async{
    var dbclient = await db;

    return await dbclient.rawQuery('SELECT * FROM Files  WHERE folderId = ?',[id]);

  }





  Future<int> updatee(String table,String title,String note,int id) async{
    var dbclient = await db;

    int update = await dbclient.rawUpdate('Update $table set message="$note" ,title="$title"'
        ' where id =$id ');
    return update;
  }
  Future<List> getFolders() async{
    var dbclient = await db;
    return await dbclient.rawQuery('SELECT * FROM folders ');

  }
  Future<List> getNotesWithDate(String date) async{
    var dbclient = await db;
    return await dbclient.rawQuery('SELECT * FROM notes where date = "$date"');

  }
  Future<List> getNotes() async{
    var dbclient = await db;
    return await dbclient.rawQuery('SELECT * FROM notes ');

  }
  Future<List> getPasswords() async{
    var dbclient = await db;
    return await dbclient.rawQuery('SELECT * FROM passwords ');

  }
  Future<List> getLinks() async{
    var dbclient = await db;
    return await dbclient.rawQuery('SELECT * FROM links ');

  }


  Future<List> getDistinctDate() async{
    var dbclient = await db;
    return await dbclient.rawQuery('SELECT DISTINCT date FROM notes ');

  }

  Future<int> delete(String table,int id) async{
    var dbclient = await db;
    int update = await dbclient.rawUpdate('DELETE  FROM $table WHERE id ="$id"');
    return update;
  }
}