# Examen-Hito-3-TQA

Repositorio del **Examen Práctico Hito 3** de la materia *Testing y Quality Assurance* — Universidad Privada "Franz Tamayo" (UNIFRANZ), Sección 6: Estrategia y Ejecución de Pruebas de Software.

**Integrante:** Aldo Michael Figueredo Salvatierra
**Aplicación bajo prueba:** SauceDemo — https://www.saucedemo.com/ (Swag Labs)

## Contenido del examen

| Punto | Qué se entrega | Dónde |
|---|---|---|
| 1 | 5 casos de prueba de caja negra, ejecutados con estado PASS/FAIL y capturas reales | [`docs/01_casos_caja_negra.md`](docs/01_casos_caja_negra.md) |
| 2 | Análisis de caja blanca: decisiones/condiciones, criterio elegido, mínimo de casos justificado y ejecución real | [`docs/02_analisis_caja_blanca.md`](docs/02_analisis_caja_blanca.md) + [`docs/04_codigo_caja_blanca/`](docs/04_codigo_caja_blanca/) |
| 3 | Escenarios Gherkin (plus): feature completa en español con 11 escenarios | [`features/saucedemo.feature`](features/saucedemo.feature) + [`docs/03_escenarios_gherkin.md`](docs/03_escenarios_gherkin.md) |
| 4 | Registro de defectos reproducibles con ID, pasos, esperado/actual, evidencia y severidad | [`bugs/bugs_encontrados.md`](bugs/bugs_encontrados.md) |
| 5 | Capturas de pantalla reales de la ejecución | [`evidencias/capturas/`](evidencias/capturas/) |
| 6 | Informe final en PDF | [`entregable/informe_hito3.pdf`](entregable/informe_hito3.pdf) |

## Resumen de resultados de la ejecución

**Caja negra: 4 PASS / 1 FAIL** (5 casos)

| TC | Título | Resultado |
|---|---|---|
| TC-01 | Inicio de sesión con credenciales válidas | PASS |
| TC-02 | Inicio de sesión con credenciales inválidas | PASS |
| TC-03 | Agregar dos productos al carrito y eliminar uno | PASS |
| TC-04 | Compra completa hasta la confirmación | PASS |
| TC-05 | Campos obligatorios y de formato en checkout | FAIL |

**Defectos detectados: 3**

| ID | Descripción corta | Severidad |
|---|---|---|
| BUG-01 | Las 6 imágenes del catálogo son iguales con `problem_user` | Media |
| BUG-02 | El checkout acepta postal no numérico y nombres de solo espacios | Alta |
| BUG-03 | El carrito persiste después de cerrar sesión con otro usuario | Media |

**Caja blanca (`validar_compra`):** mínimo de **4 casos** por cobertura de decisiones (justificado); ejecutados 5 casos → 5/5 PASS, 100 % de cobertura de sentencias, decisiones y condiciones (con el caso extra CP-5).

## Estructura del repositorio

```
Examen-Hito-3-TQA/
├── README.md                      ← este archivo
├── docs/
│   ├── 01_casos_caja_negra.md     ← 5 casos en formato de la plantilla + resultados
│   ├── 02_analisis_caja_blanca.md ← decisiones, condiciones, mínimo y cobertura
│   ├── 03_escenarios_gherkin.md   ← mapeo y notas de los escenarios
│   └── 04_codigo_caja_blanca/
│       ├── validar_compra.py      ← código bajo prueba + casos ejecutados
│       └── salida_ejecucion.txt   ← salida real de la ejecución
├── features/
│   └── saucedemo.feature          ← feature Gherkin completa (español)
├── bugs/
│   └── bugs_encontrados.md        ← BUG-01, BUG-02 y BUG-03
├── evidencias/
│   ├── capturas/                  ← 18 capturas PNG reales
│   ├── resultados_ejecucion.json  ← resultados de la ejecución automatizada
│   └── imagenes_catalogo.json     ← comparación de imágenes problem_user vs standard_user
└── entregable/
    └── informe_hito3.pdf          ← informe final en PDF
```

## Cómo ejecutar las pruebas

1. **Pruebas funcionales (caja negra):** requieren Node.js con `puppeteer-core` y Chrome local. El script de ejecución abre https://www.saucedemo.com/, ejecuta los 5 casos con estado limpio por prueba y genera las capturas en `evidencias/capturas/`.
2. **Análisis de caja blanca:** `python docs/04_codigo_caja_blanca/validar_compra.py` (Python 3). La salida esperada se compara con `salida_ejecucion.txt`.
3. **Gherkin:** el archivo `features/saucedemo.feature` puede ejecutarse con cualquier runner compatible (Behave/Cucumber) mapeando los pasos definidos en `docs/03_escenarios_gherkin.md`.

## Prácticas de Git usadas en este trabajo

- Historial con **commits atómicos y descriptivos** (cada entrega en una rama/commit propio: documentación, ejecución, informe).
- **Issues** de GitHub para el seguimiento de los defectos detectados (BUG-01, BUG-02, BUG-03).
- **Project Board** con columnas To Do / In Progress / In Review / Done para visualizar el estado de las tareas del examen.
- Trabajo desde **terminal** (`git init`, `git add`, `git commit`, `git remote`, `git push`).
