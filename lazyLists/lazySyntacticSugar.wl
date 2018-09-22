(* ::Package:: *)

BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 

partWhile::usage = "";

Begin["`Private`"]

lazyList /: Rest[lazyList[_, tail_]] := tail;

(* Set threading behaviour for lazyLists to make it possible to add and multiply them and use powers on them *)
lazyList /: (op : (Plus | Times | Power | Divide | Subtract))[first___, l__lazyList, rest___] :=
    Thread[
        Unevaluated[op[first, l, rest]],
        lazyList
    ];

lazyList::illDefined = "lazyList `1` is not well-defined";
Scan[
    Function[
        lazyList /: Alternatives[Part, Take, TakeWhile, partWhile][l : #, ___] := (Message[lazyList::illDefined, Short[l]]; $Failed) 
    ],
    {lazyList[_], lazyList[_, _, __]}
];

(* Elements from lazyLists are extracted by repeatedly evaluating the next element and sowing the results *)
lazyList /: Take[l_lazyList, n_Integer?Positive] := lazyList @@ MapAt[
    First[#, {}]&,
    Reverse @ Reap[
        Replace[
            Quiet[
                Block[{$IterationLimit = $lazyIterationLimit},
                    ReplaceRepeated[
                        l,
                        {
                            lazyList[first_, tail_] :> (Sow[first, "take"]; tail)
                        },
                        MaxIterations -> n - 1
                    ]
                ],
                {ReplaceRepeated::rrlim}
            ],
            (* The last element should only be Sown without evaluating the tail *)
            lazyList[first_, tail_] :> (Sow[first, "take"]; lazyList[first, tail]) 
        ],
        "take"
    ],
    1
];

lazyList /: Take[l_lazyList, {m_Integer?Positive, n_Integer?Positive}] /; n < m := Replace[
    Take[l, {n, m}],
    {
        lazyList[list_List, rest_] :> lazyList[Reverse[list], rest]
    }
];

lazyList /: Take[l_lazyList, {m_Integer?Positive, n_Integer?Positive}] /; n > m := Replace[
    Quiet[l[[{m}]], {Part::partw}],
    {
        lz : lazyList[_, _] :> Take[lz, n - m + 1],
        _ -> lazyList[]
    }
];

lazyList /: TakeWhile[l_lazyList, function : _ : Function[True], opts : OptionsPattern[MaxIterations -> Infinity]] := lazyList @@ MapAt[
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
                        l,
                        {
                            lazyList[pattern, tail_] :> (Sow[first, "take"]; tail),
                            other_ :> Throw[other, "break"]
                        },
                        MaxIterations -> OptionValue[MaxIterations]
                    ]
                ],
                "break"
            ],
            {ReplaceRepeated::rrlim}
        ],
        "take"
    ],
    1
];

lazyList /: partWhile[l_lazyList, function : _ : Function[True], opts : OptionsPattern[MaxIterations -> Infinity]] := Quiet[
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
                {l, First[l]},
                {
                    {lazyList[pattern, tail_], prev_} :> {tail, first},
                    {other_, prev_} :> Throw[lazyList[prev, other], "break"]
                },
                MaxIterations -> OptionValue[MaxIterations]
            ]
        ],
        "break"
    ],
    {ReplaceRepeated::rrlim}
];

lazyList /: Part[l : lazyList[], i_] := (Message[Part::partw, Short[i], Short[l]]; $Failed);
lazyList /: Part[lazyList[___], 0 | {0}] := lazyList;
lazyList /: Part[lazyList[first_, _], 1] := first;
lazyList /: Part[l : lazyList[_, _], {1}] := l;
lazyList /: Part[l : lazyList[_, _], {-1}] := partWhile[l, Function[True]];
lazyList /: Part[l_lazyList, n_Integer] := First[Part[l, {n}], $Failed];

lazyList /: Part[l_lazyList, Span[m_Integer, n_Integer]] := Replace[
    Take[l, {m, n}],
    {
        lazyList[] | lazyList[_, lazyList[]] :> (Message[Part::partw, Max[m, n], Short[l]]; $Failed)
    }
];

lazyList /: Part[l_lazyList, Span[m_Integer, n_Integer, incr_Integer]] := Part[
    l,
    Range[m, n, incr]
];

lazyList /: Part[l_lazyList, indices : {_Integer, __Integer}] := Catch[
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
                    l,
                    Prepend[Differences[sortedIndices] + 1, First[sortedIndices]]
                ],
                Ordering[indices]
            ],
            Evaluate[eval]
        ]
    ],
    "part"
];

lazyList /: Part[l_lazyList, {n_Integer}] := Replace[
    Quiet[
        Block[{$IterationLimit = $lazyIterationLimit},
            ReplaceRepeated[
                l,
                {
                    lazyList[first_, tail_] :> tail
                },
                MaxIterations -> n - 1
            ]
        ],
        {ReplaceRepeated::rrlim}
    ],
    {
        lazyList[] :> (Message[Part::partw, n, Short[l]]; $Failed)
    }
];

With[{
    patt = Append[generatorPattern, Map]
},
    (* Mapping over a generator or Mapped list is the same as composition of the generator functions: *)
    lazyList /: Map[f_, lazyList[first_, (gen : patt)[fgen_, args___]]] := With[{
        composition = f @* fgen (* Evaluate the composition to flatten it out if necessary *)
    },
        lazyList[
            f[first],
            gen[
                composition,
                args
            ]
        ]
    ]
];

lazyList /: Map[f_, lazyList[first_, tail_]] := lazyList[
    f[first],
    Map[f, tail]
];

lazySetState[l : lazyList[_, Map[f_, tail_]], state_] := With[{
    try = Check[lazySetState[tail, state], $Failed]
},
    Map[f, try] /; MatchQ[try, lazyList[_, _]]
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

lazyList /: Cases[l_lazyList, patt_] := Module[{
    case
 },
    (* Define helper function to match patterns faster *)
    case[lazyList[first : patt, tail_]] := lazyList[first, case[tail]];
    case[lazyList[first_, tail_]] := case[tail];
    
    case[l]
];

lazyList /: Pick[l_lazyList, select_lazyList, patt_] := Module[{
    pick
},
    (* Define helper function, just like with Cases *)
    pick[lazyList[first_, tail1_], lazyList[match : patt, tail2_]] :=
        lazyList[first, pick[tail1, tail2]];
    pick[lazyList[first_, tail1_], lazyList[first2_, tail2_]] :=
        pick[tail1, tail2];
        
    pick[l, select] 
];

lazyList /: Select[lazyList[first_, tail_], f_] /; f[first] := lazyList[first, Select[tail, f]];
lazyList /: Select[lazyList[first_, tail_], f_] := Select[tail, f];

End[]

EndPackage[]

