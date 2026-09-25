# PROAUTO — Documentación completa del software
### Sistema de Gestión Integral · Tornería · Mecánica · Repuestos
*Versión 1.0 (etapa piloto en servidor) · Perú · Moneda: S/ (soles) · Zona horaria: America/Lima*

---

## 1. Ficha general

| Aspecto | Definición |
|---|---|
| Empresa | PROAUTO — taller de mecánica automotriz, tornería y venta de repuestos (Perú) |
| Objetivo | Reemplazar el control en cuaderno por una plataforma en la nube: caja diaria que cuadre con el físico, órdenes de trabajo, inventario, asistencia, pagos al personal y finanzas del administrador |
| Meta estratégica | Formalizar el negocio poco a poco; los módulos tributarios/planilla existen desactivados hasta que la empresa dé el salto |
| Plataforma | Aplicación web (PC de caja / administrador) + la misma app en celulares como PWA ("Añadir a pantalla de inicio") |
| Facturación | El software NO emite comprobantes SUNAT; convive con el sistema de facturación existente |
| Costo mensual de operación | S/ 0 (Supabase gratis + Netlify gratis) |

## 2. Arquitectura (versión servidor)

- **Base de datos:** Supabase (PostgreSQL en la nube, región São Paulo). Los datos NO viven en el local: la PC del taller y el celular del dueño hablan directo con el servidor. Solo se necesita internet y un navegador.
- **Publicación:** el archivo `proauto-servidor.html` se sube a Netlify Drop → dirección web propia (ej. `proauto.netlify.app`) accesible desde cualquier lugar.
- **Sincronización:** guardado automático cada 5 segundos al servidor; refresco entre dispositivos cada 10 segundos; caché local si se cae el internet (sincroniza al volver). Indicador visible: "● Conectado al servidor".
- **Conexión por dispositivo:** la primera vez, cada equipo pega la URL del proyecto Supabase y la clave anon (Settings → API). Se guarda y no se vuelve a pedir.
- **Respaldo:** botón del administrador "Descargar respaldo (.json)" — recomendado cada sábado, además de la nube.
- **Esquema piloto:** tabla única `taller_datos` (JSON) creada con `proauto-esquema.sql`. Migración futura a tablas normalizadas sin pérdida de datos.
- **Seguridad de la etapa piloto:** accede quien tenga URL + clave anon; compartirla solo con el personal. Fase futura: Supabase Auth con políticas por rol.

## 3. Usuarios, roles y acceso

**Personal registrado:**

| Nombre | Cargo | Rol en el sistema | Esquema de pago |
|---|---|---|---|
| Tony | Administrador · Dueño | Acceso total (web + vista móvil "Negocio en vivo") | — |
| Karina | Asesora de Servicio | Operación diaria (elige Escritorio o Móvil al entrar) | Semanal |
| Nelson | Técnico Automotriz | App móvil — sus órdenes de mecánica | Semanal |
| Carlos | Técnico Automotriz | App móvil — sus órdenes de mecánica | Semanal |
| Gabriela | Técnica en Tornería | App móvil — sus trabajos de tornería | 35% de producción diaria |
| Aldair | Técnico en Tornería | App móvil — sus trabajos de tornería | 35% de producción diaria |

**Acceso:** pantalla de portada (logo animado con brillo, marcas de autos desfilando con emblema y nombre, botón INGRESAR) → selección de usuario → contraseña.
- **Primera vez:** cada colaborador crea su propia contraseña (mínimo 4 caracteres) + registra correo o celular de recuperación.
- **Olvido:** el administrador la restablece con el botón "Rest. clave" en Control de asistencia; el colaborador crea una nueva al ingresar.
- **Permisos:** el técnico no ve montos de caja ni reportes; la asesora no edita histórico ni asistencia; solo el administrador ve Finanzas, Pagos al personal y puede corregir registros (con motivo en bitácora en la versión completa).

## 4. Nomenclatura de documentos

