{ pkgs, lib, ... }: with pkgs; rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "0.2.5";

  src = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "dailydaniel";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-8MdaJ4cOdY0326joICyZPC3oaCVTYj99/1Sgu1AV23E=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -r --no-preserve=mode . $out/
      runHook postInstall
    '';

    postPatch = ''
      mkdir -p $out/notes-app/src-tauri/binaries
      cp ${pkgs.typst}/bin/typst $out/notes-app/src-tauri/binaries/typst-x86_64-unknown-linux-gnu
      cp ${pkgs.tinymist}/bin/tinymist $out/notes-app/src-tauri/binaries/tinymist-x86_64-unknown-linux-gnu
    '';
  });

  cargoHash = "sha256-HeGK42NIiwaEj70VvKwnhSNs7k2OpuVHbDmlRp4cHbk=";

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    src = "${src}/notes-app/";
    hash = "sha256-ie3Ej0ody1s8qnMy85k/tOJwoUeGPlCUjixTZq+oM8E=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    npmHooks.npmConfigHook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking # Most Tauri apps need networking
    openssl
    webkitgtk_4_1
  ];

  postPatch = ''
    cp notes-app/package.json .
    cp notes-app/package-lock.json .
    cp Cargo.lock notes-app/src-tauri/Cargo.lock
  '';

  cargoRoot = "notes-app/src-tauri";
  buildAndTestSubdir = cargoRoot;
}
