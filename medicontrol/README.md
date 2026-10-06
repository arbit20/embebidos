# MediControl

Aplicación móvil para gestionar pacientes y citas de una clínica. Los datos se guardan en el dispositivo.

## Qué incluye

- Inicio de sesión con un usuario de demostración. La sesión queda en `shared_preferences` y, si existe, la app abre directo en el inicio.
- Pantalla principal con accesos y la próxima cita.
- Lista de pacientes con búsqueda y alta.
- Perfil con datos, consultas pasadas y un tratamiento de ejemplo (texto fijo).
- Agenda mensual y registro de una cita nueva.

## Requisitos

- Flutter 3.44 o superior, con el SDK de Android ya configurado.
- Un emulador o un teléfono Android. En esta máquina el emulador existente es `Pixel_6_API_36`.
- No hace falta Android Studio: se usa la línea de comandos.

## Usuario de demostración

- Correo: `miguel@clinicademo.com`
- Contraseña: `demo1234`

La primera ejecución carga cinco pacientes de ejemplo (Juan Pérez, María López, Carlos Andrade, Ana Torres y Luis Fernández) y citas relativas al día de la instalación.

## Cómo correrla

```bash
cd medicontrol
flutter pub get
flutter emulators --launch Pixel_6_API_36
flutter run
```

## Verificación

```bash
cd medicontrol
flutter analyze
flutter test
```

## Alcance del código

Los datos viven en SQLite y `shared_preferences` del dispositivo. El historial clínico editable, el CRUD de tratamientos, los recordatorios, la recuperación de contraseña y la sincronización con Firebase o una API no están implementados.