| Código | Significado | Área |
|---|---|---|
| **OTI-M-0001** | Orden de Trabajo Interna — Mecánica | Vehículos |
| **OTI-T-0001** | Orden de Trabajo Interna — Tornería | Piezas |
| **OSI-R-0001** | Orden de Servicio Interna — Repuestos | Ventas de mostrador |

Cada serie lleva su propio correlativo. El sufijo de área permite distinguir el origen de un vistazo en reportes, caja y base de datos.

## 5. Módulos

### 5.1 Panel del día
Saludo personalizado con frase del día (21 frases motivacionales rotativas, una distinta por día). KPIs: ingresos del día (con desglose Tornería/Mecánica/Repuestos), egresos, resultado del día, órdenes abiertas. Avisos (trabajos por cobrar, stock crítico, tardanzas, cuentas por cobrar). Tarjeta "Reconocimientos del mes" (ranking amistoso de órdenes completadas). Tabla de órdenes activas.

### 5.2 Órdenes de trabajo
**Flujo de estados:** INGRESO → COTIZACIÓN → APROBADA → EN PROCESO → **POR COBRAR** → ENTREGADA.

**Alta eficiente (más rápido que el cuaderno):**
- **Mecánica:** solo se digitan **DNI y placa**. El DNI (8 dígitos) busca primero en la base propia y luego en RENIEC (autocompleta nombre); la placa recupera el vehículo y su historial completo. Cliente recurrente = cero tipeo.
- **Tornería:** DNI opcional o nombre; obligatorios **trabajo, precio acordado y entrega**. Foto de la pieza reemplaza la descripción escrita.
- **Varios trabajos en una misma orden:** líneas "+ Del catálogo" (con precio sugerido) y "+ No listado" (texto libre); el total se suma solo.
- **Entrega flexible:** "Hoy mismo" (en 1/2/3 horas, mediodía, 3 pm, 5 pm, fin del día), "Mañana" u "Otra fecha" (proyectos largos). La mayoría de trabajos del taller se entregan el mismo día.
- El **técnico puede registrar la orden desde su celular**; queda a su nombre y pasa al instante a la base de datos central.

**Cierre del trabajo:** el técnico presiona "✓ Finalizar trabajo" en su celular → puede escribir observaciones/recomendaciones para el cliente → **suena la alerta en caja** y la orden pasa a POR COBRAR (banner rojo: "el cliente debe pasar a caja"). La asesora cobra ("Cobrar y entregar", con pago mixto si hace falta) → recién ahí queda ENTREGADA con cliente conforme.

**Recomendaciones al cliente:** lo que el técnico redacta queda "pendiente de revisión"; la Asesora de Servicio lo revisa, lo ajusta si es necesario y lo envía por WhatsApp (link wa.me con mensaje pre-escrito, costo S/ 0). Nada llega al cliente sin su visto bueno.

### 5.3 Tablero de trabajos
Kanban por estado con tarjetas (orden, vehículo/pieza, cliente, responsable, precio). Las tarjetas POR COBRAR pulsan en rojo.

### 5.4 Caja del día
- **Ingresos** formato caja registradora: descripción, área, cantidad, precio unitario, total calculado.
- **Métodos de pago:** Efectivo, **Yape**, **Plin**, Transferencia (con banco: **BCP, Interbank, BBVA**).
- **Pago mixto:** cualquier cobro (orden o venta) puede dividirse entre métodos (ej. parte Yape, parte efectivo) con botón "resto" y validación "✓ Pago completo". Cada parte entra a caja por su método para que el cierre cuadre.
- **Egresos** con categoría profesional obligatoria: Compra de repuestos e insumos · **Subvención alimentaria** (con selector del colaborador beneficiario) · **Adelanto de sueldo a personal** (con colaborador) · **Pago de producción (35% torneros)** · Pago de préstamo (prestamista) · Servicios de terceros · Mantenimiento del taller · Otros. Cada egreso indica el **área a la que corresponde** y admite foto del comprobante.
- **Prestamistas informales** (personas que prestan dinero, ej. Sra. Ofelia): registro de deudas y pagos, separado de proveedores.
- Tarjetas de saldo por método en vivo. Paneles de trabajos por cobrar y de recomendaciones por revisar/enviar.

