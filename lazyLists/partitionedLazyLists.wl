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
partitionedLazyList[lazyList[], ___] := lazyList[];
partitionedLazyList[$Failed] := $Failed;
partitionedLazyList[l : lazyList[Except[_List], _]] := (
    Message[partitionedLazyList::cannotPartition, Short[l]];
    lazyList[]
);
partitionedLazyList[lazyList[list_List, tail_]] := partitionedLazyList[list, partitionedLazyList[tail]];

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

End[]

EndPackage[]

