-- À exécuter dans Supabase : Project > SQL Editor > New query > Run
-- Crée la table qui stocke ta bibliothèque de séries, une ligne par série,
-- avec les saisons/épisodes dans une colonne jsonb (même format que l'app).

create table if not exists public.shows (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  tv_id integer,
  name text not null,
  poster text,
  network text,
  avg_runtime integer default 42,
  schedule jsonb not null default '{"days":[],"time":""}'::jsonb,
  status text not null default 'a_voir',
  rating integer not null default 0,
  seasons jsonb not null default '[]'::jsonb,
  date_added timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Row Level Security : chacun ne voit / modifie que ses propres séries
alter table public.shows enable row level security;

create policy "Les utilisateurs voient leurs propres séries"
  on public.shows for select
  using (auth.uid() = user_id);

create policy "Les utilisateurs ajoutent leurs propres séries"
  on public.shows for insert
  with check (auth.uid() = user_id);

create policy "Les utilisateurs modifient leurs propres séries"
  on public.shows for update
  using (auth.uid() = user_id);

create policy "Les utilisateurs suppriment leurs propres séries"
  on public.shows for delete
  using (auth.uid() = user_id);

-- Maintient updated_at à jour automatiquement
-- (nom de fonction préfixé "shows_" pour ne pas entrer en conflit avec
-- d'autres fonctions déjà présentes si tu réutilises un projet existant)
create or replace function public.shows_set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists shows_set_updated_at on public.shows;
create trigger shows_set_updated_at
  before update on public.shows
  for each row execute function public.shows_set_updated_at();

-- Index pour trier/filtrer rapidement par utilisateur
create index if not exists shows_user_id_idx on public.shows(user_id);
