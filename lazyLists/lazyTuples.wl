(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)
Quiet[Needs["Combinatorica`"]];
BeginPackage["lazyLists`", {"Combinatorica`"}]
(* Exported symbols added here with SymbolName::usage *) 

lazyTuples::usage = "lazyTuples is a lazy version of Tuples with mostly the same syntax.
lazyTuples[n] is a special case that generates an infinite list of all n-tuples of integers \[GreaterEqual] 1";
nextIntegerTuple::usage = "nextIntegerTuple[{int1, int2, ...}] generates the next integer tuple in a canonical order";

bulkExtractElementsUsingIndexList::usage = "bulkExtractElementsUsingIndexList[lists, indices] converts elements from Tuples[Range /@ Length /@ lists] into elements from Tuples[lists]";

rangeTuplesAtPositions::usage = "rangeTuplesAtPositions[Length /@ lists] is a CompiledFunction that directly generates elements of Tuples[Range /@ Length /@ lists]";

Begin["`Private`"]
(* Implementation of the package *)

(* Source of decompose and basis: https://mathematica.stackexchange.com/a/153609/43522 *)
basis[lengths : {__Integer}] := basis[lengths] = (
    Reverse[
        FoldList[Times, 1, Reverse @ Rest @ lengths]
    ]
);

(* Compilation only works for Machine integers *)
decompose[base : {__Integer}] /; Max[base] < 2^63 := (
    decompose[base] = Compile[{
        {n, _Integer}
    }, 
        Module[{
            c = n - 1, (* I pick an offset here to make sure that n enumerates from 1 instead of 0 *)
            q
        },
            1 + Table[ (* And added 1 so it's not necessary to do so later on *)
                q = Quotient[c, i];
                c = Mod[c, i];
                q,
                {i, base}
            ]
        ],
        RuntimeAttributes -> {Listable}
    ]
);

decompose[base : {__Integer}] := (
    decompose[base] = Module[{
        baseVar = base
    },
        Function[
            Null, (* This makes it possbile to use Slot (#) inside of the function (which is faster than named arguments) and have a Listable attribute *)
            Block[{ (* Block is faster than Module *)
                c = Subtract[#, 1],
                q
            },
                1 + Table[
                    {q, c} = QuotientRemainder[c, i];
                    q,
                    {i, baseVar}
                ]
            ],
            {Listable}
        ]
    ]
);

rangeTuplesAtPositions[lengths : {__Integer}] := decompose[basis[lengths]];

(* lazyList that generates the elements of Tuples[Range /@ lengths] *)
Options[indexLazyList] = {
    "StepSize" -> 1,
    "Start" -> 1,
    "FiniteIndexCutoff" -> 10^10
};

indexLazyList[lengths : {__Integer}, opts : OptionsPattern[]] := With[{
    start = Replace[OptionValue["Start"], Except[_Integer] :> 1],
    step = Replace[OptionValue["StepSize"], Except[_Integer] :> 1],
    cutOff = Replace[OptionValue["FiniteIndexCutoff"], Except[_?NumericQ | DirectedInfinity[1]] :> 10^10]
},
    lazyGenerator[
        rangeTuplesAtPositions[lengths],
        start, 1,
        Replace[
            Times @@ lengths,
            {i_ /; i > cutOff :> DirectedInfinity[1]}
        ],
        step
    ]
];

Options[lazyTuples] = Options[indexLazyList];
lazyTuples[
    elementLists_List | Hold[elementLists_Symbol],
    opts : OptionsPattern[]
] /; MatchQ[elementLists, {{__}..}] := Map[
    MapThread[
        Part,
        {
            elementLists,
            #
        }
    ]&,
    indexLazyList[Length /@ elementLists, opts]
];

lazyTuples[
    elementList_List | Hold[elementList_Symbol],
    tupLength_Integer?Positive,
    opts : OptionsPattern[]
] /; SameQ[elementList, Range @ Length @ elementList] := indexLazyList[ConstantArray[Length[elementList], tupLength], opts];

lazyTuples[
    elementList_List | Hold[elementList_Symbol],
    tupLength_Integer?Positive,
    opts : OptionsPattern[]
] /; And[
    MatchQ[elementList, {__}],
    UnsameQ[elementList, Range @ Length @ elementList]
] := Map[
    Part[
        elementList,
        #
    ]&,
    indexLazyList[ConstantArray[Length[elementList], tupLength], opts]
];

(* Effectively equal to lazyTuples[Range /@ lengths] *)
lazyTuples[lengths : {__Integer}, opts : OptionsPattern[]] := indexLazyList[lengths, opts];

(*
    Modify the function Combinatorica`Private`NC from Combinatorica, which is a compiled function that underlies NextComposition from that package.
    Instead of returning tuples with integers >= 0, nextIntegerTuple returns tuples of integers >= 1.
    Furthermore, Combinatorica`NextComposition loops back from {n, 0, ..., 0} to {0, ..., 0, n},
    while nextIntegerTuple jumps from {n, 1, ..., 1} to {1, ..., 1, n + 1}.
*)
nextIntegerTuple = Compile[{
    {tuple, _Integer, 1}
},
    Module[{
        list = tuple - 1,
        first
    },
        first = First[list];
        If[ first == Total[list],
            Append[Table[1, {Length[list] - 1}], first + 2],
            1 + Combinatorica`Private`NC[list]
        ]
    ],
    CompilationOptions -> {
        "InlineExternalDefinitions" -> True, 
        "InlineCompiledFunctions" -> True
    }
];

(* Generates all tuples of natural numbers of length tupLength *)
lazyTuples[tupLength_Integer] := lazyNestList[
    nextIntegerTuple,
    ConstantArray[1, tupLength]
];

(* 
    Converts elements from 
    Tuples[Range /@ elements /@ elementLists]
    to elements from 
    Tuples[elementLists]
*)
bulkExtractElementsUsingIndexList[
    elementLists_List | Hold[elementLists_Symbol],
    indices_List | Hold[indices_Symbol]
] /; And[
    MatrixQ[indices, IntegerQ],
    Length[elementLists] === Dimensions[indices][[2]]
] := Transpose[
    Developer`ToPackedArray @ MapThread[
        Part,
        {
            elementLists,
            Transpose[Developer`ToPackedArray[indices]]
        }
    ]
];

(* 
    Converts elements from 
    Tuples[Range @ Length @ elementLists], tupLength]
    to elements from 
    Tuples[elementLists, tupLength]
*)
bulkExtractElementsUsingIndexList[
    elementList_List | Hold[elementList_Symbol],
    indices_List | Hold[indices_Symbol],
    tupLength_Integer
] /; And[
    MatrixQ[indices, IntegerQ],
    tupLength === Dimensions[indices][[2]]
] := Map[
    elementList[[#]]&,
    Developer`ToPackedArray[indices]
];

End[]

EndPackage[]

