# Hướng dẫn Deploy lên Railway

## Bước 1: Tải PostgreSQL JDBC Driver

1. Truy cập: https://jdbc.postgresql.org/download/
2. Tải file `postgresql-42.7.1.jar` (hoặc version mới nhất)
3. Đặt file vào thư mục `lib/` của project

Hoặc dùng lệnh:
```bash
cd lib
curl -O https://jdbc.postgresql.org/download/postgresql-42.7.1.jar
```

## Bước 2: Chuyển đổi Database Script

Cần chuyển file `ISP392_DTB.sql` từ MSSQL sang PostgreSQL.

### Các thay đổi chính:
- `IDENTITY(1,1)` → `SERIAL` hoặc `GENERATED ALWAYS AS IDENTITY`
- `NVARCHAR` → `VARCHAR`
- `DATETIME` → `TIMESTAMP`
- `GETDATE()` → `NOW()`
- `[User]` → `"User"` (thêm quotes cho reserved words)
- `GO` → bỏ (PostgreSQL không cần)

### Tool hỗ trợ:
- Online converter: https://www.sqlines.com/online
- Hoặc tạo file mới `ISP392_DTB_postgresql.sql` và convert thủ công

## Bước 3: Đăng ký và Setup Railway

1. Truy cập: https://railway.app
2. Click "Start a New Project"
3. Chọn "Login with GitHub"
4. Authorize Railway truy cập GitHub

## Bước 4: Tạo Project trên Railway

1. Click "New Project"
2. Chọn "Deploy from GitHub repo"
3. Chọn repository của bạn
4. Railway sẽ tự detect Java project

## Bước 5: Thêm PostgreSQL Database

1. Trong project dashboard, click "+ New"
2. Chọn "Database" → "Add PostgreSQL"
3. Railway tự tạo database và cung cấp connection string

## Bước 6: Cấu hình Environment Variables

1. Vào tab "Variables" trong service (không phải database service)
2. Railway tự động thêm các biến từ PostgreSQL service:
   - `DATABASE_URL` (tự động link)
   - `PGHOST`
   - `PGPORT`
   - `PGDATABASE`
   - `PGUSER`
   - `PGPASSWORD`

3. Thêm biến bổ sung nếu cần:
   ```
   DB_TYPE=postgresql
   ```

## Bước 7: Chạy Database Script

### Cách 1: Dùng Railway Dashboard
1. Vào PostgreSQL service → tab "Data"
2. Click "Query" để mở SQL editor
3. Copy nội dung file `ISP392_DTB_postgresql.sql` (đã convert)
4. Paste và Execute

### Cách 2: Dùng Railway CLI
```bash
# Cài Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link project
railway link

# Connect to database
railway connect postgres

# Sau đó chạy script
psql < ISP392_DTB_postgresql.sql
```

## Bước 8: Push Code và Deploy

```bash
# Commit các file mới
git add .
git commit -m "Add Railway deployment configuration"
git push origin main
```

Railway sẽ tự động:
- Detect push
- Build project (chạy `ant war`)
- Deploy WAR file
- Start application

## Bước 9: Kiểm tra Deployment

1. Vào tab "Deployments" để xem logs
2. Vào tab "Settings" → "Domains"
3. Railway tự tạo domain: `your-app.up.railway.app`
4. Click domain để mở app
5. Test login và các chức năng

## Bước 10: Cấu hình Google OAuth (nếu có)

1. Vào Google Cloud Console
2. Thêm redirect URI mới: `https://your-app.up.railway.app/auth/google/callback`
3. Thêm environment variables trên Railway:
   ```
   GOOGLE_CLIENT_ID=your-client-id
   GOOGLE_CLIENT_SECRET=your-client-secret
   ```

## Troubleshooting

### Lỗi: "Cannot find ant"
- File `nixpacks.toml` đã được tạo, Railway sẽ tự cài ant

### Lỗi: "Database connection failed"
- Kiểm tra environment variables trong Railway dashboard
- Xem logs trong tab "Deployments"
- Đảm bảo PostgreSQL service đã được link với web service

### Lỗi: "ClassNotFoundException: org.postgresql.Driver"
- Đảm bảo đã thêm `postgresql-42.x.x.jar` vào thư mục `lib/`
- Rebuild và redeploy

### Lỗi: "Port already in use"
- Railway tự động set PORT, không cần config thêm

### Build thành công nhưng app không chạy
- Kiểm tra logs trong Railway dashboard
- Đảm bảo WAR file được tạo đúng: `dist/Warehouse.war`
- Kiểm tra start command trong `nixpacks.toml`

## Checklist

- [ ] Đã tải PostgreSQL JDBC driver vào `lib/`
- [ ] Đã convert SQL script sang PostgreSQL
- [ ] Đã push code lên GitHub
- [ ] Đã tạo Railway project và link GitHub repo
- [ ] Đã thêm PostgreSQL database
- [ ] Đã kiểm tra environment variables
- [ ] Đã chạy database script
- [ ] Đã test deployment thành công

## Tài liệu tham khảo

- Railway Docs: https://docs.railway.app
- PostgreSQL JDBC: https://jdbc.postgresql.org/
- SQL Converter: https://www.sqlines.com/online