### 5.5 Pago de producción 35% (torneros)
Regla: **35% de lo cobrado por SUS trabajos del día, menos el material usado**. Al registrar el egreso "Pago de producción" y elegir a Gabriela o Aldair, el sistema muestra su producción cobrada hoy, el material consumido y el **pago sugerido (35% neto)** con botón "Usar sugerido". La asesora confirma el monto manualmente antes del cierre, como define el proceso del taller.

### 5.6 Cierre de caja diario
La asesora cuenta el físico por método → el sistema muestra la diferencia por método y total (verde cuadra / ámbar menor / rojo significativa, con justificación obligatoria) → al confirmar, la caja se bloquea y **alimenta automáticamente el flujo de caja del administrador**. Reporte imprimible.

### 5.7 Reporte diario consolidado
Matriz: filas por área (Tornería, Mecánica, Repuestos) × columnas por método (Efectivo, Yape, Plin, Transferencia) + total de ingresos, egresos y neto por área; fila de totales del día. Detalle de transferencias por banco. Resumen de atención: operaciones, órdenes del día, ticket promedio, entregados. Imprimible.

### 5.8 Base de datos de atenciones
Historial central de TODO lo atendido, con pestañas Mecánica / Tornería / Repuestos. Cada registro creado desde web o móvil llega automáticamente. Búsqueda y exportación a Excel.

### 5.9 Inventario
- **Repuestos (venta):** ficha con código de barras, stock, mínimo, precio. Pestañas **Disponibles / Agotados** (lo vendido sin stock no desaparece: queda en rojo listo para reponer).
- **POS con carrito:** campo de escaneo (el lector USB escribe el código y da Enter solo) o toque directo del producto; cantidades limitadas al stock; cobro con pago mixto; **el stock se descuenta al confirmar** y avisa si algo queda AGOTADO.
- **Kardex por producto:** historial completo de entradas y ventas (fecha, cantidad, precio, quién).
- **Lista de reposición sugerida:** agotados + bajo mínimo con cantidad de compra sugerida. Exportable.
- **Producto manual (sin código de barras):** alta con código interno **INT-0001** generado por el sistema (etiqueta imprimible). Botón **↥** por fila para registrar entradas de stock (reposiciones).
- **Materiales de taller (uso interno):** mini-inventario por área — Tornería (barra de acero, bocinas, soldadura, cuchillas) y Mecánica (aceite a granel, grasa, waype, sellador). Al **consumir** material se elige la orden: el costo se carga a la orden y, en tornería, **se descuenta automáticamente del 35% del tornero**.

### 5.10 Clientes
Ficha por DNI/RUC con teléfono, vehículos y visitas. Ficha por vehículo persistente (historial completo por placa). Búsqueda universal por DNI, placa, nombre u orden. Recordatorio de próximo mantenimiento (lista de "clientes por contactar" vía WhatsApp).

### 5.11 Chat del equipo
Grupo interno estilo WhatsApp, visible en web y en la pestaña "Equipo" del móvil. Todo el personal en el mismo canal.

### 5.12 Control de asistencia
- Marcación por huella **únicamente al ingreso y a la salida** (el refrigerio no se marca). Horario 08:00–18:00.
- **Marcaciones de hoy:** tabla con entrada, salida, tardanza y descuento calculado.
- **Matriz consolidada semanal:** filas = colaboradores, columnas = días; celda con hora de entrada, "+N" minutos de tardanza, "F" falta; columnas de resumen (tardanzas, faltas, descuento acumulado). Navegable semana a semana para análisis.
- **Regla configurable:** S/ 0.50 por minuto de tardanza, S/ 58.00 por falta.
- Registros **inmutables**: solo el administrador corrige, con motivo. Cada técnico ve su propio registro (solo lectura) en su perfil móvil.
- Mientras no llegue el lector: la asesora registra manual; al conectar el equipo biométrico las marcaciones pasan a ser automáticas.

