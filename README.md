# Base Flutter Project

- This is a project template that includes several libraries to help in the development process of a Flutter project using the MVVM architecture. The template includes different layers such as base, constants, extensions, init, and view-model base. It also includes libraries for state management, localization, cache, network, and serialization, among others. The template has predefined code for building views and view-models, making it easier for developers to focus on page designs and business logic.

## Project Layers

- Base

    - Can be moved from project to project. The structures it contains can be used smoothly in every project.

    - In a project based on MVVM architecture, we create the base structures of Model-View-ViewModel layers from here.

- Constants

    - Folder where values that will not change throughout the application and can be used from start to finish are kept.

    - Includes Navigation names that will be used by application Path, Enum values, Image constants,Icon constants,Status constants, Navigation paths.

- Extensions

    - Extensions that can be used in every part of the project in terms of clean code mentality are essential.

    - context_extension => the place where values such as width, height, padding, and duration are kept within the application.

- Init

    - The place where important controls such as cache, lang, navigation, network, notifier, theme, shared and utils are managed for a mobile application.

    - cache => contains locale manager for managing application cache in this section.

    - navigation => the place where navigation service and navigation routes are provided.

    - network => used for managing web scraping operations from websites using http

    - notifier => manages theme changes between dark and light themes with theme notifier.

    - theme => used for managing the application's theme

    - shared => used for sharing widget using in View

    - utils => contains utility classes and methods that are shared throughout the application.
