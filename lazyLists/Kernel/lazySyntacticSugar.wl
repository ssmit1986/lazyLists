(* ::Package:: *)

BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *)

Begin["`Private`"]

lazyList /: Rest[lazyList[_, tail_]] := tail;
lazyList /: Most[lazyList[elem_, _]] := {elem};

lazyList /: Prepend[lz_lazyList, element_] := lazyList[element, lz];

lazyList /: Append[lazyList[first_, tail_], element_] := lazyList[first, Append[tail, element]];
lazyList /: Append[lazyList[], element_] := lazyList[element, lazyList[]];

lazyList /: lazyPrependTo[lazyList[first_, lazyFiniteList[list_List, i_]], element_] := With[{
    newList = Prepend[list, element]
},
    lazyList[first, lazyFiniteList[newList, i + 1]]
];
lazyPrependTo[lazyList[first_, lazyFiniteList[list_Symbol, i_]], element_] := (
    PrependTo[list, element];
    lazyList[first, lazyFiniteList[list, i + 1]]
);

lazyList /: lazyAppendTo[lazyList[first_, lazyFiniteList[list_List, i_]], element_] := With[{
    newList = Append[list, element]
},
    lazyList[first, lazyFiniteList[newList, i]]
];
lazyAppendTo[lazyList[first_, lazyFiniteList[list_Symbol, i_]], element_] := (
    AppendTo[list, element];
    lazyList[first, lazyFiniteList[list, i]]
);

