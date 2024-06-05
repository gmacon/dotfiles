#!/usr/bin/env python3

import os
from contextlib import contextmanager
from functools import partial

import click
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec, rsa
from cryptography.x509.oid import NameOID

KEY_GENERATORS = {
    "rsa": partial(
        rsa.generate_private_key,
        public_exponent=0x10001,
        key_size=2048,
        backend=default_backend(),
    ),
    "secp256r1": partial(
        ec.generate_private_key, curve=ec.SECP256R1(), backend=default_backend()
    ),
    "secp384r1": partial(
        ec.generate_private_key, curve=ec.SECP384R1(), backend=default_backend()
    ),
    "secp521r1": partial(
        ec.generate_private_key, curve=ec.SECP521R1(), backend=default_backend()
    ),
}


@contextmanager
def umask(value):
    prev = os.umask(value)
    try:
        yield
    finally:
        os.umask(prev)


@click.command(context_settings={"help_option_names": ["-h", "--help"]})
@click.option(
    "-k",
    "--key",
    "key_file",
    default="-",
    help="File to read/write private key",
    show_default=True,
)
@click.option(
    "--generate-key/--no-generate-key",
    default=True,
    help="Generate a new key instead of reading an existing one.",
    show_default=True,
)
@click.option(
    "--key-type",
    default="secp256r1",
    type=click.Choice(list(KEY_GENERATORS)),
    help="Public-key algorithm to use for new key",
    show_default=True,
)
@click.option(
    "-o", "--output", default="-", help="File to write request", show_default=True
)
@click.argument("domains", nargs=-1)
def main(key_file, generate_key, key_type, output, domains):
    """Generates a Certificate Signing Request for TLS.

    Pass the domains you want the certificate issued for on the command
    line.  The first one will be used as the Common Name for the
    request, and all of them will be included in the Subject Alternative
    Names extension.

    If no domains are specified, this command does nothing.

    This command refuses to overwrite existing files.

    """
    if not domains:
        return

    if generate_key:
        key = KEY_GENERATORS[key_type]()
        with umask(0o77):
            with click.open_file(key_file, "xb") as f:
                f.write(
                    key.private_bytes(
                        encoding=serialization.Encoding.PEM,
                        format=serialization.PrivateFormat.TraditionalOpenSSL,
                        encryption_algorithm=serialization.NoEncryption(),
                    )
                )
    else:
        with click.open_file(key_file, "rb") as f:
            key = serialization.load_pem_private_key(
                f.read(), None, backend=default_backend()
            )

    csr = (
        x509.CertificateSigningRequestBuilder()
        .subject_name(x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, domains[0])]))
        .add_extension(
            x509.SubjectAlternativeName([x509.DNSName(d) for d in domains]),
            critical=False,
        )
        .sign(key, hashes.SHA256(), backend=default_backend())
    )

    with click.open_file(output, "xb") as f:
        f.write(csr.public_bytes(serialization.Encoding.PEM))


if __name__ == "__main__":
    main()
