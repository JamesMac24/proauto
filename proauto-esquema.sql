-- ============================================================
-- PROAUTO — Esquema inicial para Supabase (etapa piloto)
-- Pegar TODO este archivo en: Supabase → SQL Editor → Run
-- ============================================================

-- Tabla única que guarda el estado del taller como JSON.
-- (Etapa piloto: simple y robusto. La migración a tablas
--  normalizadas se hace después, sin perder datos.)

create table if not exists taller_datos (
  id integer primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Fila única del taller
insert into taller_datos (id, data)
values (1, '{}'::jsonb)
on conflict (id) do nothing;

-- Seguridad a nivel de fila (etapa piloto: acceso con la clave anon)
alter table taller_datos enable row level security;

drop policy if exists "proauto_acceso_piloto" on taller_datos;
create policy "proauto_acceso_piloto"
  on taller_datos
  for all
  using (true)
  with check (true);

-- ============================================================
-- IMPORTANTE (seguridad de la etapa piloto):
-- El acceso funciona con la clave "anon" del proyecto. Cualquiera
-- que tenga la URL + esa clave puede leer/escribir. Por eso:
--   1) No compartas la clave fuera del personal del taller.
--   2) No publiques la clave en redes ni la mandes por WhatsApp
--      a terceros.
-- Cuando pasemos a la versión con usuarios reales (Supabase Auth
-- con PIN por colaborador), esta política se reemplaza por
-- políticas por rol y la clave anon deja de dar acceso directo.
-- ============================================================
