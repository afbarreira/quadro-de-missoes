-- Quadro de Missões · configuração do Supabase (rode tudo de uma vez no SQL Editor)
-- Modelo "entre amigos": quem tem conta no app lê e edita os dados da mesa.

-- 1) Tabela única onde o app guarda tudo (campanhas, missões, fichas, mapas...)
create table if not exists public.docs (
  collection text not null,           -- users, campaigns, members, missions, sheets, maps...
  id         text not null,
  data       jsonb not null,
  updated_by uuid default auth.uid(),
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);

-- 2) Segurança: só usuários logados acessam
alter table public.docs enable row level security;
create policy "logados leem"   on public.docs for select to authenticated using (true);
create policy "logados criam"  on public.docs for insert to authenticated with check (true);
create policy "logados editam" on public.docs for update to authenticated using (true) with check (true);
create policy "logados apagam" on public.docs for delete to authenticated using (true);

-- 3) Tempo real (as mudanças de um aparecem para os outros)
alter publication supabase_realtime add table public.docs;

-- 4) Pasta para as imagens de mapa enviadas pelo app
insert into storage.buckets (id, name, public) values ('mapas', 'mapas', true)
  on conflict (id) do nothing;
create policy "logados enviam mapas" on storage.objects for insert to authenticated
  with check (bucket_id = 'mapas');
create policy "todos veem mapas" on storage.objects for select
  using (bucket_id = 'mapas');
