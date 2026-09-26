# PROAUTO — Sistema Integral de Gestión

Taller de tornería, mecánica automotriz y venta de repuestos. Perú · Moneda S/ · Zona horaria America/Lima.

## Archivos

| Archivo | Qué es |
|---|---|
| `proauto-servidor.html` | La aplicación. Es lo que se publica en Netlify. |
| `proauto-esquema.sql` | Esquema de la base de datos. Se pega en Supabase → SQL Editor → Run. |
| `proauto-prototipo.html` | Versión demo local, sin servidor. Solo para practicar. |
| `.github/workflows/respaldo-supabase.yml` | Respaldo automático diario de la base. |
| `respaldos/` | Los respaldos que genera el workflow. Se crea solo. |

## Cómo se levanta

1. **Supabase** — crear proyecto (región São Paulo), pegar `proauto-esquema.sql` en el SQL Editor y ejecutar.
2. **Credenciales** — Project URL (en Data API, sin el `/rest/v1/` del final) y clave anon legacy (en API Keys → Legacy).
3. **Respaldo** — el secreto `SUPABASE_DB_URL` del repositorio lleva el connection string del Session pooler con la contraseña ya reemplazada.
4. **Netlify** — conectar este repositorio; cada commit publica una versión nueva.
5. **Dispositivos** — cada equipo abre la dirección, pega URL y clave anon una sola vez, y la añade a su pantalla de inicio.

## Respaldos

El workflow corre todos los días a las 03:00 de Lima y guarda un `.sql.gz` en `respaldos/`. Se conservan 90 días. También se puede lanzar a mano desde la pestaña Actions.

Para restaurar:

```
gunzip -c respaldos/proauto-AAAA-MM-DD.sql.gz | psql "<connection string>"
```

## Dirección

- Sistema: `proautosistema.netlify.app/sistema`
- La raíz queda reservada para la web pública del taller.
- `/respaldos/` está bloqueado desde internet por `_redirects`.

## Equipo de trabajo

| Colaborador | Cargo | Rol en el sistema |
|---|---|---|
| Tony | Administrador · Dueño | admin |
| Alicia | Administradora | admin |
| James | Administrador | admin |
| Karina | Asesora de Servicio | caja |
| Gabriela | Técnica en Tornería | tornero |
| Aldair | Técnico en Tornería | tornero |
| Carlos | Técnico Automotriz | mecanico |
| Fernando | Técnico Automotriz | mecanico |
| Luis | Técnico Automotriz | mecanico |

Las altas y bajas se hacen desde la aplicación, en **Personal y accesos** (solo administradores). No hay que tocar el código para que entre o salga alguien. Quien se agrega entra sin contraseña y crea la suya en su primer ingreso.

## Cargar el cuaderno físico

Al registrar una orden hay un campo **Fecha de ingreso**. Viene con la fecha de hoy; se cambia para cargar trabajos atrasados con su fecha real. Cada orden guarda además la fecha completa con año (`fechaISO`), que es la que usan los cálculos del día y del 35% de producción.

## Reiniciar el sistema

El botón **Reiniciar sistema (borra todo)** del menú lateral, visible solo para administradores, borra los datos de este equipo **y del servidor**, y arranca de nuevo con el equipo de trabajo actual. Pide confirmación dos veces. Conviene descargar antes un respaldo.

Es necesario usarlo una vez al cambiar la lista de personal en el código, porque lo guardado en Supabase manda sobre lo que trae el archivo.

## Sincronización entre equipos

Cada dispositivo escribe **solo cuando algo cambió de verdad**, y antes de escribir comprueba que nadie más haya guardado mientras tanto. Si otro equipo se adelantó, la pantalla se actualiza con lo suyo y avisa, en lugar de pisarlo.

Esto resuelve la pérdida de datos entre dos personas trabajando a la vez, pero no la elimina del todo: como todo vive en un único registro JSON, dos ediciones simultáneas sobre cosas distintas siguen compitiendo. La solución definitiva es normalizar en tablas.

## Pendiente antes de producción

La etapa piloto usa una tabla única `taller_datos` en JSON con una política RLS abierta (`using (true)`). Eso significa que quien tenga la URL y la clave anon lee y escribe todo, incluida la caja y los pagos al personal. Antes de dar acceso a los técnicos hay que normalizar en tablas reales y activar Supabase Auth con políticas por rol.
