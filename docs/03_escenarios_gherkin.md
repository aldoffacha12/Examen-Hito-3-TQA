# Escenarios Gherkin (BDD) — SauceDemo

Materia: Testing y Quality Assurance — Examen Práctico Hito 3 (UNIFRANZ)
Feature completa: [`../features/saucedemo.feature`](../features/saucedemo.feature) (idioma español, `# language: es`)

## 1. ¿Qué es Gherkin y por qué se usa? (según la clase)

Gherkin es un **lenguaje legible y estructurado** para describir el comportamiento del sistema en términos de **ejemplos**. Permite que negocio, desarrollo y QA compartan un mismo lenguaje y sienta la base de BDD (Behavior Driven Development).

| Palabra clave | Función | Uso en este feature |
|---|---|---|
| `Característica` (Feature) | Describe la funcionalidad desde el punto de vista del usuario | Compra de productos en Swag Labs |
| `Antecedentes` (Background) | Pasos comunes que se repiten en todos los escenarios | Abrir la URL y limpiar el estado |
| `Escenario` (Scenario) | Un caso concreto del comportamiento | Login válido, compra completa, etc. |
| `Dado` (Given) | Estado inicial del sistema | "Dado que el usuario está en la pantalla de inicio de sesión" |
| `Cuando` (When) | La acción que realiza el usuario | "Cuando pulsa el botón Login" |
| `Entonces` (Then) | Resultado **verificable** (observable y comprobable) | "Entonces debe visualizar el mensaje …" |
| `Y` / `Pero` (And / But) | Continúan el mismo tipo de paso; `Pero` marca un contraste | "Pero no debe acceder al catálogo" |
| `Esquema del escenario` (Scenario Outline) | Escenario parametrizado con ejemplos | Validación de cada campo del checkout |
| `Ejemplos` (Examples) | Tabla de datos que alimenta el esquema | Campos vacíos → mensajes esperados |

Reglas para **buenos escenarios** aplicadas aquí:

- Un escenario = un hilo de comportamiento, con resultado final verificable (no "hace clic" como Then, sino el efecto observable).
- Pasos cortos, sin AND anidados ambiguos, en español claro.
- Los valores concretos (usuarios, importes, mensajes) se escriben literalmente para que sean ejecutables.
- Tags (`@login`, `@defecto`, …) permiten filtrar grupos de escenarios.

## 2. Mapa de escenarios del feature

| # | Escenario | Tipo | Tags | Requisito / TC relacionado |
|---|---|---|---|---|
| 1 | Inicio de sesión con credenciales válidas | Camino feliz | @login @camino_feliz | TC-01 |
| 2 | Rechazo de credenciales incorrectas con mensaje de error | Alternativo / error | @login @negativo | TC-02 |
| 3 | Agregar dos productos al carrito y verificar el contador | Camino feliz | @carrito | TC-03 |
| 4 | Eliminar un producto del carrito | Camino feliz | @carrito | TC-03 |
| 5 | Campos obligatorios vacíos en el primer paso del checkout | Error | @checkout @validacion | TC-05 (paso 1) |
| 6 | Código postal con letras es rechazado | Error (con defecto detectado) | @checkout @validacion | TC-05 (paso 4) → BUG-02 |
| 7 | Nombres compuestos solo por espacios en blanco son rechazados | Error (con defecto detectado) | @checkout @validacion | TC-05 (paso 5) → BUG-02 |
| 8 | Compra completa desde el catálogo hasta la confirmación | Camino feliz | @checkout @camino_feliz | TC-04 |
| 9 | Validación progresiva de cada campo del checkout (Esquema + Ejemplos) | Error parametrizado | @esquema | TC-05 |
| 10 | Catálogo con problem_user muestra la misma imagen | Defecto detectado | @defecto @problem_user | BUG-01 |
| 11 | El carrito de un usuario permanece visible para el siguiente | Defecto detectado | @defecto @sesion | BUG-03 |

Se entregan **11 escenarios** (el mínimo pedido era 2: uno exitoso y uno alternativo/error), incluyendo un `Esquema del escenario` con `Ejemplos`, uso de `Y`, `Pero` y `Antecedentes`.

## 3. Fragmento representativo (camino feliz)

```gherkin
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
```

## 4. Nota sobre los escenarios de defecto

Los escenarios 6, 7, 10 y 11 describen el **comportamiento exigido** (lo que el sistema *debería* hacer). Al lado se documenta con un comentario `# DEFECTO …` el comportamiento **realmente observado** durante la ejecución, enlazando con BUG-01, BUG-02 y BUG-03. Así los escenarios sirven además como especificación viva para revalidar la corrección cuando se resuelvan los defectos.
