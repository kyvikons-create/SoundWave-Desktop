# SoundWave Desktop

десктоп-версия плеера для soundcloud. сделана на [tauri 2](https://tauri.app) — rust + системный webview, без electron: установщик весит единицы мегабайт и не тащит хром.

## что внутри

- интерфейс тот же, что в ios-приложении (`ui/index.html`, одна кодовая база)
- все запросы к api soundcloud идут через rust-бэкенд tauri — нет ограничений cors браузера
- сборка установщика **setup.exe** (nsis) происходит в github actions на windows-раннере

## скачать установщик

вкладка **actions** → свежая сборка → artifacts → `SoundWave-Setup` → внутри `SoundWave_1.0.0_x64-setup.exe`

## запуск из исходников

нужен [rust](https://rustup.rs) и node:

```
npm install -g @tauri-apps/cli@^2
tauri dev
```

сборка установщика локально: `tauri build` — появится в `src-tauri/target/release/bundle/nsis/`

## идеи для развития

- глобальные хоткеи play/pause (tauri-plugin-global-shortcut)
- иконка в трее с управлением (tauri-plugin-tray)
- автозапуск с системой (tauri-plugin-autostart)
- широкий адаптив интерфейса для десктопа
