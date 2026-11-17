-- Omni RP v1.24 · rode uma vez no SQL Editor do Supabase (não apaga nada)
-- Faz o servidor carimbar a hora de cada mudança, para a atualização a cada 3 segundos ficar certinha.
create or replace function public.docs_touch() returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end $$;
drop trigger if exists docs_touch on public.docs;
create trigger docs_touch before insert or update on public.docs for each row execute function public.docs_touch();
create index if not exists docs_updated_at on public.docs (updated_at);
