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

Begin["`Private`"]
(* Implementation of the package *)

partitionedLazyList::cannotPartition = "Cannot partition lazyList `1` because not all elements are lists. Empty lazyList was returned";

Attributes[partitionedLazyList] = {HoldRest};
partitionedLazyList[] := lazyList[];
partitionedLazyList[lazyList[], ___] := lazyList[];
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

parseTakeSpec[n : (_Integer?Positive | All)] := {1, n, 1};
parseTakeSpec[{m_Integer?Positive, n_Integer?Positive}] := Append[Sort[{m, n}], 1];
parseTakeSpec[{m_Integer?Positive, All}] := {m, All, 1};
parseTakeSpec[{m_Integer?Positive, n_Integer?Positive, step_Integer}] /; step != 0 := Append[
    Sort[{m, n}],
    If[TrueQ[m <=  n], step, -step]
];
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

partitionedLazyList /: Take[lz_partitionedLazyList, {m_Integer?Positive, n_Integer?Positive, step : _Integer : 1}] /; n < m := Replace[
    Take[lz, parseTakeSpec[{m, n, step}]],
    {
        lazyList[list_List, rest_] :> lazyList[Reverse[list], rest]
    }
];

partitionedLazyList /: Take[lz_partitionedLazyList, spec_] := With[{
    parsedSpec = parseTakeSpec[spec]
},
    Take[lz, parsedSpec] /; parsedSpec =!= $Failed && parsedSpec =!= spec
];

partitionedLazyList /: Take[
    lz_partitionedLazyList,
    {start : Except[1, (_Integer?Positive)], stop : (_Integer?Positive | All), step_Integer?Positive}
] := With[{
    advancedLz = Quiet[Part[lz, {start}], {Part::partw}]
},
    If[ MatchQ[advancedLz, partitionedLazyList[_List, _]],
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
    partLz : partitionedLazyList[_List, _],
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

partitionedLazyList /: Part[partLz_partitionedLazyList, 1] := First[partLz];
partitionedLazyList /: Part[partLz : partitionedLazyList[{_, ___}, _], {1}] := partLz;
partitionedLazyList /: Part[partLz_partitionedLazyList, n_Integer?Positive] := First[Part[partLz, {n}], $Failed];

partitionedLazyList /: Part[partLz_partitionedLazyList, span_Span] := Take[partLz, List @@ span];

partitionedLazyList /: Part[partLz : partitionedLazyList[_List, _], {n : _Integer?Positive}] := Catch[
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
                    "takePartitioned"
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
                        "takePartitioned"
                    ]
                )
            },
            MaxIterations -> DirectedInfinity[1]
        ]
    ],
    "takePartitioned"
];

(* Mapping over a generator or Mapped list is the same as composition of the generator functions:*)
partitionedLazyList /: Map[
    f : Except[{_, Listable}],
    partitionedLazyList[first_, Map[fgen : Except[{_, Listable}], tail : partitionedLazyList[___]]]
] := With[{
    composition = Function[f[fgen[#]]]
},
    partitionedLazyList[
        f /@ first,
        Map[
            composition,
            tail
        ]
    ]
];
partitionedLazyList /: Map[
    {f_, Listable},
    partitionedLazyList[first_, Map[{fgen_, Listable}, tail : partitionedLazyList[___]]]
] := With[{
    composition = {Function[f[fgen[#]]], Listable}
},
    partitionedLazyList[
        f @ first,
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
partitionedLazyList /: Map[{f_, Listable}, partitionedLazyList[first_, tail_]] := partitionedLazyList[
    f[first],
    Map[{f, Listable}, tail]
];
partitionedLazyList /: Map[f_, partitionedLazyList[first_, tail_]] := partitionedLazyList[
    f /@ first,
    Map[f, tail]
];

partitionedLazyList /: MapIndexed[f_, partitionedLazyList[first_, tail_], index : (_Integer?Positive) : 1] := With[{
    length = Length[first]
},
    partitionedLazyList[
        f /@ Transpose[{first, Range[length] + index - 1}],
        MapIndexed[f, tail, index + length]
    ]
];

partitionedLazyList /: FoldList[f_, partitionedLazyList[{elem_, rest___}, tail_]] := (*Prepend[*)
    FoldList[
        f,
        elem,
        partitionedLazyList[{rest}, tail]
    ];(*,
    elem
]*)
partitionedLazyList /: FoldList[f_, current_, partitionedLazyList[first_List, tail_]] := With[{
    fold = FoldList[f, current, first]
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
                    FoldList[f, last, newTail]
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

lazyMapThread[f_, lists : {partitionedLazyList[_, _]..}] := With[{
    minLen = Min[Length /@ lists[[All, 1]]]
},
    With[{
        rest = Drop[lists[[All, 1]], None, minLen],
        tails = lists[[All, 2]]
    },
        partitionedLazyList[
            MapThread[f, Take[lists[[All, 1]], All, minLen]],
            lazyMapThread[
                f,
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

(* Default failure messages for Take and Part *)
partitionedLazyList::take = "Cannot take `1` in `2`";
partitionedLazyList /: Take[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::take, spec, Short[lz]]; lazyList[]);
partitionedLazyList::part = "Cannot take part `1` in `2`";
partitionedLazyList /: Part[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::part, spec, Short[lz]]; $Failed);

End[]

EndPackage[]

