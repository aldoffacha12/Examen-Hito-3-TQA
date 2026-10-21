# Casos de prueba — Caja negra (SauceDemo)

Aplicación bajo prueba: **https://www.saucedemo.com/** (Swag Labs)
Formato de casos de prueba según la plantilla de la tarea (tareaqa29).
Ejecución automatizada con navegador Chrome (Puppeteer) el año 2026; capturas reales en `../evidencias/capturas/`.

| ID DEL TC | TC-01 | PRIORIDAD | ALTA |
|---|---|---|---|
| **TÍTULO** | Inicio de sesión con credenciales válidas | **TIPO** | Funcional (positiva) |
| **MÓDULO** | Autenticación / Login | **RESULTADO** | ☒ PASS |
| **OBJETIVO** | Validar que un usuario registrado pueda ingresar al sistema con credenciales correctas y acceda al catálogo de productos. | | |
| **PRECONDICIONES** | 1. Navegador con acceso a internet. 2. Cuenta válida: standard_user / secret_sauce. 3. Sesión previa cerrada (carrito vacío). | | |
| **DATOS DE PRUEBA** | Usuario: standard_user — Contraseña: secret_sauce | | |
| **CRITERIO DE ÉXITO** | Tras pulsar Login se redirige a inventory.html, se muestran los 6 productos y el carrito aparece vacío. | | |

| # | Paso / acción | Resultado esperado | Estado |
|---|---|---|---|
| 1 | Abrir https://www.saucedemo.com/ | Se muestra la pantalla de inicio de sesión con los campos Username y Password y el botón Login | PASS |
| 2 | Escribir "standard_user" en el campo Username | El campo acepta el texto ingresado | PASS |
| 3 | Escribir "secret_sauce" en el campo Password | El campo acepta el texto y lo muestra oculto | PASS |
| 4 | Hacer clic en el botón Login | Se redirige a https://www.saucedemo.com/inventory.html | PASS |
| 5 | Verificar el catálogo y el carrito | Se visualizan 6 productos "Sauce Labs" y no existe badge de carrito (carrito vacío) | PASS |

**RESULTADO OBSERVADO:** El acceso se realizó correctamente: la URL resultante fue `https://www.saucedemo.com/inventory.html`, se listaron los 6 productos del catálogo y el badge del carrito no aparece, lo que confirma un carrito vacío. Coincide con lo esperado.

**OBSERVACIONES:** Ejecutado con estado limpio de navegador (localStorage y sessionStorage vacíos) para garantizar la independencia entre pruebas. Evidencia: `tc01_login_exitoso.png`.

---

| ID DEL TC | TC-02 | PRIORIDAD | ALTA |
|---|---|---|---|
| **TÍTULO** | Inicio de sesión con credenciales inválidas muestra mensaje de error | **TIPO** | Funcional (negativa) |
| **MÓDULO** | Autenticación / Login | **RESULTADO** | ☒ PASS |
| **OBJETIVO** | Validar que el sistema rechace credenciales incorrectas, muestre un mensaje de error y no permita acceder al catálogo. | | |
| **PRECONDICIONES** | 1. Navegador con acceso a internet. 2. Usuario registrado existente (standard_user) con contraseña errónea. 3. Sesión no iniciada. | | |
| **DATOS DE PRUEBA** | Usuario: standard_user — Contraseña: clave_incorrecta | | |
| **CRITERIO DE ÉXITO** | Se muestra el mensaje de error, los campos se marcan como inválidos, la URL permanece en la pantalla de login y no se accede al inventario. | | |

| # | Paso / acción | Resultado esperado | Estado |
|---|---|---|---|
| 1 | Abrir https://www.saucedemo.com/ | Se muestra la pantalla de inicio de sesión | PASS |
| 2 | Escribir "standard_user" en Username y "clave_incorrecta" en Password | Los campos aceptan los textos | PASS |
| 3 | Hacer clic en Login | Se muestra el mensaje de error "Epic sadface: Username and password do not match any user in this service" | PASS |
| 4 | Verificar la dirección URL y los campos del formulario | La URL permanece en https://www.saucedemo.com/ (sin acceder a inventory.html) y los 2 campos aparecen resaltados con clase de error | PASS |

**RESULTADO OBSERVADO:** Tras pulsar Login el sistema mostró el mensaje `Epic sadface: Username and password do not match any user in this service`, los campos Username y Password quedaron resaltados con estilo de error (2 elementos con clase de error) y la URL siguió siendo `https://www.saucedemo.com/`, por lo que no se accedió al catálogo. Coincide con lo esperado.

**OBSERVACIONES:** El mensaje genérico "Epic sadface" es el comportamiento documentado de SauceDemo tanto para contraseña incorrecta como para usuario inexistente. Evidencia: `tc02_login_invalido.png`.

---

