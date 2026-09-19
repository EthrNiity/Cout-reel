-- ============================================================
-- Schéma "Coût Réel" pour Supabase
-- À coller intégralement dans : Supabase > SQL Editor > New query > Run
-- ============================================================

-- Extension nécessaire pour générer des UUID
create extension if not exists "pgcrypto";

-- ---------- CONFIG (une ligne par utilisateur) ----------
create table if not exists config (
  user_id uuid primary key references auth.users(id) on delete cascade,
  "salaireNet" numeric,
  "salaireJour" int,
  "heuresTravail" numeric,
  "soldeActuel" numeric,
  "refVacances" numeric,
  "refLoyer" numeric,
  "autresRevenus" jsonb default '[]'::jsonb
);

-- ---------- ACHATS ----------
create table if not exists achats (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "nom" text,
  "prix" numeric,
  "categorie" text,
  "similaires" int,
  "duree" numeric,
  "usages" numeric,
  "locationPossible" boolean,
  "coutLocation" numeric,
  "envie" int,
  "heures" numeric,
  "coutParUsage" numeric,
  "coutParJour" numeric,
  "seuil" numeric,
  "datePrevue" date,
  "etale" boolean,
  "nbFois" int,
  "dateAchat" timestamptz,
  "heureAchat" int,
  "jourSemaine" int,
  "decision" text,
  "reeval7" int,
  "reeval30" int
);

-- ---------- DEPENSES FIXES ----------
create table if not exists depenses_fixes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "nom" text,
  "montant" numeric,
  "jour" int
);

-- ---------- ECHEANCES PONCTUELLES ----------
create table if not exists echeances (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "nom" text,
  "montant" numeric,
  "date" date
);

-- ---------- BUDGETS PAR CATEGORIE ----------
create table if not exists budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "categorie" text,
  "limite" numeric
);

-- ---------- COMPTES D'EPARGNE ----------
create table if not exists epargnes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "nom" text,
  "montant" numeric
);

-- ---------- DETTES ----------
create table if not exists dettes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "nom" text,
  "montantInitial" numeric,
  "montantRestant" numeric
);

-- ---------- EMPRUNTS / CREDITS ----------
create table if not exists emprunts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "nom" text,
  "montantEmprunte" numeric,
  "mensualite" numeric,
  "jour" int,
  "dateFin" date
);

-- ---------- OBJECTIFS D'EPARGNE ----------
create table if not exists objectifs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  "nom" text,
  "montantCible" numeric,
  "dateCible" date,
  "compteLie" text
);

-- ============================================================
-- ROW LEVEL SECURITY : chacun ne voit et ne modifie que ses données
-- ============================================================

alter table config enable row level security;
alter table achats enable row level security;
alter table depenses_fixes enable row level security;
alter table echeances enable row level security;
alter table budgets enable row level security;
alter table epargnes enable row level security;
alter table dettes enable row level security;
alter table emprunts enable row level security;
alter table objectifs enable row level security;

-- Une politique générique par table : l'utilisateur ne gère que ses propres lignes
do $$
declare
  t text;
begin
  foreach t in array array['config','achats','depenses_fixes','echeances','budgets','epargnes','dettes','emprunts','objectifs']
  loop
    execute format('
      create policy "Utilisateur gère ses propres lignes" on %I
      for all
      using (auth.uid() = user_id)
      with check (auth.uid() = user_id);
    ', t);
  end loop;
end $$;
