(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 18-Sep-2018 *)
BeginPackage["lazyLists`"]
(* Exported symbols added here with SymbolName::usage *) 

Begin["`Private`"]
(* Implementation of the package *)

twoSidedGenerator[___] := lazyList[];
leftSidedGenerator[___] := lazyList[];
rightSidedGenerator[___] := lazyList[];
finiteGenerator[___] := lazyList[];


lazySetState::notSupported = "lazySetState is not supported for lazyList `1`";
lazySetState[l_lazyList, _] := (Message[lazySetState::notSupported, Short[l]]; l)


lazyList::notFinite = "lazyList `1` cannot be recognised as a finite list";
lazyFinitePart[lz : lzPattern, _] := (Message[lazyList::notFinite, Short[lz]]; $Failed);
lazyFiniteTake[lz : lzPattern, _] := (Message[lazyList::notFinite, Short[lz]]; $Failed);


lazyCatenate::invrp = "Argument `1` is not a valid list or lazyList";
lazyCatenate[{___, arg : Except[_List | lzPattern | heldListPattern], ___}]  := (Message[lazyCatenate::invrp, Short[arg]]; $Failed);
lazyCatenate[lazyList[arg : Except[_List | _lazyList], _]] := (Message[lazyCatenate::invrp, Short[arg]]; $Failed);

lazyTruncate::int = "Argument `1` should be a positive integer";
lazyTruncate[arg : Except[lzPattern], _] := (Message[lazyTruncate::invrp, Short[arg]]; $Failed);
lazyTruncate[_, i : Except[_Integer?Positive]] := (Message[lazyTruncate::int, Short[i]]; $Failed);

(* Default failure messages for Take and Part *)

Scan[
    Function[{
        head
    },
        head::illDefined = "lazyList `1` is not well-defined";
        Scan[
            Function[
                head /: Alternatives[Part, Take, TakeWhile, LengthWhile][lz : #, ___] :=
                    (Message[head::illDefined, Short[lz]]; $Failed) 
            ],
            {head[_], head[_, _, __]}
        ]
    ],
    {lazyList, partitionedLazyList}
];


lazyList::take = "Cannot take `1` in `2`";
lazyList /: Take[lz_lazyList, spec_, ___] := (Message[lazyList::take, spec, Short[lz]]; lazyList[]);
lazyList::part = "Cannot take part `1` in `2`";
lazyList /: Part[lz_lazyList, spec_, ___] := (Message[lazyList::part, spec, Short[lz]]; $Failed);

partitionedLazyList::take = "Cannot take `1` in `2`";
partitionedLazyList /: Take[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::take, spec, Short[lz]]; lazyList[]);
partitionedLazyList::part = "Cannot take part `1` in `2`";
partitionedLazyList /: Part[lz_partitionedLazyList, spec_, ___] := (Message[lazyList::part, spec, Short[lz]]; $Failed);

lazyMapThread[___] := lazyList[];

End[]

EndPackage[]

