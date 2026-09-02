# ical-calendar-feeds

用來存放 `.ics` 日曆檔案，透過 GitHub Pages 對外提供靜態網址，讓 epaper 專案可以用 HTTP 直接抓取 iCal 日曆來源。

## 首次設定

1. 到 GitHub 建立一個新的空 repository（不要勾選 add README），例如叫 `ical-calendar-feeds`。
2. 在這個資料夾內設定 remote 並 push：

   ```bash
   git remote add origin git@github.com:<你的帳號>/ical-calendar-feeds.git
   git branch -M main
   git push -u origin main
   ```

3. 到 repo 的 **Settings → Pages**，Source 選擇 `Deploy from a branch`，Branch 選 `main` / `/ (root)`，儲存。
4. 等一兩分鐘後，網站會部署在：

   ```
   https://<你的帳號>.github.io/ical-calendar-feeds/
   ```

## 日常使用：上傳新的 .ics

```bash
./add_calendar.sh /path/to/mycalendar.ics
```

這會自動：
- 把檔案複製進 `calendars/`
- 重新產生 `manifest.json`（給 `index.html` 列表用）
- `git commit` 並 `git push`

也可以指定要用的檔名：

```bash
./add_calendar.sh /path/to/mycalendar.ics work.ics
```

## 在 epaper 專案裡使用

push 完、GitHub Pages 部署完成後，日曆檔案的網址是：

```
https://<你的帳號>.github.io/ical-calendar-feeds/calendars/<檔名>.ics
```

把這個網址填到 epaper 專案的 iCal 日曆來源設定即可。首頁 `index.html` 也會列出目前所有日曆的網址，方便複製。

## 更新既有日曆

如果日曆內容有更新，直接用相同檔名再跑一次 `add_calendar.sh` 覆蓋即可，網址不會變。
