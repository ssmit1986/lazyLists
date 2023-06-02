(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)
Quiet[Needs["Combinatorica`"]];
BeginPackage["lazyLists`", {"Combinatorica`"}]
(* Exported symbols added here with SymbolName::usage *) 

Begin["`Private`"]
(* Implementation of the package *)

(* Source of decompose and basis: https://mathematica.stackexchange.com/a/153609/43522 *)
basis[lengths : {__Integer}] := ( 
	basis[lengths] = Reverse @ FoldList[Times, 1, Reverse @ Rest @ lengths]
);

(* Compilation only works for Machine integers *)
decompose[base : {__Integer}] /; AllTrue[base, Developer`MachineIntegerQ] := (
	decompose[base] = Compile[{
		{n, _Integer, 1}
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
			Block[{ (* Block is faster than Module *)
				q,
				r = Subtract[#, 1]
			},
				1 + Table[
					q = Quotient[r, i];
					r = Mod[q, i];
					q,
					{i, baseVar}
				]
			]
		]
	]
);

rangeTuplesAtPositions[lengths : {__Integer}] := decompose[basis[lengths]];

(* lazyList that generates the elements of Tuples[Range /@ lengths] *)
Options[indexLazyList] = {
	"PartitionSize" -> 10,
	"Start" -> 1
};

indexLazyList[lengths : {__Integer}, opts : OptionsPattern[]] := With[{
	start = Replace[OptionValue["Start"], Except[_Integer] :> 1],
	partition = Replace[OptionValue["PartitionSize"], Except[_Integer] :> 1]
},
	Map[
		{rangeTuplesAtPositions[lengths], Listable},
		partitionedLazyRange[start, Times @@ lengths, 1, partition]
	]
];

(* 
	Converts elements from 
	Tuples[Range /@ elements /@ elementLists]
	to elements from 
	Tuples[elementLists]
*)
bulkExtractElementsUsingIndexList[elementLists_List | elementLists_Symbol | Hold[elementLists_Symbol]] := 
	Function[
		Transpose[
			Developer`ToPackedArray[
				MapThread[Part, {elementLists, #}]
			]
		]
	];

(* 
	Converts elements from 
	Tuples[Range @ Length @ elementLists], tupLength]
	to elements from 
	Tuples[elementLists, tupLength]
	Note that the tupLength argument only serves to distinguish the two use cases of bulkExtractElementsUsingIndexList
*)

bulkExtractElementsUsingIndexList[elementList_List | elementList_Symbol | Hold[elementList_Symbol], tupLength_Integer] := 
	Function[Transpose[Part[elementList, #]& /@ #]];

Options[lazyTuples] = Options[indexLazyList];
lazyTuples[
	elementLists_List | Hold[elementLists_Symbol],
	opts : OptionsPattern[]
] /; MatchQ[elementLists, {{__}..}] := With[{
	lengths = Length /@ elementLists
},
	composeMappedFunctions @ Map[
		{
			bulkExtractElementsUsingIndexList[Unevaluated[elementLists]],
			Listable
		},
		indexLazyList[lengths, opts]
	]
];

(* Effectively equal to lazyTuples[Range /@ lengths] *)
lazyTuples[lengths : {__Integer}, opts : OptionsPattern[]] := composeMappedFunctions @ Map[
	{
		Transpose[#]&,
		Listable
	},
	indexLazyList[lengths, opts]
]


lazyTuples[
	elementList_List | Hold[elementList_Symbol],
	tupLength_Integer?Positive,
	opts : OptionsPattern[]
] /; And[
	MatchQ[elementList, {__}],
	UnsameQ[elementList, Range @ Length @ elementList]
] := composeMappedFunctions @ Map[
	{
		bulkExtractElementsUsingIndexList[Unevaluated[elementList], tupLength],
		Listable
	},
	indexLazyList[ConstantArray[Length[elementList], tupLength], opts]
];

(* If elementList is just a Range of integers, there's no need to look up the elements from elementList *)
lazyTuples[
	elementList_List | Hold[elementList_Symbol],
	tupLength_Integer?Positive,
	opts : OptionsPattern[]
] /; SameQ[elementList, Range @ Length @ elementList] := lazyTranspose[
	indexLazyList[ConstantArray[Length[elementList], tupLength], opts]
];

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
lazyTuples[tupLength_Integer, staringTuple : ({__} | Automatic) : Automatic, opt : OptionsPattern[]] := partitionedLazyNestList[
	nextIntegerTuple,
	Replace[staringTuple, Automatic :> ConstantArray[1, tupLength]],
	OptionValue["PartitionSize"]
];

Options[lazyOuter] = Options[lazyTuples];
lazyOuter[f_, lists__List, opts : OptionsPattern[]] := Map[
	{Map[Function[f @@ #]], Listable},
	lazyTuples[{lists}, opts]
];

(* ================ lazySubsets Start ================ *)

Options[lazySubsets] = {"PartitionSize" -> 10, "Start" -> 1};
lazySubsets[list_List, opts : OptionsPattern[]] := lazySubsets[list, All, opts];
lazySubsets[list_List, arg_, OptionsPattern[]] := With[{
	partitionSize = OptionValue["PartitionSize"],
	n = Length[list],
	start = OptionValue["Start"]
},
	Map[
	{
		Function[
			With[{res = Quiet @ Subsets[list, arg, MinMax[#]]},
				If[res === {},
					Append[res, endOfLazyList],
					res
				]
			]
		],
		Listable
	},
		partitionedLazyRange[start, partitionSize]
	]
];


(* ================ lazySubsets End ================ *)



End[]

EndPackage[]

