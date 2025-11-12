# 🚀 Các bước tiếp theo để deploy lên Railway

## Bước 1: Khởi tạo Git Repository (Nếu chưa có)

Nếu chưa có Git repository, chạy các lệnh sau:

```bash
# Khởi tạo git
git init

# Thêm tất cả file
git add .

# Commit lần đầu
git commit -m "Initial commit - Warehouse Management System"

# Tạo repository trên GitHub (qua web)
# Sau đó link với local:
git remote add origin https://github.com/your-username/your-repo-name.git
git branch -M main
git push -u origin main
```

## Bước 2: Push code lên GitHub

Nếu đã có Git repository:

```bash
# Kiểm tra trạng thái
git status

# Thêm các file mới
git add .

# Commit
git commit -m "Add Railway deployment configuration and PostgreSQL support"

# Push lên GitHub
git push origin main
```

## Bước 3: Đăng ký và Setup Railway

### 3.1. Đăng ký Railway
1. Truy cập: **https://railway.app**
2. Click **"Start a New Project"** hoặc **"Login"**
3. Chọn **"Login with GitHub"**
4. Authorize Railway truy cập GitHub
5. Chọn plan **"Hobby"** (miễn phí, $5 credit/tháng)

### 3.2. Tạo Project
1. Click **"+ New Project"** (góc trên bên phải)
2. Chọn **"Deploy from GitHub repo"**
3. Chọn repository của bạn
4. Railway sẽ tự động detect và bắt đầu build

## Bước 4: Thêm PostgreSQL Database

1. Trong project dashboard, click **"+ New"** (bên trái)
2. Chọn **"Database"** → **"Add PostgreSQL"**
3. Đợi Railway tạo database (vài giây)

## Bước 5: Cấu hình Environment Variables

Railway thường tự động link database với web service. Kiểm tra:

1. Vào **Web Service** (service đầu tiên)
2. Click tab **"Variables"**
3. Railway tự động thêm:
   - `DATABASE_URL` (từ PostgreSQL service)
   - `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`

Nếu chưa có, thêm thủ công:
- Click **"New Variable"**
- Name: `DATABASE_URL`
- Value: `${{Postgres.DATABASE_URL}}`

## Bước 6: Chạy Database Script

### Cách dễ nhất - Dùng Railway Dashboard:

1. Vào **PostgreSQL service** (service màu xanh)
2. Click tab **"Data"**
3. Click nút **"Query"** hoặc **"Connect"**
4. Mở file SQL PostgreSQL của bạn
5. Copy toàn bộ nội dung script
6. Paste vào SQL editor
7. Click **"Run"** hoặc **"Execute"**
8. Đợi script chạy xong (có thể mất 1-2 phút)

**Lưu ý:** Nếu script quá dài, có thể chia nhỏ và chạy từng phần.

## Bước 7: Kiểm tra Deployment

1. Vào **Web Service** → tab **"Deployments"**
2. Xem logs:
   - Build logs: Xem quá trình build
   - Runtime logs: Xem app đang chạy
3. Nếu có lỗi, click vào deployment để xem chi tiết

## Bước 8: Lấy URL và Test

1. Vào **Web Service** → tab **"Settings"**
2. Scroll xuống phần **"Domains"**
3. Railway tự tạo domain: `your-app-name.up.railway.app`
4. Click vào domain để mở app
5. Test:
   - Đăng nhập
   - Các chức năng chính
   - Database connection

## Bước 9: Cấu hình Google OAuth (Nếu có)

1. Vào Google Cloud Console: https://console.cloud.google.com
2. **APIs & Services** → **Credentials**
3. Chọn OAuth 2.0 Client ID
4. Thêm **Authorized redirect URIs**:
   ```
   https://your-app-name.up.railway.app/auth/google/callback
   ```
5. Railway → **Web Service** → **Variables**
6. Thêm:
   - `GOOGLE_CLIENT_ID` = (client ID)
   - `GOOGLE_CLIENT_SECRET` = (client secret)
7. Service sẽ tự động restart

---

## 🎯 Checklist

- [ ] Đã push code lên GitHub
- [ ] Đã đăng ký Railway và tạo project
- [ ] Đã thêm PostgreSQL database
- [ ] Đã kiểm tra environment variables
- [ ] Đã chạy database script
- [ ] Đã test app trên Railway
- [ ] Đã cấu hình Google OAuth (nếu cần)

---

## 🔧 Troubleshooting nhanh

**Build failed?**
→ Xem logs trong tab "Deployments"

**Database connection error?**
→ Kiểm tra environment variables, đảm bảo PostgreSQL đã link

**App không chạy?**
→ Xem runtime logs, kiểm tra WAR file đã tạo chưa

**Script SQL lỗi?**
→ Kiểm tra syntax PostgreSQL, chia nhỏ script nếu cần

---

## 📚 Tài liệu tham khảo

- Railway Docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway

