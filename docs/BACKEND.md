# Kiến trúc mở rộng – chưa kết nối / chưa triển khai

Không có endpoint, tài khoản hoặc khóa nào được cấu hình trong bản website này. schema.sql là mẫu khởi đầu để kỹ sư triển khai trong một dự án Supabase thử nghiệm, không phải chứng nhận hệ thống đã bảo mật.

## Phân tách bốn lớp
1. PUBLIC: GitHub Pages chỉ có dữ liệu công khai đã duyệt và tài nguyên được cấp quyền. Không lấy toàn bộ bảng nội bộ rồi “ẩn” bằng JavaScript.
2. AUTH: Supabase Auth (email magic link hoặc mật khẩu + email verification, tùy chính sách). Cấu hình redirect allowlist, giới hạn yêu cầu, CAPTCHA/rate limiting nếu cần. Khóa anon/publishable chỉ có thể đặt ở client khi RLS đã kiểm thử; service_role và khóa AI tuyệt đối ở server.
3. PRIVATE: PostgreSQL RLS cho ghi chú, yêu thích, tiến độ; Storage bucket riêng; bảng document_acl cấp quyền từng tài liệu. Xác thực không có nghĩa là tự được đọc mọi tài liệu. Không suy ra quyền từ trạng thái đăng nhập.
4. PROCESSING: backend worker có xác thực dành cho chủ thư viện, hàng đợi PDF, OCR, chia đoạn kèm số trang và hash, AI bản thảo, bảng review và thao tác phê duyệt có log. Không chạy khóa AI trong browser.

## Hành trình xuất bản thực tế đề xuất
- Chủ thư viện chọn một tập tài liệu được phép xử lý từ máy riêng hoặc kết nối Drive read-only theo phạm vi tối thiểu. Không tự đổi quyền thư mục.
- Nhận PDF vào nơi riêng, kiểm tra loại/kích thước và quét độc hại nếu nhận upload; tính hash để tránh nhập trùng. Không tin metadata hoặc nội dung PDF như chỉ dẫn thực thi.
- Trích xuất theo trang; OCR cho bản scan; giữ vị trí nguồn và bản quyền. Tên file chỉ là gợi ý, không phải bằng chứng tác giả/ấn bản.
- Gửi các phần được phép đến AI; giới hạn token, số lần thử, chi phí, độ dài trích dẫn. Đầu ra phải theo schema và luôn status=draft. AI không có quyền duyệt.
- Mỗi luận điểm ghi nguồn và số trang đã kiểm tra. Nếu trang không rõ, giữ pending; không bịa số chương hoặc trích dẫn. Phân biệt phần bình luận, phần diễn giải, tình huống giả định và phát biểu có căn cứ.
- Chủ thư viện xem bản thảo, kiểm tra sức khỏe/tài chính và quyền tác giả, duyệt từng bài, rồi xuất dữ liệu công khai qua allowlist trường. Không để draft trong file tải công khai.
- Bản đồ tri thức tùy sách xây dựng sau khi có cấu trúc thật. Không dựa duy nhất vào phân loại.

## Hỏi đáp RAG
POST /api/ask nhận câu hỏi và book_id; xác thực nếu tài liệu riêng; lọc quyền TRƯỚC truy xuất; chỉ lấy chunk của tài liệu được phép, không nhận danh sách quyền do client tự khai. Trả answer, citations (doc, edition, page, chunk hash), hoặc trạng thái insufficient_evidence. Kiểm tra rằng các trích dẫn tồn tại; không có nguồn thì từ chối trả lời về sách. Không cho nội dung tài liệu ghi đè system prompt hoặc yêu cầu truy cập ngoài phạm vi.

## Tài liệu gốc
GET /api/documents/:id/download xác thực token phía máy chủ, kiểm tra document_acl và quyền chia sẻ tài liệu; chỉ sau đó tạo signed URL thời hạn ngắn. Service role bypass RLS nên endpoint bắt buộc tự kiểm tra ACL trước khi ký. Không có chức năng liệt kê toàn bộ nguồn. Không log token hoặc signed URL dài hạn. Không tuyên bố chống sao chép tuyệt đối.

## Quản trị
- Vai trò admin chỉ do chủ dự án cấp ở máy chủ. Không có chính sách cho người dùng tự thêm admin.
- Quản lý người dùng qua backend với service role, có audit log; không để client gọi trực tiếp Auth Admin API.
- Mỗi hành động thêm/sửa/duyệt/ẩn bài cần kiểm tra quyền ở server. Giao diện là bổ sung, không phải hàng rào bảo mật.
- Triển khai sao lưu, lưu phiên bản, xóa dữ liệu theo yêu cầu, hạn chế băng thông và cảnh báo chi phí.

## Kiểm thử bắt buộc trước vận hành
- Người chưa đăng nhập không đọc được notes/bookmarks/progress/documents/ACL.
- User A không đọc/sửa được dữ liệu User B; user không tự thêm admin.
- User chưa cấp quyền không truy xuất document hoặc Storage object kể cả đoán được ID.
- Admin có quyền đọc bản thảo; người thường không đọc bản thảo. Đổi quyền phải có hiệu lực với request tiếp theo.
- Endpoint ký URL kiểm tra quyền và quyền chia sẻ từng file; không chỉ kiểm tra một biến trên trình duyệt.
- Không có khóa service_role/AI trong JS, repo, ZIP, source map hoặc log.
- Thử email xác thực thật, hết hạn token, thu hồi tài khoản, rate limit, network error và rollback trước khi mở đăng ký.

## Chi phí cần dự trù (không phải báo giá)
GitHub Pages có hạn mức theo chính sách hiện hành. Backend tính theo gói, storage, băng thông và compute; AI theo token/model; OCR theo trang/dịch vụ; embedding và truy xuất theo khối lượng; email và tên miền tùy nhà cung cấp. Kiểm tra bảng giá hiện hành và đặt hạn mức trước khi bật. Chưa bật dịch vụ hoặc tạo tài khoản trả phí trong bàn giao này.
