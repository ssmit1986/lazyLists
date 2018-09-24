(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)
BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 

partitionedLazyList::usage = "Is a special wrapper for lazyLists that generate ordinary Lists.
The elements of the inner Lists are treated as if they're seperate elements of the outer lazyList, making it possible to generate elements in chunks";

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
partitionedLazyList[lazyList[list_List, tail_]] := partitionedLazyList[list, partitionedLazyList[tail]];

partitionedLazyList /: Take[lz_partitionedLazyList, {m_Integer?Positive, n_Integer?Positive}] /; n < m := Replace[
    Take[lz, {n, m}],
    {
        lazyList[list_List, rest_] :> lazyList[Reverse[list], rest]
    }
];

partitionedLazyList /: Take[lz_partitionedLazyList, {m_Integer?Positive, n : (_Integer?Positive | All)}] /; (n === All || n > m) := Replace[
    Take[lz, m],
    {
        lazyList[_, lazyList[]] :> lazyList[],
        lazyList[_, tail_] :> Take[tail, Replace[n, i_Integer :> i - m]],
        _ -> lazyList[]
    }
];

partitionedLazyList /: Take[partLz : partitionedLazyList[_List, _], n : (_Integer?Positive | All)] := lazyList @@ MapAt[
    First[#, {}]&,
    Reverse @ Reap[
        Catch[
            Block[{
                $IterationLimit = $lazyIterationLimit,
                count = n,
                length,
                pattern,
                result,
                list
            },
                pattern = If[ n === All,
                    list_List,
                    list_List?(Function[
                        (length = Length[#]) < count
                    ])
                    
                ];
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
                        partitionedLazyList[{}, tail_] :> tail,
                        partitionedLazyList[pattern, tail_] :>
                            (
                                Scan[Sow[#, "results"]&, list];
                                count -= length;
                                tail
                            ),
                        If[ n === All,
                            Nothing,
                            partitionedLazyList[l_List, tail_] :> (
                                result = TakeDrop[l, count];
                                Scan[Sow[#, "results"]&, result[[1]]];
                                Throw[
                                    partitionedLazyList[result[[2]], tail],
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
    ],
    1
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

partitionedLazyList /: Map[{f_, Listable}, partitionedLazyList[first_, tail_]] := partitionedLazyList[
    f[first],
    Map[{f, Listable}, tail]
];
partitionedLazyList /: Map[f_, partitionedLazyList[first_, tail_]] := partitionedLazyList[
    f /@ first,
    Map[f, tail]
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

lazyList /: Cases[lz_lazyList, patt_] := Module[{
    case
 },
    (* Define helper function to match patterns faster *)
    case[lazyList[first : patt, tail_]] := lazyList[first, case[tail]];
    case[lazyList[first_, tail_]] := case[tail];
    
    case[lz]
];

lazyList /: Pick[lz_lazyList, select_lazyList, patt_] := Module[{
    pick
},
    (* Define helper function, just like with Cases *)
    pick[lazyList[first_, tail1_], lazyList[match : patt, tail2_]] :=
        lazyList[first, pick[tail1, tail2]];
    pick[lazyList[first_, tail1_], lazyList[first2_, tail2_]] :=
        pick[tail1, tail2];
        
    pick[lz, select] 
];

lazyList /: Select[lazyList[first_, tail_], f_] /; f[first] := lazyList[first, Select[tail, f]];
lazyList /: Select[lazyList[first_, tail_], f_] := Select[tail, f];


(* Default failure messages for Take and Part *)
partitionedLazyList::take = "Cannot take `1` in `2`";
partitionedLazyList /: Take[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::take, spec, Short[lz]]; lazyList[]);
partitionedLazyList::part = "Cannot take part `1` in `2`";
partitionedLazyList /: Part[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::part, spec, Short[lz]]; $Failed);

End[]

EndPackage[]