| ID DEL TC | TC-03 | PRIORIDAD | ALTA |
|---|---|---|---|
| **TÍTULO** | Agregar dos productos al carrito y eliminar uno de ellos | **TIPO** | Funcional (positiva) |
| **MÓDULO** | Carrito de compra | **RESULTADO** | ☒ PASS |
| **OBJETIVO** | Validar que el usuario pueda agregar productos al carrito, verlos reflejados en el contador y el listado, y eliminar uno de ellos dejando el estado consistente. | | |
| **PRECONDICIONES** | 1. Usuario standard_user autenticado. 2. Carrito vacío (sin badge). 3. Catálogo cargado con 6 productos. | | |
| **DATOS DE PRUEBA** | Productos: Sauce Labs Backpack ($29.99) y Sauce Labs Bike Light ($9.99) | | |
| **CRITERIO DE ÉXITO** | El badge marca 2 tras agregar; el carrito lista ambos productos; al eliminar uno el badge marca 1 y solo queda el producto restante. | | |

| # | Paso / acción | Resultado esperado | Estado |
|---|---|---|---|
| 1 | Iniciar sesión con standard_user / secret_sauce | Se accede al catálogo inventory.html | PASS |
| 2 | Hacer clic en "Add to cart" del producto Sauce Labs Backpack | El badge del carrito muestra "1" | PASS |
| 3 | Hacer clic en "Add to cart" del producto Sauce Labs Bike Light | El badge del carrito muestra "2" | PASS |
| 4 | Hacer clic en el ícono del carrito | Se abre cart.html con 2 productos: Sauce Labs Backpack y Sauce Labs Bike Light, cada uno con QTY = 1 | PASS |
| 5 | Hacer clic en el botón "Remove" de Sauce Labs Backpack | El badge queda en "1" y en el carrito solo permanece Sauce Labs Bike Light | PASS |

**RESULTADO OBSERVADO:** El contador del carrito llegó a 2 tras las dos altas. En `cart.html` se listaron exactamente 2 ítems (Sauce Labs Backpack y Sauce Labs Bike Light) con QTY 1. Tras pulsar Remove sobre el Backpack, el badge pasó a 1, quedó un solo ítem en el carrito (Sauce Labs Bike Light) y el catálogo ofrece nuevamente "Add to cart" para el producto eliminado. Coincide con lo esperado.

**OBSERVACIONES:** Se verificó también el contenido persistido por la aplicación (`cart-contents = [4, 0]`), consistente con los ítems mostrados. Evidencias: `tc03_agregar_productos.png`, `tc03_carrito_2_items.png`, `tc03_eliminar_producto.png`.

---

| ID DEL TC | TC-04 | PRIORIDAD | ALTA |
|---|---|---|---|
| **TÍTULO** | Compra completa: checkout hasta la confirmación del pedido | **TIPO** | Funcional (positiva / integración) |
| **MÓDULO** | Checkout (Your Information → Overview → Complete) | **RESULTADO** | ☒ PASS |
| **OBJETIVO** | Validar el flujo completo de compra: agregar producto, informar datos de facturación, revisar el resumen con importes correctos y finalizar el pedido. | | |
| **PRECONDICIONES** | 1. Usuario standard_user autenticado. 2. Carrito con 1 producto (Sauce Labs Backpack, $29.99). 3. Datos de prueba disponibles. | | |
| **DATOS DE PRUEBA** | First Name: Aldo — Last Name: Figueredo — Zip/Postal Code: 0000 | | |
| **CRITERIO DE ÉXITO** | El resumen muestra subtotal $29.99, impuesto $2.40 y total $32.39; al finalizar se muestra "Thank you for your order!" en checkout-complete.html. | | |

| # | Paso / acción | Resultado esperado | Estado |
|---|---|---|---|
| 1 | Iniciar sesión y agregar Sauce Labs Backpack al carrito | Badge del carrito = 1 | PASS |
| 2 | Abrir el carrito y hacer clic en "Checkout" | Se abre checkout-step-one.html con los campos First Name, Last Name y Zip Code | PASS |
| 3 | Completar First Name "Aldo", Last Name "Figueredo" y Zip Code "0000" | Los campos aceptan los valores ingresados | PASS |
| 4 | Hacer clic en "Continue" | Se abre checkout-step-two.html con el resumen: 1 ítem (Sauce Labs Backpack), Item total: $29.99, Tax: $2.40, Total: $32.39 | PASS |
| 5 | Verificar los importes del resumen | El total ($32.39) es mayor que el subtotal ($29.99) y coincide con subtotal + impuesto | PASS |
| 6 | Hacer clic en "Finish" | Se muestra "Thank you for your order!" con imagen de confirmación en checkout-complete.html | PASS |

**RESULTADO OBSERVADO:** El flujo completo se ejecutó sin interrupciones: el resumen presentó `Item total: $29.99`, `Tax: $2.40`, `Total: $32.39` para 1 ítem (Sauce Labs Backpack), y al finalizar la URL fue `https://www.saucedemo.com/checkout-complete.html` con el mensaje `Thank you for your order!` y la imagen del cartero (pony express). Coincide con lo esperado.

**OBSERVACIONES:** El impuesto del 8.08% ($2.40 sobre $29.99) corresponde a la configuración de demostración de SauceDemo. Evidencias: `tc04_checkout_datos.png`, `tc04_resumen_pedido.png`, `tc04_compra_confirmada.png`.

---

| ID DEL TC | TC-05 | PRIORIDAD | MEDIA |
|---|---|---|---|
| **TÍTULO** | Validación de campos obligatorios y de formato en el formulario de checkout | **TIPO** | Funcional (negativa / validación) |
| **MÓDULO** | Checkout — Your Information (checkout-step-one) | **RESULTADO** | ☒ FAIL |
| **OBJETIVO** | Validar que el formulario de facturación rechace campos vacíos y valores con formato inválido (código postal no numérico, nombres compuestos solo por espacios) mostrando el mensaje de error correspondiente. | | |
| **PRECONDICIONES** | 1. Usuario standard_user autenticado. 2. Carrito con al menos 1 producto. 3. Situado en checkout-step-one.html. | | |
| **DATOS DE PRUEBA** | Caso A: campos vacíos. Caso B: First Name "Aldo", Last Name "Figueredo", Postal Code "abc". Caso C: First Name "   " (3 espacios), Last Name "   ", Postal Code "0000". | | |
| **CRITERIO DE ÉXITO** | Cada caso muestra el mensaje de error indicando el campo a corregir y permanece en checkout-step-one.html sin avanzar al resumen. | | |

| # | Paso / acción | Resultado esperado | Estado |
|---|---|---|---|
| 1 | Con el formulario vacío, hacer clic en "Continue" | Mensaje "Error: First Name is required" y permanece en checkout-step-one.html | PASS |
| 2 | Escribir "Aldo" en First Name y hacer clic en "Continue" | Mensaje "Error: Last Name is required" | PASS |
| 3 | Escribir "Figueredo" en Last Name y hacer clic en "Continue" | Mensaje "Error: Postal Code is required" | PASS |
| 4 | Escribir "abc" en Postal Code y hacer clic en "Continue" | Mensaje de validación del código postal (ej. "Postal Code must contain only numbers") y permanece en checkout-step-one.html | FAIL |
| 5 | Escribir "   " (3 espacios) en First Name y Last Name, "0000" en Postal Code y hacer clic en "Continue" | Mensaje "Error: First Name is required" (nombre vacío tras recortar espacios) y permanece en checkout-step-one.html | FAIL |

**RESULTADO OBSERVADO:** Los pasos 1 a 3 funcionan correctamente (los tres mensajes de campo obligatorio aparecen). En el paso 4 el sistema **no mostró ningún mensaje** con el código postal "abc" y avanzó a `checkout-step-two.html` (resumen del pedido). En el paso 5 el sistema **aceptó los nombres compuestos solo por espacios** y también avanzó al resumen sin mostrar errores. 2 de 5 pasos fallan: la validación de formato es insuficiente.

**OBSERVACIONES:** Los defectos observados en los pasos 4 y 5 se documentan por separado como **BUG-02** (ver `../bugs/bugs_encontrados.md`). Las validaciones de campos vacíos (pasos 1–3) sí operan correctamente. Evidencias: `tc05_campo_primer_nombre_vacio.png`, `tc05_campos_obligatorios.png`, `bug_postal_formulario_abc.png`, `bug_postal_aceptado_resumen.png`, `bug_espacios_formulario.png`, `bug_espacios_aceptados.png`.

---

## Resumen de resultados

| TC | Título | Prioridad | Resultado |
|---|---|---|---|
| TC-01 | Inicio de sesión con credenciales válidas | Alta | ☒ PASS |
| TC-02 | Inicio de sesión con credenciales inválidas | Alta | ☒ PASS |
| TC-03 | Agregar dos productos y eliminar uno del carrito | Alta | ☒ PASS |
| TC-04 | Compra completa hasta la confirmación | Alta | ☒ PASS |
| TC-05 | Campos obligatorios y de formato en checkout | Media | ☒ FAIL |

**Total: 4 PASS / 1 FAIL (5 casos ejecutados).** Los resultados FAIL originaron los defectos BUG-02; adicionalmente, en pruebas exploratorias se detectaron BUG-01 y BUG-03.

## Pruebas exploratorias complementarias

| Verificación | Usuario | Resultado | Detalle |
|---|---|---|---|
| Imágenes del catálogo | problem_user | Defecto (BUG-01) | Los 6 productos cargan la misma imagen `sl-404-Cq1a9k9X.jpg`; con standard_user cada producto tiene su imagen |
| Agregar al carrito | error_user | PASS | El botón "Add to cart" responde: badge = 1 y el botón cambia a "Remove" (comportamiento correcto) |
| Carrito tras Logout con otro usuario | standard_user → performance_glitch_user | Defecto (BUG-03) | El badge del carrito sigue en "1" después de cerrar sesión y entrar con otro usuario |
| Ordenamiento "Price (low to high)" | standard_user | PASS | Precios ordenados: 7.99, 9.99, 15.99, 15.99, 29.99, 49.99 |

Evidencias: `bug01_imagenes_problem_user.png`, `explor_error_user_agregar.png`, `bug02_carrito_persiste_logout.png`, `extra_ordenamiento_precios.png`.
