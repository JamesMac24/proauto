# PROAUTO — Guía para montar el servidor real (gratis) paso a paso

Esta guía te lleva del prototipo HTML (que ya tienes) a un sistema real funcionando en internet, con base de datos, usuarios, y multi-dispositivo. **Sin costo mensual hasta que crezcas mucho.** Usando Claude AI para escribir el código por ti.

---

## Qué tienes hoy vs qué necesitas

**Hoy tienes:** `proauto-prototipo.html`
- Se abre con doble clic.
- Funciona en la PC local (solo).
- Datos se pierden al cerrar el navegador.
- Perfecto para ver cómo se ve y sentir la app.

**Meta:** un sistema real
- Funciona desde cualquier PC del taller.
- La cajera, el admin y los mecánicos ven los mismos datos.
- La app móvil de los mecánicos sincroniza.
- Nada se pierde.
- **Costo mensual: $0** (hasta ~50 000 movimientos/mes, después ~$25/mes cuando el negocio crezca).

---

## Herramientas que vas a usar (todas gratis)

| Herramienta | Para qué sirve | Costo |
|---|---|---|
| **Supabase** | Base de datos + login de usuarios + API automática | Gratis (500 MB, suficiente para años) |
| **Vercel** | Publica la web en internet con un dominio | Gratis |
| **GitHub** | Guarda el código y lo conecta con Vercel | Gratis |
| **Claude AI** | Te escribe el código de cada módulo | Ya lo tienes |
| **Cursor** (opcional) | Editor de código que integra con Claude | Gratis |

**Único gasto opcional:** un dominio propio tipo `proauto.ec` (~$15/año en NameCheap o Cloudflare). Mientras tanto Vercel te da un dominio gratis tipo `proauto-taller.vercel.app`.

---

## Ruta de 7 pasos (aprox. 2-3 fines de semana)

### Paso 1 — Crear cuentas (30 min)
1. GitHub: `github.com/signup` — con tu email.
2. Supabase: `supabase.com` → "Start your project" → login con GitHub.
3. Vercel: `vercel.com` → login con GitHub.

Con solo GitHub las tres se conectan automáticamente.

### Paso 2 — Instalar herramientas (20 min)
En tu PC:
- **Node.js**: descargar desde `nodejs.org` (versión LTS). Instalador siguiente-siguiente.
- **Git**: `git-scm.com/downloads`. Instalador siguiente-siguiente.
- **Cursor** (opcional pero muy recomendado): `cursor.com` — es un editor con Claude adentro. Escribe el código por ti conversando.

### Paso 3 — Crear el proyecto en Supabase (15 min)
1. En Supabase → New Project.
2. Nombre: `proauto`.
3. Región: elige la más cercana (South America — São Paulo).
4. Password de la base de datos: guárdala en un lugar seguro.
5. Espera 2 minutos a que se cree.

Cuando termine, Supabase te da:
- **Project URL** (algo como `https://xxxx.supabase.co`)
- **API Key (anon)** — pública, va en el frontend
- **Service Role Key** — secreta, solo del servidor

**Guarda estas tres cosas** en un archivo `.env` local.

### Paso 4 — Crear las tablas en la base de datos (1 hora con Claude)
Aquí Claude te ahorra días. Le pegas este mensaje:

```
Tengo Supabase (Postgres). Necesito crear las tablas para el sistema PROAUTO 
descrito en el archivo PROMPT_SOFTWARE_PROAUTO.md que te adjunto. 
Genérame los CREATE TABLE con las relaciones (foreign keys), 
los índices necesarios, y las políticas RLS (Row Level Security) para que:
- Los mecánicos solo vean sus OT asignadas.
- La cajera vea todo del día pero no pueda editar histórico.
- El admin vea y edite todo.

Necesito que me entregues un solo archivo SQL para pegar en el editor 
SQL de Supabase.
```

Claude te genera el SQL. Lo pegas en Supabase → SQL Editor → Run. Tablas creadas.

### Paso 5 — Convertir el prototipo HTML en app real (2-3 días con Claude)
Le pides a Claude:

```
Tengo este prototipo HTML (`proauto-prototipo.html`) hecho con Alpine.js. 
Quiero convertirlo en una app Next.js con:
- Autenticación de Supabase (los 3 roles del prototipo).
- Todos los datos en Supabase en vez de arrays en memoria.
- Mismas pantallas, misma paleta (naranja #F26522, rojo #DC1F26, negro #0A0A0A, blanco).
- Componentes en React con Tailwind.
- Preparado para desplegar en Vercel.
Empecemos por el módulo de login y el dashboard. Los demás módulos los hacemos 
en iteraciones siguientes.
```

Claude te genera el proyecto por partes. Cursor te ayuda a editarlo en vivo. Vas probando en `localhost:3000`.

### Paso 6 — Publicar en Vercel (10 min)
1. Sube el código a GitHub (Cursor tiene un botón "Publish to GitHub" que lo hace en un clic).
2. En Vercel → "Import Project" → elige el repo.
3. Vercel detecta que es Next.js, pide las variables de entorno (las de Supabase que guardaste).
4. Deploy. En 2 minutos tienes `https://proauto.vercel.app` funcionando en internet.

Cada vez que hagas un cambio en el código y lo subas a GitHub, Vercel lo publica automáticamente.

