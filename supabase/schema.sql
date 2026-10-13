-- Run once in the Supabase SQL Editor. No application password is stored here.
create table if not exists public.kpss_user_data (
 user_id uuid primary key references auth.users(id) on delete cascade,
 payload jsonb not null check (jsonb_typeof(payload) = 'object'),
 revision bigint not null default 1,
 updated_at timestamptz not null default now()
);
alter table public.kpss_user_data enable row level security;
revoke all on public.kpss_user_data from anon;
grant select, insert, update on public.kpss_user_data to authenticated;
drop policy if exists own_select on public.kpss_user_data;
create policy own_select on public.kpss_user_data for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists own_insert on public.kpss_user_data;
create policy own_insert on public.kpss_user_data for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists own_update on public.kpss_user_data;
create policy own_update on public.kpss_user_data for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create or replace function public.save_kpss_data(p_payload jsonb, p_expected bigint)
returns bigint language plpgsql security invoker set search_path = public, pg_temp as $$
declare new_revision bigint;
begin
 if auth.uid() is null then raise exception 'authentication_required'; end if;
 if jsonb_typeof(p_payload) <> 'object' or octet_length(p_payload::text) > 10485760 then raise exception 'invalid_payload'; end if;
 if p_expected = -1 then
  insert into public.kpss_user_data(user_id,payload,revision) values(auth.uid(),p_payload,1)
  on conflict(user_id) do nothing returning revision into new_revision;
 else
  update public.kpss_user_data set payload=p_payload,revision=revision+1,updated_at=now()
  where user_id=auth.uid() and revision=p_expected returning revision into new_revision;
 end if;
 if new_revision is null then raise exception 'revision_conflict'; end if;
 return new_revision;
end $$;
revoke all on function public.save_kpss_data(jsonb,bigint) from public;
grant execute on function public.save_kpss_data(jsonb,bigint) to authenticated;
