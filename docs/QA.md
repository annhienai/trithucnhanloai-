# Báo cáo kiểm thử · 27/10/2026

## Môi trường và phạm vi
Chromium headless tại máy cục bộ, kích thước 1440×1000 (máy tính), 820×1180 (máy tính bảng), 390×844 (điện thoại). Không phải kiểm thử trên thiết bị vật lý hoặc chứng nhận mọi trình duyệt. Đã mở ảnh chụp để kiểm tra trực quan các chuyên mục chính và các trạng thái quan trọng, sửa biểu tượng thiếu glyph, tăng cỡ nhãn chức năng và tránh che chữ trên thiết kế bìa tri ân.

## Kết quả kiểm tra tự động
22 phép kiểm tra tương tác trong bộ chính đều đạt. Kiểm tra bố cục 14 chuyên mục × 3 kích thước: không có tràn ngang toàn trang. Không phát hiện lỗi JavaScript hoặc phản hồi tài nguyên lỗi trong các lượt kiểm tra.

- Thư mở đầu đủ nội dung; ghi nhớ tùy chọn bỏ qua sau tải lại.
- Tìm kiếm tiếng Việt không dấu; không có kết quả; xóa bộ lọc; lọc chủ đề.
- 12 mục của sách chưa xử lý đều có trạng thái chờ, không bịa nội dung.
- 12 mục hồ sơ minh họa đều có nội dung hoặc trạng thái chờ mục lục thật; sơ đồ theo chủ đề hiện đúng.
- Yêu thích, ghi chú và tiến độ lưu sau tải lại; hiển thị tại Góc học tập.
- Tra cứu từ khóa có bài liên quan; câu hỏi ngoài dữ liệu không tự bịa câu trả lời.
- Ảnh có lightbox, đóng bằng Escape; bổ sung nút xem kích thước gốc và thu về vừa màn hình.
- Menu điện thoại mở/đóng và chuyển đúng trang; A+ không gây tràn ngang trong kiểm thử.
- Công cụ biên tập thêm sách; từ chối xuất bản thiếu nguồn/quyền; nhập 150 hồ sơ thử.
- Mở index.html trực tiếp bằng file: vẫn có đủ 12 hồ sơ, không cần fetch.

## Kiểm tra bổ sung
- Nút Bỏ qua điều hướng đưa focus vào main, không bị hash router hiểu nhầm thành trang mới.
- Công cụ xuất đủ catalog.json và catalog.js, danh mục 12 hồ sơ đúng.
- Chuỗi HTML thử trong tên sách được escape, không thực thi script.
- Tải cả bốn ảnh bằng đường dẫn dưới thư mục dự án và so SHA-256: khớp originals-manifest.json và tệp gốc.
- Phông Charm có glyph tiếng Việt, kể cả chữ Đ/Ơ/Ư và dấu kết hợp trong tên và thư.
- Công cụ chuẩn bị PDF đã thử với một PDF tổng hợp không chứa sách thật: sinh văn bản theo trang và metadata riêng. Chưa thử PDF scan, mật khẩu, lỗi hoặc kho sách thật; cần OCR và xử lý vận hành bổ sung.

## Chưa thể xác nhận
- Chưa triển khai GitHub Pages: phải kiểm tra lại sau lần xuất bản thực tế. Kiểm tra hiện tại chứng minh đường dẫn tương đối chạy dưới thư mục dự án, không thay thế kiểm tra trên hạ tầng GitHub.
- Chưa thử phát video thật vì chủ thư viện chưa chọn video. Link kênh có trong giao diện; không tự phát. Cần kiểm tra quyền nhúng và điều khiển âm lượng cho video được chọn.
- Chưa xác minh khả năng truy cập từng hồ sơ Facebook/YouTube/Zalo từ tài khoản người dùng; chuỗi URL được đối chiếu yêu cầu.
- Không có hệ thống xác thực/RLS đang chạy để kiểm thử. schema.sql là mẫu chưa triển khai; cần kiểm thử riêng trước khi bật tài khoản/tài liệu.
- Chưa kiểm thử Safari/iOS, trình đọc màn hình thực tế, audit WCAG đầy đủ hoặc hiệu năng với hàng nghìn đầu sách.

## Checklist sau khi chị An xuất bản
Mở máy tính và điện thoại thật; vào bốn khu vực ảnh và bấm phóng to; thử tìm sách không dấu; mở hồ sơ sách và tải lại; kiểm tra console/network không có 404; thêm video thật rồi kiểm tra phát/dừng/âm lượng; kiểm tra không có dữ liệu riêng trong repo hoặc file JS. Không coi “ẩn link” là bảo mật.