### 5.13 Pagos al personal (administrador)
- Tabla por colaborador: esquema (35% diario / semanal), producción de hoy, pagado hoy, adelantos de la semana, descuentos por asistencia.
- **Historial automático** de pagos de producción y adelantos registrados en caja.
- **Cierre de semana:** base semanal + producción 35% − adelantos − descuentos = **neto a pagar por colaborador**; botón "Congelar semana y generar reporte" para el pago del sábado. El material de tornería descontado lo administra Dirección.

### 5.14 Finanzas y ratios (administrador)
- **Flujo de caja automático** desde los cierres, con vista Día / Semana / Mes y formato financiero: **periodos en horizontal**, conceptos hacia abajo (Ingresos, Egresos, Flujo neto, Acumulado, Estado del cierre).
- **Ratios:** margen bruto, margen neto, ROI mensual, cobertura de caja (días), ticket promedio, punto de equilibrio diario, crecimiento vs periodo anterior, cuentas por cobrar.
- **Análisis complementario:** participación por área (%), egresos por categoría, margen por área (mecánica / tornería neta de material y 35% / repuestos).
- Ingresos del mes por área y productividad por colaborador.

### 5.15 Cronograma de tareas
Funciones fijas del taller con responsable y día: limpieza del baño (diaria rotativa), barrido al fin de jornada, orden de herramientas, engrase de máquinas (lunes), residuos (mié/sáb), conteo de inventario (viernes), **limpieza profunda del sábado por la tarde (todo el equipo)**. Botón "Marcar hecha". Cada colaborador ve "Mis tareas de hoy" con checkboxes en su perfil móvil. Editable por el administrador.

### 5.16 Reglamento y funciones
Sección visible para todos con borrador editable por Dirección: normas generales (horario y huella, puntualidad, registro previo de todo trabajo, orden y limpieza, EPP, trato al cliente) y funciones cuando no hay trabajos asignados (mantenimiento preventivo, orden, inventario, apoyo entre áreas). Resumen en el perfil móvil.

### 5.17 App móvil (por rol)
- **Técnicos (Nelson, Carlos, Gabriela, Aldair):** banner de reconocimiento semanal, sus órdenes con "Iniciar trabajo" y "✓ Finalizar trabajo", registro de fotos y repuestos usados, **registrar nueva orden desde el celular**, pestañas Equipo (chat) y Mi perfil (avatar con cambio de foto, **Mi jornada de hoy** automática: finalizados / en proceso / pendientes para iniciar, mi asistencia de la semana, mis tareas, reglamento, cambio de contraseña). No ven montos de caja.
- **Karina (móvil):** cobros pendientes con alerta, registrar ingresos/egresos, venta con escáner, recomendaciones por enviar.
- **Tony (móvil — Negocio en vivo):** ingresos/egresos/neto del momento, **caja chica de hoy movimiento por movimiento**, trabajos en curso por estado, avisos. Todo se actualiza solo, desde cualquier lugar.

## 6. Identidad visual

- **Logo:** silueta deportiva blanca con cabina naranja; "PRO" blanco itálico + "AUTO" rojo sobre negro. Presente en portada, header, y en la versión completa en tickets y reportes.
- **Portada:** fondo negro con degradado radial, logo grande con brillo animado y flotación, línea naranja, botón INGRESAR con resplandor, y marquesina de marcas (emblema + nombre: Toyota, Kia, Chevrolet, Hyundai, Nissan, Ford, Mazda, VW, Suzuki, Mitsubishi).
- **Estilo "ejecutivo claro":** fondo blanco/gris claro, estructura negra (sidebar, tablas), UN acento naranja `#F26522` para acciones primarias, rojo `#DC1F26` reservado a lo crítico. Chips neutros con punto de color por estado. Tipografía Inter.
- **Menú lateral agrupado por prioridad** con íconos: Operación diaria → Registros → Equipo → Administración.
- **Paleta:** naranja `#F26522` · rojo `#DC1F26` · negro `#0A0A0A` · blanco · canvas `#F7F8FA` · verde `#059669` · ámbar `#B45309`.

