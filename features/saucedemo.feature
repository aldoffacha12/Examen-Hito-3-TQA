# language: es
@funcional @compra @hito3
Característica: Compra de productos en Swag Labs (SauceDemo)
  Como cliente de la tienda Swag Labs
  Quiero iniciar sesión, elegir productos y completar el proceso de checkout
  Para realizar un pedido con mis datos de facturación correctamente validados

  Reglas de negocio:
    Solo los usuarios registrados pueden acceder al catálogo
    El carrito inicia vacío en cada sesión nueva
    El checkout exige nombre, apellido y código postal válidos para continuar

  Antecedentes:
    Dado que el navegador abre la página "https://www.saucedemo.com/"
    Y que se limpia el estado local del navegador para iniciar una sesión nueva

  # ------------------------------------------------------------------
  # 1. Autenticación
  # ------------------------------------------------------------------
  @login @camino_feliz
  Escenario: Inicio de sesión con credenciales válidas
    Dado que el usuario está en la pantalla de inicio de sesión
    Cuando ingresa el usuario "standard_user"
    Y ingresa la contraseña "secret_sauce"
    Y pulsa el botón "Login"
    Entonces debe ser redirigido a la pantalla de catálogo "inventory.html"
    Y debe visualizar los 6 productos del catálogo "Sauce Labs"
    Y el carrito no debe mostrar ninguna cantidad porque está vacío

  @login @negativo
  Escenario: Rechazo de credenciales incorrectas con mensaje de error
    Dado que el usuario está en la pantalla de inicio de sesión
    Cuando ingresa el usuario "standard_user"
    Y ingresa la contraseña "clave_incorrecta"
    Y pulsa el botón "Login"
    Entonces debe permanecer en la pantalla de inicio de sesión
    Y debe visualizar el mensaje "Epic sadface: Username and password do not match any user in this service"
    Y los campos de usuario y contraseña deben resaltarse como inválidos
    Pero no debe acceder al catálogo de productos

  # ------------------------------------------------------------------
  # 2. Gestión del carrito
  # ------------------------------------------------------------------
  @carrito @camino_feliz
  Escenario: Agregar dos productos al carrito y verificar el contador
    Dado que el usuario "standard_user" inició sesión y visualiza el catálogo
    Cuando pulsa el botón "Add to cart" del producto "Sauce Labs Backpack"
    Y pulsa el botón "Add to cart" del producto "Sauce Labs Bike Light"
    Entonces el contador del carrito debe indicar "2"
    Y al entrar al carrito deben listarse "Sauce Labs Backpack" y "Sauce Labs Bike Light"
    Y cada producto debe figurar con cantidad "QTY" igual a 1

  @carrito @camino_feliz
  Escenario: Eliminar un producto del carrito
    Dado que el carrito contiene "Sauce Labs Backpack" y "Sauce Labs Bike Light"
    Cuando pulsa el botón "Remove" del producto "Sauce Labs Backpack"
    Entonces el contador del carrito debe indicar "1"
    Y en el carrito solo debe permanecer "Sauce Labs Bike Light"
    Y el catálogo debe volver a mostrar el botón "Add to cart" para "Sauce Labs Backpack"

  # ------------------------------------------------------------------
  # 3. Checkout y validaciones
  # ------------------------------------------------------------------
  @checkout @validacion
  Escenario: Campos obligatorios vacíos en el primer paso del checkout
    Dado que el carrito contiene al menos un producto
    Y que el usuario está en el formulario de "Your Information"
    Cuando pulsa el botón "Continue" sin completar ningún campo
    Entonces debe visualizar el mensaje "Error: First Name is required"
    Y debe permanecer en la página "checkout-step-one.html"

  @checkout @validacion
  Escenario: Código postal con letras es rechazado
    Dado que el usuario está en el formulario de "Your Information"
    Cuando completa el primer nombre con "Aldo"
    Y completa el apellido con "Figueredo"
    Y completa el código postal con "abc"
    Y pulsa el botón "Continue"
    Entonces debe visualizar un mensaje de validación del código postal
    Y debe permanecer en la página "checkout-step-one.html"
    # DEFECTO BUG-02: el sistema actualmente no muestra ningún mensaje y
    # avanza al resumen del pedido con el código postal "abc".

  @checkout @validacion
  Escenario: Nombres compuestos solo por espacios en blanco son rechazados
    Dado que el usuario está en el formulario de "Your Information"
    Cuando completa el primer nombre con tres espacios en blanco "   "
    Y completa el apellido con tres espacios en blanco "   "
    Y completa el código postal con "0000"
    Y pulsa el botón "Continue"
    Entonces debe visualizar el mensaje "Error: First Name is required"
    Y debe permanecer en la página "checkout-step-one.html"
    # DEFECTO BUG-02: el sistema actualmente acepta los espacios en blanco como
    # nombre válido y avanza al resumen del pedido.

  @checkout @camino_feliz
  Escenario: Compra completa desde el catálogo hasta la confirmación
    Dado que el carrito contiene el producto "Sauce Labs Backpack"
    Y que el usuario está en el formulario de "Your Information"
    Cuando completa el primer nombre con "Aldo"
    Y completa el apellido con "Figueredo"
    Y completa el código postal con "0000"
    Y pulsa el botón "Continue"
    Entonces debe visualizar el resumen del pedido en "checkout-step-two.html"
    Y el subtotal del pedido debe ser "$29.99"
    Y el impuesto debe ser "$2.40"
    Y el total debe ser "$32.39"
    Cuando pulsa el botón "Finish"
    Entonces debe visualizar la confirmación "Thank you for your order!"
    Y la URL debe corresponder a "checkout-complete.html"

  # ------------------------------------------------------------------
  # 4. Casos combinados con ejemplos (Esquema del escenario)
  # ------------------------------------------------------------------
  @checkout @validacion @esquema
  Esquema del escenario: Validación progresiva de cada campo del checkout
    Dado que el usuario está en el formulario de "Your Information"
    Cuando completa únicamente el campo "<campo>" con el valor "<valor>"
    Y pulsa el botón "Continue"
    Entonces debe visualizar el mensaje "<mensaje_esperado>"
    Y debe permanecer en la página "checkout-step-one.html"

    Ejemplos:
      | campo        | valor         | mensaje_esperado              |
      | first-name   |               | Error: First Name is required |
      | last-name    |               | Error: Last Name is required  |
      | postal-code  |               | Error: Postal Code is required |

  # ------------------------------------------------------------------
  # 5. Defectos detectados en la ejecución (comportamiento observado)
  # ------------------------------------------------------------------
  @defecto @imagenes @problem_user
  Escenario: Catálogo con el usuario problem_user muestra la misma imagen en todos los productos
    Dado que el usuario inicia sesión con el usuario "problem_user" y la contraseña "secret_sauce"
    Cuando visualiza el catálogo de productos
    Entonces los 6 productos deben mostrarse con nombres distintos
    Pero todas las miniaturas del catálogo deben ser la misma imagen
    # DEFECTO BUG-01: los 6 productos cargan "sl-404-Cq1a9k9X.jpg";
    # con "standard_user" cada producto tiene su propia imagen.

  @defecto @sesion
  Escenario: El carrito de un usuario permanece visible para el siguiente usuario
    Dado que el usuario "standard_user" inició sesión y agregó un producto al carrito
    Cuando cierra sesión desde el menú "Logout"
    Y otro usuario inicia sesión con "performance_glitch_user"
    Entonces el carrito no debe mostrar productos de la sesión anterior
    Pero el contador del carrito mantiene el producto agregado por el usuario anterior
    # DEFECTO BUG-03: el carrito persiste en el navegador después del Logout.
