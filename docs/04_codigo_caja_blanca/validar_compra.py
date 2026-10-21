"""
Examen Practico Hito 3 - Testing y Quality Assurance (UNIFRANZ)
Codigo bajo prueba: validar_compra

Criterio aplicado: COBERTURA DE DECISIONES (ver analisis en docs/02_analisis_caja_blanca.md)
  D1: edad < 18                      (condicion C1)
  D2: not cuenta_activa              (condicion C2)
  D3: saldo >= monto and monto > 0   (condiciones C3a: saldo >= monto ; C3b: monto > 0)

Minimo por cobertura de decisiones: 4 casos.
Caso extra (5) para alcanzar cobertura completa de condiciones (C3b = F).
"""


def validar_compra(edad, cuenta_activa, saldo, monto):
    """Evalua una compra segun edad, estado de la cuenta y saldo disponible."""
    if edad < 18:
        return "Edad no habilitada"
    if not cuenta_activa:
        return "Cuenta inactiva"
    if saldo >= monto and monto > 0:
        return "Compra aprobada"
    return "Saldo insuficiente"


# ----------------------------------------------------------------------
# Casos de prueba (entradas -> salida esperada segun el analisis previo)
# ----------------------------------------------------------------------
CASOS = [
    # (id, edad, cuenta_activa, saldo, monto, salida_esperada, decisiones_recorridas)
    ("CP-1", 15, True, 100, 50, "Edad no habilitada", "D1 = verdadero"),
    ("CP-2", 20, False, 100, 50, "Cuenta inactiva", "D1 = falso, D2 = verdadero"),
    ("CP-3", 20, True, 100, 50, "Compra aprobada", "D1 = falso, D2 = falso, D3 = verdadero"),
    ("CP-4", 20, True, 10, 50, "Saldo insuficiente", "D1 = falso, D2 = falso, D3 = falso"),
    ("CP-5", 20, True, 100, 0, "Saldo insuficiente", "D1 = falso, D2 = falso, D3 = falso (C3b = falso)"),
]


def main():
    print("=" * 100)
    print("EJECUCION DEL CODIGO validar_compra - Examen Hito 3 TQA")
    print("=" * 100)
    print(f"{'Caso':<6} {'Edad':>5} {'Cuenta':>8} {'Saldo':>7} {'Monto':>7} {'Salida real':<22} {'Salida esperada':<22} {'Resultado':<10}")
    print("-" * 100)
    aciertos = 0
    for cid, edad, activa, saldo, monto, esperada, camino in CASOS:
        salida = validar_compra(edad, activa, saldo, monto)
        ok = salida == esperada
        aciertos += ok
        cuenta = "activa" if activa else "inactiva"
        print(f"{cid:<6} {edad:>5} {cuenta:>8} {saldo:>7} {monto:>7} {salida:<22} {esperada:<22} {'PASS' if ok else 'FAIL':<10}")
        print(f"       Camino: {camino}")
    print("-" * 100)
    print(f"Total: {aciertos}/{len(CASOS)} casos cumplen la salida esperada")

    # Cobertura lograda con los 4 casos minimos (CP-1..CP-4)
    print()
    print("COBERTURA CON EL MINIMO DE 4 CASOS (CP-1 a CP-4):")
    print("  Sentencias: 7/7  (3 if + 4 return)  -> 100%")
    print("  Decisiones: D1(T,F), D2(T,F), D3(T,F) -> 6/6 resultados de decision -> 100%")
    print("  Condiciones: C1(T,F), C2(T,F), C3a(T,F), C3b solo T -> 7/8 -> 87.5%")
    print("COBERTURA DE CONDICIONES AL AGREGAR CP-5 (monto = 0, C3b = F):")
    print("  Condiciones: 8/8 -> 100%")


if __name__ == "__main__":
    main()
