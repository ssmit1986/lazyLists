(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)

BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 


Begin["`Private`"]
(* Implementation of the package *)

lzPattern = _lazyList | _partitionedLazyList;
lzHead = lazyList | partitionedLazyList;
emptyLazyListQ = Function[# === lazyList[]];
validLazyListPattern = lazyList[_, _];
validPartitionedLazyListPattern = partitionedLazyList[_List, _];
heldListPattern = Hold[_Symbol?ListQ];

$lazyIterationLimit = Infinity;

Attributes[lazyList] = {HoldRest};

lazyList[{}] := lazyList[];
lazyList[Nothing, tail_] := tail;
lazyList[{fst_, rest___}] := lazyList[fst, lazyList[{rest}]];
lazyList[endOfLazyList, ___] := lazyList[]


Attributes[lazyFiniteList] = {HoldFirst};
lazyList::noList = "Symbol `1` is not a list";

lazyList[Hold[list_Symbol?ListQ]] := lazyFiniteList[list, 1];
lazyList[Hold[list_Symbol]] := (
    Message[lazyList::noList, HoldForm[list]];
    lazyList[]
);

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

lazyFinitePart[lzHead[_, HoldPattern[(lazyFiniteList | lazyPeriodicListInternal)[list_, __]]], spec__] := Part[list, spec];
lazyFiniteTake[lzHead[_, HoldPattern[(lazyFiniteList | lazyPeriodicListInternal)[list_, __]]], spec_] := Take[list, spec];

lazySetState[lzHead[_, HoldPattern @ lazyFiniteList[list_, _, rest___]], index_Integer] /; 0 < index <= Length[list] :=
    lazyFiniteList[list, index, rest];

lazySetState[lzHead[_, HoldPattern @ lazyFiniteList[list_, _, rest___]], index_Integer] /; -Length[list] <= index < 0 := 
    lazyFiniteList[list, index + Length[list] + 1, rest];

lazySetState[lz : lzHead[_, HoldPattern @ lazyFiniteList[list_, _, ___]], index_Integer] := (
    Message[Part::partw, index, Short[lz]];
    lz
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

rightSidedGenerator[f_, pos_, min_, step_] /; min <= pos := lazyList[
    f[pos],
    rightSidedGenerator[f, pos + step, min, step]
];

finiteGenerator[f_, pos_, min_, max_, step_] /; Between[pos, {min, max}] := lazyList[
    f[pos],
    finiteGenerator[f, pos + step, min, max, step]
];

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
            Except[validLazyListPattern] :> (Message[Part::partw, state, Short[l]]; l)
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
    lazyPeriodicListInternal[list, Mod[i + 1, max, 1], max]
];

lazyPeriodicList[Hold[list_Symbol?ListQ] | list_List] := lazyPeriodicListInternal[list, 1, Length[list]];
lazyPeriodicList[Hold[list_Symbol?ListQ] | list_List, part_Integer?Positive] := lazyPeriodicListInternal[list, 1, Length[list], part];

lazySetState[lzHead[_, HoldPattern @ lazyPeriodicListInternal[list_, _, max_, rest___]], index_Integer] := 
    lazyPeriodicListInternal[list, Mod[index  + 1 - UnitStep[index], max, 1], max, rest];


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

lazyMapThread[f_, lists : {___, _List | heldListPattern, ___}, opts : OptionsPattern[]] := lazyMapThread[
    f,
    Replace[
        lists,
        l : (_List | heldListPattern) :> lazyList[l],
        {1}
    ],
    opts
];

lazyMapThread[f_, lists : {validLazyListPattern..}, opts : OptionsPattern[]] := lazyList[
    f @@ lists[[All, 1]],
    lazyMapThread[f, lists[[All, 2]], opts]
];

lazyTranspose[lists : {___, _List | heldListPattern, ___}, opts : OptionsPattern[]] := lazyTranspose[
    Replace[
        lists,
        l : (_List | heldListPattern) :> lazyList[l],
        {1}
    ],
    opts
];

lazyTranspose[list : {validLazyListPattern..}, opts : OptionsPattern[]] := lazyMapThread[List, list, opts];

lazyTruncate[lz : (validLazyListPattern | validPartitionedLazyListPattern), int_Integer?Positive] := MapIndexed[
    Function[If[#2 <= int, #1, endOfLazyList, endOfLazyList]],
    lz
];

End[]

EndPackage[]

