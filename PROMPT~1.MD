# PROMPT MAESTRO — Software de Gestión Integral PROAUTO

> Brief técnico + funcional para diseñar y construir el sistema. Copiar y pegar en Claude (u otro LLM/desarrollador senior).

---

## 1. Contexto del negocio

**Empresa:** PROAUTO — Taller mecánico y de tornería con venta de repuestos, ubicado en Perú.

**Áreas operativas (centros de ingreso):**
1. **Tornería** — 2 trabajadores.
2. **Mecánica** — 2 trabajadores.
3. **Repuestos** — 1 persona (la misma que opera la caja).

**Personal total:** 5 trabajadores + 1 administrador (dueño).

**Situación actual:** todo el control de caja diaria (ingresos y gastos), órdenes de trabajo y asistencia se lleva en cuaderno. La facturación tributaria se emite en otro sistema (SRI) que se sigue usando en paralelo — **este software NO factura al SRI**, solo controla operación interna.

**Meta estratégica:** formalizar el negocio poco a poco. El sistema arranca acompañando las prácticas actuales (informales) y deja preparados los ganchos para activar módulos formales (retenciones, IESS, comprobantes de pago) cuando la empresa dé el salto.

**Objetivo del software:** reemplazar el cuaderno por una **plataforma web + app móvil** alojada en la nube, con foco en:
- **Flujo de caja diario** que cuadre con la caja física.
- **Control de órdenes de trabajo** por área.
- **Asistencia biométrica** por huella dactilar.
- **Inventario de repuestos** con lector de código de barras.
- **Registro histórico por vehículo y cliente.**

---

## 2. Identidad visual y paleta

**Logo:** PROAUTO — silueta deportiva de auto en blanco con cabina/parabrisas naranja, tipografía itálica "PRO" en blanco + "AUTO" en rojo, sobre fondo negro. En fondos claros, "PRO" pasa a negro. El logo se usa en header de la app, favicon, splash de la app móvil y encabezado de reportes y tickets impresos.

**Estilo de interfaz: "ejecutivo claro"** — fondo blanco/gris muy claro, estructura en negro (header, sidebar, tablas), UN solo acento naranja usado con moderación en acciones primarias, rojo reservado exclusivamente para acciones críticas y alertas. Sin decoración excesiva ni multiplicidad de colores: aspecto de software bancario/profesional.

**Paleta oficial PROAUTO — cuatro colores base:**

| Uso | Color | Hex |
|---|---|---|
| **Primario** — botones principales, links, badges activos | Naranja PROAUTO | `#F26522` |
| **Acento fuerte** — CTAs destacadas, hero highlights, botones destructivos, alertas críticas | Rojo PROAUTO | `#DC1F26` |
| **Base oscura** — header, sidebar, footer, hero | Negro logo | `#0A0A0A` |
| **Superficie** — cards, modales, contenedores | Blanco | `#FFFFFF` |
| Fondo principal (canvas) | Gris muy claro | `#F5F5F7` |
| Texto principal | Casi negro | `#111111` |
| Texto secundario | Gris medio | `#6B7280` |
| Bordes / divisores | Gris tenue | `#E5E7EB` |
| Éxito (funcional) | Verde profundo | `#059669` |
| Advertencia (funcional) | Ámbar | `#F59E0B` |

**Reglas de uso profesional:**
- El **naranja** manda todas las acciones primarias del día a día (guardar, cobrar, crear OT).
- El **rojo** se reserva para lo importante: eliminar, anular, alertas críticas, badges de "urgente" o "vencido". No abusar, mantiene su peso.
- El **negro** estructura la interfaz: header con logo, sidebar de navegación, tablas de datos densas.
- El **blanco** respira. Nada de rellenar todo con colores.
- Combinaciones prohibidas: naranja sobre rojo, rojo sobre naranja. Siempre neutro entre medio.

**Modo oscuro opcional** con fondo `#0A0A0A`, superficies `#1A1A1A`, texto `#F5F5F7`, acentos naranja y rojo iguales.

**Tipografía:** Inter o Manrope. Alto contraste. Botones grandes (uso en taller, manos con grasa). Iconografía Lucide o Phosphor Icons.

---

## 3. Roles y permisos

