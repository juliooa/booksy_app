Esta app fue creada para el curso **Flutter: Crea apps multiplataforma para Android y iOS** que puedes encontrar acá.

# Booksy App

Una app para los amantes de los libros.

## Empieza

Esta app está hecha en [Flutter](https://flutter.dev/), para Android y iOS, para compilar y correr el proyecto:

1. Instala Flutter. Puedes revisar [https://docs.flutter.dev/get-started/install]()
2. Configuro un IDE, yo uso Android Studio. [https://docs.flutter.dev/get-started/editor]()
3. Clona (o fork y clona) el proyecto en tu máquina. `git clone https://github.com/juliooa/booksy_app.git`
5. Ejectua el comando `flutter run`, o corre la app en tu editor.


## Características

* Navegación entre pantallas.
* Uso de GridViews.
* Uso de ListViews con distintos formatos de filas.
* Manejo de estados con [Bloc](https://bloclibrary.dev/).
* Uso de Firebase Firestore para obtener y guardar los datos.
* Uso de cámara del dispositivo para capturar portadas de libros.
* Uso de Firebase Storage para almacenar y acceder las fotos.
* más por venir...

## Configuraciones

### Firebase
La app usa Firebase pero no viene con los archivos de configuración, necesitas crear un proyecto en Firebase con tu cuenta y configurar la app para usarlo. Puedes revisar acá https://firebase.flutter.dev/docs/overview/, o comprar mi curso para ver como se hace 😜.


### Google Admob

Hay un [branch](https://github.com/juliooa/booksy_app/tree/feature/admob) donde instalamos Admob para mostrar ads en la app, para ver su funcionamiento tienes que poner tu app id y ads ids primero:

* [AndroidManifest.xml](https://github.com/juliooa/booksy_app/blob/feature/admob/android/app/src/main/AndroidManifest.xml#L42)
* [book\_details\_screen.dart](https://github.com/juliooa/booksy_app/blob/feature/admob/lib/book_details/book_details_screen.dart#L13)
* [bookshelf_screen.dart](https://github.com/juliooa/booksy_app/blob/feature/admob/lib/bookshelf/bookshelf_screen.dart#L18)


### Contato

Cualquier pregunta/comentario me puedes contactar por cualquiera de las redes: [https://www.udemy.com/user/julio-andres/]()

Saludos!





