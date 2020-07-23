# lazyLists package for Wolfram Language

Implements Haskell-style lazy lists in Mathematica and adds syntactic sugar to various build-in functions to work with them. Lazylists make it possible to iterate through large amounts of data without holding it all in memory at once and even allow for potentially infinite lists (e.g., the list of all integers) to be used in computations.

## Installation instructions

1. Clone the repository or download the ZIP and unzip in a directory of choice
2. You can start using the code by opening the file lazyLists.nb and running the intialisation lines at the top
3. If, instead, you want to use the code from another notebook, just point the Paclet Manager at the right directory (i.e., the directory of lazyLists.nb) with `PacletDirectoryLoad` (`PacletDirectoryAdd` in versions <= 12.0) to and then run:

    << lazyLists`

4. If you want to install the package as a Wolfram Paclet so that you can `Get` it from anywhere you only need to download the .paclet file and run:

    PacletInstall["path/to/lazyLists-X.X.paclet"]


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
* 19 April 2019
    * Update some matching patterns that technically should use `HoldPattern`. Clear all definition in the package when reloading it. 
    * Test code in notebook in Mathematica V12.
* 27 April 2019
    * Add new function `repartitionAll` which is used when threading over multiple `partitionedLazyList`s.
    * As a consequence, the `lazyListable` pseudo-attribute will now work with `partitionedLazyList`s that have been partitioned differently.
* 07 May 2019
    * Add unit tests.
    * Fix dates in change log <_<
* 20 May 2019
    * Add additional unit tests and add section in example notebook that shows how to run them.
* 19 June 2019
    * Fix a bug where `endOfLazyList` wouldn't work if returned from a function mapped over a `lazyList`.
    * Add new function `composeMappedFunctions` which compacts multiple `Map`s into one. This was default behavior for `Map` before, but this feature was removed from `Map`.
* 13 November 2019
    * Add support for using `Nothing` in `FoldList`.
* 03 January 2020
    * Bring `lazyMapThread` in line with normal `MapThread`.
    * The code files have been restructured to match the specifications of a Wolfram Paclet. A Paclet installer has been added to the repository.
* 22 July 2020
    * Add function `lazyTruncate` to cut long/infinite lazyLists short (without having to evaluate them fully).
    * Add support for held lists to `lazyMapThread`, `lazyTranspose` and `lazyCatenate`.
    * Add support for `TakeDrop`.
    * Add support for `Drop`.
* 23 July 2020
    * Add function `lazyAggregate` that can be used to do running totals over large lists.
