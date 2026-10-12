-- Tabla para cargar la hoja BD_GABAST (viajes TPG con tarifa de flete ya calculada).
-- Ejecuta este script una sola vez en Supabase -> SQL Editor.
-- Luego: Table Editor -> tpg_gabast -> Insert -> Import data from CSV -> tpg_gabast_carga.csv
--
-- Las columnas siguen el orden y los nombres de la hoja (en minusculas y con guion bajo),
-- asi puedes exportar la hoja a "CSV UTF-8" y cargarla sin transformar nada.
-- Todas aceptan vacio. No hay restricciones (CHECK) para que la importacion no se rechace.

create table if not exists tpg_gabast (
  id bigint generated always as identity primary key,

  operador                          text,
  tracto                            text,
  botella                           text,      -- placa de la cisterna
  conductor                         text,
  planta_origen                     text,
  fecha_hora_ingreso_planta_origen  text,      -- text: la hoja hoy trae toneladas en esta columna
  fecha_hora_salida_planta_origen   text,
  inicio_de_ruta_cargado            text,
  cantidad_carga_gr_tm              numeric,
  gr_operador                       text,
  gr_solgas                         text,
  planta_destino                    text,
  fecha_hora_llegada_destino        text,      -- text: idem
  fecha_hora_ingreso_planta_d       text,
  fecha_hora_de_salida_descarga     text,
  tm_descargadas_ticket             numeric,
  ubicacion                         text,
  estado                            text,
  fecha_hora_llegada_modificada     text,
  tiempo_espera                     numeric,
  stand_by                          numeric,
  tarifa                            numeric,   -- tarifa diaria de stand by
  pago_stand_by                     numeric,
  propiedad_cisterna                text,
  tipo_de_servicio                  text,      -- TRACTO / TRACTO + CISTERNA
  combustible_tracto                text,      -- Diesel / GNL
  destino_tarifa                    text,
  via_ruta                          text,
  bonificacion                      text,
  rt_dias_aplicado                  numeric,
  nro_tarifas_aplicables            numeric,
  tarifa_flete_por_tm               numeric,
  estado_tarifa                     text,
  liquidacion_flete                 numeric,
  capacidad_cisterna_tm             numeric,
  pct_ocupabilidad                  numeric,

  -- Para filtrar por mes en el dashboard. La hoja actual no trae fechas reales:
  -- cuando las tengas, llena fecha_viaje (AAAA-MM-DD) y el dashboard podra agrupar por mes.
  fecha_viaje                       date,

  creado_en                         timestamptz default now()
);

-- Lectura publica para el dashboard (la carga se hace desde Supabase, que no pasa por RLS).
alter table tpg_gabast enable row level security;
drop policy if exists "tpg_gabast lectura publica" on tpg_gabast;
create policy "tpg_gabast lectura publica" on tpg_gabast for select using (true);

-- Si necesitas recargar todo desde cero (evita duplicados):
--   truncate table tpg_gabast restart identity;