| Rol | Acceso | Restricciones clave |
|---|---|---|
| **Administrador (dueño)** | Total. Ve reportes financieros, configura reglas, aprueba correcciones, gestiona personal y cierres mensuales. | Único que puede modificar registros de asistencia, anular movimientos de caja y reabrir cierres. |
| **Personal de caja / repuestos** | Registra ingresos, gastos de caja chica, órdenes de trabajo, ventas de repuestos, movimientos de inventario, cierre diario. | No edita histórico. Sus correcciones quedan como solicitudes al admin. No ve gastos externos del admin ni reportes financieros globales. |
| **Mecánico / Tornero (solo móvil)** | Login propio. Ve órdenes asignadas, marca avance, sube fotos, registra observaciones y repuestos usados, marca "cliente conforme" al entregar. | No ve montos, precios ni reportes. Solo su trabajo. |

**Autenticación por PIN de 4 dígitos:** cada colaborador elige su nombre en la pantalla de acceso y teclea su PIN (rápido para el ritmo del taller). El administrador crea/edita/desactiva usuarios y resetea PINs. Opcional: desbloqueo con la huella del propio celular (biometría del dispositivo, sin costo) y 2FA para el administrador. Toda acción sensible queda en **bitácora de auditoría** (usuario, acción, fecha/hora, IP/dispositivo).

**Navegación lateral agrupada por prioridad** con iconografía coherente por sección: (1) Operación diaria — panel del día, órdenes, tablero, caja; (2) Registros — base de datos de atenciones, reporte diario, inventario, clientes; (3) Administración — control de asistencia, finanzas y ratios, cierre de caja.

Auto-logout de la PC de caja tras 10 min de inactividad.

---

## 4. Módulos del sistema

### 4.1 Caja — modelo de dos niveles

**Caja chica (opera la cajera, diaria):**
- **Ingresos** del día por área (Tornería / Mecánica / Repuestos), vinculados a OT o venta de mostrador.
- **Gastos operativos diarios** que hace la cajera: compras urgentes de repuestos, alimentación a los trabajadores, pagos a prestamistas informales, servicios menores, etc.
- **Cierre diario** cuadrando efectivo, transferencias y Yape/Plin contra el saldo teórico.
- Una vez cerrada, la caja queda bloqueada. Solo el admin la reabre con motivo.

**Caja principal / Administración (opera el admin, mensual):**
- Consolidado mensual de todas las cajas chicas.
- **Gastos fijos externos** del admin: arriendo, luz, agua, internet, sueldos, mantenimiento del local, impuestos, etc. Se programan como recurrentes y se auto-generan cada mes.
- **Cierre mensual**: bloquea el período. Genera estado de resultados básico del mes.

**Ingresos — campos:**
- Fecha/hora automática (servidor).
- Área (obligatorio).
- Cliente (obligatorio en mecánica, opcional en repuestos de mostrador).
- Descripción / concepto.
- Monto.
- Método de pago: **Efectivo / Yape / Plin / Transferencia bancaria** — si es transferencia, se registra el banco (**BCP, Interbank, BBVA**, extensible).
- Cantidad, precio unitario y total calculado (formato de caja registradora).
- OT vinculada (si aplica).
- Usuario que registró.

**Gastos de caja chica — campos:**
- Fecha/hora automática.
- **Categoría obligatoria** (nomenclatura profesional): compra de repuestos e insumos, **subvención alimentaria** (con selector del colaborador beneficiario — permite reporte mensual por trabajador), pago de préstamos (prestamistas), servicios de terceros, mantenimiento del taller, otros gastos operativos.
- **Área a la que corresponde el egreso** (Tornería / Mecánica / Repuestos / General) — permite el consolidado por área en el reporte diario.
- Beneficiario (persona/negocio).
- Descripción.
- Monto.
- Método de pago.
- **Foto del comprobante** (obligatoria si supera un umbral configurable).
- **Aprobación del admin** requerida si el monto supera un tope (ej. $100). La cajera lo registra pero queda "pendiente" hasta que el admin apruebe desde su celular.

**Prestamistas informales** (personas que prestan dinero, no venden mercadería — ej. señora Ofelia):
- Ficha simple: nombre, contacto, notas.
- Registro de deudas pendientes: monto, motivo, fecha.
- Cuando la cajera paga, se descarga la deuda automáticamente.
- Reporte de "cuánto debemos y a quién" para el admin.
- **Nota:** categoría claramente separada de "proveedores" (los que sí venden repuestos o insumos, formales o informales).

**Cierre de caja diario — flujo:**
1. Cajera hace "Cierre" al final del día.
2. Sistema calcula: saldo inicial + ingresos por método − gastos por método = **saldo teórico** por método.
3. Cajera cuenta el físico y digita: efectivo contado, transferencias confirmadas, Yape/Plin recibidos.
4. Sistema muestra **diferencia (sobrante / faltante)** por método.
5. Si la diferencia supera un umbral configurable, obliga a **justificar** con nota.
6. Genera **reporte PDF** del cierre (movimientos, cuadre, diferencia, firma). Para imprimir y archivar.
7. Caja queda bloqueada.

