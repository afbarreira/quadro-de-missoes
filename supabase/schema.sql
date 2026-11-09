-- Rascunho do banco no Supabase (espelha as coleções do protótipo).
-- Contas: use o Auth do Supabase; a tabela profiles guarda nome e cor.
-- Campos flexíveis (ficha, estilo do cartaz, checklist) ficam em JSONB.
-- IMPORTANTE: ative RLS e crie as políticas antes de publicar (ver README).

create table profiles (
  id uuid primary key references auth.users on delete cascade,
  name text not null,
  color text default '#a8322a',
  created_at timestamptz default now()
);

create table campaigns (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  system text not null check (system in ('t20','custom')),
  code text unique not null,
  owner_id uuid references profiles(id) on delete cascade,
  template jsonb,              -- modelo de ficha (sistema próprio)
  created_at timestamptz default now()
);

create table members (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid references campaigns(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  role text not null check (role in ('master','player')),
  status text not null check (status in ('active','pending','invited')),
  created_at timestamptz default now(),
  unique (campaign_id, user_id)
);

create table missions (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid references campaigns(id) on delete cascade,
  number int,
  title text, client text, location text, category text, rarity text,
  status text default 'disponivel', reward text, description text,
  visible boolean default true,
  checklist jsonb default '[]',  -- [{id, text}]
  style jsonb default '{}',      -- formato, cor, efeitos do cartaz
  pos jsonb, z int,              -- posição no quadro
  finished_at timestamptz,
  created_at timestamptz default now()
);

create table checks (
  mission_id uuid references missions(id) on delete cascade,
  item_id text not null,
  user_id uuid references profiles(id) on delete cascade,
  at timestamptz default now(),
  primary key (mission_id, item_id)
);

create table notes (
  id uuid primary key default gen_random_uuid(),
  mission_id uuid references missions(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  text text,
  updated_at timestamptz default now(),
  unique (mission_id, user_id)
);

create table sheets (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid references campaigns(id) on delete cascade,
  user_id uuid references profiles(id) on delete set null,
  npc boolean default false,
  main boolean default false,
  system text not null,
  share text default 'privada' check (share in ('privada','grupo','alguns')),
  share_with uuid[] default '{}',
  data jsonb not null,
  updated_at timestamptz default now()
);

create table maps (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid references campaigns(id) on delete cascade,
  name text not null,
  image text,                    -- URL (ou caminho no Storage)
  w int, h int,
  km_per_100 numeric, unit text default 'km',
  speed_foot numeric default 30, speed_horse numeric default 60,
  preset text, party jsonb,
  created_at timestamptz default now()
);

create table markers (
  id uuid primary key default gen_random_uuid(),
  map_id uuid references maps(id) on delete cascade,
  name text, cat text, tags text[] default '{}', descr text,
  x int, y int,
  mission_id uuid references missions(id) on delete set null,
  hidden boolean default false,
  owner_id uuid references profiles(id) on delete cascade,  -- anotação pessoal
  preset text,
  created_at timestamptz default now()
);

create table regions (
  id uuid primary key default gen_random_uuid(),
  map_id uuid references maps(id) on delete cascade,
  name text, type text default 'reino', color text, descr text,
  hidden boolean default false, preset text,
  points jsonb not null,
  created_at timestamptz default now()
);

create table routes (
  id uuid primary key default gen_random_uuid(),
  map_id uuid references maps(id) on delete cascade,
  name text, color text, hidden boolean default false,
  owner_id uuid references profiles(id) on delete cascade,
  pts jsonb not null,
  created_at timestamptz default now()
);
