{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  squashfsTools,
  makeBinaryWrapper,
  alsa-lib,
  atk,
  at-spi2-atk,
  cups,
  gtk3,
  libdrm,
  libsecret,
  libxkbcommon,
  libgbm,
  pango,
  sqlite,
  systemd,
  wayland,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tradingview";
  version = "2.9.6";
  revision = "63";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/nJdITJ6ZJxdvfu8Ch7n5kH5P99ClzBYV_${finalAttrs.revision}.snap";
    hash = "sha256-WmeGtR/rOzlgTpa1JZKskxre2ONtzppYsA/yhDhv5TI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    squashfsTools
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    atk
    at-spi2-atk
    cups
    gtk3
    libdrm
    libsecret
    libxkbcommon
    libgbm
    pango
    sqlite
    systemd
    wayland
    xorg.libxcb
    xorg.libX11
    xorg.libXext
  ];

  unpackPhase = ''
    runHook preUnpack

    unsquashfs $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r squashfs-root $out/share/tradingview
    rm -rf $out/share/tradingview/meta

    install -Dm444 squashfs-root/meta/gui/tradingview.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/tradingview.desktop \
      --replace-fail \$\{SNAP}/meta/gui/icon.png tradingview

    mkdir $out/share/icons
    cp squashfs-root/meta/gui/icon.png $out/share/icons/tradingview.png

    mkdir $out/bin
    makeBinaryWrapper $out/share/tradingview/tradingview $out/bin/tradingview \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Charting platform for traders and investors";
    homepage = "https://www.tradingview.com/desktop/";
    changelog = "https://www.tradingview.com/support/solutions/43000673888/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ prominentretail ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tradingview";
  };
})