**Restricciones globales:**
- No hay fechas retroactivas sin permiso de admin.
- Hora del servidor, no de la PC local.
- Zona horaria: America/Lima. Moneda: S/ (soles).

### 4.2 Órdenes de trabajo (Tornería y Mecánica)

**Flujo de estados:**

```
INGRESO → COTIZACIÓN → APROBADA → EN PROCESO → TERMINADA → ENTREGADA / PAGADA
```

**Al ingresar el trabajo — máxima eficiencia, mínimo tipeo:**

- Número correlativo automático (ej. OT-2026-0001).
- Área (Tornería / Mecánica) — pre-seleccionada según el contexto.

**Cliente — autocompletado por DNI/RUC (solo se digitan DNI y placa):**
- La cajera teclea (o escanea) el **DNI (8 dígitos) o RUC (11 dígitos)** y el sistema:
  1. Busca primero en la **base de datos local** de clientes recurrentes → si existe, autocompleta nombre, teléfono, vehículos asociados. **Cero tipeo adicional.**
  2. Si no existe, consulta una **API de RENIEC (DNI) o SUNAT (RUC)** → autocompleta el nombre. La cajera solo agrega teléfono y guarda.
- Validación automática del formato de DNI/RUC (evita errores de digitación).
- El cliente queda registrado con un solo movimiento.
- **En Mecánica los únicos datos que se digitan son DNI y placa** — todo lo demás lo completa el sistema.
- **En Tornería:** DNI o nombre del cliente (flexible), pero son obligatorios: **trabajo a realizar, precio acordado y fecha de entrega**.

**Vehículo (solo mecánica) — placa como llave, marca visual automática:**
- La cajera (o el mecánico desde móvil) teclea o **escanea la placa con OCR de cámara**.
- Si el vehículo ya existe en el sistema → autocompleta marca, modelo, año, color, historial de servicios. **Cero tipeo.**
- Si es nuevo:
  - Marca: **dropdown con logo visual de cada marca** (Toyota, Chevrolet, Kia, Hyundai, Ford, Nissan, Mazda, Volkswagen, Renault, etc.). Al elegir, el **logo de la marca aparece en la ficha del vehículo y en la tarjeta de la OT** en todos lados donde se muestre.
  - Modelo: dropdown filtrado según la marca seleccionada (base de datos local de modelos comunes en Perú).
  - Año, color, kilometraje: rápidos, con valores por defecto sugeridos.
- Opción **decodificador de VIN**: tecleando el VIN (17 caracteres) o escaneando el código, la API pública NHTSA devuelve marca, modelo, año, motor. Un paso, cero errores.

**Al ingreso (obligatorio en mecánica):**
- Foto del odómetro (obligatorio, desde cámara del móvil).
- Nivel de combustible (dropdown: E / ¼ / ½ / ¾ / F).
- Accesorios visibles marcados por checkbox (radio, tapetes, herramientas, gata, triángulos, etc.) — no se escribe, se marca.
- Blinda contra reclamos.

**Cierre del alta:**
- Descripción del trabajo solicitado (con **sugerencias del catálogo de servicios frecuentes** — pocos clics).
- Maestro asignado (dropdown con foto y nombre).
- Fecha estimada de entrega (con calendario, por defecto +2 días).

**Meta de tiempo de alta de OT:** menos de **90 segundos** para un cliente recurrente, menos de **3 minutos** para un cliente nuevo.

**Alta de OT en Tornería (flujo simplificado, sin vehículo):**
- Cliente por cédula (mismo autocompletado).
- **Pieza que trae**: dropdown de tipos comunes (cigüeñal, eje, biela, engranaje, tambor de freno, disco, buje, tornillo especial, otro).
- **Foto de la pieza** desde el móvil (reemplaza descripción escrita).
- Trabajo solicitado: dropdown del catálogo de tornería (rectificar, tornear, roscar, soldar, ajustar medida, fabricar).
- Medidas críticas (campos numéricos rápidos).
- Maestro tornero asignado.
- Estimado de entrega.

**Cotización:** el maestro cotiza con el cliente; se registra mano de obra + repuestos estimados. Pasa a APROBADA cuando el cliente acepta (aprobación verbal marcada o mediante link enviado por WhatsApp).

**Cotizaciones no aprobadas:** quedan guardadas con **recordatorio automático a los 3 días** para dar seguimiento telefónico.

