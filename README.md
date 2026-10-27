# KHO BÁU TRI THỨC – MỘT ĐỜI BIẾT ƠN
## Thư viện tri thức An Nhiên AI · Trịnh Thị An (TTA)

Bản bàn giao 1.0 · 27/10/2026. Không cần npm, không có API key.

## Mở ngay
Giải nén ZIP, mở `index.html` bằng Chrome/Edge/Firefox. Dữ liệu được nạp bằng script cục bộ nên không cần fetch hoặc máy chủ. Một số trình duyệt hạn chế localStorage ở địa chỉ file:; nếu ghi chú không lưu, dùng máy chủ cục bộ hoặc GitHub Pages.

Chạy bằng máy chủ cục bộ: mở terminal trong thư mục, chạy `python3 -m http.server 8000`, truy cập `http://localhost:8000`. Không cần thực hiện bước này nếu mở tệp trực tiếp đã hoạt động.

## Chức năng đã hoạt động
- Mở sách tri ân bằng CSS 3D; thư đầy đủ với phông Charm hỗ trợ tiếng Việt được lưu cục bộ; bỏ qua ở lần sau; mở lại; giảm chuyển động.
- Trang chủ, lời tri ân, danh mục, khám phá tri thức, sách gợi ý, nghiên cứu, góc học tập, âm nhạc, bộ sưu tập website, giới thiệu và kết nối.
- Danh mục 12 đầu sách từ yêu cầu, không tự điền tác giả chưa được cung cấp; phân loại ban đầu là dự kiến.
- Tìm kiếm không dấu, bộ lọc chủ đề và trạng thái; thông báo khi không có kết quả.
- Hồ sơ riêng mỗi sách và 12 nút theo chủ đề; mục chưa có nội dung hiển thị chờ biên soạn.
- Hồ sơ Đắc nhân tâm là mẫu NGOÀI kho: bài bình luận độc lập, tình huống giả định, bản đồ chủ đề, nguồn chính thức. Chưa đọc PDF, chưa khẳng định mục lục. Chủ thư viện cần duyệt trước khi dùng mẫu làm nội dung chính thức.
- Tra cứu theo từ khóa đã cấu hình cho hồ sơ mẫu, không phải hỏi đáp AI.
- Yêu thích, ghi chú, tiến độ tại localStorage; xuất/nhập JSON sao lưu; xóa dữ liệu. Đây là công cụ cá nhân trên thiết bị, không phải tài khoản.
- Bốn ảnh nguyên bản ở assets/images, có phóng to, không cắt hoặc sửa ảnh. SHA-256 ở originals-manifest.json.
- Màu sắc theo yêu cầu, menu điện thoại, nút A+, focus bàn phím, nhãn form, dialog có Escape, hình ảnh có mô tả.
- Liên kết Facebook, YouTube, Zalo đúng chuỗi chị An cung cấp. Liên kết không chứng minh tài khoản từ xa còn hoạt động.
- Công cụ `tools/catalog-editor.html`: thêm, sửa, xóa, phân loại, nổi bật, nhập nội dung có nguồn, duyệt/ẩn, nhập danh mục lớn, cấu hình video và website, xuất JSON/JS. Chỉ chạy cục bộ, không phải admin có xác thực.

## Chưa triển khai / cần dữ liệu hoặc dịch vụ
- Chưa nhận kho Google Drive hoặc PDF; chưa xử lý hàng trăm sách thật. Không dùng tên tệp để bịa nội dung.
- Chưa có bìa xuất bản có quyền; bìa chữ hiện tại là thiết kế nhận diện, không phải ảnh bìa gốc.
- Không có đăng nhập, thành viên máy chủ, quản lý người dùng, đồng bộ ghi chú, tài liệu nâng cao riêng tư.
- Không có OCR/AI trực tiếp, hàng đợi xử lý, embeddings, hỏi đáp RAG, quản trị xuất bản tập trung.
- Chưa có video/playlist và URL website sáng tạo được chị An lựa chọn. Các vùng này hiển thị đúng trạng thái trống. Link kênh YouTube hoạt động; trình phát chỉ xuất hiện sau khi thêm video hợp lệ.
- Chưa đăng lên GitHub Pages, chưa có tên miền, chưa kiểm tra hạ tầng sản xuất. Đã kiểm tra gói tĩnh cục bộ, gồm đường dẫn dạng thư mục dự án GitHub Pages.

## Cấu trúc
- index.html: điểm vào; các chuyên mục dùng hash route để không lỗi tải lại trên GitHub Pages.
- assets/style.css, app.js, sample.js: giao diện, logic, bài mẫu có nguồn.
- assets/images: bốn ảnh gốc và tệp kiểm tra SHA-256.
- assets/fonts: Charm-Regular.ttf và giấy phép OFL. Font mã nguồn mở từ Google Fonts.
- data/catalog.json + catalog.js: dữ liệu công khai. Hai tệp phải đồng nhất.
- tools/catalog-editor.html + editor.js: biên tập danh mục cục bộ.
- tools/prepare_pdf.py: trích xuất PDF riêng tư; không phân tích AI.
- docs/QUAN-TRI.md: nhập sách, phê duyệt và xuất bản.
- docs/BACKEND.md + backend/schema.sql: kiến trúc mở rộng và mẫu RLS chưa triển khai.
- docs/QA.md: kiểm tra đã chạy và giới hạn kiểm chứng.

## Xuất bản GitHub Pages
1. Tạo repository riêng cho phần công khai. Không đưa PDF, bản thảo riêng, credential hoặc ID Drive vào repository dù tạm thời.
2. Tải TOÀN BỘ nội dung trong thư mục này lên gốc repository, không chỉ index.html. Nếu muốn chỉ công khai website, không cần upload tools, docs, backend; hãy giữ chúng trên máy quản trị.
3. Settings → Pages → Deploy from a branch → main / root → Save.
4. Đợi GitHub báo triển khai thành công, mở URL do GitHub cung cấp. Không tự suy ra URL khi chưa có tài khoản/repository thực.
5. Kiểm tra trang chủ, menu, danh mục, sách, tìm kiếm và cả bốn ảnh: tri-an-thay-tuan.png, triet-ly-song.jpg, hanh-trinh-kien-tao.png, biet-on-vi-tat-ca.jpg.
6. Mở một hash route sách rồi tải lại. Thử cửa sổ riêng tư và điện thoại thật. Kiểm tra tab Network không có lỗi 404.
7. Chỉ chia sẻ URL sau khi kiểm tra. Bản này dùng đường dẫn tương đối, không bắt đầu bằng `/assets`, nên chạy dưới tên thư mục repository.

Lưu ý: dữ liệu tĩnh công khai đều có thể đọc/sao chép, dù nút hoặc liên kết bị ẩn. Hệ thống tĩnh không bảo vệ được dữ liệu riêng.
