# Prueba Técnica - App de Películas

## Descripción

Esta aplicación implementa un flujo de autenticación básico y muestra las películas mejor valoradas de The Movie Database (TMDB). La aplicación está desarrollada siguiendo la arquitectura VIPER y utiliza Swift UIKit para la interfaz de usuario.

## Características

- **Autenticación**: Implementa un sistema de login básico con validación de email y contraseña.
- **Lista de Películas**: Muestra las 10 películas mejor valoradas de TMDB.
- **Detalle de Película**: Muestra información detallada de una película seleccionada.
- **Persistencia de Datos**: Almacena los datos localmente para reducir las llamadas a la API.
- **Diseño Moderno**: Interfaz de usuario moderna siguiendo las directrices de Human Interface Design.

## Arquitectura

La aplicación está desarrollada siguiendo la arquitectura VIPER:

- **View**: Responsable de mostrar la información al usuario y capturar las interacciones.
- **Interactor**: Contiene la lógica de negocio y se comunica con los servicios externos.
- **Presenter**: Coordina la comunicación entre la vista y el interactor.
- **Entity**: Modelos de datos utilizados en la aplicación.
- **Router**: Maneja la navegación entre las diferentes pantallas.

## Requisitos Técnicos

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## API de TMDB

La aplicación utiliza la API de The Movie Database (TMDB) para obtener información sobre películas. Para más información, visita:

- [Registro en TMDB](https://www.themoviedb.org/)
- [Documentación de la API](https://developer.themoviedb.org/reference)
## Autor

Eduardo Carranza Maqueda 