**En proceso:** el mecánico/tornero desde su móvil marca avance, agrega notas técnicas, **descuenta repuestos del inventario al usarlos** (se suma al costo real de la OT) y sube fotos del avance.

**Trabajos externos subcontratados:** si se manda algo a soldar/pintar afuera, se registra el costo dentro de la OT como línea aparte.

**Terminada:** el mecánico marca desde su celular:
- Botón **"Cliente conforme — trabajo terminado"**.
- Escribe nombre de quien retira.
- Sube foto del auto entregado (evidencia digital, reemplaza firma en tablet que aún no se tiene).
- La OT pasa a ENTREGADA con hora y usuario registrado.

**Pago:** al cobrar, el ingreso se registra automáticamente en caja del día vinculado a la OT.
- **Pagos parciales / abonos** permitidos: si el cliente paga la mitad, queda saldo en cuentas por cobrar hasta liquidar.

**Impresión:** dos formatos —
- (a) Comprobante para el cliente con datos, trabajo, valor y **QR de estado**.
- (b) Orden interna para el taller con detalle técnico y repuestos.

**QR del estado (portal público):** cada OT tiene un QR/link. El cliente lo abre en su celular y ve sin login: "Su auto está EN PROCESO. Mecánico: Juan. Estimado: hoy 4pm." Reduce llamadas.

**Garantías:** cada trabajo entregado tiene garantía configurable (30/60/90 días). Si el cliente vuelve dentro del plazo por el mismo problema, alerta automática y no se cobra. Registra qué mecánico hizo el trabajo original.

### 4.3 Inventario de repuestos

- **Ficha de producto:** código interno, código de barras, nombre, marca, categoría, ubicación en bodega, stock actual, stock mínimo (alerta), costo, precio de venta, proveedor habitual.
- **Lector de código de barras USB (HID)** para venta y recepción de mercadería.
- **Movimientos:** entrada (compra), salida (venta mostrador o consumo en OT), ajuste (inventario físico), devolución.
- **Kardex por producto** con costo promedio ponderado.
- **Historial de precios versionado**: cuando cambias un precio queda registro con fecha.
- **Alerta automática** de stock bajo mínimo en dashboard del admin.
- **Inventario físico periódico:** reporte para conteo, ingreso de diferencias justificadas.
- **Devoluciones** de repuestos (mostrador y proveedor) con motivo y afectación a stock/caja.
- **Proveedores** (informales por ahora): ficha simple (nombre, contacto, productos que provee). Claramente distintos de "prestamistas".

### 4.4 Control de asistencia y personal

**Ficha del empleado (RRHH básico):**
- Nombre completo, cédula, cargo (tornero / mecánico / cajera / admin), área.
- Fecha de ingreso, sueldo base.
- Contacto de emergencia.
- Foto.
- **ID de huella asignado** (vincula al lector biométrico).
- Estado activo/inactivo (baja lógica: no se borra al salir, se preserva historial).

**Marcaciones por huella:**
- Entrada, salida a almuerzo, retorno de almuerzo, salida final.
- Horario estándar: **08:00 – 18:00**. Almuerzo **45 min a 1 h** (configurable por empleado).

**Cálculo automático:**
- **Atrasos** (minutos post hora entrada, con tolerancia configurable).
- **Salidas anticipadas.**
- **Faltas** (día sin marcación).
- **Horas extra** (marcación post horario, requieren aprobación del admin para contabilizar).

**Reglas de descuento configurables por el admin:**
- Valor del minuto de atraso.
- Valor de la falta.
- Tope mensual de descuento.

**Vistas del módulo:**
- **Marcaciones del día:** tabla con entrada, salida a refrigerio, retorno, salida, tardanza en minutos y descuento calculado por colaborador.
- **Matriz consolidada** (formato cuadro general, no tarjetas): filas = colaboradores, columnas = días de la semana/mes; cada celda muestra hora de entrada y tardanza. Columnas de resumen: total tardanzas (min), faltas, descuento acumulado. Navegable semana a semana y mes a mes — pensada para análisis día tras día.
- **Reporte mensual por colaborador** con: días trabajados, tardanzas totales, faltas, horas extra, descuento sugerido.

**Rol de pagos informativo** (mensual):
- Sueldo base − descuentos + horas extra aprobadas = **neto a pagar en efectivo**.
- **No genera boletas de pago ni cálculos de planilla por ahora** (nadie está en planilla, todo informal).
- Cuando el negocio se formalice, se activa el módulo de planilla completo (EsSalud, AFP/ONP, gratificaciones, CTS, boletas de pago electrónicas).