### Paso 7 — App móvil (fin de semana adicional)
Para los mecánicos:
- Opción A (**más rápida y gratis**): la misma web es "PWA" — instalable en el celular como app. El mecánico entra desde el navegador y le da "Añadir a pantalla de inicio". Se ve como app nativa. Cero costo, cero tiendas.
- Opción B (más profesional pero requiere pagar developer accounts): app nativa con React Native. Cuando el negocio crezca.

**Recomendación:** arranca con PWA. Es lo que hacen Uber y Twitter Lite.

---

## Costos reales a largo plazo

| Escenario | Costo/mes |
|---|---|
| PROAUTO ahora (5 empleados, ~200 OT/mes) | **$0** |
| PROAUTO en 2 años (10 empleados, ~600 OT/mes) | **$0** (todavía dentro de tier gratis) |
| PROAUTO con multi-sucursal, 30 empleados, 2000 OT/mes | **~$25** (Supabase Pro) |
| + dominio propio `proauto.ec` | **~$1.25/mes** ($15/año) |

**Casi nunca vas a pagar nada por infraestructura.**

---

## Conexiones especiales (hardware)

### Lector de código de barras — cómo se enlaza a la venta

**No requiere ninguna programación.** Los lectores USB son tipo "HID": la PC los ve como un teclado. Cuando escaneas, el lector "escribe" el código y presiona Enter solo.

Flujo real de venta en PROAUTO:
1. La asesora abre la pantalla "Venta de repuestos" — el cursor queda en el campo de escaneo.
2. Pasa el producto por el lector → *bip* → el código entra + Enter automático.
3. El sistema busca el código en el inventario → agrega el producto al carrito con su precio → muestra stock disponible.
4. Escanea los demás productos → elige método de pago → Cobrar.
5. El stock se descuenta al instante y el movimiento queda en el kardex del producto.

Para productos **sin código de fábrica** (pernos, piezas a granel): el sistema genera un código interno y se imprime una etiqueta (con la misma impresora térmica de tickets o una de etiquetas ~S/150). Se pega en el estante o en la bolsa.

**Compra recomendada:** cualquier lector USB 1D/2D de S/60–120 (Netum, Eyoyo, o genérico con buenas reseñas). Verificar que diga "USB HID / plug and play".

### Lector de huella — dos opciones, cómo se enlaza cada una

**Opción A — Reloj biométrico independiente (ZKTeco K40 / iClock, ~S/250–350) ← recomendado**
- Se instala en la pared, junto a la entrada del taller.
- Cada trabajador registra su huella una vez, directamente en el aparato.
- El aparato guarda las marcaciones aunque no haya internet ni PC encendida.
- **Enlace al software:** el K40 se conecta por cable de red (LAN) o WiFi. Un pequeño servicio (script Python con la librería gratuita `pyzk`, ~80 líneas que Claude te escribe) corre en la PC de caja o en el servidor y cada 5 minutos jala las marcaciones nuevas del aparato y las sube a la base de datos (Supabase). De ahí el software calcula tardanzas y descuentos solo.
- Ventaja: robusto, independiente, es lo que usan las empresas formales en Perú.

**Opción B — Lector USB de escritorio (ZKTeco SLK20R / U.are.U 4500, ~S/150–200)**
- Se conecta a la PC de caja por USB; los trabajadores marcan en el mostrador.
- **Enlace al software:** el SDK gratuito del fabricante + un script local que captura la huella, identifica al trabajador y envía la marcación a la base de datos al instante.
- Ventaja: más barato y marcación en tiempo real. Desventaja: la PC debe estar encendida y el punto de marcación es el mostrador (puede hacer cola).

**Recomendación PROAUTO:** arrancar con la **Opción A (K40)** — la asistencia no depende de la PC, y el punto de marcación queda en la puerta, que es donde debe estar. El software del prototipo ya está diseñado para recibir marcaciones de cualquiera de las dos.

### Impresora térmica
- Requiere librería `escpos` (Node o Python). Claude te escribe la función de imprimir ticket de venta, orden de trabajo y cierre de caja.

---

## Cronograma sugerido

| Semana | Trabajo | Resultado |
|---|---|---|
| 1 | Pasos 1-3 (cuentas, herramientas, Supabase) | Todo instalado, base creada |
| 2 | Paso 4 (tablas) + convertir login y dashboard | Ya puedes entrar |
| 3-4 | Módulos: caja, OT, inventario | Sistema usable en un día real |
| 5 | Módulos: personal, cierre, reportes | Sistema completo |
| 6 | Integración lector huella y código de barras | Automatización completa |
| 7 | PWA móvil para mecánicos | Cierre del MVP |

**Total: 6-7 semanas** trabajando fines de semana o ratos libres, siempre asistido por Claude.

---

## Si te trabas

Cada vez que algo falle, le pegas a Claude:
1. El error exacto (copia/pega).
2. El archivo donde estás.
3. Qué esperabas que pasara.

Claude te dice qué corregir. En el 95% de casos, resuelve en un intento.

---

## Primer paso concreto para hoy

1. Abre `proauto-prototipo.html` con doble clic en tu navegador.
2. Pruébalo: login → cajera → crea una OT con cédula `1712345678` (verás el autocompletado). Marca como Kia en marca. Ve el kanban.
3. Cuando estés listo para el real → crea cuenta en Supabase (Paso 1 de esta guía).
4. Vuelve con Claude y dile: "Empecemos con el Paso 4, generame el SQL para las tablas de PROAUTO".

Y arrancamos.
