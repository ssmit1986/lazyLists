(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)
BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 

lazyList::usage = "lazyList is a linked-list data structure that should contain 2 elements: the first is the first element, the second a held expression that will generate the next linked list when evaluated.
You can extract these elements explicitely with First and Last/Rest. Part and Take have been overloaded with special functionalities when used on lazyList and will iteratively evaluate the tail to collect elements from the lazyList.
lazyList[list] or lazyList[Hold[var]] is a special constructor that generates a lazyList from an ordinary list.";

lazyRange::usage = "lazyRange[] is a lazy representation of the Integers from 1 to \[Infinity]. lazyRange[min, delta] represents values values from min onwards in steps of delta.
lazyRange has no upper limit and is generally slightly faster than lazyGenerator.";

lazyPowerRange::usage = "lazyPowerRange[min, r] is the infinite list {min, r \[Times] min, r^2 \[Times] min, ...}";

lazyNestList::usage = "lazyNestList[f, elem] is the infinite list {elem, f[elem], f[f[elem]], ...} starting with elem and generated by iterating f repeatedly.";

lazyFixedPointList::usage = "lazyFixedPointList[f, elem, sameTest] nests f to elem until the result not longer changes according to sameTest.";

lazyStream::usage = "lazyStream[streamObject] creates a lazyList that streams from streamObject. These streams will stop automatically when EndOfFile is reached.";

lazyConstantArray::usage = "lazyConstantArray[elem] produces an infinite list of copies of elem.";

lazyMapThread::usage = "lazyMapThread[f, {lz1, lz2, ...}] is similar to MapThread, except all elements from the lazyLists are fed to the first slot of f as a regular List.";

lazyTranspose::usage = "lazyTranspose[{lz1, lz2, ...}] creates a lazyList with tuples of elements from lz1, lz2, etc. 
Equivalent to lazyMapThread[Identity, {lz1, lz2, ...}]";

lazyPartMap::usage = "lazyPartMap[l, {i, j, k, ...}] is equivalent to Map[Part[l, {#}]&, {i, j, k, ...}] but faster.";

lazyFinitePart::usage = "lazyFinitePart[lz, i, j, k,...] directly extracts Part from finite and periodic lazyLists without having to traverse the lazyList element-by-element. 
It is equivalent to Part[list, i, j, k, ...]";

lazyFiniteTake::usage = "lazyFiniteTake[lz, spec] directly applies Take to finite lazyLists and periodic lazyLists without having to traverse the lazyList element-by-element. 
It is equivalent to Take[list, spec]";

lazySetState::usage = "lazySetState[lz, state] with lz a supported lazyList returns a lazyList at the specified state. 
Finite lists, lazyPeriodicList, lists generated with lazyGenerator, lazy(Power)Range, and lazyNestList are supported.
Maps over supported lists are also supported.";

lazyGenerator::usage = "lazyGenerator[f, start, min, max, step] generates a lazyList that applies f to values {start, start + step, start + 2 step, ...} for values between min and max (which are allowed to be infinite).
When min and max are both infinite, symbolic values for start and step are allowed.";

lazyPeriodicList::usage = "lazyPeriodicList[list] is an infinite lazyList that cycles through the values in list periodically.";

$lazyIterationLimit::usage = "Iteration limit used for finding successive elements in a lazy list.";

emptyLazyListQ::usage = "emptyLazyListQ tests if an expression is equal to lazyList[]";
endOfLazyList::usage = "A special token that will terminate any lazyList whenever it is encountered.";

partitionedLazyList::usage = "Is a special wrapper for lazyLists that generate ordinary Lists.
The elements of the inner Lists are treated as if they're seperate elements of the outer lazyList, making it possible to generate elements in chunks.
List operations on partitionedLazyList such as Map and FoldList will be automatically applied to the generated lists for efficiency.";

partitionedLazyRange::usage = "partitionedLazyRange[start, step, partitionLength] works like lazyRange, but yields a partitionedLazyList.
partitionedLazyRange[partitionLength] generates the natural numbers in chuncks of length partitionLength.";

partitionedLazyNestList::usage = "partitionedLazyNestList[fun, elem, partitionLength] is a partitioned version of lazyNestList.
Each new partition is generated with NestList.";

lazyPartition::usage = "lazyPartition[l, n] turns an ordinary list or lazyList into a partitioned lazyList with chunks of length n.";


lazyCatenate::usage = "lazyCatenate catenates lists of lazyLists, lazyLists of lists and lazyLists of lazyLists into one lazyList.";

setLazyListable::usage = "setLazyListable[sym] sets UpValues to lazyList that ensure that sym threads over lazyLists. 
Be aware that the attributes have priority over UpValues, so if sym has the Listable attribute it will always act first.";

lazyPrependTo::usage = "lazyPrependTo[lz, element] can be used on lazyLists generated by lazyList[Hold[var]] or lazyList[list] to modify the underlying list.
It returns a lazyList with the modified variable at the index where lz was originally.";

lazyAppendTo::usage = "lazyAppendTo[lz, element] can be used on lazyLists generated by lazyList[Hold[var]] or lazyList[list] to modify the underlying list.
It returns a lazyList with the modified variable at the index where lz was originally.";

lazyTuples::usage = "lazyTuples is a lazy version of Tuples with mostly the same syntax.
lazyTuples[n] is a special case that generates an infinite list of all n-tuples of integers \[GreaterEqual] 1.";
nextIntegerTuple::usage = "nextIntegerTuple[{int1, int2, ...}] generates the next integer tuple in a canonical order.";

bulkExtractElementsUsingIndexList::usage = "bulkExtractElementsUsingIndexList[lists, indices] converts elements from Tuples[Range /@ Length /@ lists] into elements from Tuples[lists]";

rangeTuplesAtPositions::usage = "rangeTuplesAtPositions[Length /@ lists] is a CompiledFunction that directly generates elements of Tuples[Range /@ Length /@ lists]";

repartitionAll::usage = "repartitionAll[{lz1, lz2, ...}] returns the list of lazy lists, but with all partitioned lazylists restructured to be of the same partition length. Ordinary lazyLists will be converted to partitionedLazyLists.";

composeMappedFunctions::usage = "composeMappedFunctions[lzList] will convert mappings of the form f /@ g /@ ... /@ list with a single map f @* g @* ... /@ list";

EndPackage[]

