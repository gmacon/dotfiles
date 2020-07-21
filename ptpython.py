import os

__all__ == ("configure",)


def configure(repl):
    repl.colorscheme = "solarized-{}".format(
        os.environ.get("LC_COLORSCHEME_VARIANT", "light")
    )
