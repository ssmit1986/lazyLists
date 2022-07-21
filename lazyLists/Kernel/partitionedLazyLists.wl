(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)
BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 


Begin["`Private`"]
(* Implementation of the package *)

partitionedLazyList::cannotPartition = "Cannot partition lazyList `1` because not all elements are lists. Empty lazyList was returned";

Attributes[partitionedLazyList] = {HoldRest, ReadProtected};
partitionedLazyList[] := lazyList[];
partitionedLazyList[lazyList[], ___] := lazyList[];
partitionedLazyList[{Shortest[first___], endOfLazyList, ___}, ___] := partitionedLazyList[{first}, lazyList[]];
partitionedLazyList[$Failed] := $Failed;
partitionedLazyList[lz : lazyList[Except[_List], _]] := (
	Message[partitionedLazyList::cannotPartition, Short[lz]];
	lazyList[]
);
partitionedLazyList[{}, tail_] := tail;
partitionedLazyList[list_List] := partitionedLazyList[list, lazyList[]];
partitionedLazyList[lazyList[list_List, tail_]] := partitionedLazyList[list, partitionedLazyList[tail]];

partitionedLazyList /: Prepend[partitionedLazyList[list_List, tail_], newElem_] := partitionedLazyList[Prepend[list, newElem], tail];

partitionedLazyList /: First[partitionedLazyList[{elem_, ___}, _], ___] := elem;
partitionedLazyList /: Most[partitionedLazyList[list_List, _]] := list;
partitionedLazyList /: Rest[partitionedLazyList[{_}, tail_]] := tail;
partitionedLazyList /: Rest[partitionedLazyList[{_, rest__}, tail_]] := partitionedLazyList[{rest}, tail];

partitionedLazyRange[partition_Integer?Positive] := partitionedLazyRange[1, Infinity, 1, partition];
partitionedLazyRange[start_, partition_Integer?Positive] := partitionedLazyRange[start, Infinity, 1, partition];
partitionedLazyRange[start_, end_, partition_Integer?Positive] := partitionedLazyRange[start, end, 1, partition];

partitionedLazyRange[start_, _, step_ /; TrueQ[step == 0], partition_Integer?Positive] := With[{
	arr = ConstantArray[start, partition]
},
	Function[
		partitionedLazyList[
			arr,
			#0[#1 + 1]
		]
	][1]
];

