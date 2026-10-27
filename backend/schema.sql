-- MẪU KHỞI ĐẦU SUPABASE / CHƯA TRIỂN KHAI. Chạy trong dự án thử nghiệm mới.
-- Không thay thế kiểm thử RLS và các endpoint backend xác thực.
create table public.library_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.library_admins enable row level security;
create policy admins_read_self on public.library_admins for select to authenticated using (user_id = auth.uid());
-- Không có policy INSERT/UPDATE/DELETE: chỉ chủ dự án/service role được cấp admin.
create function public.library_is_admin() returns boolean language sql stable security definer
set search_path = public as $$
 select exists(select 1 from public.library_admins where user_id = auth.uid());
$$;
revoke all on function public.library_is_admin() from public;
grant execute on function public.library_is_admin() to authenticated;

create table public.private_books (
 id text primary key, title text not null, private_metadata jsonb not null default '{}',
 draft jsonb not null default '{}', status text not null default 'draft'
 check (status in ('draft','review','approved','hidden')),
 rights text not null default 'unknown', reviewed_by uuid references auth.users(id), reviewed_at timestamptz
);
alter table public.private_books enable row level security;
create policy private_books_admin on public.private_books for all to authenticated
using(public.library_is_admin()) with check(public.library_is_admin());

create table public.public_books (
 id text primary key, public_payload jsonb not null,
 published_at timestamptz not null default now()
);
alter table public.public_books enable row level security;
create policy public_books_read on public.public_books for select to anon, authenticated using(true);
-- Chỉ backend xuất bản được public_payload qua allowlist sau duyệt; không cho client write.

create table public.reader_notes (
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 book_id text not null, note text not null default '', updated_at timestamptz not null default now(),
 primary key(user_id,book_id)
);
alter table public.reader_notes enable row level security;
create policy reader_notes_owner on public.reader_notes for all to authenticated
using(user_id=auth.uid()) with check(user_id=auth.uid());

create table public.reader_bookmarks (
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 book_id text not null, primary key(user_id,book_id)
);
alter table public.reader_bookmarks enable row level security;
create policy reader_bookmarks_owner on public.reader_bookmarks for all to authenticated
using(user_id=auth.uid()) with check(user_id=auth.uid());

create table public.reader_progress (
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 book_id text not null, section_key integer not null check(section_key between 0 and 11),
 primary key(user_id,book_id,section_key)
);
alter table public.reader_progress enable row level security;
create policy reader_progress_owner on public.reader_progress for all to authenticated
using(user_id=auth.uid()) with check(user_id=auth.uid());

create table public.source_documents (
 id uuid primary key default gen_random_uuid(), book_id text references public.private_books(id),
 object_path text unique not null, sharing_allowed boolean not null default false
);
alter table public.source_documents enable row level security;
create policy source_documents_admin on public.source_documents for all to authenticated
using(public.library_is_admin()) with check(public.library_is_admin());

create table public.document_acl (
 user_id uuid references auth.users(id) on delete cascade,
 document_id uuid references public.source_documents(id) on delete cascade,
 primary key(user_id,document_id)
);
alter table public.document_acl enable row level security;
create policy document_acl_admin on public.document_acl for all to authenticated
using(public.library_is_admin()) with check(public.library_is_admin());
-- Người thường không thấy bảng document/ACL. Backend kiểm tra quyền rồi trả từng tài liệu được phép.
-- Bucket phải private; không thêm policy đọc cho anon hoặc authenticated mặc định.
-- Endpoint dùng service role phải tự kiểm tra ACL trước khi ký URL.
insert into storage.buckets (id,name,public) values ('library-private','library-private',false);
-- Không có policy storage.objects đọc/ghi client cho bucket này: mặc định từ chối.
-- Cấu hình owner/admin đầu tiên trong SQL Editor của chủ dự án, không từ giao diện công khai.
