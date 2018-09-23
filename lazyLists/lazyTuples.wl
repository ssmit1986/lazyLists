(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)

BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 

lazyTuples::usage = "lazyTuples is a lazy version of Tuples";

bulkExtractElementsUsingIndexList::usage = "bulkExtractElementsUsingIndexList[lists, indices] converts elements from Tuples[Range /@ Length /@ lists] into elements from Tuples[lists]";

rangeTuplesAtPositions::usage = "rangeTuplesAtPositions[Length /@ lists] is a CompiledFunction that directly generates elements of Tuples[Range /@ Length /@ lists]";

Begin["`Private`"]
(* Implementation of the package *)

(* Source of decompose and basis: https://mathematica.stackexchange.com/a/153609/43522 *)
basis[lengths : {__Integer}] := Reverse[
    FoldList[Times, 1, Reverse @ Rest @ lengths]
];

decompose = Compile[{
    {n, _Integer},
    {d, _Integer, 1}
}, 
    Module[{
        c = n - 1, (* I pick an offset here to make sure that n enumerates from 1 instead of 0 *)
        q
    },
        1 + Table[ (* And added 1 so it's not necessary to do so later on *)
            q = Quotient[c, i];
            c = Mod[c, i];
            q,
            {i, d}
        ]
    ],
    RuntimeAttributes -> {Listable}
];

rangeTuplesAtPositions[lengths : {__Integer}] := With[{
    b = basis[lengths]
},
    If[ Max[b] < 2^63, (* Compile only works with machine integers *)
        rangeTuplesAtPositions[lengths] = Compile[{
            {n, _Integer}
        },
            decompose[n, b],
            RuntimeAttributes -> {Listable},
            CompilationOptions -> {"InlineExternalDefinitions" -> True}
        ],
        
        (* use module to store the basis since the base is very quite and we don't want to copy it around all the time or take up much space in the FrontEnd *)
        rangeTuplesAtPositions[lengths] = Module[{
            base = b
        },
            Composition[
                Function[1 + #], (* Vectorise the additions and subtractions *)
                Function[
                    Null, (* Makes it possible to use Slot (#) and still define attributes for the function *)
                    NumberDecompose[#, base],
                    {Listable}
                ],
                Function[Subtract[#, 1]]
            ]
        ]
    ]
];

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

