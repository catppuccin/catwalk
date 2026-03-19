mod fixtures;
use assert_cmd::cargo::cargo_bin_cmd;
use predicates::prelude::predicate;
use ril::prelude::*;

#[test]
fn test_composite_output() {
    let f = fixtures::Fixtures::new();
    let out = f.dir.path().join("out.png");
    let mut cmd = cargo_bin_cmd!("catwalk");
    cmd.args([
        f.path("latte").to_str().unwrap(),
        f.path("frappe").to_str().unwrap(),
        f.path("macchiato").to_str().unwrap(),
        f.path("mocha").to_str().unwrap(),
        "--output",
        out.to_str().unwrap(),
    ]);
    cmd.assert().success();
    assert!(out.exists());
}

#[test]
fn test_mismatched_sizes() {
    let f = fixtures::Fixtures::new();
    let small = f.dir.path().join("small.png");
    Image::new(50u32, 50u32, Rgba::new(0, 0, 0, 255))
        .save_inferred(&small)
        .unwrap();
    let out = f.dir.path().join("out.png");
    let mut cmd = cargo_bin_cmd!("catwalk");
    cmd.args([
        f.path("latte").to_str().unwrap(),
        f.path("frappe").to_str().unwrap(),
        f.path("macchiato").to_str().unwrap(),
        small.to_str().unwrap(),
        "--output",
        out.to_str().unwrap(),
    ]);
    cmd.assert()
        .failure()
        .stderr(predicate::str::contains("Images must be the same size"));
}

#[test]
fn test_nonexistent_input() {
    let f = fixtures::Fixtures::new();
    let out = f.dir.path().join("out.png");
    let mut cmd = cargo_bin_cmd!("catwalk");
    cmd.args([
        "nonexistent.png",
        f.path("frappe").to_str().unwrap(),
        f.path("macchiato").to_str().unwrap(),
        f.path("mocha").to_str().unwrap(),
        "--output",
        out.to_str().unwrap(),
    ]);
    cmd.assert()
        .failure()
        .stderr(predicate::str::contains("Failed to open"));
}

#[test]
fn test_unsupported_output_extension() {
    let f = fixtures::Fixtures::new();
    let out = f.dir.path().join("out.jpg");
    let mut cmd = cargo_bin_cmd!("catwalk");
    cmd.args([
        f.path("latte").to_str().unwrap(),
        f.path("frappe").to_str().unwrap(),
        f.path("macchiato").to_str().unwrap(),
        f.path("mocha").to_str().unwrap(),
        "--output",
        out.to_str().unwrap(),
    ]);
    cmd.assert()
        .failure()
        .stderr(predicate::str::contains("Output file type not supported"));
}
