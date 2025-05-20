{
  mkDerivation,
  aeson,
  ansi-terminal,
  ansi-wl-pprint,
  base,
  binary,
  broadcast-chan,
  bytestring,
  command,
  conduit,
  conduit-extra,
  containers,
  directory,
  edit-distance,
  elm-format,
  elm-format-lib,
  entropy,
  fetchgit,
  file-embed,
  filelock,
  filemanip,
  filepath,
  fold-debounce,
  formatting,
  fsnotify,
  ghc-prim,
  githash,
  haskeline,
  HTTP,
  http-client,
  http-client-tls,
  http-types,
  language-glsl,
  lib,
  listsafe,
  main-tester,
  mtl,
  natural-sort,
  neat-interpolation,
  network,
  network-info,
  parsec,
  process,
  raw-strings-qq,
  safe,
  scientific,
  SHA,
  snap-core,
  snap-server,
  stringsearch,
  template-haskell,
  temporary,
  time,
  tree-diff,
  unicode-show,
  unordered-containers,
  utf8-string,
  uuid,
  vector,
  wai,
  wai-logger,
  warp,
  websockets,
  websockets-snap,
  word8,
  zip-archive,
}:
mkDerivation {
  pname = "lamdera";
  version = "0.19.1";
  src =
    (fetchgit {
      url = "https://github.com/lamdera/compiler";
      sha256 = "yNMeNL6yx9ub/RUXj+6gCmJZfmO2RUTRQgmfyIGVIik=";
      rev = "b3514260acecbedb3289d7f0c7386dcf174de59a";
      fetchSubmodules = true;
    }).overrideAttrs
      {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson
    ansi-terminal
    ansi-wl-pprint
    base
    binary
    broadcast-chan
    bytestring
    command
    conduit
    conduit-extra
    containers
    directory
    edit-distance
    elm-format
    elm-format-lib
    entropy
    file-embed
    filelock
    filemanip
    filepath
    fold-debounce
    formatting
    fsnotify
    ghc-prim
    githash
    haskeline
    HTTP
    http-client
    http-client-tls
    http-types
    language-glsl
    listsafe
    main-tester
    mtl
    natural-sort
    neat-interpolation
    network
    network-info
    parsec
    process
    raw-strings-qq
    safe
    scientific
    SHA
    snap-core
    snap-server
    stringsearch
    template-haskell
    temporary
    time
    tree-diff
    unicode-show
    unordered-containers
    utf8-string
    uuid
    vector
    wai
    wai-logger
    warp
    websockets
    websockets-snap
    word8
    zip-archive
  ];
  homepage = "https://lamdera.com";
  description = "`lamdera` command line interface";
  license = lib.licenses.bsd3;
  mainProgram = "lamdera";
}
