# Registro de defectos — SauceDemo (Swag Labs)

Examen Práctico Hito 3 — Testing y Quality Assurance (UNIFRANZ)
Aplicación bajo prueba: https://www.saucedemo.com/
Ejecución: navegador Chrome (automatización) con estado limpio por prueba. Evidencias en `../evidencias/capturas/`.

## Tabla resumen de bugs (formato de la tarea)

| ID | Descripción | Pasos para reproducir | Severidad |
|---|---|---|---|
| BUG-01 | El catálogo muestra la misma imagen (`sl-404-Cq1a9k9X.jpg`) en los 6 productos cuando se ingresa con el usuario problem_user, aunque cada producto tiene su propio nombre y descripción | 1. Abrir https://www.saucedemo.com/ 2. Iniciar sesión con problem_user / secret_sauce 3. Observar las miniaturas de los 6 productos 4. Comparar repitiendo el paso con standard_user | Media |
| BUG-02 | El formulario de checkout acepta valores con formato inválido: código postal no numérico ("abc") y nombres compuestos solo por espacios en blanco; el sistema no muestra error y avanza al resumen del pedido | 1. Iniciar sesión con standard_user 2. Agregar un producto y entrar al carrito 3. Clic en Checkout 4. Ingresar First Name "Aldo", Last Name "Figueredo", Postal Code "abc" → clic Continue (avanza sin error). 5. Repetir con First Name y Last Name de 3 espacios y Postal "0000" → también avanza | Alta |
| BUG-03 | El carrito de compras persiste después de cerrar sesión: el siguiente usuario que entra en el mismo navegador ve el producto agregado por el usuario anterior (contador del carrito = 1) | 1. Iniciar sesión con standard_user 2. Agregar un producto (badge = 1) 3. Menú hamburguesa → Logout 4. Iniciar sesión con performance_glitch_user 5. Observar que el badge del carrito sigue en 1 | Media |

---

## BUG-01 — Imágenes duplicadas en el catálogo para `problem_user`

- **Título:** Los 6 productos del catálogo cargan la misma imagen con el usuario problem_user.
- **Módulo:** Catálogo de productos (inventory.html).
- **Descripción:** Al autenticarse con el usuario de demostración `problem_user`, todas las miniaturas del catálogo apuntan al mismo archivo (`sl-404-Cq1a9k9X.jpg`), en lugar de mostrar la imagen de cada producto. Los nombres, descripciones y precios sí son correctos y distintos entre sí.
- **Precondiciones:** Navegador con acceso a internet; sesión no iniciada.
- **Datos de prueba:** Usuario: `problem_user` / Contraseña: `secret_sauce`. Contraste: `standard_user` / `secret_sauce`.
- **Pasos para reproducir:**
  1. Abrir https://www.saucedemo.com/
  2. Iniciar sesión con `problem_user` / `secret_sauce`
  3. Observar las imágenes de los 6 productos del catálogo
  4. Cerrar sesión e ingresar con `standard_user` / `secret_sauce` para comparar
- **Resultado esperado:** Cada producto muestra su propia imagen (como con standard_user).
- **Resultado actual:** Los 6 productos muestran exactamente la misma imagen `sl-404-Cq1a9k9X.jpg`. Con `standard_user` se observaron 6 imágenes distintas (verificado por DOM: 1 ruta única vs. 6 rutas únicas).
- **Severidad:** **Media** — daño visual general del catálogo, pero no impide navegar ni comprar; afecta solo a este usuario de demostración.
- **Evidencia:** `bug01_imagenes_problem_user.png`, `../evidencias/imagenes_catalogo.json` (rutas de imagen de ambos usuarios).

## BUG-02 — Checkout acepta valores con formato inválido (postal no numérico y nombres vacíos con espacios)

