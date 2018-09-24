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

partitionedLazyList /: Prepend[partitionedLazyList[list_List, tail_], newElem_] := partitionedLazyList[Prepend[list, newElem], tail];

Scan[
    Function[
        partitionedLazyList /: #[partitionedLazyList[{}, tail_]] := #[tail]
    ],
    {First, Most, Rest}
];
partitionedLazyList /: First[partitionedLazyList[{elem_, ___}, _]] := elem;
partitionedLazyList /: Most[partitionedLazyList[list_List, _]] := list;
partitionedLazyList /: Rest[partitionedLazyList[{_}, tail_]] := tail;
partitionedLazyList /: Rest[partitionedLazyList[{_, rest__}, tail_]] := partitionedLazyList[{rest}, tail];

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
partitionedLazyList /: FoldList[f_, current_, partitionedLazyList[{}, tail_]] := FoldList[f, current, tail];
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

partitionedLazyList /: Pick[partitionedLazyList[{}, tail1_], lz2_partitionedLazyList, patt_] := Pick[tail1, lz2, patt];
partitionedLazyList /: Pick[lz1_partitionedLazyList, partitionedLazyList[{}, tail2_], patt_] := Pick[lz1, tail2, patt];
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


(* Default failure messages for Take and Part *)
partitionedLazyList::take = "Cannot take `1` in `2`";
partitionedLazyList /: Take[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::take, spec, Short[lz]]; lazyList[]);
partitionedLazyList::part = "Cannot take part `1` in `2`";
partitionedLazyList /: Part[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::part, spec, Short[lz]]; $Failed);

End[]

EndPackage[]

