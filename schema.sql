-- Run once in Supabase SQL Editor. Each account owns only its own rows in this trial.
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default '教練',
 role text not null default 'coach' check (role in ('coach','admin')),
 created_at timestamptz not null default now()
);
create table if not exists public.members (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 name text not null,
 phone text not null default '',
 notes text not null default '',
 created_at timestamptz not null default now()
);
create table if not exists public.lessons (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 member_id uuid not null references public.members(id) on delete cascade,
 starts_at timestamptz not null,
 status text not null default '預約' check (status in ('預約','完成','取消')),
 created_at timestamptz not null default now()
);
create table if not exists public.purchases (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 member_id uuid not null references public.members(id) on delete cascade,
 sessions integer not null check (sessions > 0),
 amount numeric(12,2) not null default 0,
 created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
alter table public.members enable row level security;
alter table public.lessons enable row level security;
alter table public.purchases enable row level security;
drop policy if exists profiles_own on public.profiles;
create policy profiles_own on public.profiles for all to authenticated using (id = auth.uid()) with check (id = auth.uid());
drop policy if exists members_own on public.members;
create policy members_own on public.members for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
drop policy if exists lessons_own on public.lessons;
create policy lessons_own on public.lessons for all to authenticated using (owner_id = auth.uid() and exists (select 1 from public.members m where m.id = member_id and m.owner_id = auth.uid())) with check (owner_id = auth.uid() and exists (select 1 from public.members m where m.id = member_id and m.owner_id = auth.uid()));
drop policy if exists purchases_own on public.purchases;
create policy purchases_own on public.purchases for all to authenticated using (owner_id = auth.uid() and exists (select 1 from public.members m where m.id = member_id and m.owner_id = auth.uid())) with check (owner_id = auth.uid() and exists (select 1 from public.members m where m.id = member_id and m.owner_id = auth.uid()));
-- For trial safety, 'admin' is a display role only. Cross-coach access is NOT enabled.
