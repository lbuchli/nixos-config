{ pkgs, ... }: pkgs.python3Packages.buildPythonPackage rec {
  pname = "rmc";
  version = "0.3.0";

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-V6/hTVZpQIW2o4KqK5O3uG6yHpPnILFqgpkKoNZRPcs=";
  };

  pyproject = true;

  build-system = with pkgs.python3Packages; [
    poetry-core
  ];

  nativeBuildInputs = with pkgs.python3Packages; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "rmscene"
  ];

  dependencies = with pkgs.python3Packages; [
    click
    rmscene
  ];

  pythonImportsCheck = [ "rmc" ];

  meta = with pkgs.lib; {
    description = "Remarkable Cloud API client and utility";
    homepage = "https://pypi.org/project/rmc/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