**Inmutabilidad:** registros de asistencia solo modificables por el admin, con motivo en bitácora.

**Vinculación productividad:** reporte de cuántas OT completó cada mecánico/tornero por mes, tiempo promedio por trabajo, ingresos generados.

### 4.5 Clientes y vehículos

- **Ficha de cliente:** nombre, cédula/RUC, teléfono, email, vehículo(s) asociado(s). Alta y búsqueda por cédula con autocompletado (BD local + API SRI Perú).
- **Ficha por vehículo** (persistente aunque cambie de dueño): placa, VIN, marca, modelo, año, color, historial de km, todas las OT realizadas.
- **Logo de la marca visible en todas partes**: ficha del vehículo, tarjeta de la OT en el kanban, portal público de estado, comprobante impreso, historial. Refuerza identidad visual y hace escaneable la información.
- **Recordatorio de próximo mantenimiento**: al entregar el auto, sistema calcula próximo servicio por km o meses. Cuando toque, aparece en la lista de "clientes por contactar" para que la cajera les mande WhatsApp desde el sistema.
- Búsqueda rápida universal (barra superior): teclea cédula, placa o nombre → resultados instantáneos.
- Marcado de clientes frecuentes / morosos.

### 4.6 Servicios frecuentes (catálogo)

Base de datos de servicios estandarizados con precio y tiempo estimado:
- "Cambio de aceite", "Cambio de pastillas", "Rectificación de disco", "Torneado de cigüeñal", etc.
- Al crear una OT, la cajera selecciona del catálogo y se autocompleta precio y tiempo.
- El admin edita/agrega servicios y precios.
- Menos improvisación en cotizaciones.

### 4.7 Agenda de citas

- Calendario visual con vista día/semana.
- Cliente reserva (por teléfono → cajera agenda) o el admin bloquea horarios.
- Vista por mecánico: qué auto está asignado a quién y cuándo.
- Evita saturación del taller.
- **Recordatorio automático** al cliente la noche anterior vía link wa.me.

### 4.8 Panel de bahías (kanban visual)

Vista tipo tablero: columnas por estado (ingreso → cotización → en proceso → terminado). Cada tarjeta es una OT con placa, mecánico y tiempo transcurrido. El admin ve el pulso del taller desde su celular en 2 segundos.

### 4.9 WhatsApp integrado (SIN COSTO — vía `wa.me`)

- El sistema **NO usa WhatsApp Business API** (que cuesta).
- Genera automáticamente **links `wa.me/número?text=mensaje-pre-escrito`**.
- La cajera ve un botón "Avisar por WhatsApp" en cada OT, cliente o encuesta.
- Al hacer clic se abre WhatsApp Web (o la app en móvil) con el mensaje listo — solo aprieta enviar.
- **Costo: $0/mes**. Semi-manual pero funcional.

**Usos:**
- Avisar al cliente que su auto está listo.
- Enviar cotización para aprobación.
- Enviar recordatorio de cita.
- Enviar link de encuesta post-servicio.
- Enviar recordatorio de próximo mantenimiento.

### 4.10 Encuesta de satisfacción (mismo día)

- Al marcar la OT como ENTREGADA, el sistema **genera un link de encuesta corto**.
- Se envía al cliente el **mismo día**, por wa.me, con un clic desde la vista de la OT.
- Cliente accede sin login: rating 1–5 estrellas + comentario opcional.
- Resultados agregados en dashboard del admin: promedio por mecánico, por área, por mes.
- Detecta problemas de calidad temprano.

### 4.11 Reportes y dashboards

**Dashboard admin (pantalla principal):**
- Ingreso del día por área (barras).
- Gasto del día (caja chica).
- Utilidad bruta del día.
- OTs abiertas por estado.
- Alertas: stock bajo, cierre pendiente, atrasos, gasto pendiente de aprobación, cliente con saldo antiguo.

**Reportes operativos:**
- **Reporte diario de caja** (imprimible al cierre): movimientos, cuadre por método, diferencia.
- **Reporte por período** (semana, mes, rango): ingresos vs gastos por área, top clientes, top repuestos vendidos.
- **Reporte de asistencia mensual** por empleado.
- **Reporte de productividad** por mecánico/tornero (OT completadas, tiempo promedio, ingresos generados).
- **Reporte de cuentas por cobrar** (OT entregadas con saldo).
- **Reporte de inventario valorizado** con rotación.
- **Reporte de rentabilidad por OT**: precio cobrado − costo repuestos − mano de obra estimada = utilidad.
- **Reporte de deudas a prestamistas informales.**
- **Reporte de encuestas de satisfacción**: promedio por mecánico, tendencia mensual.