Attributes[setLazyListable] = {HoldFirst};
setLazyListable[sym_Symbol] := (
    lazyList /: (expr : sym[___, lazyList[], ___]) := lazyList[];
    partitionedLazyList /: sym[first___, lz_partitionedLazyList, rest___] := Function[
        Thread[
            Unevaluated[
                Thread[Unevaluated[sym[##]]]&[##]
            ],
            partitionedLazyList
        ]
    ] @@ repartitionAll[{first, lz, rest}];
    lazyList /: (expr : sym[___, _lazyList, ___]) := Thread[
        Unevaluated[expr],
        lazyList
    ];
    sym
);
setLazyListable[{sym_Symbol, Listable}] := (
    lazyList /: (expr : sym[___, lazyList[], ___]) := lazyList[];
    partitionedLazyList /: (sym[first___, lz_partitionedLazyList, rest___]) := Thread[
        Unevaluated[sym[##]],
        partitionedLazyList
    ]& @@ repartitionAll[{first, lz, rest}];
    lazyList /: (sym[first___, lz_lazyList, rest___]) := Thread[
        Unevaluated[sym[##]],
        lazyList
    ]& @@ If[ MemberQ[{first, rest}, _partitionedLazyList],
        repartitionAll[{first, lz, rest}],
        {first, lz, rest}
    ];
    sym
);

(* Set threading behaviour for lazyLists to make it possible to add and multiply them and use powers on them *)
Scan[
    Function[Null, setLazyListable[{#, Listable}], {HoldAll}],
    {Plus, Times, Power, Divide, Subtract}
];

(* Elements from lazyLists are extracted by repeatedly evaluating the next element and sowing the results *)
lazyList /: Take[lz : validLazyListPattern, n_Integer?Positive] := ReleaseHold[
    lazyList @@ MapAt[
        First[#, {}]&,
        Reverse @ Reap[
            Replace[
                Quiet[
                    Block[{$IterationLimit = $lazyIterationLimit},
                        ReplaceRepeated[
                            lz,
                            {
                                lazyList[first_, tail_] :> (Sow[first, "take"]; tail)
                            },
                            MaxIterations -> n - 1
                        ]
                    ],
                    {ReplaceRepeated::rrlim}
                ],
                (* The last element should only be Sown without evaluating the tail *)
                lazyList[first_, tail_] :> (Sow[first, "take"]; Hold[tail])
            ],
            "take"
        ],
        1
    ]
];

lazyList /: Take[lz : validLazyListPattern, {m_Integer?Positive, n_Integer?Positive}] /; n < m := Replace[
    Take[lz, {n, m}],
    {
        lazyList[list_List, rest_] :> lazyList[Reverse[list], rest]
    }
];

lazyList /: Take[lz : validLazyListPattern, {m_Integer?Positive, n : (_Integer?Positive | All)}] /; (n === All || n > m) := Replace[
    Quiet[lz[[{m}]], {Part::partw}],
    {
        l : validLazyListPattern :> Take[l, Replace[n, int_Integer :> int - m + 1]],
        _ -> lazyList[]
    }
];

lazyList /: Take[lz : validLazyListPattern, All] := TakeWhile[lz];

lazyList /: TakeWhile[lz : validLazyListPattern, function : _ : Function[True], opts : OptionsPattern[MaxIterations -> Infinity]] := lazyList @@ MapAt[
    First[#, {}]&,
    Reverse @ Reap[
        Quiet[
            Catch[
                Block[{
                    $IterationLimit = $lazyIterationLimit,
                    first,
                    pattern
                },
                    pattern = If[ function === Function[True],
                        first_,
                        first_?function
                    ];
                    ReplaceRepeated[
                        lz,
                        {
                            lazyList[pattern, tail_] :> (Sow[first, "take"]; tail),
                            other_ :> Throw[other, "takeWhile"]
                        },
                        MaxIterations -> OptionValue[MaxIterations]
                    ]
                ],
                "takeWhile"
            ],
            {ReplaceRepeated::rrlim}
        ],
        "take"
    ],
    1
];

lazyList /: LengthWhile[lz : validLazyListPattern, function : _ : Function[True], opts : OptionsPattern[MaxIterations -> Infinity]] := Quiet[
    Block[{
        $IterationLimit = $lazyIterationLimit,
        first,
        pattern,
        count = 0
    },
        pattern = If[ function === Function[True],
            first_,
            first_?function
        ];
        Replace[
            Catch[
                ReplaceRepeated[
                    {lz, First[lz]},
                    {
                        {lazyList[pattern, tail_], prev_} :> (count++; {tail, first}),
                        {other_, prev_} :> Throw[lazyList[prev, other], "lengthWhile"]
                    },
                    MaxIterations -> OptionValue[MaxIterations]
                ],
                "lengthWhile"
            ],
            {
                (* This happens whenever $lazyIterationLimit was exceeded *)
                {l : validLazyListPattern, prev_} :> <|"Index" -> Infinity, "Element" -> l|>,
                l : validLazyListPattern :> <|"Index" -> count, "Element" -> l|>
            }
        ]
    ],
    {ReplaceRepeated::rrlim}
];

lazyList /: Part[lz : lazyList[], i_] := (Message[Part::partw, Short[i], Short[lz]]; $Failed);
lazyList /: Part[lazyList[___], 0 | {0}] := lazyList;
lazyList /: Part[lazyList[first_, _], 1] := first;
lazyList /: Part[lz : validLazyListPattern, {1}] := lz;
lazyList /: Part[lazyList[_, tail_], {2}] := tail;
lazyList /: Part[lz : validLazyListPattern, {-1}] := Replace[
    LengthWhile[lz, Function[True]],
    KeyValuePattern["Element" -> el_] :> el
];
lazyList /: Part[lz : validLazyListPattern, n : (_Integer?Positive | -1)] := First[Part[lz, {n}], $Failed];

lazyList /: Part[lz : validLazyListPattern, Span[m_Integer, n_Integer]] := Replace[
    Take[lz, {m, n}],
    {
        lazyList[] | lazyList[_, lazyList[]] :> (Message[Part::partw, Max[m, n], Short[lz]]; $Failed)
    }
];

lazyList /: Part[lz : validLazyListPattern, Span[m_Integer, n_Integer, incr_Integer]] := Part[
    lz,
    Range[m, n, incr]
];

lazyList /: Part[lz : validLazyListPattern, indices : {_Integer, __Integer}] /; VectorQ[indices, Positive]:= Catch[
    Module[{
        sortedIndices = Sort[indices],
        eval
    },
        lazyList[
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

lazyList /: Part[lz : validLazyListPattern, {n_Integer?Positive}] := Replace[
    Quiet[
        Block[{$IterationLimit = $lazyIterationLimit},
            ReplaceRepeated[
                lz,
                {
                    lazyList[first_, tail_] :> tail
                },
                MaxIterations -> n - 1
            ]
        ],
        {ReplaceRepeated::rrlim}
    ],
    {
        lazyList[] :> (Message[Part::partw, n, Short[lz]]; $Failed)
    }
];

lazyList /: TakeDrop[lz : validLazyListPattern, args__] := With[{
    newLz = Take[lz, args]
},
    If[ MatchQ[newLz, validLazyListPattern],
        {First[newLz], Rest[newLz]},
        $Failed
    ]
];

lazyList /: Drop[lz : validLazyListPattern, args__] := With[{
    newLz = Take[lz, args]
},
    If[ MatchQ[newLz, validLazyListPattern],
        Rest[newLz],
        $Failed
    ]
];

lazyList /: Map[f_, lazyList[first_, tail_]] := lazyList[
    f[first],
    Map[f, tail]
];

lazySetState[l : lazyList[_, Map[f_, tail_]], state_] := With[{
    try = Check[lazySetState[tail, state], $Failed]
},
    If[ MatchQ[try, validLazyListPattern],
        Map[f, try],
        l
    ]
];

lazyList /: MapIndexed[f_, lazyList[first_, tail_], index : (_Integer?Positive) : 1] := lazyList[
    f[first, index],
    MapIndexed[f, tail, index + 1]
];

lazyList /: FoldList[f_, lazyList[first_, tail_]] := FoldList[f, first, tail];
lazyList /: FoldList[f_, current_, lazyList[first_, tail_]] := lazyList[
    current,
    FoldList[f, f[current, first], tail]
];
lazyList /: FoldList[f_, current_, empty : lazyList[]] := lazyList[current, empty];

(*
    The True value that passes with FoldPairList is used to see if this is the first call to FoldPairList or if the process in already iterating.
    This is because the starting value in FoldPairList should not end up in the actual list.
*)
lazyList /: FoldPairList[fun_, {emit_, feed_}, True, lazyList[first_, tail_]] := lazyList[
    emit,
    FoldPairList[fun, fun[feed, first], True, tail]
];
lazyList /: FoldPairList[fun_, {emit_, feed_}, True, empty : lazyList[]] := lazyList[emit, empty];

lazyList /: FoldPairList[fun_, {emit_, feed_}, True, lazyList[first_, tail_], red_] := lazyList[
    red[{emit, feed}],
    FoldPairList[fun, fun[feed, first], True, tail, red]
];
lazyList /: FoldPairList[fun_, {emit_, feed_}, True, empty : lazyList[], red_] := lazyList[red[{emit, feed}], empty];

(* Patterns that start FoldPairList *)
lazyList /: FoldPairList[fun_, val_, lazyList[first_, tail_]] := FoldPairList[fun, fun[val, first], True, tail];
lazyList /: FoldPairList[fun_, val_, lazyList[first_, tail_], red_] := FoldPairList[fun, fun[val, first], True, tail, red];
lazyList /: FoldPairList[fun_, val_, lazyList[], ___] := lazyList[];

lazyList /: Cases[lazyList[], _] := lazyList[]
lazyList /: Cases[lz_lazyList, patt_] := Module[{
    case
 },
    (* Define helper function to match patterns faster *)
    case[lazyList[first : patt, tail_]] := lazyList[first, case[tail]];
    case[lazyList[first_, tail_]] := case[tail];
    case[lazyList[]] := lazyList[];

    case[lz]
];

lazyList /: Pick[lazyList[], _, _] := lazyList[];
lazyList /: Pick[_, lazyList[], _] := lazyList[];
lazyList /: Pick[lz_lazyList, select_lazyList, patt_] := Module[{
    pick
},
    (* Define helper function, just like with Cases *)
    pick[lazyList[first_, tail1_], lazyList[match : patt, tail2_]] :=
        lazyList[first, pick[tail1, tail2]];
    pick[lazyList[first_, tail1_], lazyList[first2_, tail2_]] :=
        pick[tail1, tail2];
    pick[lazyList[], _] := lazyList[];
    pick[_, lazyList[]] := lazyList[];

    pick[lz, select]
];

lazyList /: Select[lazyList[first_, tail_], f_] /; f[first] := lazyList[first, Select[tail, f]];
lazyList /: Select[lazyList[first_, tail_], f_] := Select[tail, f];

listOrLazyListPattern = lazyList | List;
lazyCatenate[listOrLazyListPattern[]] := lazyList[];

(*Cases where the outer list is List *)
lazyCatenate[list : {___, heldListPattern, ___}] := lazyCatenate @ Replace[
    list,
    l : heldListPattern :> lazyList[l],
    {1}
];

lazyCatenate[list : {___, listOrLazyListPattern[], ___}] := lazyCatenate[
    DeleteCases[list, listOrLazyListPattern[]]
];
lazyCatenate[lists : {(_List | _lazyList)..., _List, (_List | _lazyList)...}] := lazyCatenate[
    Replace[
        SequenceReplace[
            lists,
            {l1_List, l2__List} :> Join[l1, l2]
        ],
        l_List :> lazyList[l],
        {1}
    ]
];
lazyCatenate[{lz : lzHead[_, _]}] := lz;
lazyCatenate[{lazyList[first_, tail_], rest__}] := lazyList[first, lazyCatenate[{tail, rest}]];

(*Cases where the outer list is lazyList *)
lazyCatenate[lazyList[listOrLazyListPattern[], tail_]] := lazyCatenate[tail];
lazyCatenate[lazyList[list_List, tail_]] := lazyCatenate[lazyList[lazyList[list], tail]];
lazyCatenate[lazyList[lazyList[first_, tail1_], tail2_]] := lazyList[first, lazyCatenate[lazyList[tail1, tail2]]];

composeMappedFunctions[lz_lazyList] := With[{
    patt = Append[generatorPattern, Map]
},
    ReplaceRepeated[
        lz,
        {
             HoldPattern @ Map[f_, (gen : patt)[fgen_, args___]] :> With[{
                composition = f @* fgen (* Evaluate the composition to flatten it out if necessary *)
            },
                gen[
                    composition,
                    args
                ] /; True (* condition trick to make sure the With evaluates *)
            ]
        }
    ]
];

composeMappedFunctions[lz_partitionedLazyList] := ReplaceRepeated[
    lz,
    {
        HoldPattern @ Map[fun_, Map[fgen_, tail_]] :> With[{
            composition = Replace[
                {fun, fgen},
                {
                    (* Don't use Composition here, because it doesn't auto-compile *)
                    {{f_, Listable}, {g_, Listable}} :> {Function[f[g[#]]], Listable},
                    {f : Except[{_, Listable}], {g_, Listable}} :> {Function[f /@ g[#]], Listable},
                    {{f_, Listable}, g : Except[{_, Listable}]} :> {Function[f[g /@ #]], Listable},
                    {f_, g_} :> Function[f[g[#]]]
                }
            ]
        },
            Map[
                composition,
                tail
            ] /; True (* condition trick to make sure the With evaluates *)
        ]
    }
];

lazyList /: AllTrue[lazyList[], _] := True;
lazyList /: AnyTrue[lazyList[], _] := False;
lazyList /: NoneTrue[lazyList[], _] := True;

MapThread[
    Function[{sym, patt},
        sym /: AllTrue[lz : patt, f_] := Catch[
            Map[
                Function[
                    If[ !TrueQ[f[#]],
                        Throw[False, "lzAllTrue"],
                        Null
                    ]
                ],
                lz
            ][[-1]];
            True,
            "lzAllTrue"
        ]
    ],
    {
        {lazyList, partitionedLazyList},
        {validLazyListPattern, validPartitionedLazyListPattern}
    }
];

MapThread[
    Function[{sym, patt},
        sym /: AnyTrue[lz : patt, f_] := Catch[
            Map[
                Function[
                    If[ TrueQ[f[#]],
                        Throw[True, "lzAnyTrue"],
                        Null
                    ]
                ],
                lz
            ][[-1]];
            False,
            "lzAnyTrue"
        ]
    ],
    {
        {lazyList, partitionedLazyList},
        {validLazyListPattern, validPartitionedLazyListPattern}
    }
];

MapThread[
    Function[{sym, patt},
        sym /: NoneTrue[lz : patt, f_] := Catch[
            Map[
                Function[
                    If[ TrueQ[f[#]],
                        Throw[False, "lzNoneTrue"],
                        Null
                    ]
                ],
                lz
            ][[-1]];
            True,
            "lzNoneTrue"
        ]
    ],
    {
        {lazyList, partitionedLazyList},
        {validLazyListPattern, validPartitionedLazyListPattern}
    }
];

lazyAggregate[
    lz : nonEmptyLzListPattern,
    {agg_, comb_},
    maxItems: (_Integer?Positive | Infinity) : Infinity,
    bsize : (_Integer?Positive | Automatic) : Automatic
] := With[{
    batchSize = Replace[
        {bsize, lz},
        {
            {i_Integer, _} :> i,
            {Automatic, partitionedLazyList[l_List, _]} :> Length[l],
            _ :> Min[100, maxItems]
        }
    ]
},
    With[{
        n = Min[batchSize, maxItems]
    },
       Block[{$IterationLimit = $lazyIterationLimit},
           lazyAggregateInternal[
                Replace[TakeDrop[lz, n],
                    {
                        {l_List, lz1_} :> {agg[l], lz1},
                        _ :> $Failed
                    }
                ],
                {agg, comb},
                Subtract[maxItems, n],
                If[ Head[lz] === lazyList,
                    batchSize,
                    bsize
                ]
            ]
       ]
    ]
];

lazyAggregateInternal[{tot_, lz_}, _, 0, _] := {tot, lz};
lazyAggregateInternal[{tot_, lazyList[]}, _, _, _] := {tot, lazyList[]};
lazyAggregateInternal[$Failed, ___] := $Failed;

lazyAggregateInternal[
    {tot_, lz : nonEmptyLzListPattern},
    {agg_, comb_},
    maxItems_,
    batchSize_Integer
] := With[{
    n = Min[batchSize, maxItems]
},
   lazyAggregateInternal[
        Replace[TakeDrop[lz, n],
            {
                {l_List, lz1_} :> {comb[{tot, agg[l]}], lz1},
                _ :> $Failed
            }
        ],
        {agg, comb},
        Subtract[maxItems, n],
        batchSize
    ]
];
lazyAggregateInternal[
    {tot_, lz : partitionedLazyList[lst_List, _]},
    {agg_, comb_},
    maxItems_,
    Automatic
] := With[{
    n = Min[Length[lst], maxItems]
},
   lazyAggregateInternal[
        Replace[TakeDrop[lz, n],
            {
                {l_List, lz1_} :> {comb[{tot, agg[l]}], lz1},
                _ :> $Failed
            }
        ],
        {agg, comb},
        Subtract[maxItems, n],
        Automatic
    ]
];

(*
(* TODO: Implement *)
Scan[
    Function[sym,
        lazyList /: HoldPattern[sym[lazyList[], ___]] := lazyList[];
        lazyList /: HoldPattern[sym[lazyList[first_, tail_], n_]] := Undefined,
        {TakeLargest, TakeSmallest}
    ]
];

Scan[
    Function[sym,
        lazyList /: HoldPattern[sym[lazyList[], ___]] := lazyList[];
        With[{
            smallOrLarge = Replace[sym, {TakeLargestBy -> TakeLargest, TakeSmallestBy -> TakeSmallest}]
        },
            lazyList /: HoldPattern[sym[lz : validLazyListPattern, f_, n_]] := smallOrLarge[Map[f, lz], n]
        ],
        {TakeLargestBy, TakeSmallestBy}
    ]
];
*)
End[]

EndPackage[]

