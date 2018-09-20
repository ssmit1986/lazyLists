# lazyLists package for Wolfram Language

Implements Haskell-style lazy lists in Mathematica and adds syntactic sugar to various build-in functions to work with them. Current implementation uses ReplaceRepeated because that was found to be the most computationally efficient.

## Installation instructions

1. Clone the repository or download the ZIP and unzip in a directory of choice
2. You can start using the code by opening the file lazyLists.nb and running the intialisation lines at the top
3. If, instead, you want to use the code from another notebook, just set the directory with `SetDirectory` to the directory of lazyLists.nb and then simply run

    <<lazyLists`

4. If you want to install the package as a Wolfram application so that you can `Get` it from anywhere you:
    1. Evaluate `SystemOpen[$UserBaseDirectory]`
    2. In the directory that just opened, go to the "Applications" directory (or create it if it doesn't exist)
    3. Drop the inner "lazyLists" directory from the repository into the "Applications" directory. Your should now have a path that look like this: `Applications/lazyLists/Kernel`


## Using the code

See lazyLists.nb for details and examples.