**BI del admin:**
- Ticket promedio por área.
- Comparativo mes actual vs mismo mes año anterior.
- Ranking de servicios más vendidos.
- Ranking de mecánicos por productividad e ingresos.
- Días de la semana con más demanda.
- Ciclo promedio de OT (días entre ingreso y entrega).

**Flujo de caja y ratios financieros (automáticos desde los cierres):**
- Cada **cierre de caja diario alimenta automáticamente el flujo de caja** del administrador — sin doble digitación.
- Vista por **día / semana / mes**: ingresos, egresos, flujo neto, acumulado, estado del cierre.
- **Ratios calculados automáticamente:** margen bruto, margen neto, ROI mensual (utilidad / capital invertido), cobertura de caja (días de operación que cubre el efectivo disponible), ticket promedio, punto de equilibrio diario, crecimiento vs periodo anterior, total de cuentas por cobrar.
- **Reporte diario consolidado de caja:** matriz de ingresos por área (Tornería/Mecánica/Repuestos) × método de pago (Efectivo/Yape/Plin/Transferencia con detalle por banco), egresos por área y neto por área. Imprimible al cierre.
- **Vista "negocio en vivo" para el dueño (móvil):** ingresos del día al momento, trabajos en curso por estado, última actividad de caja y avisos — sin necesidad de estar en el taller.

Todos los reportes exportables a Excel y PDF.

**Alertas push al admin** (en su celular): diferencia grande en cierre, stock crítico, cliente con saldo pendiente, gasto pendiente de aprobación.

---

### 4.12 Base de datos de atenciones (por área)

- Registro histórico central de **todo lo atendido** en Mecánica, Tornería y Repuestos, con pestañas por área.
- Cada orden o venta creada desde **web o móvil** llega automáticamente a esta base — una sola fuente de verdad.
- **El mecánico/tornero puede registrar la orden de trabajo directamente desde su celular** (cliente por DNI, placa o pieza, trabajo, precio y fecha de entrega); la orden queda a su nombre y pasa al instante a la base de datos central y al tablero.
- Búsqueda y filtros por fecha, cliente, responsable, estado. Exportable a Excel.

### 4.13 Motivación del personal

- **Saludo personalizado con frase del día** al iniciar sesión ("Buenos días, Luis. Hoy es un buen día para hacer un gran trabajo.").
- **Frase del día** visible en el panel web y en la cabecera de la app móvil (banco de frases editable por el administrador).
- **Reconocimiento al colaborador en su móvil**: "5 trabajos terminados esta semana — excelente ritmo".
- **Ranking amistoso mensual** de órdenes completadas visible en el panel del día — motiva sin presionar; el detalle fino de productividad queda en el módulo de finanzas del administrador.

## 5. Requisitos técnicos

### Plataforma
- **Aplicación web** responsiva (PC de caja y admin).
- **App móvil** (iOS + Android) con **perfiles separados por rol**: mecánico (órdenes de mecánica), tornero (trabajos de tornería), personal de repuestos, y **dueño/administrador con vista "negocio en vivo"**. Usos principales:
  - **Mecánicos/torneros:** ver OT asignada, marcar avance, subir fotos, descontar repuestos, marcar "cliente conforme". Debe funcionar **offline** y sincronizar al recuperar red.
  - **Captura de datos del auto al ingreso** (usada por cajera o mecánico): placa, marca, modelo, año, km, conductor, fotos.
- Sugerido: **React Native** o **Flutter** (código compartido iOS/Android).

