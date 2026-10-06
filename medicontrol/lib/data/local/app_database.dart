import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'semilla.dart';

class AppDatabase {
  AppDatabase._(this.db);

  final Database db;

  static Future<AppDatabase> abrir() async {
    final ruta = p.join(await getDatabasesPath(), 'medicontrol.db');
    final db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pacientes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            ci TEXT NOT NULL UNIQUE,
            telefono TEXT NOT NULL,
            fecha_nacimiento TEXT,
            direccion TEXT NOT NULL,
            activo INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await db.execute('''
          CREATE TABLE citas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            paciente_id INTEGER NOT NULL,
            fecha_hora TEXT NOT NULL,
            motivo TEXT NOT NULL,
            notas TEXT NOT NULL DEFAULT '',
            FOREIGN KEY (paciente_id) REFERENCES pacientes (id)
          )
        ''');
      },
    );
    final app = AppDatabase._(db);
    await app._sembrarSiEstaVacia();
    return app;
  }

  Future<void> _sembrarSiEstaVacia() async {
    final conteo = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM pacientes'),
    );
    if (conteo != null && conteo > 0) {
      return;
    }

    final semilla = crearSemilla(DateTime.now());
    await db.transaction((txn) async {
      final idPorOrdinal = <int, int>{};
      for (final paciente in semilla.pacientes) {
        final id = await txn.insert('pacientes', paciente.toInsertMap());
        idPorOrdinal[paciente.id!] = id;
      }
      for (final cita in semilla.citas) {
        final mapa = cita.toInsertMap();
        mapa['paciente_id'] = idPorOrdinal[cita.pacienteId];
        await txn.insert('citas', mapa);
      }
    });
  }
}