## 7. Hardware (por etapas, compra local)

| Equipo | Recomendación | Costo aprox. | Estado |
|---|---|---|---|
| Lector código de barras | USB HID 1D/2D genérico (Netum/Eyoyo) — plug and play, sin programación | S/ 60–120 | Pendiente (el POS funciona sin él tocando el producto) |
| Lector de huella | **ZKTeco K40** de pared (funciona sin PC, sincroniza por red con script `pyzk`) — alternativa: SLK20R USB de escritorio | S/ 250–350 / S/ 150–200 | Pendiente (asistencia manual mientras tanto) |
| Impresora térmica | Xprinter 58/80 mm ESC/POS — tickets, órdenes, cierres, etiquetas internas | S/ 150 | Opcional |
| PC de caja | Cualquiera con Chrome e internet | Ya existe | ✔ |
| Celulares del personal | Los propios — la app se instala como PWA sin tiendas | S/ 0 | ✔ |

## 8. Puesta en marcha (resumen)

1. **Supabase:** crear cuenta → New Project `proauto` (São Paulo) → SQL Editor → pegar `proauto-esquema.sql` → Run.
2. **Claves:** Settings → API → copiar Project URL y clave anon.
3. **Conectar:** abrir `proauto-servidor.html` → pegar URL y clave → Conectar. Tony entra primero y crea su contraseña.
4. **Publicar:** subir el archivo a netlify.com/drop → compartir la dirección con el equipo → cada uno la abre, conecta una vez y la añade a su pantalla de inicio.
5. **Carga inicial:** inventario (con producto manual), materiales con costos, clientes frecuentes, contraseñas del personal.
6. **Primera semana:** operar en paralelo con el cuaderno; si los cierres cuadran, el cuaderno se retira. Respaldo .json cada sábado.

## 9. Hoja de ruta (fases futuras)

- **Fase 2:** integración física del lector de huella (K40) y lector de barras; impresora térmica; recordatorios de mantenimiento; encuesta de satisfacción el mismo día vía wa.me; agenda de citas; garantías con seguimiento; portal público de estado con QR.
- **Fase 3:** autenticación robusta (Supabase Auth por usuario), tablas normalizadas con sincronización en tiempo real, bitácora de auditoría completa, alertas push al celular del dueño, rotación automática de tareas.
- **Fase 4 — Formalización:** planilla completa (EsSalud, AFP/ONP, gratificaciones, CTS, boletas), retenciones (IGV/Renta) y exportación PLE-SUNAT, órdenes de compra formales, puente con el sistema de facturación.

## 10. Principios innegociables

1. El cierre de caja diario siempre cuadra con el dinero físico, método por método.
2. La asistencia es inmutable; solo Dirección corrige, con motivo.
3. Cero costo recurrente: nube gratis y WhatsApp por wa.me, sin APIs pagadas.
4. Más rápido que el cuaderno: DNI + placa bastan en mecánica; metas de alta < 90 segundos.
5. Nada llega al cliente sin pasar por la Asesora de Servicio.
6. Preparado para formalizarse: los módulos formales se activan cuando la empresa lo decida.

## 11. Archivos del proyecto

| Archivo | Contenido |
|---|---|
| `proauto-servidor.html` | **La aplicación** (versión servidor con equipo real y contraseñas) — se sube a Netlify |
| `proauto-esquema.sql` | Script de base de datos para Supabase |
| `proauto-prototipo.html` | Versión demo local (práctica sin servidor) |
| `PROMPT_SOFTWARE_PROAUTO.md` | Brief original de diseño para desarrollo |
| `GUIA_MONTAR_SERVIDOR_GRATIS.md` | Guía paso a paso de infraestructura y hardware |
| `PROAUTO_DOCUMENTACION_COMPLETA.md` | Este documento |
