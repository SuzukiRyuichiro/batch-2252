¡Vamos a construir un programa de entrega de comida a domicilio (Food Delivery) para un restaurante!

Aquí están las primeras **acciones de usuario** de nuestra aplicación:

- Como usuario, puedo agregar un nuevo plato
- Como usuario, puedo mostrar la lista de todos los platos
- Como usuario, puedo agregar a un cliente nuevo
- Como usuario, puedo mostrar la lista de todos los clientes

**ATENCIÓN**

El programa está diseñado para **un solo restaurante** así que no hay necesidad de que entregues (sin intención de jugar con los términos 😉) una aplicación multi restaurante (e.g. no se necesita un modelo `Restaurant`).

El programa está hecho **solamente para los empleados del restaurante** así que no es necesario diseñar una interfaz de usuario para los clientes.

Por ende los primeros elementos de nuestro programa son:
- **Meals**: Platos
- **Customers**: Clientes

## Cómo vamos a construir esto

Trabajaremos en dos fases:

1. **Primero la capa de datos**: Para cada componente, construye el modelo y el repositorio y usa `rake` para verificar que funciona. Sin UI, sin ruteador, solo lógica de datos sólida.
2. **Luego las funcionalidades**: Una vez que la capa de datos esté sólida, pon la aplicación en marcha y construye cada funcionalidad (controlador + vista) de principio a fin. Testea cada una usando la aplicación de verdad.

Aunque los tests de `rake` son muy útiles para verificar que la capa de datos funciona, no testean la experiencia de usuario. Por eso queremos asegurarnos de testear cada funcionalidad usando la aplicación de verdad y viéndola funcionar en la terminal. Es la mejor manera de asegurarnos de que la experiencia de usuario es buena y que todas las piezas de nuestra aplicación funcionan bien juntas.

## 1 - Platos (Meals)

### 1.1. - Modelo de Platos

Comencemos con la capa de datos para los platos.

Nuestro restaurante vende platos, así que necesitamos una representación de lo es un plato.

Cada plato tiene un número de identidad (id), un nombre (name) y un precio (price).

Escribe el código para implementar esto y haz el crash test de tu modelo. Luego testea tu código corriendo `rake meal`.

¿Tienes todo en verde? ¡Genial! Es hora de hacer `git add`, `commit` y `push`.

### 1.2 Repositorio de platos

Ya que tenemos un modelo de los platos, necesitamos un repositorio para almacenarlos.

El repositorio se inicializa con una ruta a un archivo CSV, lee/escribe los platos de dicho archivo y los almacena como objetos en un arreglo (array). A continuación se muestra el comportamiento que queremos que tenga el repositorio:
- Agregar un nuevo plato
- Recuperar todos los platos
- Buscar un plato específico a través de su número de identidad (id).

Escribe el código para implementar esto y haz el crash test de tu repositorio. Debes crear tu propio archivo CSV `meals.csv` dentro de la carpeta `data`. Luego testea tu código corriendo `rake meal`.

¿Tienes todo en verde? ¡Bien! Es hora de hacer `git add`, `commit` y `push`.

### 1.3 - Ruta y aplicación

Ahora, empecemos a construir las funcionalidades reales de nuestra aplicación. Antes de implementar las funcionalidades de los platos, necesitamos poder correr la aplicación.

Para eso necesitamos un ruteador (router) y también es necesario completar el archivo `app.rb`.

El ruteador es el responsable de la visualización de las diferentes funcionalidades que el/la usuario/a puede seleccionar y de direccionar sus decisiones a la acción en el controlador correspondiente. El archivo `app.rb` es el responsable de pedir los archivos necesarios, de instanciar un ruteador y de ejecutar su método `run` para correr la aplicación.

