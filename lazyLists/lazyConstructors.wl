(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)

BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 

lazyList::usage = "lazyList is a linked-list data structure that should contain 2 elements: the first is the first element, the second a held expression that will generate the next linked list when evaluated.
You can extract these elements explicitely with First and Last/Rest. Part and Take have been overloaded with special functionalities when used on lazyList and will iteratively evaluate the tail to collect elements from the lazyList.
lazyList[list] or lazyList[Hold[var]] is a special constructor that generates a lazyList from an ordinary list";

lazyRange::usage = "lazyRange[] is a lazy representation of the Integers from 1 to \[Infinity]. lazyRange[min, delta] represents values values from min onwards in steps of delta.
lazyRange has no upper limit and is generally slightly faster than lazyGenerator";

lazyPowerRange::usage = "lazyPowerRange[min, r] is the infinite list {min, r \[Times] min, r^2 \[Times] min, ...}";

lazyNestList::usage = "lazyNestList[f, elem] is the infinite list {elem, f[elem], f[f[elem]], ...} starting with elem and generated by iterating f repeatedly";

lazyFixedPointList::usage = "lazyFixedPointList[f, elem, sameTest] nests f to elem until the result not longer changes according to sameTest";

lazyStream::usage = "lazyStream[streamObject] creates a lazyList that streams from streamObject. These streams will stop automatically when EndOfFile is reached";

lazyConstantArray::usage = "lazyConstantArray[elem] produces an infinite list of copies of elem";

lazyMapThread::usage = "lazyMapThread[f, {lz1, lz2, ...}] is similar to MapThread, except all elements from the lazyLists are fed to the first slot of f as a regular List";

lazyTranspose::usage = "lazyTranspose[{lz1, lz2, ...}] creates a lazyList with tuples of elements from lz1, lz2, etc. 
Equivalent to lazyMapThread[Identity, {lz1, lz2, ...}]";

lazyPartMap::usage = "lazyPartMap[l, {i, j, k, ...}] is equivalent to Map[Part[l, {#}]&, {i, j, k, ...}] but faster";

lazyFinitePart::usage = "lazyFinitePart[lz, i, j, k,...] directly extracts Part from finite and periodic lazyLists without having to traverse the lazyList element-by-element. 
It is equivalent to Part[list, i, j, k, ...]";

lazyFiniteTake::usage = "lazyFiniteTake[lz, spec] directly applies Take to finite lazyLists and periodic lazyLists without having to traverse the lazyList element-by-element. 
It is equivalent to Take[list, spec]";

lazySetState::usage = "lazySetState[lz, state] with lz a supported lazyList returns a lazyList at the specified state. 
Finite lists, lazyPeriodicList, lists generated with lazyGenerator, lazy(Power)Range, and lazyNestList are supported.
Maps over supported lists are also supported";

lazyGenerator::usage = "lazyGenerator[f, start, min, max, step] generates a lazyList that applies f to values {start, start + step, start + 2 step, ...} for values between min and max (which are allowed to be infinite).
When min and max are both infinite, symbolic values for start and step are allowed";

lazyPeriodicList::usage = "lazyPeriodicList[list] is an infinite lazyList that cycles through the values in list periodically";

$lazyIterationLimit::usage = "Iteration limit used for finding successive elements in a lazy list";

emptyLazyListQ::usage = "emptyLazyListQ tests if an expression is equal to lazyList[]";

Begin["`Private`"]
(* Implementation of the package *)

