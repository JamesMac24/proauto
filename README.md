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

## Pendiente antes de producción

La etapa piloto usa una tabla única `taller_datos` en JSON con una política RLS abierta (`using (true)`). Eso significa que quien tenga la URL y la clave anon lee y escribe todo, incluida la caja y los pagos al personal. Antes de dar acceso a los técnicos hay que normalizar en tablas reales y activar Supabase Auth con políticas por rol.
