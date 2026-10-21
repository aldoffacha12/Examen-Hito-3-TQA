# Análisis de caja blanca — Código `validar_compra`

Materia: Testing y Quality Assurance — Examen Práctico Hito 3 (UNIFRANZ)
Código bajo prueba: [`04_codigo_caja_blanca/validar_compra.py`](04_codigo_caja_blanca/validar_compra.py)

## 1. Código fuente

```python
def validar_compra(edad, cuenta_activa, saldo, monto):
    if edad < 18:
        return "Edad no habilitada"
    if not cuenta_activa:
        return "Cuenta inactiva"
    if saldo >= monto and monto > 0:
        return "Compra aprobada"
    return "Saldo insuficiente"
```

## 2. Identificación de sentencias, decisiones y condiciones

| Elemento | Descripción | Tipo |
|---|---|---|
| S1 | `if edad < 18:` | Sentencia de decisión |
| S2 | `return "Edad no habilitada"` | Sentencia simple |
| S3 | `if not cuenta_activa:` | Sentencia de decisión |
| S4 | `return "Cuenta inactiva"` | Sentencia simple |
| S5 | `if saldo >= monto and monto > 0:` | Sentencia de decisión |
| S6 | `return "Compra aprobada"` | Sentencia simple |
| S7 | `return "Saldo insuficiente"` | Sentencia simple |

**Total de sentencias ejecutables: 7** (3 `if` + 4 `return`).

| Decisión | Condición(es) que la componen | Resultados posibles |
|---|---|---|
| **D1**: primer `if` | C1: `edad < 18` | Verdadero / Falso |
| **D2**: segundo `if` | C2: `not cuenta_activa` | Verdadero / Falso |
| **D3**: tercer `if` | C3a: `saldo >= monto` **y** C3b: `monto > 0` | Verdadero / Falso |

**3 decisiones, 4 condiciones** (C1, C2, C3a, C3b).

### Grafo de flujo y caminos

```
        [inicio]
            |
      (D1: edad < 18?) ----V----> return "Edad no habilitada"      (P1)
            | F
      (D2: not cuenta_activa?) --V--> return "Cuenta inactiva"     (P2)
            | F
   (D3: saldo>=monto Y monto>0?) -V-> return "Compra aprobada"     (P3)
            | F
            +---------------------> return "Saldo insuficiente"     (P4)
```

| Camino | Recorrido | Salida |
|---|---|---|
| P1 | D1 = V | Edad no habilitada |
| P2 | D1 = F, D2 = V | Cuenta inactiva |
| P3 | D1 = F, D2 = F, D3 = V | Compra aprobada |
| P4 | D1 = F, D2 = F, D3 = F | Saldo insuficiente |

## 3. Criterio de cobertura aplicado y cálculo del mínimo

### Criterios evaluados (según la clase)

| Criterio | Pregunta que responde | Mínimo de casos | Cobertura con los 4 casos mínimos |
|---|---|---|---|
| Sentencias | ¿Se ejecutaron todas las sentencias? | 4 | 7/7 = 100 % |
| Decisiones | ¿Se recorrieron ambas ramas de cada decisión? | 4 | 6/6 resultados = 100 % |
| Condiciones | ¿Se probaron ambos valores de cada condición? | 5 | 7/8 = 87,5 % (con CP-5: 8/8) |

### Cálculo mínimo por el criterio de DECISIONES (elegido)

Se elige el criterio **cobertura de decisiones** como principal porque equilibra esfuerzo y capacidad de detección: sin requerir la combinación exhaustiva de condiciones, garantiza que **cada rama del código se ejecute al menos una vez** (cada `return` distinto queda cubierto). Además, en este código el mínimo por sentencias coincide (4), y se reporta también el de condiciones.

Cada decisión debe evaluarse con sus dos resultados:

