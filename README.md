# ical-calendar-feeds

用來存放 `.ics` 日曆檔案，透過 GitHub Pages 對外提供靜態網址，讓 epaper 專案可以用 HTTP 直接抓取 iCal 日曆來源。

## 隱私設計（請先讀）

GitHub Pages 網站**即使 repo 設成 private，網站本身還是公開可存取的**（GitHub Free 方案沒有限制 Pages 訪客登入的功能）。因此這個專案的保護方式是：

- repo 設為 **private**（原始碼、commit 記錄不公開，免費）
- `.ics` 檔案一律用**隨機檔名**（例如 `f9344e532dfdeb08.ics`），不要用小孩名字、學校名稱等描述性檔名
- `index.html` / `manifest.json`（會列出所有檔名的清單頁）**刻意不 commit、不部署**，避免把所有隨機檔名列在公開首頁上洩漏出去
- 檔名 <-> 實際內容的對應表存在 `calendars/LOCAL_NOTES.md`，這個檔案已加進 `.gitignore`，只留在本機

簡單說：只要 URL 不外流，別人猜中的機率極低；但這仍是「隱蔽性保護」而不是真正的存取控制，不要把非常敏感的資料放進去。

## 首次設定

1. 到 GitHub 建立一個新的 **private** repository（不要勾選 add README），例如叫 `ical-calendar-feeds`。
2. 在這個資料夾內設定 remote 並 push：

   ```bash
   git remote add origin git@github.com:<你的帳號>/ical-calendar-feeds.git
   git branch -M main
   git push -u origin main
   ```

3. 到 repo 的 **Settings → Pages**，Source 選擇 `Deploy from a branch`，Branch 選 `main` / `/ (root)`，儲存。
4. 等一兩分鐘後，日曆網址會是：

   ```
   https://<你的帳號>.github.io/ical-calendar-feeds/calendars/<隨機檔名>.ics
   ```

## 日常使用：上傳新的 .ics

```bash
./add_calendar.sh /path/to/mycalendar.ics "備註，例如：Javery 課表"
```

這會自動：
- 把檔案複製進 `calendars/`，用隨機字串當檔名
- 把「隨機檔名 → 你的備註」寫進 `calendars/LOCAL_NOTES.md`（只在本機，不會上傳）
- `git commit` 並 `git push`
- 印出可以直接貼進 epaper 專案的完整網址

## 更新既有日曆

如果日曆內容有更新，直接覆蓋 `calendars/<隨機檔名>.ics` 這個檔案，`git add / commit / push` 即可，網址不會變。

## 在 epaper 專案裡使用

把腳本印出來的網址填到 epaper 專案的 iCal 日曆來源設定即可。**這個網址等同於密碼，不要貼到公開的地方（例如公開的 GitHub issue、聊天群組截圖等）。**
