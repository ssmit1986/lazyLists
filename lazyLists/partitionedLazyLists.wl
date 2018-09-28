(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)
BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 

partitionedLazyList::usage = "Is a special wrapper for lazyLists that generate ordinary Lists.
The elements of the inner Lists are treated as if they're seperate elements of the outer lazyList, making it possible to generate elements in chunks.
List operations on partitionedLazyList such as Map and FoldList will be automatically applied to the generated lists for efficiency";

partitionedLazyRange::usage = "partitionedLazyRange[start, step, partitionLength] works like lazyRange, but yields a partitionedLazyList.
partitionedLazyRange[partitionLength] generates the natural numbers in chuncks of length partitionLength";

partitionedLazyNestList::usage = "partitionedLazyNestList[fun, elem, partitionLength] is a partitioned version of lazyNestList.
Each new partition is generated with NestList";

lazyPartition::usage = "lazyPartition[lz, n] turns an ordinary lazyList into a partitioned lazyList with chunks of length n";

Begin["`Private`"]
(* Implementation of the package *)

partitionedLazyList::cannotPartition = "Cannot partition lazyList `1` because not all elements are lists. Empty lazyList was returned";

Attributes[partitionedLazyList] = {HoldRest};
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

partitionedLazyRange[start : _ : 1, step: _ : 1, partition_Integer?Positive] := partitionedLazyList[
    lazyRange[
        start + step * Range[0, partition - 1],
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
lazyPartition[lzHead[_, lazyFiniteList[list_, ind_, p0 : _Integer : 1]], newPart_Integer?Positive] :=
    lazyFiniteList[list, ind - p0, newPart];
lazyPartition[lzHead[_, lazyPeriodicListInternal[list_, ind_, max_, p0 : _Integer : 1]], newPart_Integer?Positive] :=
    lazyPeriodicListInternal[list, ind - p0, max, newPart];

lazyPartition[lz : lzPattern, partition_Integer?Positive] := Replace[
    Take[lz, partition],
    (lazyList | partitionedLazyList)[list_List, tail_] :> partitionedLazyList[list, lazyPartition[tail, partition]]
];
lazyPartition[list_List, partition_Integer?Positive] := With[{
    rest = Drop[list, UpTo[partition]]
},
    partitionedLazyList[
        Take[list, UpTo[partition]],
        lazyPartition[rest, partition]
    ]
];

With[{
    msgs = {Take::take, Take::normal}
},
    lazyFiniteList[list_, ind_, partition_] := Quiet[
        Check[
            partitionedLazyList[
                Take[list, {ind, UpTo[ind + partition - 1]}],
                lazyFiniteList[list, ind + partition, partition]
            ],
            lazyList[],
            msgs
        ],
        msgs
    ]
];

lazyPartition[Hold[list_Symbol], n_Integer?Positive] /; ListQ[list] := partitionedLazyList[
    Take[list, UpTo[n]],
    lazyFiniteList[list, n + 1, n]
];

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
                result,
                take,
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
                    first,
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

(* Mapping over a generator or Mapped list is the same as composition of the generator functions:*)
partitionedLazyList /: Map[
    fun_,
    partitionedLazyList[first_, Map[fgen_, tail_]]
] := With[{
    composition = Replace[
        {fun, fgen},
        {
            {{f_, Listable}, {g_, Listable}} :> {Function[f[g[#]]], Listable},
            {f : Except[{_, Listable}], {g_, Listable}} :> {Function[f /@ g[#]], Listable},
            {{f_, Listable}, g : Except[{_, Listable}]} :> {Function[f[g /@ #]], Listable},
            {f_, g_} :> Function[f[g[#]]] (* Don't use Composition here, because it doesn't auto-compile *)
        }
    ]
},
    partitionedLazyList[
        Replace[
            fun,
            {
                {f_, Listable} :> f[first],
                f_ :> f /@ first
            }
        ],
        Map[
            composition,
            tail
        ]
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
        MapThread[fun, {first, Range[length] + index - 1}],
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
    With[{
        newTail = tail
    },
        If[ newTail === lazyList[],
            partitionedLazyList[
                fold,
                lazyList[]
            ],
            With[{
                last = Last[fold]
            },
                partitionedLazyList[
                    Most @ fold, (* The last element of fold will be added in the next iteration *)
                    FoldList[fun, last, newTail]
                ]
            ]
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

lazyMapThread[fun_, lists : {partitionedLazyList[_, _]..}] := With[{
    minLen = Min[Length /@ lists[[All, 1]]]
},
    With[{
        rest = Drop[lists[[All, 1]], None, minLen],
        tails = lists[[All, 2]]
    },
        partitionedLazyList[
            MapThread[fun, Take[lists[[All, 1]], All, minLen]],
            lazyMapThread[
                fun,
                MapThread[
                    partitionedLazyList,
                    {
                        rest,
                        tails
                    }
                ]
            ]
        ]
    ]
];

lazyTranspose[lists : {partitionedLazyList[_, _]..}] := lazyMapThread[List, lists];
lazyTranspose[
    lz : partitionedLazyList[lists : {{___}..}, _]
] /; SameQ @@ (Length /@ lists) := Map[{Transpose, Listable}, lz];

lazyCatenate[lists : {___, __List, partitionedLazyList[_, _], rest___}] := 
    lazyCatenate[
        SequenceReplace[
            lists,
            {l1__List, partitionedLazyList[l2_List, tail_]} :> partitionedLazyList[Join[l1, l2], tail]
        ]
    ];
lazyCatenate[{fst__partitionedLazyList, lists__List}] := lazyCatenate[{fst, partitionedLazyList[Join[lists], lazyList[]]}];

lazyCatenate[{partitionedLazyList[list_List, tail_], rest__partitionedLazyList}] := partitionedLazyList[list, lazyCatenate[{tail, rest}]];

End[]

EndPackage[]