1. **D1**: necesita 1 caso con `edad < 18` = V y 1 caso con = F.
2. **D2**: solo se evalúa cuando D1 = F; necesita un caso con cuenta inactiva (V) y otro con cuenta activa (F).
3. **D3**: solo se evalúa cuando D1 = F y D2 = F; necesita un caso con la condición compuesta = V y otro = F.

| Caso | Entrada (edad, cuenta_activa, saldo, monto) | Decisiones recorridas | Resultado esperado |
|---|---|---|---|
| **CP-1** | (15, True, 100, 50) | D1 = **V** | Edad no habilitada |
| **CP-2** | (20, False, 100, 50) | D1 = F, D2 = **V** | Cuenta inactiva |
| **CP-3** | (20, True, 100, 50) | D1 = F, D2 = F, D3 = **V** | Compra aprobada |
| **CP-4** | (20, True, 10, 50) | D1 = F, D2 = F, D3 = **F** (C3a = F) | Saldo insuficiente |

**Mínimo por cobertura de decisiones = 4 casos.**

> **¿Por qué 4 y no 3?** (justificación)
> El examen sugiere partir de 3 casos, pero D3 tiene dos resultados que solo se alcanzan **después** de recorrer D1=F y D2=F (los `return` anteriores impiden llegar a D3), y D2 necesita un caso con resultado V que necesariamente tiene D1=F; el caso con D1=V nunca llega a evaluar D2 ni D3. Por esa dependencia de los caminos, se necesitan **4 casos** para cubrir los 6 resultados posibles de las 3 decisiones (y las 7 sentencias). Con 3 casos quedaría sin cubrir al menos un resultado de decisión.

### Caso adicional por cobertura de condiciones

La condición C3b (`monto > 0`) nunca se observa con valor F si `monto` siempre es positivo; para lograr **100 % de cobertura de condiciones (8/8)** se agrega:

| Caso | Entrada | Cobertura adicional | Resultado esperado |
|---|---|---|---|
| **CP-5** | (20, True, 100, 0) | C3b = **F** (con C3a = V) | Saldo insuficiente |

## 4. Ejecución del código con los casos

Salida real de la ejecución (`python validar_compra.py`):

```
EJECUCION DEL CODIGO validar_compra - Examen Hito 3 TQA
====================================================================================================
Caso    Edad   Cuenta   Saldo   Monto Salida real            Salida esperada        Resultado
----------------------------------------------------------------------------------------------------
CP-1      15   activa     100      50 Edad no habilitada     Edad no habilitada     PASS
       Camino: D1 = verdadero
CP-2      20 inactiva     100      50 Cuenta inactiva        Cuenta inactiva        PASS
       Camino: D1 = falso, D2 = verdadero
CP-3      20   activa     100      50 Compra aprobada        Compra aprobada        PASS
       Camino: D1 = falso, D2 = falso, D3 = verdadero
CP-4      20   activa      10      50 Saldo insuficiente     Saldo insuficiente     PASS
       Camino: D1 = falso, D2 = falso, D3 = falso
CP-5      20   activa     100       0 Saldo insuficiente     Saldo insuficiente     PASS
       Camino: D1 = falso, D2 = falso, D3 = falso (C3b = falso)
----------------------------------------------------------------------------------------------------
Total: 5/5 casos cumplen la salida esperada
```

Se ejecutaron **5 casos** (el mínimo de 4 por decisiones + 1 extra por condiciones): todos devolvieron exactamente la salida esperada (**5/5 PASS**).

**Conclusión del análisis:** con los 4 casos mínimos el código alcanza 100 % de cobertura de sentencias y de decisiones y 87,5 % de condiciones; con el caso CP-5 se llega a 100 % en los tres criterios analizados. No se detectaron errores en la lógica de `validar_compra`.

Archivos: [`04_codigo_caja_blanca/validar_compra.py`](04_codigo_caja_blanca/validar_compra.py) · [`04_codigo_caja_blanca/salida_ejecucion.txt`](04_codigo_caja_blanca/salida_ejecucion.txt)
