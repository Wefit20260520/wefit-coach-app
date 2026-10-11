# Wefit Coach Cloud V2 — 雲端測試版

## 能做什麼
- Supabase 電子郵件註冊／登入；同一帳號在手機、平板、電腦看到相同雲端資料（重新整理即可更新）
- 新增學員、預約課程、完成／取消課程、購課堂數與剩餘堂數
- 資料庫 Row Level Security (RLS) 強制每位教練只讀寫自己的資料
- 響應式介面與 PWA 安裝清單

## 開始使用（約 10–20 分鐘）
1. 前往 https://supabase.com/dashboard 建立免費 Supabase 專案，選擇適合的區域並保管好資料庫密碼。
2. 打開專案 **SQL Editor**，貼上 `schema.sql` 全部內容，執行一次。
3. 到 **Project Settings → API**（新版可能是 Connect/API Keys），複製 **Project URL** 與 **publishable / anon key**，填入 `config.js` 的兩個空字串。**切勿填 service_role 或 secret key。**
4. 到 **Authentication → Providers → Email** 檢查是否允許 Email 註冊及驗證；測試時建議保留 Email 驗證。正式上線前限制註冊、設定邀請流程。
5. 將本資料夾部署至支援 HTTPS 的靜態網站託管服務，並將網站網址加入 Supabase **Authentication → URL Configuration** 的 Site URL / Redirect URLs。可先用 `python3 -m http.server 8080` 在電腦本機測試，但手機需要 HTTPS 部署網址。
6. 在兩台裝置開啟同一個網址，使用同一帳號登入；在 A 新增「示範學員」，在 B 重新整理頁面，即可看到同一筆資料。

## 重要安全限制
- **測試版，請只用虛構學員資料。** 尚未完成個資保護、稽核紀錄、備份還原、帳號邀請及正式商用檢核。
- 每個教練帳號目前只有自己的資料；**管理員跨教練總覽尚未實作**。`profiles.role` 目前不賦予任何跨帳號權限。此設計避免測試版權限洩漏。
- 未整合舊 Google Sheets、Google Calendar；未自動即時推播變更（重新整理可同步）。
- 正式版應加入組織／團隊資料模型、受控管理員角色、後端權限與資料備份。
- Supabase 免費方案限制和部署商用條款依供應商最新規定。
