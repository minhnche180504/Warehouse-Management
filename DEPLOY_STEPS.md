# Các bước deploy lên Railway - Hướng dẫn chi tiết

## ✅ Đã hoàn thành:
- [x] Convert database script sang PostgreSQL
- [x] PostgreSQL JDBC driver đã có trong lib/
- [x] Các file cấu hình Railway đã tạo

## 📋 Các bước tiếp theo:

### Bước 1: Kiểm tra file SQL PostgreSQL

Đảm bảo bạn có file SQL đã convert (ví dụ: `ISP392_DTB_postgresql.sql` hoặc đã sửa `ISP392_DTB.sql`)

### Bước 2: Commit và Push code lên GitHub

```bash
# Kiểm tra trạng thái
git status

# Thêm tất cả file mới
git add .

# Commit
git commit -m "Add Railway deployment configuration and PostgreSQL support"

# Push lên GitHub
git push origin main
```

### Bước 3: Đăng ký Railway

1. Truy cập: **https://railway.app**
2. Click **"Start a New Project"** hoặc **"Login"**
3. Chọn **"Login with GitHub"**
4. Authorize Railway truy cập GitHub repositories
5. Chọn plan **"Hobby"** (miễn phí)

### Bước 4: Tạo Project mới trên Railway

1. Click nút **"+ New Project"** (góc trên bên phải)
2. Chọn **"Deploy from GitHub repo"**
3. Chọn repository **"Warehouse-Management"** (hoặc tên repo của bạn)
4. Railway sẽ tự động detect Java project và bắt đầu build

### Bước 5: Thêm PostgreSQL Database

1. Trong project dashboard, click nút **"+ New"** (bên trái)
2. Chọn **"Database"**
3. Chọn **"Add PostgreSQL"**
4. Railway sẽ tự động tạo PostgreSQL database
5. Đợi vài giây để database khởi tạo xong

### Bước 6: Link Database với Web Service

1. Click vào **PostgreSQL service** (service màu xanh)
2. Vào tab **"Variables"**
3. Copy các giá trị:
   - `DATABASE_URL`
   - `PGHOST`
   - `PGPORT`
   - `PGDATABASE`
   - `PGUSER`
   - `PGPASSWORD`

4. Quay lại **Web Service** (service đầu tiên)
5. Vào tab **"Variables"**
6. Railway thường tự động link, nhưng nếu chưa có, thêm:
   - Click **"New Variable"**
   - Thêm: `DATABASE_URL` = `${{Postgres.DATABASE_URL}}`
   - (Railway sẽ tự động thay thế giá trị)

### Bước 7: Chạy Database Script

#### Cách 1: Dùng Railway Dashboard (Dễ nhất)

1. Vào **PostgreSQL service**
2. Click tab **"Data"**
3. Click nút **"Query"** (hoặc "Connect")
4. Mở file SQL PostgreSQL của bạn (`ISP392_DTB_postgresql.sql`)
5. Copy toàn bộ nội dung
6. Paste vào SQL editor
7. Click **"Run"** hoặc **"Execute"**
8. Đợi script chạy xong (có thể mất vài phút)

#### Cách 2: Dùng Railway CLI (Nâng cao)

```bash
# Cài Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link project
railway link

# Connect to database
railway connect postgres

# Chạy script (sau khi connect)
psql < ISP392_DTB_postgresql.sql
```

### Bước 8: Kiểm tra Deployment

1. Vào **Web Service** → tab **"Deployments"**
2. Xem logs để đảm bảo build thành công
3. Nếu có lỗi, click vào deployment để xem chi tiết

### Bước 9: Lấy URL và Test

1. Vào **Web Service** → tab **"Settings"**
2. Scroll xuống phần **"Domains"**
3. Railway tự tạo domain: `your-app-name.up.railway.app`
4. Click vào domain để mở trong browser
5. Test đăng nhập và các chức năng

### Bước 10: Cấu hình Google OAuth (Nếu có)

1. Vào Google Cloud Console: https://console.cloud.google.com
2. Vào **APIs & Services** → **Credentials**
3. Chọn OAuth 2.0 Client ID của bạn
4. Thêm **Authorized redirect URIs**:
   ```
   https://your-app-name.up.railway.app/auth/google/callback
   ```
5. Quay lại Railway → **Web Service** → **Variables**
6. Thêm:
   - `GOOGLE_CLIENT_ID` = (client ID của bạn)
   - `GOOGLE_CLIENT_SECRET` = (client secret của bạn)
7. Railway sẽ tự động restart service

---

## 🔍 Troubleshooting

### Lỗi: "Build failed"
- Kiểm tra logs trong tab "Deployments"
- Đảm bảo file `nixpacks.toml` đúng format
- Kiểm tra xem `ant war` có chạy được local không

### Lỗi: "Database connection failed"
- Kiểm tra environment variables đã set đúng chưa
- Đảm bảo PostgreSQL service đã được link với web service
- Xem logs để biết lỗi cụ thể

### Lỗi: "ClassNotFoundException: org.postgresql.Driver"
- Đảm bảo `postgresql-42.7.7.jar` có trong thư mục `lib/`
- Rebuild và redeploy

### App không chạy sau khi deploy
- Kiểm tra logs trong Railway dashboard
- Đảm bảo WAR file được tạo: `dist/Warehouse.war`
- Kiểm tra start command trong `nixpacks.toml`

### Database script lỗi
- Kiểm tra syntax PostgreSQL
- Đảm bảo đã convert đúng từ MSSQL
- Chạy từng phần script nếu script quá dài

---

## ✅ Checklist cuối cùng

- [ ] Đã push code lên GitHub
- [ ] Đã tạo Railway project và link GitHub repo
- [ ] Đã thêm PostgreSQL database
- [ ] Đã kiểm tra environment variables
- [ ] Đã chạy database script thành công
- [ ] Đã test app trên Railway domain
- [ ] Đã cấu hình Google OAuth (nếu cần)

---

## 📞 Cần hỗ trợ?

- Railway Docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway
- Xem logs trong Railway dashboard để debug