- **Título:** El primer paso del checkout no valida el formato del código postal ni recorta los nombres, y permite completar la compra con datos de facturación inválidos.
- **Módulo:** Checkout — Your Information (checkout-step-one.html).
- **Descripción:** La validación del formulario solo comprueba que los campos no estén vacíos de forma literal. Como resultado: (a) el código postal `abc` (letras) pasa sin ningún mensaje y (b) nombres compuestos únicamente por espacios en blanco se aceptan como si fueran nombres válidos. En ambos casos el sistema avanza al resumen del pedido (`checkout-step-two.html`) sin mostrar error.
- **Precondiciones:** Usuario `standard_user` autenticado; carrito con al menos un producto; situado en checkout-step-one.html.
- **Datos de prueba:** Caso A: First Name `Aldo`, Last Name `Figueredo`, Postal Code `abc`. Caso B: First Name `   ` (3 espacios), Last Name `   ` (3 espacios), Postal Code `0000`.
- **Pasos para reproducir:**
  1. Iniciar sesión con `standard_user` / `secret_sauce`
  2. Agregar un producto al carrito e ir al carrito
  3. Clic en `Checkout`
  4. Caso A: completar nombre y apellido válidos y postal `abc`; clic en `Continue`
  5. Caso B: completar nombre y apellido con solo espacios y postal `0000`; clic en `Continue`
- **Resultado esperado:** Mensaje de validación (p. ej. `Error: Postal Code must contain only numbers` / `Error: First Name is required`) y permanencia en `checkout-step-one.html`.
- **Resultado actual:** Sin mensaje de error; URL `https://www.saucedemo.com/checkout-step-two.html` (resumen del pedido) en ambos casos.
- **Severidad:** **Alta** — afecta la integridad de la información de facturación de cualquier pedido (campos obligatorios vacíos o con formato inválido que igualmente se procesan).
- **Evidencia:** `bug_postal_formulario_abc.png` (campo con "abc"), `bug_postal_aceptado_resumen.png` (avanza al resumen), `bug_espacios_formulario.png`, `bug_espacios_aceptados.png`.
- **Relación:** Originó el resultado FAIL de TC-05 (pasos 4 y 5).

## BUG-03 — El carrito persiste después de cerrar sesión (no hay aislamiento entre usuarios)

- **Título:** El Logout no limpia el carrito: el siguiente usuario ve el producto del usuario anterior.
- **Módulo:** Sesión de usuario / Carrito de compra.
- **Descripción:** El carrito se guarda en el navegador (`localStorage`) y no se elimina al cerrar sesión. Si `standard_user` agrega un producto y cierra sesión, el usuario `performance_glitch_user` que inicia sesión a continuación en el mismo navegador encuentra el contador del carrito en 1 con el producto del usuario anterior.
- **Precondiciones:** Navegador con sesión de `standard_user` y un producto en el carrito.
- **Datos de prueba:** Usuario 1: `standard_user`; Usuario 2: `performance_glitch_user`; ambos con `secret_sauce`. Producto: Sauce Labs Backpack.
- **Pasos para reproducir:**
  1. Iniciar sesión con `standard_user` / `secret_sauce`
  2. Agregar "Sauce Labs Backpack" al carrito (badge = 1)
  3. Abrir el menú hamburguesa y pulsar `Logout`
  4. Iniciar sesión con `performance_glitch_user` / `secret_sauce`
  5. Observar el contador del carrito
- **Resultado esperado:** Al iniciar sesión con otro usuario, el carrito aparece vacío (badge sin mostrar).
- **Resultado actual:** El badge del carrito muestra `1` con el producto agregado por `standard_user`.
- **Severidad:** **Media** — fuga de estado entre sesiones en un navegador compartido; no expone datos de pago, pero sí la actividad del usuario anterior y puede generar pedidos incorrectos.
- **Evidencia:** `bug02_carrito_persiste_logout.png`.

---

## Verificaciones que NO presentaron defecto

| Verificación | Resultado | Detalle |
|---|---|---|
| Botón "Add to cart" con `error_user` | PASS | El clic sí registra: badge = 1 y el botón cambia a "Remove" (comportamiento correcto en la versión actual) |
| Ordenamiento "Price (low to high)" | PASS | Precios ordenados: 7.99, 9.99, 15.99, 15.99, 29.99, 49.99 |
| Validación de campos vacíos del checkout | PASS | Muestra `First Name is required`, `Last Name is required` y `Postal Code is required` |
| Limpieza del carrito al eliminar ítems | PASS | Badge y listado se mantienen consistentes |

Evidencias: `explor_error_user_agregar.png`, `extra_ordenamiento_precios.png`, `tc05_campo_primer_nombre_vacio.png`, `tc05_campos_obligatorios.png`.
