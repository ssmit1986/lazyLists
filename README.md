# lazyLists package for Wolfram Language

Implements Haskell-style lazy lists in Mathematica and adds syntactic sugar to various build-in functions to work with them. Current implementation uses ReplaceRepeated because that was found to be the most computationally efficient.

## Installation instructions

1. Clone the repository or download the ZIP and unzip in a directory of choice
2. You can start using the code by opening the file lazyLists.nb and running the intialisation lines at the top
3. If, instead, you want to use the code from another notebook, just set the directory with `SetDirectory` to the directory of lazyLists.nb and then simply run

       << lazyLists`

4. If you want to install the package as a Wolfram application so that you can `Get` it from anywhere you:
    1. Evaluate `SystemOpen[$UserBaseDirectory]`
    2. In the directory that just opened, go to the "Applications" directory (or create it if it doesn't exist)
    3. Drop the inner "lazyLists" directory from the repository into the "Applications" directory. You should now have a path that look like this: `Applications/lazyLists/Kernel`


## Using the code

See lazyLists.nb for details and examples.


## Change log

* 21 September 2018: 
    * Add `lazyTuples`, which is the lazy version of `Tuples`. Includes helper functions for generating tuples efficiently.
        * Hotfix: `lazyTuples` will now switch between compiled evaluation and regular evaluation depending on the size of the integers involves (since `Compile` can only use machine numbers).
* 22 September 2018
    * Add `partWhile`, which finds the last element in a lazyList that matches a selector function. Also add support for `Part[lz, {-1}]`, which is equivalent to `partWhile[lz, True&]`. 
    * Add `Take[lz, All]` as usable syntax for finite lazyLists.
* 23 September 2018
    * Add `lazyCatenate`, which works like regular `Catenate` but returns a lazyList. Works on lists and lazyLists or any mixture of the two.
    * Add `FoldPairList` as supported system symbol.
    * Add `Prepend` and `Append` as usable system symbols. Also add `lazyPrependTo` and `lazyAppendTo` to modify lazyLists created by `lazyList[Hold[var]]`.
    * Add use case `lazyTuples[n]`, which gives an infinite lazyList that generates all n-tuples of positive integers iteratively.
* 24 September 2018
    * Add `setLazyListable`, which is used to set a pseudo-Listable attribute to symbols that makes them automatically thread over lazyLists.
    * Add partitioned lazyLists. Any lazyList that generates ordinary lists can be converted to a `partitionedLazyList`. Doing so effectively flattens the generated lists into one continuous list. `partitionedLazyList` supports list operations like `Map` and `Fold`, which will be applied directly to the generated lists for efficiency.
* 25 September 2018
    * Add `{start, stop, step}` syntax for `Take`, which can be used in conjunction with `partitionedLazyList`.
    * Some efficiency updates to `Take` and `Part`.
    * Add `lazyMapThread` and `lazyCatenate` for `partitionedLazyList`.
    * Add `lazyPartition`, which can be used to make a `partitionedLazyList` out of any normal `lazyList`.
    * Implement pseudo-listability for `partitionedLazyList`.
* 26 September 2018
    * Various updates to `partitionedLazyList` to bring it more in line with ordinary `lazyList`.
    * Re-implement `lazyTuples` using `partitionedLazyList` to make tuples generation significantly faster.
* 28 September 2018
    * Implement `LengthWhile` for `lazyList` and `partitionedLazyList`. Replaces `partWhile`, which was removed.
    * Add the `endOfLazyList` token, which is used to force lazy lists to terminate.
* 19 April 2018
    * Update some matching patterns that technically should use `HoldPattern`. Clear all definition in the package when reloading it. 
    * Test code in notebook in Mathematica V12.