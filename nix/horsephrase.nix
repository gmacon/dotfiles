{ buildPythonPackage, fetchPypi, setuptools }: buildPythonPackage rec {
  pname = "horsephrase";
  version = "2022.12.9.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "2a957c6f9122d18fe0f820631f3664aedfc4e0663e2e0c2a8d77ecc8891e6e47";
  };
  format = "setuptools";
  buildInputs = [ setuptools ];
  doCheck = false;
}
