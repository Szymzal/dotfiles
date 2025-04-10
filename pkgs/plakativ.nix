{
  python3Packages,
  fetchPypi,
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "plakativ";
    version = "0.5.3";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-6TvMznd5obkn/gsQTyZ6Pc/dF55I53987EbuSNAlY58=";
    };

    build-system = [
      setuptools
    ];

    dependencies = with python3Packages; [
      img2pdf
      pymupdf
      tkinter
    ];
  }