Para poder implementar esto debes completar los archivos `router.rb` y `app.rb`. Si tienes algún problema y necesitas un poco de inspiración, te recomendamos regresar a [Cookbook](https://kitt.lewagon.com/camps/<user.batch_slug>/challenges?path=02-OOP%2F03-Cookbook%2F02-Cookbook) y descargar la solución. **No tienes que instanciar el ruteador con el controlador** ya que todavía no lo tenemos. Simplemente haz que se muestre el término `TODO` cuando el/la usuario/a selecciona una tarea.

No hay rake en esta parte. Corre la aplicacion ejecutando el siguiente comando en la Terminal:

```bash
ruby app.rb
```

¿Todo funciona bien? ¡Excelente! Es hora de hacer `git add`, `commit` y `push`.

### 1.4 - Funcionalidades de los platos

Ahora vayamos al `MealsController`. Las siguientes son las **acciones de usuario** que queremos implementar:
- `add`: agregar un plato
- `list`: mostrar la lista de todos los platos

⚠️ No intentes construir las dos funcionalidades al mismo tiempo. **Codea en silo**, primero construyendo toda la funcionalidad `add` y testeándola en la Terminal corriendo tu aplicación con `ruby app.rb`. Luego pasa a la funcionalidad `list` y haz lo mismo. Solo continúa cuando puedas realmente agregar un plato y listar todos los platos en la terminal.

¡Recuerda que el papel del controlador es delegar y coordinar el trabajo de los demás elementos de tu aplicación (modelo, repositorio y vista)!

Para implementar estas funcionalidades, puede que también necesites crear una `MealsView` para mostrar la información relevante al usuario y pedirle información.

Comienza escribiendo el **pseudocódigo** separando cada acción de usuario en pasos básicos y delegando cada uno de ellos a un componente (modelo, repositorio, vista). Luego escribe el código correspondiente. Crea la vista y escribe su código paso por paso.

Para testear el controlador, conectalo a tu aplicación instanciandolo en `app.rb` y pasándoselo al ruteador. Luego haz el crash test del código corriendo tu aplicación:

```bash
ruby app.rb
```

`rake meal` también te debería ser de utilidad en estos pasos. ¡Sigue la guía!

Asegurate que las dos acciones de usuarios para platos funcionen bien antes de pasar a la siguiente funcionalidad.

📝 **Nota:** En este ejercicio (a diferencia de los modelos y los controladores), no hay un `rake` específico para las vistas. Esto se debe a que hay muchas formas diferentes de mostrar la información relevante y no hay una única manera "correcta". Así que siéntete libre de pensar de manera artística 🧑‍🎨 en lo que deberían mostrar tus vistas. Pero asegúrate de que funcionen correctamente ejecutando `ruby app.rb` y comprobando si la aplicación funciona bien y es fácil de usar.

Si todo funciona, así es como debería verse tu aplicación:

```
--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
8. Exit
> 1

Name?
> Burger
Price?
> 10

--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
8. Exit
> 2

1. Margherita : 8€
2. Capricciosa : 11€
3. Napolitana : 9€
4. Funghi : 12€
5. Calzone : 10€
6. Burger : 10€
```

¿Todo está en verde y funcionando? ¡OK! Es hora de hacer `git add`, `commit` y `push`.

## 2 - Clientes

### 2.1 - Modelo del cliente

Nuestro restaurante le vende a sus clientes, así que necesitamos una representación de lo es un cliente (customer). Volvamos a la capa de datos.

Cada cliente tiene un número de identificación (id), un nombre (name) y una dirección (address).

Escribe el código para implementar esto y haz el crash test de tu modelo. Luego testea tu código corriendo `rake customer`.

¿Todo está en verde? ¡Bravo! Es hora de hacer `git add`, `commit` y `push`.

### 2.2 - Repositorio del cliente

Ya que ahora tenemos un modelo que representa a los clientes, necesitamos un repositorio para almacenarlos.

El repositorio se inicializa con una ruta a un archivo CSV, lee/escribe los clientes de dicho archivo y los almacena como objetos en un arreglo (array). A continuación se muestra el comportamiento que queremos que tenga el repositorio:
- Agregar un nuevo cliente
- Recuperar todos los clientes
- Buscar un cliente específico a través de su número de identificación (id).

Escribe el código para implementar esto y haz el crash test del repositorio. Tienes que crear tu propio archivo `customers.csv`  dentro de la carpeta `data`. Luego prueba tu código corriendo `rake customer`.

¿Todo está en verde? ¡Bravo! Es hora de hacer `git add`, `commit` y `push`.

### 2.3 - Funcionalidades de los clientes

Es el momento de implementar las funcionalidades de los clientes. _Nota: no necesitas un nuevo ruteador ni un nuevo archivo app; usaremos los mismos para toda la aplicación._

Ahora vayamos al `CustomersController`. Aquí están las **acciones de usuario** que queremos implementar:
- `add`: agregar un nuevo cliente
- `list`: mostrar la lista de todos los clientes

No olvides **codear en silo**, primero construyendo toda la funcionalidad `add` y testeándola en la Terminal corriendo tu aplicación con `ruby app.rb`. Luego pasa a la funcionalidad `list` y haz lo mismo. Solo continúa cuando puedas realmente agregar un cliente y listar todos los clientes en la terminal.

¡Recuerda que el rol del controlador es delegar el trabajo a los otros elementos de tu aplicación (modelo, repositorio y vista)!

Comienza escribiendo el **pseudocodigo** separando cada acción de usuario en pasos básicos y delegando cada uno de ellos a un componente (modelo, repositorio, vista). Luego escribe el código correspondiente. Crea la vista y escribe su código paso por paso.

Para testear el controlador, conectalo a tu aplicación instanciandolo en `app.rb` y pasándoselo al ruteador. Luego haz el crash test del código corriendo tu aplicación:

```bash
ruby app.rb
```

`rake customer` también te debería ser de utilidad en estos pasos. ¡Sigue la guia!

Asegurate que cada acción de usuario funcione bien antes de pasar a la siguiente funcionalidad.

Si todo funciona, así es como debería verse tu aplicación:

```
--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
3. Add new customer
4. List all customers
8. Exit
> 3

Name?
> Alex
Address?
> Berlin

--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
3. Add new customer
4. List all customers
8. Exit
> 4

1. Paul McCartney : Liverpool
2. John Bonham : Redditch
3. John Entwistle : Chiswick
4. Alex : Berlin
```

¿Todo está en verde? ¡Qué bueno! Es hora de hacer `git add`, `commit` y `push`.

## 3 - Opcionales

### 3.1 - Implementa las acciones `edit` y `destroy` para los platos y los clientes.

Recuerda que hasta ahora los usuarios de tu aplicación no pueden editar o borrar un plato o cliente.

Implementa las siguientes acciones de usuario adicionales:
- Como usuario puedo editar un plato actual
- Como usuario puedo borrar un plato actual
- Como usuario puedo editar un cliente actual
- Como usuario puedo borrar un cliente actual

¿Listo? Es hora de hacer `git add`, `commit` y `push`.

### 3.2 - Refactorización de repositorios con el concepto de  herencia

`MealRepository` y `CustomerRepository` tienen mucho en común, ¿cierto? Para mantener el principio de no repetirse a uno mismo [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) tenemos que definir la clase padre `BaseRepository` la cual tendrá todo el comportamiento compartido que `MealRepository` y `CustomerRepository` heredarán.
Escribe el código para esto. Como es una refactorización no hay un nuevo test. Si tu `rake` estuvo todo verde anteriormente, ¡deberá estarlo después!

¿Listo? Es hora de hacer `git add`, `commit` y `push`.

¡Ya terminaste por hoy!