### Stack sugerido (open source, económico)
- **Backend:** Node.js (NestJS) o Python (Django/FastAPI). **PostgreSQL** como BD.
- **Frontend web:** React + Tailwind (con la paleta PROAUTO configurada).
- **Móvil:** React Native o Flutter.
- **Hosting:** VPS en nube (DigitalOcean, Hetzner, AWS Lightsail) ~$10–20 USD/mes.
- **Backups automáticos diarios** a almacenamiento externo, con **prueba de restauración semanal**.
- **HTTPS** obligatorio (Let's Encrypt gratis).
- **Auth:** JWT + bcrypt. 2FA opcional (TOTP) para admin.

### Integraciones
- **Huella dactilar:** SDK del fabricante. Un servicio local en la PC de caja envía marcaciones al servidor.
- **Lector de código de barras:** USB HID (sin driver, se comporta como teclado).
- **Impresora térmica** (58/80 mm, ESC/POS) para cierre de caja y OT.
- **WhatsApp:** solo links `wa.me` (sin API pagada).

### No funcionales
- Idioma: **español**.
- Zona horaria: **America/Lima**. Moneda: **S/ (soles)** en toda la interfaz, reportes y tickets.
- Modo offline mínimo en app móvil de mecánicos.
- Bitácora de auditoría en todas las tablas críticas.
- Preparado para **multi-sucursal** desde el modelo de datos.

---

## 6. Hardware recomendado (económico, compatible)

### Lector de huella dactilar
- **Recomendado: ZKTeco SLK20R** (~$45–70 USD). SDK gratuito, muy usado en Perú.
- Alternativa: **Digital Persona U.are.U 4500** (~$40 USD), SDK gratuito.

### Lector de código de barras
- **Cualquier lector USB tipo HID** de $20–40 USD (Honeywell, Zebra, Netum o genérico chino). Soporte EAN-13, Code 128, QR.

### Impresora térmica (recomendada)
- **Xprinter XP-58** o XP-80 (~$40–60 USD), compatible ESC/POS.

### PC de caja
- Windows 10+ o Linux, 4 GB RAM, internet estable.

---

## 7. Flujo de un día típico (validación de diseño)

1. **08:00** — Los 5 empleados marcan huella al llegar. Sistema calcula atrasos automáticamente.
2. Cajera abre caja con **saldo inicial** del día (fondo de caja).
3. Llega cliente con vehículo → cajera (o mecánico desde móvil) crea OT en Mecánica, asigna maestro, sube fotos de ingreso (odómetro, combustible, accesorios), cotiza.
4. Cliente aprueba → OT pasa a APROBADA. Mecánico ve la OT en su celular.
5. Mecánico consume repuestos → los escanea desde su móvil → stock se descuenta y suma al costo de la OT.
6. Mecánico marca TERMINADA → "Cliente conforme", nombre de quien retira, foto del auto entregado.
7. Cliente paga (efectivo + transferencia) → cajera cobra, imprime ticket con QR, OT pasa a PAGADA.
8. **Mismo día**: cajera hace clic en "Enviar encuesta" → wa.me abre WhatsApp con el link listo, envía.
9. Paralelo: clientes de mostrador de repuestos → cajera escanea código de barras, cobra, stock se descuenta.
10. Gastos del día: la cajera registra en **caja chica** con categoría y foto del comprobante.
11. **18:00** — Todos marcan huella de salida.
12. Cajera hace **cierre de caja**: cuenta físico por método, sistema muestra diferencia, imprime reporte. Caja bloqueada.
13. Admin desde su celular ve dashboard con ingresos, gastos, alertas y encuestas del día.
14. **Fin de mes:** admin ejecuta cierre mensual, registra gastos externos (arriendo, luz, etc.), genera estado de resultados y roles de pago informativos.

---

## 8. Fases de implementación

### **Fase 1 — MVP (4–6 semanas). Web + captura móvil.**
- Login y roles.
- Personal (ficha básica).
- Caja diaria dos niveles (chica + principal) con ingresos, gastos categorizados, prestamistas, cierre diario cuadrado.
- Órdenes de trabajo con flujo completo, catálogo de servicios, historial por vehículo.
- Inventario con lector de código de barras.
- App móvil mínima para: captura de datos del auto al ingreso + mecánicos marcando avance y "cliente conforme".
- Impresión de OT y cierre de caja.
- Portal público de estado con QR.
- Reportes básicos.
- Paleta y logo PROAUTO integrados.

### **Fase 2 — Asistencia y comunicación (3–4 semanas).**
- Asistencia biométrica con cálculo de atrasos, faltas y extras.
- Rol de pagos informativo mensual.
- Panel de bahías (kanban).
- Agenda de citas.
- Integración wa.me para avisos, cotizaciones y encuestas.
- Encuesta de satisfacción post-servicio.
- Recordatorio de próximo mantenimiento.
- Cierre mensual del admin con gastos fijos recurrentes.

### **Fase 3 — Analítica y garantías (3–4 semanas).**
- Dashboard BI completo del admin.
- Reportes de rentabilidad por OT.
- Módulo de garantías con seguimiento.
- Módulo de reclamos/posventa.
- Alertas push al celular del admin.
- Alertas de cotizaciones no aprobadas (3 días).

### **Fase 4 — Formalización (cuando el negocio dé el salto).**
- Módulo de planilla completo (EsSalud, AFP/ONP, gratificaciones, CTS, boletas de pago).
- Retenciones tributarias (IGV, Renta) y exportación PLE para SUNAT.
- Órdenes de compra formales a proveedores con factura.
- Control de EPP y capacitaciones.
- Cotización a múltiples proveedores.
- Puente al sistema de facturación SRI existente (evitar doble digitación).

---

## 9. Entregables esperados del diseñador/desarrollador

1. **Modelo de datos (ERD)** completo con todas las tablas y relaciones.
2. **Wireframes** de las 10–12 pantallas principales:
   - Login
   - Dashboard admin
   - Vista de caja (cajera)
   - Alta y detalle de OT
   - Vista de inventario y venta con código de barras
   - Cierre de caja diario
   - Personal y asistencia
   - Ficha de vehículo con historial
   - App móvil del mecánico
   - Captura de datos del auto en móvil
   - Portal público de estado (QR)
   - Reportes / BI
3. **Manual de estandarización de procesos** (procedimiento del cajero, del mecánico, del admin, del cierre diario y mensual).
4. **Especificación técnica (SRS)** para desarrollo.
5. **Estimación de tiempo y costo** por fases en USD.
6. **Plan de migración** desde el cuaderno actual (qué datos históricos cargar, cuáles no).
7. **Plan de capacitación** para cajera, mecánicos y admin.

---

## 10. Eficiencia y experiencia de uso (principios de diseño UX)

El sistema tiene que ser **más rápido que el cuaderno**. Si un proceso toma más tiempo en el software que a mano, el software falló. Estas reglas son obligatorias:

**Reducción radical de tipeo:**
- **Cédula → todo el resto se autocompleta** (nombre por SRI, vehículos, historial). La cajera solo digita cédula + teléfono la primera vez; después, cero tipeo.
- **Placa → vehículo completo** (marca con logo, modelo, año, historial). Si el auto ya vino antes, se recuerda todo.
- **Código de barras → producto y precio**. Sin buscar en lista.
- **Escaneo con cámara** para placa (OCR), VIN (código de barras del parabrisas), comprobantes de gasto.
- **Fotos reemplazan descripciones** siempre que se pueda (pieza de tornería, estado del auto, comprobante).

**Autocompletado y valores por defecto:**
- Todos los dropdowns con búsqueda incremental (typeahead).
- Valores por defecto inteligentes: fecha estimada de entrega +2 días, método de pago = efectivo, área = la última usada, etc.
- Catálogo de servicios frecuentes en un clic (mecánica y tornería) con precio y tiempo pre-cargados.
- Sugerencias contextuales: si el auto tiene 10 000 km desde el último cambio de aceite, sugerir el servicio.

**Atajos de teclado para la cajera:**
- `F2` nueva OT · `F3` nueva venta de repuestos · `F4` nuevo gasto · `F5` cobrar OT · `F9` cierre de caja · `Ctrl+B` búsqueda global.

**Menos clics, más contexto:**
- Barra de búsqueda global siempre visible (arriba): cédula, placa, nombre, número de OT, código de repuesto. Un solo campo para todo.
- Vista principal del día siempre a un clic desde cualquier pantalla.
- Acciones frecuentes como botones grandes en el dashboard (no ocultas en menús).

**Identidad visual permanente:**
- **Logo de la marca del auto** visible en toda pantalla, ticket y reporte donde aparezca un vehículo (ficha, OT, kanban, portal público, encuesta, comprobante impreso).
- Logo PROAUTO fijo en header, favicon, splash móvil y encabezado de todo documento impreso.
- Paleta oficial aplicada consistentemente: naranja para acciones, rojo para críticos, negro para estructura, blanco para respirar.

**Metas medibles del sistema:**
- Alta de OT (cliente recurrente): **< 90 segundos**.
- Alta de OT (cliente nuevo): **< 3 minutos**.
- Cobro y cierre de venta de repuestos con código de barras: **< 30 segundos**.
- Cierre de caja diario completo: **< 5 minutos**.
- Marcación de "cliente conforme" en móvil del mecánico: **< 20 segundos**.

---

## 11. Principios innegociables

1. **Cuadre absoluto del cierre diario** con la caja física. Sin excepciones.
2. **Asistencia inmutable.** Solo el admin corrige, con motivo en bitácora.
3. **Cero costo recurrente en comunicación** (usar `wa.me`, no API pagada).
4. **Más rápido que el cuaderno.** Cada pantalla se diseña midiendo tiempo real de uso, no solo estética.
5. **Diseño para uso en taller**: botones grandes, alto contraste, manos con grasa.
6. **Preparado para formalizarse:** los módulos formales existen desactivados y se activan cuando la empresa dé el salto.
7. **Identidad PROAUTO consistente**: paleta oficial (naranja, rojo, negro, blanco) y logo de marca visible en toda referencia a un vehículo.