lzPattern = _lazyList | _partitionedLazyList;
lzHead = lazyList | partitionedLazyList;
emptyLazyListQ = Function[# === lazyList[]];

$lazyIterationLimit = Infinity;

Attributes[lazyList] = {HoldRest};

lazyList[{}] := lazyList[];
lazyList[Nothing, tail_] := tail;
lazyList[list_List] := lazyFiniteList[list, 1];

Attributes[lazyFiniteList] = {HoldFirst};
lazyList[Hold[list_Symbol]] := lazyFiniteList[list, 1];

With[{
    msgs = {Part::partw}
},
    (* Don't test patterns for performance. It's up to the user to make sure nothing illegal ends up in lazyFiniteList if they decide to use it *)
    lazyFiniteList[list_, i_] := Quiet[
        Check[
            lazyList[list[[i]], lazyFiniteList[list, i + 1]], 
            lazyList[],
            msgs
        ],
        msgs
    ]
];

lazyList::notFinite = "lazyList `1` cannot be recognised as a finite list";

lazyFinitePart[lazyList[_, (lazyFiniteList | lazyPeriodicListInternal)[list_, __]], spec__] := Part[list, spec];
lazyFinitePart[l_lazyList, _] := (Message[lazyList::notFinite, Short[l]]; $Failed);

lazyFiniteTake[lazyList[_, (lazyFiniteList | lazyPeriodicListInternal)[list_, __]], spec_] := Take[list, spec];
lazyFiniteTake[l_lazyList, _] := (Message[lazyList::notFinite, Short[l]]; $Failed);

lazySetState[lazyList[_, l : lazyFiniteList[list_, _]], index_Integer] /; 0 < index <= Length[list] :=
    lazyFiniteList[list, index];

lazySetState[l : lazyList[_, lazyFiniteList[list_, _]], index_Integer] /; -Length[list] <= index < 0 := 
    lazySetState[l, index + Length[list] + 1];

lazySetState[l : lazyList[_, lazyFiniteList[list_, _]], index_Integer] := (
    Message[Part::partw, index, Short[l]];
    l
);

lazyGenerator::badSpec = "Cannot create lazyGenerator with specifications `1`. Empty lazyList was returned";
lazyGenerator[
    f_,
    start : _ : 1,
    min : _ : DirectedInfinity[-1], max : _ : DirectedInfinity[1], step : _ : 1
] := Replace[
    Switch[ {min, max, start, step},
        {DirectedInfinity[-1], DirectedInfinity[1], __},
            twoSidedGenerator[f, start, step],
        {DirectedInfinity[-1], _?NumericQ, _?NumericQ, _?NumericQ},
            leftSidedGenerator[f, start, max, step],
        {_?NumericQ, DirectedInfinity[1], _?NumericQ, _?NumericQ},
            rightSidedGenerator[f, start, min, step],
        {_?NumericQ, _?NumericQ,_?NumericQ, _?NumericQ},
            finiteGenerator[f, start, min, max, step],
        _,
            lazyList[]
    ],
    {
        lazyList[] :> (
            Message[
                lazyGenerator::badSpec,
                AssociationThread[{"min", "max", "start", "step"}, {min, max, start, step}]
            ];
            lazyList[]
        )
    }
];

twoSidedGenerator[f_, pos_, step_] := lazyList[
    f[pos],
    twoSidedGenerator[f, pos + step, step]
];

leftSidedGenerator[f_, pos_, max_, step_] /; pos <= max := lazyList[
    f[pos],
    leftSidedGenerator[f, pos + step, max, step]
];
leftSidedGenerator[___] := lazyList[];

rightSidedGenerator[f_, pos_, min_, step_] /; min <= pos := lazyList[
    f[pos],
    rightSidedGenerator[f, pos + step, min, step]
];
rightSidedGenerator[___] := lazyList[];

finiteGenerator[f_, pos_, min_, max_, step_] /; Between[pos, {min, max}] := lazyList[
    f[pos],
    finiteGenerator[f, pos + step, min, max, step]
];
finiteGenerator[___] := lazyList[];

generatorPattern = Alternatives[twoSidedGenerator, leftSidedGenerator, rightSidedGenerator, finiteGenerator];

With[{ (* pattern needs to be With'ed in because of the HoldRest attribute of lazyList *)
    patt = generatorPattern
},
    lazySetState[
        l : lazyList[
            _,
            (gen : patt)[f_, pos_, rest___]
        ],
        state_
    ] := Replace[
        Check[gen[f, state, rest], $Failed],
        {
            Except[lazyList[_, _]] :> (Message[Part::partw, state, Short[l]]; l)
        }
    ]
];


(* For efficiency reasons, these lazy list generatorss are defined by self-referential anynomous functions. Note that #0 refers to the function itself *)
lazyRange[start : _ : 1, step : _ : 1] /; !TrueQ[step == 0] := Function[
    lazyList[#1, #0[#2 + #1, #2]]
][start, step];

lazyRange[start_, step_ /; TrueQ[step == 0]] := lazyConstantArray[start];

lazyPowerRange[start_, r_ /; !TrueQ[r == 1]] := Function[
    lazyList[#1, #0[#2 * #1, #2]]
][start, r];

lazyPowerRange[min_, r_ /; TrueQ[r == 1]] := lazyConstantArray[min]

lazyNestList[f_, elem_] := Function[
    lazyList[
        #1,
        #0[f[#1], #2 + 1]
    ]
][elem, 1];

lazyFixedPointList[f_, elem_, sameTest : _ : SameQ] := lazyFixedPointList[f, f[elem], elem, sameTest];
lazyFixedPointList[f_, elem_, prev_, sameTest_] /; sameTest[elem, prev] := lazyList[elem, lazyList[]];
lazyFixedPointList[f_, elem_, prev_, sameTest_] := lazyList[
    elem,
    lazyFixedPointList[f, f[elem], elem, sameTest]
];

(*lazySetState definition for lazyRange and lazyPowerRange and lazyNestList *)
lazySetState[
    lazyList[_, (f : Function[lazyList[#1, #0[_, _]]])[_, step_]],
    state_
] := f[state, step];

lazyStream[stream_InputStream] := Function[
    With[{
        read = Read[#1]
    },
        lazyList[
            read,
            If[ read =!= EndOfFile,
                #0[#1, #2 + 1], (* Increase an iterator to make sure that ReplaceRepeated in Take doesn't stop *)
                lazyList[] (* return an empty lazyList to end stream *)
            ]
        ]
    ]
][stream, 1];

lazyConstantArray[const_] := Function[
    lazyList[
        const,
        (* Increase an iterator to make sure that ReplaceRepeated in Take doesn't stop *)
        #0[#1 + 1]
    ]
][1];


Attributes[lazyPeriodicListInternal] = {HoldFirst};
lazyPeriodicListInternal[list_, i_, max_] := lazyList[
    list[[i]],
    lazyPeriodicListInternal[list, Mod[i, max] + 1, max]
];

lazyPeriodicList[list_List] := Module[{
    listVar = list
},
    lazyPeriodicList[Hold[listVar]]
];
lazyPeriodicList[Hold[list_Symbol]] := lazyPeriodicListInternal[list, 1, Length[list]];

lazySetState[lazyList[_, lazyPeriodicListInternal[list_, _, max_]], index_Integer] := 
    lazyPeriodicListInternal[list, Mod[index - UnitStep[index], max] + 1, max];

lazySetState::notSupported = "lazySetState is not supported for lazyList `1`";
lazySetState[l_lazyList, _] := (Message[lazySetState::notSupported, Short[l]]; l)

lazyPartMap[l_lazyList, indices : {__Integer}] := Module[{
    sortedIndices = Sort[indices]
},
    Part[
        FoldList[
            Function[
                Part[#1, {#2}]
            ],
            Part[l, sortedIndices[[{1}]]],
            Differences[sortedIndices] + 1
        ],
        Ordering[indices]
    ]
];

lazyMapThread[f_, lists : {___, _List, ___}] := lazyMapThread[
    f,
    Replace[
        lists,
        l_List :> lazyList[l],
        {1}
    ]
]

lazyMapThread[f_, lists : {lazyList[_, _]..}] := lazyList[
    f[lists[[All, 1]]],
    lazyMapThread[f, lists[[All, 2]]]
];

lazyMapThread[_, _] := lazyList[];

lazyTranspose[list : {(_lazyList | _List)..}] := lazyMapThread[Identity, list];


End[]

EndPackage[]