partitionedLazyRange[start_?NumericQ, DirectedInfinity[dir : 1 | -1],
	step_?NumericQ, partition_Integer?Positive
] /; Sign[step] === Sign[dir] := With[{
	stepMult = Subtract[partition, 1]
},
	Function[
		With[{next = #1 + step * stepMult},
			partitionedLazyList[
				Range[#1, next, step],
				#0[next + step]
			]
		]
	][start]
];

partitionedLazyRange[start_?NumericQ, DirectedInfinity[dir : 1 | -1],
	step_?NumericQ, partition_Integer?Positive
] /; Sign[step] =!= Sign[dir] := lazyList[];

partitionedLazyRange[start_?NumericQ, max_?NumericQ,  
	step_?NumericQ, partition_Integer?Positive
] /; start <= max && Positive[step] := With[{
	stepMult = Subtract[partition, 1]
},
	Function[
		With[{next = Min[#1 + step * stepMult, max]},
			partitionedLazyList[
				Replace[Range[#1, next, step], {} :> lazyList[]],
				#0[next + step]
			]
		]
	][start]
];

partitionedLazyRange[start_?NumericQ, min_?NumericQ,
	step_?NumericQ, partition_Integer?Positive
] /; start >= min && Negative[step] := With[{
	stepMult = Subtract[partition, 1]
},
	Function[
		With[{next = Max[#1 + step * stepMult, min]},
			partitionedLazyList[
				Replace[Range[#1, next, step], {} :> lazyList[]],
				#0[next + step]
			]
		]
	][start, min]
];

partitionedLazyRange[start_?NumericQ, end_?NumericQ, step_?NumericQ, partition_Integer?Positive] := lazyList[];

partitionedLazyRange[start_, inf_DirectedInfinity, step_, partition_Integer?Positive] := partitionedLazyList[
	lazyRange[
		start + step * Range[0, partition - 1],
		inf,
		partition * step
	]
];

partitionedLazyNestList[fun_, elem_, partition_Integer?Positive] := Function[
	With[{
		nestList = NestList[fun, #1, partition - 1]
	},
		With[{
			last = Last[nestList]
		},
			partitionedLazyList[
				nestList,
				#0[fun[last], #2 + 1]
			]
		]
	]
][elem, 1];

lazyPartition[lazyList[] | {}, ___] := lazyList[];

lazyPartition[lazyList[fst_, lazyList[rest_List]], newPart_Integer?Positive] := With[{
	newRest = Drop[rest, UpTo[newPart - 1]]
},
	partitionedLazyList[
		Prepend[Take[rest, UpTo[newPart - 1]], fst],
		lazyPartition[newRest, newPart]
	]
];

lazyPartition[lzHead[_, HoldPattern @ lazyFiniteList[list_, ind_, p0 : _Integer : 1]], newPart_Integer?Positive] :=
	lazyFiniteList[list, ind - p0, newPart];
lazyPartition[lzHead[_, HoldPattern @ lazyPeriodicListInternal[list_, ind_, max_, p0 : _Integer : 1]], newPart_Integer?Positive] :=
	lazyPeriodicListInternal[list, ind - p0, max, newPart];

lazyPartition[partitionedLazyList[list_, lazyPartition[tail_, _]], partition_Integer?Positive] := Take[
	partitionedLazyList[list, lazyPartition[tail, partition]],
	partition
];

lazyPartition[lz : lzPattern, partition_Integer?Positive] := Replace[
	Take[lz, partition],
	{
		lazyList[list_List, lazyList[]] :> partitionedLazyList[list, lazyList[]],
		(lazyList | partitionedLazyList)[list_List, tail : Except[lazyList[]]] :> partitionedLazyList[list, lazyPartition[tail, partition]]
	}
];

With[{
	msgs = {Take::take, Take::normal}
},
	lazyFiniteList[list_, ind_, partition_] := Quiet[
		Check[
			With[{
				nextIndex = ind + partition
			},
				partitionedLazyList[
					Take[list, {ind, UpTo[ind + partition - 1]}],
					lazyFiniteList[list, nextIndex, partition]
				]
			],
			lazyList[],
			msgs
		],
		msgs
	]
];

lazyPartition[Hold[list_Symbol?ListQ] | list_List, n_Integer?Positive] := lazyFiniteList[list, 1, n];

lazyPeriodicListInternal[list_, i_, max_, part_] := partitionedLazyList[
	Part[
		list,
		Mod[Range[i, i + part - 1], max, 1]
	],
	lazyPeriodicListInternal[list, Mod[i + part, max, 1], max, part]
];

parseTakeSpec[n : (_Integer?Positive | All)] := {1, n, 1};
parseTakeSpec[{m_Integer?Positive, n_Integer?Positive}] := Append[Sort[{m, n}], 1];
parseTakeSpec[{m_Integer?Positive, All}] := {m, All, 1};
parseTakeSpec[{m_Integer?Positive, n_Integer?Positive, step_Integer}] /; step != 0 && m > n := {
	n + Mod[Subtract[m, n], Abs[step]], (* Make sure take starts at the right value to end up exactly at m *)
	m,
	-step
}

parseTakeSpec[{m_Integer?Positive, n_Integer?Positive, step_Integer}] /; step != 0 && m <= n := {m, n, step};
parseTakeSpec[spec : {_Integer?Positive, All, _Integer?Positive}] := spec;
parseTakeSpec[___] := $Failed

partitionedLazyList /: Take[
	partitionedLazyList[list_List, tail_],
	spec : _Integer | {_Integer, ___Integer}
] :=  With[{
	maxIndex = Max @ Replace[spec, {m_, n_, _} :> {m, n}]
},
	partitionedLazyList[
		Take[list, spec],
		Evaluate @ partitionedLazyList[Drop[list, maxIndex], tail]
	] /; Length[list] >= maxIndex
];

partitionedLazyList /: Take[lz : validPartitionedLazyListPattern, {m_Integer?Positive, n_Integer?Positive, step : _Integer : 1}] /; n < m := Replace[
	Take[lz, parseTakeSpec[{m, n, step}]],
	{
		partitionedLazyList[list_List, rest_] :> partitionedLazyList[Reverse[list], rest]
	}
];

partitionedLazyList /: Take[lz : validPartitionedLazyListPattern, spec_] := With[{
	parsedSpec = parseTakeSpec[spec]
},
	Take[lz, parsedSpec] /; parsedSpec =!= $Failed && parsedSpec =!= spec
];

partitionedLazyList /: Take[
	lz : validPartitionedLazyListPattern,
	{start : Except[1, (_Integer?Positive)], stop : (_Integer?Positive | All), step_Integer?Positive}
] := With[{
	advancedLz = Quiet[Part[lz, {start}], {Part::partw}]
},
	If[ MatchQ[advancedLz, validPartitionedLazyListPattern],
		Take[
			advancedLz, 
			{
				1,
				Replace[stop, {int_Integer :> int - start + 1}],
				step
			}
		],
		lazyList[]
	]
];

partitionedLazyList /: Take[
	partLz : validPartitionedLazyListPattern,
	{1, n : (_Integer?Positive | All), step_Integer?Positive}
] := partitionedLazyList @@ MapAt[
	Catenate[First[#, {}]]&,
	Reap[
		Catch[
			Block[{
				$IterationLimit = $lazyIterationLimit,
				count = n,
				offset = 0,
				len
			},
				ReplaceRepeated[
					partLz,
					{
						lazyList[] :> Throw[
							lazyList[],
							"takePartitioned"
						],
						partitionedLazyList[l : Except[_List], _] :> (
							Message[partitionedLazyList::cannotPartition, Short[l]];
							lazyList[]
						),
						Switch[ {n, step},
							{All, 1},
								partitionedLazyList[list_List, tail_] :> (
									Sow[list, "results"];
									tail
								),
							{All, _},
								partitionedLazyList[list_List, tail_] :> (
									If[Length[list] > offset,
										Sow[Part[list, 1 + offset ;; All ;; step], "results"]
									];
									offset = Mod[Subtract[offset, Length[list]], step];
									tail
								),
							{_, 1},
								partitionedLazyList[
									list_List?(Function[(len = Length[#]) < count]),
									tail_
								] :> (
									Sow[list, "results"];
									count -= len;
									tail
								),
							_,
								partitionedLazyList[
									list_List?(Function[(len = Length[#]) < count]),
									tail_
								] :> (
									If[ TrueQ[len > offset],
										Sow[Part[list, 1 + offset ;; All ;; step], "results"]
									];
									count -= len;
									offset = Mod[Subtract[offset, len], step];
									tail
								)
						],
						If[ n === All,
							Nothing,
							partitionedLazyList[list_List, tail_] :> (
								Sow[Part[list, 1 + offset ;; count ;; step], "results"];
								Throw[
									partitionedLazyList[Drop[list, count], tail],
									"takePartitioned"
								]
							)
						]
					},
					MaxIterations -> DirectedInfinity[1]
				]
			],
			"takePartitioned"
		],
		"results"
	][[{2, 1}]],
	1
];

partitionedLazyList /: TakeWhile[
	partLz : validPartitionedLazyListPattern,
	function : _ : Function[True],
	opts : OptionsPattern[MaxIterations -> Infinity]
] := partitionedLazyList @@ MapAt[
	Catenate[First[#, {}]]&,
	Reverse @ Reap[
		Quiet[
			Catch[
				Block[{
					$IterationLimit = $lazyIterationLimit,
					ind
				},
					ReplaceRepeated[
						partLz,
						{
							If[ function === Function[True]
								,
								partitionedLazyList[list_List, tail_] :> (
									Sow[list, "partTakeWhile"];
									tail
								)
								,
								partitionedLazyList[list_List, tail_] :> (
									ind = LengthWhile[list, function];
									If[ ind === Length[list]
										,
										Sow[list, "partTakeWhile"];
										tail
										,
										Sow[Take[list, ind], "partTakeWhile"];
										Throw[
											partitionedLazyList[Drop[list, ind], tail],
											"takeWhile"
										]
									]
								)
							],
							other_ :> Throw[other, "takeWhile"]
						},
						MaxIterations -> OptionValue[MaxIterations]
					]
				],
				"takeWhile"
			],
			{ReplaceRepeated::rrlim}
		],
		"partTakeWhile"
	],
	1
];

partitionedLazyList /: LengthWhile[
	lz : partitionedLazyList[{___, el_}, _],
	function : _ : Function[True],
	opts : OptionsPattern[MaxIterations -> Infinity]
] := Quiet[
	Block[{
		$IterationLimit = $lazyIterationLimit,
		count = 0,
		ind
	},
		Replace[
			Catch[
				ReplaceRepeated[
					{lz, el},
					{
						If[ function === Function[True]
							,
							{partitionedLazyList[list : {___, elem_}, tail_], prev_} :> (
								count += Length[list];
								{tail, elem}
							)
							,
							{partitionedLazyList[list : {___, elem_}, tail_], prev_} :> (
								count += (
									ind = LengthWhile[list, function]
								);
								Switch[ ind,
									Length[list],
										{tail, elem},
									0,
										Throw[
											partitionedLazyList[{prev}, tail],
											"lengthWhile"
										],
									_,
										Throw[
											partitionedLazyList[Drop[list, ind - 1], tail],
											"lengthWhile"
										]
								]
							)
						],
						{other_, prev_} :> Throw[partitionedLazyList[{prev}, other], "lengthWhile"]
					},
					MaxIterations -> OptionValue[MaxIterations]
				],
				"lengthWhile"
			],
			{
				(* This happens whenever $lazyIterationLimit was exceeded *)
				{l : validPartitionedLazyListPattern, prev_} :> <|"Index" -> Infinity, "Element" -> l|>,
				l : validPartitionedLazyListPattern :> <|"Index" -> count, "Element" -> l|>
			}
		]
	],
	{ReplaceRepeated::rrlim}
];

partitionedLazyList /: Part[_partitionedLazyList, {0} | 0] := partitionedLazyList;
partitionedLazyList /: Part[partLz : validPartitionedLazyListPattern, 1] := First[partLz];
partitionedLazyList /: Part[partLz : validPartitionedLazyListPattern, {1}] := partLz;
partitionedLazyList /: Part[partLz : validPartitionedLazyListPattern, n : (_Integer?Positive | -1)] := First[Part[partLz, {n}], $Failed];
partitionedLazyList /: Part[partitionedLazyList[list : {_, ___}, tail_], {n_Integer?Positive}] /; n <= Length[list] :=
	partitionedLazyList[Drop[list, n - 1], tail];
partitionedLazyList /: Part[lz : validPartitionedLazyListPattern, {-1}] := Replace[
	LengthWhile[lz, Function[True]],
	KeyValuePattern["Element" -> el_] :> el
];


partitionedLazyList /: Part[partLz : validPartitionedLazyListPattern, span_Span] := Take[partLz, List @@ span];

partitionedLazyList /: Part[partLz : validPartitionedLazyListPattern, {n_Integer?Positive}] := Catch[
	Block[{
		$IterationLimit = $lazyIterationLimit,
		count = n,
		length
	},
		ReplaceRepeated[
			partLz,
			{
				lazyList[] :> Throw[
					lazyList[],
					"partPartitioned"
				],
				partitionedLazyList[l : Except[_List], _] :> (
					Message[partitionedLazyList::cannotPartition, Short[l]];
					lazyList[]
				),
				partitionedLazyList[
					list_List?(Function[(length = Length[#]) < count]), tail_] :> (
						count -= length;
						tail
					),
				partitionedLazyList[l_List, tail_] :> (
					Throw[
						partitionedLazyList[
							l[[{count}]],
							Evaluate @ partitionedLazyList[Drop[l, count], tail]
						],
						"partPartitioned"
					]
				)
			},
			MaxIterations -> DirectedInfinity[1]
		]
	],
	"partPartitioned"
];

partitionedLazyList /: Part[lz : validPartitionedLazyListPattern, indices : {_Integer, __Integer}] /; VectorQ[indices, Positive]:= Catch[
	Module[{
		sortedIndices = Sort[indices],
		eval
	},
		partitionedLazyList[
			Part[
				FoldPairList[
					Function[
						eval = Check[Part[#1, {#2}], Throw[$Failed, "part"], {Part::partw}];
						{
							First[eval], (* emit the value at this position *)
							eval (* and return the lazyList to the next iteration *)
						}
					],
					lz,
					Prepend[Differences[sortedIndices] + 1, First[sortedIndices]]
				],
				Ordering[indices]
			],
			Evaluate[eval]
		]
	],
	"part"
];

partitionedLazyList /: TakeDrop[lz : validPartitionedLazyListPattern, args__] := With[{
	newLz = Take[lz, args]
},
	If[ MatchQ[newLz, validPartitionedLazyListPattern],
		{Most[newLz], Last[newLz]},
		$Failed
	]
];

partitionedLazyList /: Drop[lz : validPartitionedLazyListPattern, args__] := With[{
	newLz = Take[lz, args]
},
	If[ MatchQ[newLz, validPartitionedLazyListPattern],
		Last[newLz],
		$Failed
	]
];

(* 
	The function specification {fun, Listable} signals that fun is listable and should be applied directly to the list. 
	Note that it's up to the user to ensure that fun is actually listable
*)
partitionedLazyList /: Map[{fun_, Listable}, partitionedLazyList[first_, tail_]] := partitionedLazyList[
	fun[first],
	Map[{fun, Listable}, tail]
];
partitionedLazyList /: Map[fun_, partitionedLazyList[first_, tail_]] := partitionedLazyList[
	fun /@ first,
	Map[fun, tail]
];

partitionedLazyList /: MapIndexed[fun_, partitionedLazyList[first_, tail_], index : (_Integer?Positive) : 1] := With[{
	length = Length[first]
},
	partitionedLazyList[
		MapThread[fun, {first, Range[index, index + length - 1]}],
		MapIndexed[fun, tail, index + length]
	]
];

partitionedLazyList /: FoldList[fun_, partitionedLazyList[{elem_, rest___}, tail_]] := FoldList[
	fun,
	elem,
	partitionedLazyList[{rest}, tail]
];

partitionedLazyList /: FoldList[fun_, current_, partitionedLazyList[first_List, tail_]] := With[{
	fold = FoldList[fun, current, first]
},
	With[{newTail = tail},
		If[ newTail === lazyList[],
			partitionedLazyList[
				fold,
				lazyList[]
			],
			If[ fold === {}, (* If fold has length 0, the last element is assumed to have been Nothing *)
				FoldList[fun, Nothing, newTail],
				With[{last = Last[fold]},
					partitionedLazyList[
						Most @ fold, (* The last element of fold will be added in the next iteration *)
						FoldList[fun, last, newTail]
					]
				]
			]
		]
	]
];

partitionedLazyList /: FoldPairList[fun_, current_, partitionedLazyList[first_List, tail_], g : _ : First] := Block[{
	foldPairListState,
	fold
},
	fold = FoldPairList[fun, current, first, Function[foldPairListState = Last[#]; g[#]]];
	With[{
		st = foldPairListState
	},
		partitionedLazyList[
			fold,
			FoldPairList[fun, st, tail, g]
		]
	]
];

partitionedLazyList /: Cases[partitionedLazyList[list_List, tail_], patt_] := partitionedLazyList[
	Cases[list, patt],
	Cases[tail, patt]
];

partitionedLazyList /: Pick[
	partitionedLazyList[first_List, tail1_],
	partitionedLazyList[select_List, tail2_],
	patt_
] := With[{
	minLength = Min[Length /@ {first, select}]
},
	With[{
		rest1 = Drop[first, minLength],
		rest2 = Drop[select, minLength]
	},
		partitionedLazyList[
			Pick[Take[first, minLength], Take[select, minLength], patt],
			Pick[
				partitionedLazyList[rest1, tail1],
				partitionedLazyList[rest2, tail2],
				patt
			]
		]
	]
];

partitionedLazyList /: Select[partitionedLazyList[first_List, tail_], fun_] := partitionedLazyList[
	Select[first, fun],
	Select[tail, fun]
];

lazyCatenate[lists : {___, __List, partitionedLazyList[_, _], rest___}] := 
	lazyCatenate[
		SequenceReplace[
			lists,
			{l1__List, partitionedLazyList[l2_List, tail_]} :> partitionedLazyList[Join[l1, l2], tail]
		]
	];
lazyCatenate[{fst__partitionedLazyList, lists__List}] := lazyCatenate[{fst, partitionedLazyList[Join[lists], lazyList[]]}];

lazyCatenate[{partitionedLazyList[list_List, tail_], rest__partitionedLazyList}] := partitionedLazyList[list, lazyCatenate[{tail, rest}]];

Options[repartitionAll] = {
	"RepartitionFunction" -> Max
};
repartitionAll[exprs : {___, lazyList[], ___}, ___] := Replace[
	exprs,
	{
		lz : lzPattern -> lazyList[]
	},
	{1}
];
repartitionAll[exprs_List, opts : OptionsPattern[]] := With[{
	lengths = Cases[exprs, partitionedLazyList[lst_List, ___] :> Length[lst]]
},
	If[ SameQ @@ lengths && FreeQ[exprs, _lazyList, {1}, Heads -> False],
		exprs,
		repartitionAll[exprs, OptionValue["RepartitionFunction"][lengths]]
	] /; MatchQ[lengths, {__Integer}]
];
repartitionAll[exprs_List, newLength_Integer?Positive] := repartitionAll[
	Replace[
		exprs,
		{
			lz : partitionedLazyList[_, _lazyPartition] | _lazyList :> lazyPartition[lz, newLength],
			partLz_partitionedLazyList :> Take[partLz, newLength]
		},
		{1}
	],
	"RepartitionFunction" -> Min
];
repartitionAll[other_, ___] := other;

Options[lazyMapThread] = Options[repartitionAll];
lazyMapThread[fun_, lists : {lzHead[_, _]..}, opts : OptionsPattern[]] := With[{
	repartitioned = repartitionAll[lists, opts]
},
	With[{
		heads = repartitioned[[All, 1]],
		tails = repartitioned[[All, 2]]
	},
		partitionedLazyList[
			MapThread[fun, heads],
			lazyMapThread[
				fun,
				tails
			]
		]
	] /; FreeQ[repartitioned, lazyList[], {1}, Heads -> False]
];

Options[lazyTranspose] = Options[repartitionAll];
lazyTranspose[lists : {lzHead[_, _]..}, opts : OptionsPattern[]] := lazyMapThread[List, lists, opts];
lazyTranspose[
	lz : partitionedLazyList[lists : {{___}..}, _]
] /; SameQ @@ (Length /@ lists) := Map[{Transpose, Listable}, lz];

End[]

EndPackage[]

