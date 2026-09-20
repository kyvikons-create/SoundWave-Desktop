#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::menu::{Menu, MenuItem};
use tauri::tray::TrayIconBuilder;
use tauri::Manager;

fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_http::init())
        .plugin(tauri_plugin_opener::init())
        .setup(|app| {
            let toggle = MenuItem::with_id(app, "toggle", "Show/Hide", true, None::<&str>)?;
            let play = MenuItem::with_id(app, "play", "Play/Pause", true, None::<&str>)?;
            let next = MenuItem::with_id(app, "next", "Next", true, None::<&str>)?;
            let previous = MenuItem::with_id(app, "previous", "Previous", true, None::<&str>)?;
            let quit = MenuItem::with_id(app, "quit", "Quit", true, None::<&str>)?;
            let menu = Menu::with_items(app, &[&toggle, &play, &next, &previous, &quit])?;

            TrayIconBuilder::with_id("main")
                .icon(app.default_window_icon().expect("default window icon").clone())
                .menu(&menu)
                .show_menu_on_left_click(true)
                .on_menu_event(|app, event| {
                    let Some(webview) = app.get_webview_window("main") else { return };
                    let command = match event.id().as_ref() {
                        "toggle" => {
                            if webview.is_visible().unwrap_or(false) && !webview.is_minimized().unwrap_or(false) {
                                let _ = webview.hide();
                            } else {
                                let _ = webview.unminimize();
                                let _ = webview.show();
                                let _ = webview.set_focus();
                            }
                            None
                        }
                        "play" => Some("play"),
                        "next" => Some("next"),
                        "previous" => Some("prev"),
                        "quit" => {
                            app.exit(0);
                            None
                        }
                        _ => None,
                    };
                    if let Some(command) = command {
                        let _ = webview.eval(&format!("window.__swRemote && window.__swRemote('{command}')"));
                    }
                })
                .build(app)?;

            Ok(())
        })
        .on_window_event(|window, event| {
            if let tauri::WindowEvent::CloseRequested { api, .. } = event {
                let _ = window.hide();
                api.prevent_close();
            }
        })
        .run(tauri::generate_context!())
        .expect("soundwave: error while running");
}
