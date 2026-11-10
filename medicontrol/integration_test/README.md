# Verificación Android de MediControl

El workflow `.github/workflows/medicontrol-android.yml` corre solo al publicar en
la rama `dot/medicontrol-android-verification` o mediante ejecución manual cuando
GitHub la permita. No modifica ni despliega `main`.

Usa Flutter 3.44.7 (la revisión original del proyecto), Java 17 y un emulador
Android 15 / API 35 x86_64 con KVM. El job tiene un límite de 30 minutos y la
prueba de interfaz un límite de 12 minutos. El token solo puede leer contenido.

Comprueba análisis estático, la suite unit/widget existente, compilación y
apertura del APK normal, login inválido y válido, recuperación informativa,
búsqueda y perfil, alta de un paciente ficticio en SQLite, lectura de sesión
en preferencias reales, agenda, validación/cancelación/Back de nueva cita,
cancelación y confirmación de cierre de sesión y un nuevo login.

No registra citas nuevas, no prueba un cierre/reinicio del proceso con sesión
guardada, no usa pacientes reales y no envía información a un servidor. No
valida seguridad clínica, notificaciones, funcionalidades pendientes ni
comportamiento en dispositivos físicos o versiones Android adicionales.

La evidencia incluye capturas y registros acotados. No se suben APKs, bases de
datos, cachés ni vídeos. Los artefactos caducan a los tres días.

Para repetir en un emulador Android desechable ya iniciado:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
bash scripts/verify-android.sh
```

El script borra únicamente los datos de `com.unifranz.medicontrol` en el
emulador seleccionado antes de ejecutar; no debe usarse con datos que conservar.
