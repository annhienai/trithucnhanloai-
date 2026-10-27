#!/usr/bin/env python3
"""Private offline intake only. Does NOT analyze, call AI, or publish PDFs."""
import argparse,hashlib,json,subprocess
from pathlib import Path
p=argparse.ArgumentParser(description='Chuẩn bị bản nháp riêng từ PDF, không xuất bản hoặc gọi AI.')
p.add_argument('source',type=Path,help='Thư mục PDF đã được cấp quyền trên máy quản trị')
p.add_argument('--out',type=Path,required=True,help='Thư mục riêng NGOÀI repository website')
a=p.parse_args();root=Path(__file__).resolve().parents[1]
if a.out.resolve().is_relative_to(root):p.error('Phải lưu kết quả ngoài thư mục website để không lộ PDF/nội dung gốc.')
if not a.source.is_dir():p.error('Thư mục nguồn không tồn tại.')
a.out.mkdir(parents=True,exist_ok=True)
rows=[]
for f in sorted(a.source.rglob('*.pdf')):
 key=hashlib.sha256(f.read_bytes()).hexdigest();dest=a.out/key[:16];dest.mkdir(exist_ok=True)
 try:
  info=subprocess.run(['pdfinfo',str(f)],capture_output=True,text=True,timeout=90)
  text=subprocess.run(['pdftotext','-layout',str(f),str(dest/'extracted.txt')],capture_output=True,text=True,timeout=180)
  content=(dest/'extracted.txt').read_text(errors='replace') if (dest/'extracted.txt').exists() else ''
  pages=content.split('\f');chunks=[{'page':i+1,'text':pg} for i,pg in enumerate(pages) if pg.strip()]
  (dest/'pages.json').write_text(json.dumps(chunks,ensure_ascii=False,indent=2))
  draft={'id':key[:16],'source_filename':f.name,'sha256':key,'status':'needs-review' if len(content.strip())>100 else 'needs-ocr','rights':'unknown','metadata_unverified':info.stdout,'pages_extracted':len(chunks),'ai_analysis':None,'approval':False,'error':text.stderr if text.returncode else None}
 except (OSError,subprocess.TimeoutExpired) as e:draft={'id':key[:16],'source_filename':f.name,'status':'error','error':str(e),'approval':False}
 (dest/'intake.json').write_text(json.dumps(draft,ensure_ascii=False,indent=2));rows.append({'id':draft['id'],'filename':f.name,'status':draft['status']})
(a.out/'intake-index.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2))
print(f'Đã chuẩn bị {len(rows)} PDF. Kết quả riêng tư; không tự phân tích, không tự xuất bản.')
