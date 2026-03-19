use ril::prelude::*;
use std::path::PathBuf;
use tempfile::TempDir;

pub struct Fixtures {
    pub dir: TempDir,
}

impl Fixtures {
    pub fn new() -> Self {
        let dir = tempfile::tempdir().expect("failed to create tempdir");
        let colors = [
            ("latte", Rgba::new(239, 241, 245, 255)),
            ("frappe", Rgba::new(48, 52, 70, 255)),
            ("macchiato", Rgba::new(36, 39, 58, 255)),
            ("mocha", Rgba::new(30, 30, 46, 255)),
        ];
        for (name, color) in colors {
            let img = Image::new(100, 100, color);
            img.save_inferred(dir.path().join(format!("{name}.png")))
                .expect("failed to save fixture image");
        }
        Self { dir }
    }

    pub fn path(&self, name: &str) -> PathBuf {
        self.dir.path().join(format!("{name}.png"))
    }
}
