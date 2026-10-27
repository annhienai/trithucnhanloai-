# Hướng dẫn quản trị cục bộ

## Ranh giới bảo mật
Công cụ biên tập là tiện ích tạo tệp trên máy của chủ thư viện. Không có đăng nhập và không kết nối máy chủ. Người ghé website không thể dùng công cụ này để sửa repository của bạn. Tuy nhiên mọi tệp bạn tải lên repository công khai đều có thể bị đọc. Không dùng thư mục website để giữ bản thảo riêng.

## Thêm hoặc sửa sách
1. Mở tools/catalog-editor.html, nhập data/catalog.json nếu đang biên tập một bản cũ.
2. Chọn sách hoặc Thêm sách. Mã định danh duy nhất chỉ gồm a-z, 0-9 và dấu gạch nối.
3. Nhập tên và tác giả đã xác minh. Không biết tác giả thì để trống. Chọn chủ đề phù hợp nhất.
4. Nếu có bìa được phép sử dụng, tự chép tệp vào assets/images, tên không dấu và dùng đường dẫn assets/images/ten-bia.jpg. Không dùng liên kết ảnh tạm.
5. Bấm Giữ thay đổi trong phiên. Đây chưa phải lưu lên đĩa hoặc xuất bản.
6. Bấm Kiểm tra & xuất hai tệp dữ liệu. Cho phép trình duyệt tải nhiều tệp nếu được hỏi. Thay data/catalog.json và data/catalog.js bằng hai tệp vừa tải (không giữ hậu tố (1) trong tên).
7. Mở index.html kiểm tra rồi tải lại hai tệp lên GitHub. Dữ liệu công khai không được có ID kho nguồn hay liên kết tài liệu riêng.

## Phân tích có duyệt
Các mục công khai chỉ hiện khi status = published và sections[].approved = true. Công cụ yêu cầu quyền không còn unknown và ít nhất một nguồn HTTPS hợp lệ, nhưng KHÔNG thể tự xác minh nguồn hoặc giá trị pháp lý. Chính chủ phải kiểm tra nội dung, quyền sử dụng và nguồn trước khi chọn “Đã duyệt”.

sections là mảng bài viết văn bản thuần:
```json
[{"key":0,"approved":true,"text":"Bài giới thiệu đã kiểm chứng, viết bằng lời của người biên tập."}]
```
key 0..11 tương ứng các nút trong hồ sơ sách. Các nút 4..6 thay đổi theo nhóm sức khỏe, kinh doanh/quản trị, triết học hoặc nhóm còn lại. Hiện sơ đồ tùy chỉnh có thể viết ở mục key 9; chỉ hồ sơ mẫu có sơ đồ trực quan. Không tải HTML lạ vào trường text. Xuống dòng bằng ký tự \n trong JSON.

Nguồn:
```json
[{"label":"Tên nguồn đã kiểm chứng","url":"https://nguon-thuc-te.example"}]
```
URL trên là ký hiệu minh họa trong tài liệu, không phải dữ liệu đã nhập. Hãy thay bằng nguồn thật; không dùng liên kết Drive riêng, link chứa token hoặc tài liệu chưa được phép công khai.

Chuyển về draft sẽ loại toàn bộ sections khỏi dữ liệu công khai khi xuất. Đánh dấu hidden loại cả hồ sơ khỏi danh mục xuất. Bản xuất công khai không phải bản sao lưu bản thảo: giữ bản thảo riêng ngoài repository và ngoài ZIP công khai. Không có nút xuất bản lên mạng tự động.

## Nhập hơn 100 sách
Công cụ nhận một JSON có version: 1, books: [...], music: [], websites: []. Có thể biên soạn danh mục hàng loạt ở trình soạn thảo JSON và nhập một lần. Giới hạn tệp 20 MB để tránh treo trình duyệt; hiện hiển thị danh mục không phân trang nên nên dùng tìm kiếm khi dữ liệu tăng lớn. Đã kiểm tra nhập 150 hồ sơ thử trong QA, không đưa hồ sơ thử vào danh mục bàn giao.

Mỗi hồ sơ gồm id, title, author (null nếu chưa rõ), topic, cover (null hoặc đường dẫn ảnh), description, status (pending/draft/published), rights (unknown/commentary-only/licensed/public-domain), featured (boolean), hidden (boolean), sources (mảng), sections (mảng). mindmap/illustrations dành cho mở rộng; bản công khai hiện không render dữ liệu riêng của hai trường này.

## Âm nhạc
Tại công cụ dữ liệu, nhập mảng music gồm title và videoId (11 ký tự của một video YouTube thực tế được chủ thư viện lựa chọn). Không dùng ID kênh thay cho ID video. Giữ thay đổi và xuất hai tệp. Trên trang âm nhạc, người đọc tự bấm tải trình phát; iframe không autoplay. Dùng điều khiển YouTube để dừng và chỉnh âm lượng. Chọn video khác để đổi bài; chưa có hàng đợi phát liên tục hoặc hỗ trợ playlist riêng. Chính sách nền tảng và quyền nhúng của từng video có thể hạn chế phát, phải thử video thật trước khi công khai.

## Website đã kiến tạo
Thêm mảng websites có title, topic, description, url HTTPS thật, image tương đối (nếu có quyền). Giữ thay đổi rồi xuất tệp. Không tự tạo URL, không tạo ảnh giả giao diện website của người khác.

## Chuẩn bị PDF riêng
Công cụ tools/prepare_pdf.py dùng Python 3 và Poppler (pdfinfo/pdftotext). Tải PDF bằng tài khoản có quyền trên máy chủ thư viện, không đổi quyền chia sẻ Drive.

```bash
python3 tools/prepare_pdf.py /duong-dan-nguon-rieng --out /duong-dan-ban-thao-rieng
```
Đường dẫn trên cần thay bằng thư mục thật trên máy của bạn. Công cụ từ chối xuất vào thư mục website. Nó tạo intake-index.json, hash SHA-256, metadata thô và văn bản theo trang, đánh dấu needs-review hoặc needs-ocr. Không đưa PDF vào ZIP; không có gọi AI; không có suy luận tên sách. PDF scan cần OCR bổ sung. Chỉ gửi tài liệu cho dịch vụ OCR/AI khi có quyền và đồng ý chính sách xử lý dữ liệu.

## Bảo toàn bốn tác phẩm
Không ghi đè, resize, crop, nén lại hoặc chỉnh màu tệp gốc. CSS dùng width:100%, height:auto, object-fit:contain. Lightbox xem nguyên bản. File originals-manifest.json lưu hash để kiểm tra. Trình duyệt có thể nội suy khi phóng lớn hơn độ phân giải gốc; website không thể tạo thêm chi tiết thật cho ảnh.

## Ghi chú người đọc
localStorage chỉ thuộc trình duyệt/nguồn trang hiện tại, không đồng bộ tài khoản hoặc thiết bị. Khi chuyển từ file sang tên miền, xuất trước rồi nhập lại. Sao lưu dùng JSON phiên bản 1. Nhập sao lưu thay thế dữ liệu cũ sau xác nhận. Không nhập thông tin nhạy cảm.
