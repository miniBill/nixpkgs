{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ZnNfa4POUTMi9sDGMyR6gu9Xpg+j/JmyWVnBBSnRSE=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pylutron" ];

  meta = with lib; {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    changelog = "https://github.com/thecynic/pylutron/releases/tag/${version}";
    license = with licenses; [
      mit
      psfl
    ];
    maintainers = with maintainers; [ fab ];
  };
}
