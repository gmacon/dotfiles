{ buildPythonApplication, fetchPypi, flit, horsephrase, keyring }: buildPythonApplication rec {
  pname = "pinpal";
  version = "2023.4.22";
  src = fetchPypi {
    inherit pname version;
    sha256 = "ed2f445b4cf0fa16a57729dc08e2c3dc2a04352a27d99e7804e9ea21807abd22";
  };
  format = "pyproject";
  buildInputs = [ flit ];
  propagatedBuildInputs = [ horsephrase keyring ];
  # There are no tests
  doCheck = false;
}
