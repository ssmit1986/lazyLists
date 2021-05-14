BeginTestSection["VerificationTests3"]

BeginTestSection["Initialisation"]

VerificationTest[
    $HistoryLength = 10; With[{
            dir =
                ParentDirectory[
                    If[Quiet[TrueQ[FileExistsQ[$TestFileName]]],
                        DirectoryName[$TestFileName]
                        ,
                        NotebookDirectory[]
                    ]
                ]
        },
        PacletDirectoryLoad[dir]
]; Quiet[Get["lazyLists`"]]; ClearAll["Global`*"]; "Done"
    ,
    "Done"
    ,
    TestID -> "429d6b44-7f18-408a-a11b-af3070fbdc57"
]

EndTestSection[]

BeginTestSection["lazyListable"]

VerificationTest[
    First[Take[lazyRange[] + lazyRange[2], 5]]
    ,
    {3, 5, 7, 9, 11}
    ,
    TestID -> "10ffdd73-035c-4ba5-a271-64a4e1bf04b9"
]

VerificationTest[
    First[Take[2 * lazyRange[] + 3 * lazyRange[1, Infinity, 2], 5]]
    ,
    {5, 13, 21, 29, 37}
    ,
    TestID -> "d7ff3a30-f6b5-4d8a-9ab2-ff7f8ed70d73"
]

VerificationTest[
    First[Take[lazyRange[]^lazyRange[], 5]]
    ,
    {1, 4, 27, 256, 3125}
    ,
    TestID -> "cb32bc98-d965-431f-9f96-3ada1f100757"
]

VerificationTest[
    First[Take[1 / lazyRange[2, Infinity, 2], 5]]
    ,
    {1 / 2, 1 / 4, 1 / 6, 1 / 8, 1 / 10}
    ,
    TestID -> "88f9cdf0-0340-44dd-9935-af0cfe6259f5"
]

VerificationTest[
    setLazyListable[listableSymbol]
    ,
    listableSymbol
    ,
    TestID -> "160be7e3-bf2c-448e-91f6-7bbd9a33e714"
]

VerificationTest[
    First[Take[listableSymbol[lazyRange[], lazyRange[2], 5], 5]]
    ,
    {listableSymbol[1, 2, 5], listableSymbol[2, 3, 5], listableSymbol[3, 
        4, 5], listableSymbol[4, 5, 5], listableSymbol[5, 6, 5]}
    ,
    TestID -> "c7310b38-f3a8-455d-920e-531b0051796e"
]

VerificationTest[
    SetAttributes[listableSymbol, {Listable}]; listableSymbol[lazyRange[],
         lazyRange[2], 5, {1, 2}]
    ,
    {lazyList[listableSymbol[1, 2, 5, 1], listableSymbol[___]], lazyList[
        listableSymbol[1, 2, 5, 2], listableSymbol[___]]}
    ,
    TestID -> "56038233-6e7c-403b-bd23-ff528dab83bf"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    First[Take[lazyRange[] + lazyRange[], 20]]
    ,
    {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 
        38, 40}
    ,
    TestID -> "b303f0b8-31df-472b-bf50-f5eef1970d6a"
]

VerificationTest[
    Most[Take[partitionedLazyRange[10] + partitionedLazyRange[10], 20]]
    ,
    {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 
        38, 40}
    ,
    TestID -> "04ed330a-9048-4c6e-a7c6-b627ec4bb963"
]

VerificationTest[
    Most[Take[partitionedLazyRange[10] + partitionedLazyRange[3], 20]]
    ,
    {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 
        38, 40}
    ,
    TestID -> "97bb9fa9-efb3-4ee3-b236-66389f58bee3"
]

VerificationTest[
    Most[Take[partitionedLazyRange[10] + lazyRange[], 20]]
    ,
    {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 
        38, 40}
    ,
    TestID -> "0dab5eee-6788-4214-a369-18836d19f10a"
]

VerificationTest[
    Most[Take[a * partitionedLazyList[lazyGenerator[Range, 1, 1]] + b / partitionedLazyList[
        lazyGenerator[Range, 2, 2]], 5]]
    ,
    {a + b, a + b / 2, 2 * a + b, a + b / 2, 2 * a + b / 3}
    ,
    TestID -> "c11cacfe-c700-4812-8a51-95a151ee3eaf"
]

VerificationTest[
    Most[partitionedLazyRange[3] + partitionedLazyRange[5] + partitionedLazyRange[
        6]]
    ,
    {3, 6, 9, 12, 15, 18}
    ,
    TestID -> "b19f5a9c-bda9-4c9e-9d66-abbe90d7064d"
]

VerificationTest[
    setLazyListable[{Sin, Listable}]
    ,
    Sin
    ,
    TestID -> "33e34634-2c70-48c3-867d-7d1129c95903"
]

VerificationTest[
    Most[Sin[partitionedLazyRange[10]]]
    ,
    {Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[
        9], Sin[10]}
    ,
    TestID -> "1cc79346-5d1d-4988-b0ce-81b7ae7f4be7"
]

EndTestSection[]

BeginTestSection["Map"]

VerificationTest[
    Reap[Most[Take[(Sqrt[Sow[#1]]&) /@ partitionedLazyRange[3], 4]]]
    ,
    {{1, Sqrt[2], Sqrt[3], 2}, {{1, 2, 3, 4, 5, 6}}}
    ,
    TestID -> "6440fb8d-a118-491f-88fd-43fd54af5daf"
]

VerificationTest[
    Reap[Most[Take[{Sqrt[Sow[#1]]&, Listable} /@ partitionedLazyRange[3],
         4]]]
    ,
    {{1, Sqrt[2], Sqrt[3], 2}, {{{1, 2, 3}, {4, 5, 6}}}}
    ,
    TestID -> "aff39ed4-8213-41e6-8228-aeceabbf621c"
]

VerificationTest[
    Sqrt /@ lazyRange[0, Infinity, 2]
    ,
    lazyList[0, Sqrt /@ _]
    ,
    TestID -> "c6d789ea-cab2-47f5-b533-b8d08cbea2f1"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    First[Take[Sqrt /@ lazyRange[0, Infinity, 2], 5]]
    ,
    {0, Sqrt[2], 2, Sqrt[6], 2 * Sqrt[2]}
    ,
    TestID -> "8e897f69-0991-43b0-a47e-33c4c2ad2605"
]

VerificationTest[
    Cos /@ Sin /@ Exp /@ lazyRange[]
    ,
    lazyList[Cos[Sin[E]], Cos /@ Sin /@ Exp /@ _]
    ,
    TestID -> "fb24aab4-c206-439c-9a7b-3f300593d086"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    composeMappedFunctions[Cos /@ Sin /@ Exp /@ lazyRange[]]
    ,
    lazyList[Cos[Sin[E]], Cos @* Sin @* Exp /@ _]
    ,
    TestID -> "66f1eb1f-2b16-4e07-8261-69e9233b6d4f"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    Cos /@ Exp /@ lazyGenerator[Sin]
    ,
    lazyList[Cos[E^Sin[1]], Cos /@ Exp /@ lazyLists`Private`twoSidedGenerator[
        Sin, 1 + 1, 1]]
    ,
    TestID -> "f152549d-6a7c-4270-a618-b0ee9d3c21a9"
]

VerificationTest[
    composeMappedFunctions[Cos /@ Exp /@ lazyGenerator[Sin]]
    ,
    lazyList[Cos[E^Sin[1]], lazyLists`Private`twoSidedGenerator[Cos @* Exp
         @* Sin, 1 + 1, 1]]
    ,
    TestID -> "cd24d0b2-3f35-4442-8db5-122d8b62a9fa"
]

VerificationTest[
    Most[Take[f /@ g /@ partitionedLazyRange[5], 10]]
    ,
    {f[g[1]], f[g[2]], f[g[3]], f[g[4]], f[g[5]], f[g[6]], f[g[7]], f[g[8
        ]], f[g[9]], f[g[10]]}
    ,
    TestID -> "a5450e1b-fb2c-44eb-8b13-ade880632dd7"
]

VerificationTest[
    MatchQ[composeMappedFunctions[f /@ g /@ partitionedLazyRange[5]], partitionedLazyList[
        {f[g[1]], f[g[2]], f[g[3]], f[g[4]], f[g[5]]}, (f[g[#1]]&) /@ _]]
    ,
    True
    ,
    TestID -> "476f6f8e-0110-4a8e-b2bd-81017fb9ea17"
]

VerificationTest[
    Most[Take[composeMappedFunctions[f /@ g /@ partitionedLazyRange[5]], 
        10]]
    ,
    {f[g[1]], f[g[2]], f[g[3]], f[g[4]], f[g[5]], f[g[6]], f[g[7]], f[g[8
        ]], f[g[9]], f[g[10]]}
    ,
    TestID -> "97e07718-e310-4d36-8af1-187f48e2fc4b"
]

VerificationTest[
    Most[Take[f /@ {Exp, Listable} /@ partitionedLazyRange[5], 10]]
    ,
    {f[E], f[E^2], f[E^3], f[E^4], f[E^5], f[E^6], f[E^7], f[E^8], f[E^9],
         f[E^10]}
    ,
    TestID -> "13563dea-b677-4304-9187-2d1566ecc789"
]

VerificationTest[
    MatchQ[composeMappedFunctions[f /@ {Exp, Listable} /@ partitionedLazyRange[
        5]], partitionedLazyList[{f[E], f[E^2], f[E^3], f[E^4], f[E^5]}, {f /@
         Exp[#1]&, Listable} /@ _]]
    ,
    True
    ,
    TestID -> "933709fd-737f-4c46-9d86-9b35f41696a2"
]

VerificationTest[
    Most[Take[{Exp, Listable} /@ f /@ partitionedLazyRange[5], 10]]
    ,
    {E^f[1], E^f[2], E^f[3], E^f[4], E^f[5], E^f[6], E^f[7], E^f[8], E^f[
        9], E^f[10]}
    ,
    TestID -> "8b28ed93-5599-4b12-b84d-bd37d052ecea"
]

VerificationTest[
    MatchQ[composeMappedFunctions[{Exp, Listable} /@ f /@ partitionedLazyRange[
        5]], partitionedLazyList[{E^f[1], E^f[2], E^f[3], E^f[4], E^f[5]}, {Exp[
        f /@ #1]&, Listable} /@ _]]
    ,
    True
    ,
    TestID -> "6f341dd2-f2d3-41b5-a19e-e8565a0603be"
]

VerificationTest[
    Most[Take[{Cos, Listable} /@ {Exp, Listable} /@ partitionedLazyRange[
        5], 10]]
    ,
    {Cos[E], Cos[E^2], Cos[E^3], Cos[E^4], Cos[E^5], Cos[E^6], Cos[E^7], 
        Cos[E^8], Cos[E^9], Cos[E^10]}
    ,
    TestID -> "4e2acbd3-503b-4447-a034-2730b0328cb1"
]

VerificationTest[
    MatchQ[composeMappedFunctions[{Cos, Listable} /@ {Exp, Listable} /@ partitionedLazyRange[
        5]], partitionedLazyList[{Cos[E], Cos[E^2], Cos[E^3], Cos[E^4], Cos[E
        ^5]}, {Cos[Exp[#1]]&, Listable} /@ _]]
    ,
    True
    ,
    TestID -> "5d044afc-f4b7-4dfc-8614-388fa9ae2138"
]

VerificationTest[
    Take[{someFunction, Listable} /@ partitionedLazyRange[3], 4]
    ,
    lazyList[]
    ,
    {lazyList::take}
    ,
    TestID -> "e590682e-ebf3-47af-b876-76df923fbbb8"
]

VerificationTest[
    First[Take[MapIndexed[{#1, #2}&, lazyRange[2, Infinity, 2]], 10]]
    ,
    {{2, 1}, {4, 2}, {6, 3}, {8, 4}, {10, 5}, {12, 6}, {14, 7}, {16, 8}, 
        {18, 9}, {20, 10}}
    ,
    TestID -> "c92d00e7-e6d1-47aa-a5f1-df872503201e"
]

VerificationTest[
    Most[Take[MapIndexed[{#1, #2}&, partitionedLazyRange[10, Infinity, 2,
         5]], 20]]
    ,
    {{10, 1}, {12, 2}, {14, 3}, {16, 4}, {18, 5}, {20, 6}, {22, 7}, {24, 
        8}, {26, 9}, {28, 10}, {30, 11}, {32, 12}, {34, 13}, {36, 14}, {38, 15
        }, {40, 16}, {42, 17}, {44, 18}, {46, 19}, {48, 20}}
    ,
    TestID -> "940191b2-9c52-43c6-80e9-ca109bcf4440"
]

VerificationTest[
    First[Take[MapIndexed[{#1, #2}&, lazyRange[2, Infinity, 2]], 5]]
    ,
    {{2, 1}, {4, 2}, {6, 3}, {8, 4}, {10, 5}}
    ,
    TestID -> "755a2a31-5e94-41a8-b2bc-a72cb672099b"
]

VerificationTest[
    First[Take[MapIndexed[{#1, #2}&, lazyRange[], 20], 5]]
    ,
    {{1, 20}, {2, 21}, {3, 22}, {4, 23}, {5, 24}}
    ,
    TestID -> "e7f47333-553c-4f61-bf2b-454329529868"
]

VerificationTest[
    First[Take[lazySetState[f /@ lazyRange[], 20], 5]]
    ,
    {f[20], f[21], f[22], f[23], f[24]}
    ,
    TestID -> "0d6c8aaf-3971-4513-b6b5-c7a976370960"
]

VerificationTest[
    lst = Range[10]; lazySetState[f /@ lazyList[Hold[lst]], 5]
    ,
    lazyList[f[5], f /@ lazyLists`Private`lazyFiniteList[lst, 5 + 1]]
    ,
    TestID -> "031e4dc8-5c16-47a2-9fc3-07410474c6bd"
]

VerificationTest[
    lazySetState[f /@ lazyList[Hold[lst]], 20]
    ,
    lazyList[f[1], f /@ lazyLists`Private`lazyFiniteList[lst, 1 + 1]]
    ,
    {Part::partw}
    ,
    TestID -> "8bc09958-c00d-4608-a327-fb972e14312e"
]

EndTestSection[]

BeginTestSection["Fold"]

VerificationTest[
    FoldList[Plus, x0, lazyRange[n, Infinity, m]]
    ,
    lazyList[x0, FoldList[Plus, x0 + n, _]]
    ,
    TestID -> "78ede253-0641-40d1-91a6-ada7c363db06"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    First[Take[FoldList[Plus, x0, lazyRange[n, Infinity, m]], 5]]
    ,
    {x0, n + x0, m + 2 * n + x0, 3 * m + 3 * n + x0, 6 * m + 4 * n + x0}
    ,
    TestID -> "db188c97-bab5-4d20-9c9c-d317201c07d3"
]

VerificationTest[
    First[
        Take[
            FoldList[
                If[#2 < 15,
                    Nothing
                    ,
                    #2
                ]&
                ,
                Nothing
                ,
                lazyRange[10]
            ]
            ,
            20
        ]
]
    ,
    {15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 
        32, 33, 34}
    ,
    TestID -> "4f3d6397-e664-44d8-a0cf-3e752dc62c3c"
]

VerificationTest[
    Most[
        Take[
            FoldList[
                If[#2 < 15,
                    Nothing
                    ,
                    #2
                ]&
                ,
                Nothing
                ,
                partitionedLazyRange[10]
            ]
            ,
            20
        ]
]
    ,
    {15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 
        32, 33, 34}
    ,
    TestID -> "40919827-ae18-4769-8793-82574d5ca24b"
]

VerificationTest[
    First[Take[FoldPairList[{p[#1, #2], q[#1, #2]}&, u, lazyRange[]], 6]]
    ,
    {p[u, 1], p[q[u, 1], 2], p[q[q[u, 1], 2], 3], p[q[q[q[u, 1], 2], 3], 
        4], p[q[q[q[q[u, 1], 2], 3], 4], 5], p[q[q[q[q[q[u, 1], 2], 3], 4], 5
        ], 6]}
    ,
    TestID -> "22e0751b-1a8b-4c64-ab0d-7d245c004db7"
]

VerificationTest[
    Most[Take[FoldPairList[{p[#1, #2], q[#1, #2]}&, u, partitionedLazyRange[
        3]], 6]]
    ,
    {p[u, 1], p[q[u, 1], 2], p[q[q[u, 1], 2], 3], p[q[q[q[u, 1], 2], 3], 
        4], p[q[q[q[q[u, 1], 2], 3], 4], 5], p[q[q[q[q[q[u, 1], 2], 3], 4], 5
        ], 6]}
    ,
    TestID -> "3991fc43-240c-4484-b447-79575b7081c3"
]

VerificationTest[
    FoldPairList[TakeDrop, lazyRange[], {2, 3, 6, 10}]
    ,
    {{1, 2}, {3, 4, 5}, {6, 7, 8, 9, 10, 11}, {12, 13, 14, 15, 16, 17, 18,
         19, 20, 21}}
    ,
    TestID -> "a66185cd-0733-4052-863c-2a7522eea654"
]

VerificationTest[
    FoldPairList[TakeDrop, partitionedLazyRange[10], {2, 3, 6, 10}]
    ,
    {{1, 2}, {3, 4, 5}, {6, 7, 8, 9, 10, 11}, {12, 13, 14, 15, 16, 17, 18,
         19, 20, 21}}
    ,
    TestID -> "ccd1e34b-4c67-499f-9528-b5716c21f95d"
]

VerificationTest[
    Most[Take[FoldPairList[TakeDrop, lazyRange[], lazyRange[]], 10]]
    ,
    {{{1}, {2, 3}, {4, 5, 6}, {7, 8, 9, 10}, {11, 12, 13, 14, 15}, {16, 17,
         18, 19, 20, 21}, {22, 23, 24, 25, 26, 27, 28}, {29, 30, 31, 32, 33, 
        34, 35, 36}, {37, 38, 39, 40, 41, 42, 43, 44, 45}, {46, 47, 48, 49, 50,
         51, 52, 53, 54, 55}}}
    ,
    TestID -> "4dc80dfa-8008-44cc-aac8-6cf0c9fb94bf"
]

VerificationTest[
    Most[Take[FoldPairList[TakeDrop, partitionedLazyRange[10], partitionedLazyRange[
        10]], 10]]
    ,
    {{1}, {2, 3}, {4, 5, 6}, {7, 8, 9, 10}, {11, 12, 13, 14, 15}, {16, 17,
         18, 19, 20, 21}, {22, 23, 24, 25, 26, 27, 28}, {29, 30, 31, 32, 33, 
        34, 35, 36}, {37, 38, 39, 40, 41, 42, 43, 44, 45}, {46, 47, 48, 49, 50,
         51, 52, 53, 54, 55}}
    ,
    TestID -> "e65bea94-a585-402f-9550-59754f63bad2"
]

EndTestSection[]

BeginTestSection["Cases, Pick, Select"]

VerificationTest[
    MatchQ[Cases[lazyRange[0, Infinity, 2 / 3], _Integer], lazyList[0, _]
        ]
    ,
    True
    ,
    TestID -> "eef58711-9a2b-4adf-bb35-fd6ddc3b49a1"
]

VerificationTest[
    First[Take[Cases[lazyRange[0, Infinity, 2 / 3], _Integer], 5]]
    ,
    {0, 2, 4, 6, 8}
    ,
    TestID -> "1c11a617-94ea-42b9-bf57-ccb346d33046"
]

VerificationTest[
    MatchQ[Pick[lazyRange[0, Infinity, 2], lazyRange[0, Infinity, 2 / 3],
         _Integer], lazyList[0, _]]
    ,
    True
    ,
    TestID -> "df1ac686-6c55-4310-b8be-df2063f48b70"
]

VerificationTest[
    First[Take[Pick[lazyRange[0, Infinity, 2], lazyRange[0, Infinity, 2 /
         3], _Integer], 5]]
    ,
    {0, 6, 12, 18, 24}
    ,
    TestID -> "232b3f69-ae25-4cc2-9e08-7fc39008ebff"
]

VerificationTest[
    Select[lazyRange[], OddQ]
    ,
    lazyList[1, Select[_, OddQ]]
    ,
    TestID -> "8d8036f1-5720-4811-8629-7c25ce67842b"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    First[Take[Select[lazyRange[], OddQ], 5]]
    ,
    {1, 3, 5, 7, 9}
    ,
    TestID -> "2ff4ea71-a191-4c9f-9760-83fb52d4606d"
]

EndTestSection[]

BeginTestSection["lazyMapThread, lazyTranspose"]

VerificationTest[
    First[Take[lazyMapThread[f, {lazyRange[], lazyRange[2, Infinity, 2]}],
         5]]
    ,
    {f[1, 2], f[2, 4], f[3, 6], f[4, 8], f[5, 10]}
    ,
    TestID -> "713e38e1-53ae-455a-bbf8-0bbc02d45524"
]

VerificationTest[
    MapThread[f, {Range[5], 2 * Range[5]}]
    ,
    {f[1, 2], f[2, 4], f[3, 6], f[4, 8], f[5, 10]}
    ,
    TestID -> "04ba0346-ff2e-4659-8597-53624df2a10d"
]

VerificationTest[
    First[Take[lazyMapThread[f, {lazyRange[], Range[5]}], All]]
    ,
    {f[1, 1], f[2, 2], f[3, 3], f[4, 4], f[5, 5]}
    ,
    TestID -> "32188d20-9d34-4122-bf92-06bb3cf26702"
]

VerificationTest[
    Most[Take[lazyMapThread[f, {partitionedLazyList[Range /@ lazyRange[]],
         partitionedLazyRange[4], partitionedLazyRange[2, Infinity, 2, 6]}], 
        10]]
    ,
    {f[1, 1, 2], f[1, 2, 4], f[2, 3, 6], f[1, 4, 8], f[2, 5, 10], f[3, 6,
         12], f[1, 7, 14], f[2, 8, 16], f[3, 9, 18], f[4, 10, 20]}
    ,
    TestID -> "1da06e68-9eab-497a-92fa-298cc059d2a2"
]

VerificationTest[
    lazyMapThread[f, {partitionedLazyRange[3], lazyRange[]}]
    ,
    partitionedLazyList[{f[1, 1], f[2, 2], f[3, 3]}, lazyMapThread[f, _]]
    ,
    TestID -> "afa9dc39-c825-4926-a453-fdf3dc86c42d"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    First[Take[lazyTranspose[{lazyRange[], lazyRange[start]}], 5]]
    ,
    {{1, start}, {2, 1 + start}, {3, 2 + start}, {4, 3 + start}, {5, 4 + 
        start}}
    ,
    TestID -> "6f32f0a8-9388-4926-998a-161b2cdd31a4"
]

VerificationTest[
    First[Take[lazyMapThread[List, {lazyRange[], lazyRange[start]}], 5]]
    ,
    {{1, start}, {2, 1 + start}, {3, 2 + start}, {4, 3 + start}, {5, 4 + 
        start}}
    ,
    TestID -> "6d546c3e-83bb-4b12-832a-cc468addc674"
]

EndTestSection[]

BeginTestSection["lazyCatenate"]

VerificationTest[
    lazyCatenate[{{1, 2}}]
    ,
    lazyList[1, lazyList[{2}]]
    ,
    TestID -> "d44e1a68-eed8-4007-8121-b5732cbc3f46"
]

VerificationTest[
    lazyCatenate[{lazyRange[]}]
    ,
    lazyRange[]
    ,
    TestID -> "5a71142c-3026-4188-bf98-8c2241e3e39e"
]

VerificationTest[
    lazyCatenate[{partitionedLazyRange[5]}]
    ,
    partitionedLazyRange[5]
    ,
    TestID -> "503585d1-e1e3-4211-9795-8c4c977a7c4d"
]

VerificationTest[
    lazyCatenate[{{1, 2}, {2, 3, 4}}]
    ,
    lazyList[1, lazyList[{2, 2, 3, 4}]]
    ,
    TestID -> "b2868662-c220-4ca5-9934-cf1408f55c4c"
]

VerificationTest[
    First[Take[lazyCatenate[{{1, 2}, {2, 3, 4}}], All]]
    ,
    {1, 2, 2, 3, 4}
    ,
    TestID -> "26cc958a-8c1c-46fb-8da0-897ff4d162d5"
]

VerificationTest[
    First[Take[lazyCatenate[{lazyGenerator[f, 1, 1, 5], lazyGenerator[g, 
        1, 1, 5]}], All]]
    ,
    {f[1], f[2], f[3], f[4], f[5], g[1], g[2], g[3], g[4], g[5]}
    ,
    TestID -> "23dbb7e0-0165-415b-873b-c8ea5d62ef15"
]

VerificationTest[
    First[Take[lazyCatenate[lazyGenerator[Range, 1, 1, 5]], All]]
    ,
    {1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5}
    ,
    TestID -> "6b951aba-15c0-4b1d-942a-9a5eb2395281"
]

VerificationTest[
    First[Take[lazyCatenate[lazyGenerator[lazyGenerator[Subscript[f, #1],
         #1, #1, #1 + 3]&, 1, 1, 5]], All]]
    ,
    {Subscript[f, 1][1], Subscript[f, 1][2], Subscript[f, 1][3], Subscript[
        f, 1][4], Subscript[f, 2][2], Subscript[f, 2][3], Subscript[f, 2][4],
         Subscript[f, 2][5], Subscript[f, 3][3], Subscript[f, 3][4], Subscript[
        f, 3][5], Subscript[f, 3][6], Subscript[f, 4][4], Subscript[f, 4][5],
         Subscript[f, 4][6], Subscript[f, 4][7], Subscript[f, 5][5], Subscript[
        f, 5][6], Subscript[f, 5][7], Subscript[f, 5][8]}
    ,
    TestID -> "5a550561-3bb0-4958-ae50-af45c4caf47c"
]

EndTestSection[]

BeginTestSection["endOfLazyList"]

VerificationTest[
    lazyList[endOfLazyList, "stuff"]
    ,
    lazyList[]
    ,
    TestID -> "9dc7e6eb-3363-4834-a585-2c2a9296a68d"
]

VerificationTest[
    lazyList[endOfLazyList, lazyRange[]]
    ,
    lazyList[]
    ,
    TestID -> "4f792f28-e364-415a-b4ef-4bcfc98a7be5"
]

VerificationTest[
    partitionedLazyList[{1, 2, 3, endOfLazyList, otherStuff}, anyTail]
    ,
    partitionedLazyList[{1, 2, 3}, lazyList[]]
    ,
    TestID -> "94817bc0-0d2d-4936-a5db-71739d8c11d6"
]

VerificationTest[
    Take[f /@ partitionedLazyList[{1, 2, 3}, partitionedLazyList[{4, 5, 6,
         endOfLazyList, Sequence @@ Range[10]}, partitionedLazyRange[5]]], 20
        ]
    ,
    partitionedLazyList[{f[1], f[2], f[3], f[4], f[5], f[6]}, lazyList[]]
    ,
    TestID -> "ed006187-1cdf-429c-bf81-1372cb1c21b2"
]

VerificationTest[
    Take[g /@ f /@ partitionedLazyList[{1, 2, 3}, partitionedLazyList[{4,
         5, 6, endOfLazyList, Sequence @@ Range[10]}, partitionedLazyRange[5]
        ]], 20]
    ,
    partitionedLazyList[{g[f[1]], g[f[2]], g[f[3]], g[f[4]], g[f[5]], g[f[
        6]]}, lazyList[]]
    ,
    TestID -> "570c9489-e01d-4aa5-aa36-9409385fa8bf"
]

VerificationTest[
    Take[g /@ {Sin, Listable} /@ partitionedLazyList[{1, 2, 3}, partitionedLazyList[
        {4, 5, 6, endOfLazyList, Sequence @@ Range[10]}, partitionedLazyRange[
        5]]], 20]
    ,
    partitionedLazyList[{g[Sin[1]], g[Sin[2]], g[Sin[3]], g[Sin[4]], g[Sin[
        5]], g[Sin[6]]}, lazyList[]]
    ,
    TestID -> "a82e8b8e-e760-4b09-8799-a58114510cc3"
]

VerificationTest[
    Take[{Sqrt, Listable} /@ {Sin, Listable} /@ partitionedLazyList[{1, 2,
         3}, partitionedLazyList[{4, 5, 6, endOfLazyList, Sequence @@ Range[10
        ]}, partitionedLazyRange[5]]], 20]
    ,
    partitionedLazyList[{Sqrt[Sin[1]], Sqrt[Sin[2]], Sqrt[Sin[3]], Sqrt[Sin[
        4]], Sqrt[Sin[5]], Sqrt[Sin[6]]}, lazyList[]]
    ,
    TestID -> "7f54badb-04eb-4387-839f-c61a96a88f32"
]

VerificationTest[
    Take[{Sqrt, Listable} /@ f /@ partitionedLazyList[{1, 2, 3}, partitionedLazyList[
        {4, 5, 6, endOfLazyList, Sequence @@ Range[10]}, partitionedLazyRange[
        5]]], 20]
    ,
    partitionedLazyList[{Sqrt[f[1]], Sqrt[f[2]], Sqrt[f[3]], Sqrt[f[4]], 
        Sqrt[f[5]], Sqrt[f[6]]}, lazyList[]]
    ,
    TestID -> "081a33cc-6d46-4a5d-9e20-4f80c8af8f5c"
]

VerificationTest[
    Take[
        Sin /@
            (
                If[#1 > 10,
                    endOfLazyList
                    ,
                    #1
                ]&
            ) /@ lazyRange[]
        ,
        20
]
    ,
    lazyList[{Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[
        8], Sin[9], Sin[10]}, lazyList[]]
    ,
    TestID -> "d45fb48f-f591-4dc9-8f64-ddaa030a3ebd"
]

VerificationTest[
    Take[
        Sin /@
            (
                If[#1 > 10,
                    endOfLazyList
                    ,
                    #1
                ]&
            ) /@ partitionedLazyRange[5]
        ,
        20
]
    ,
    partitionedLazyList[{Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], 
        Sin[7], Sin[8], Sin[9], Sin[10]}, lazyList[]]
    ,
    TestID -> "cb8edc20-4697-48dd-bd1b-bf5a62532ba3"
]

VerificationTest[
    Take[
        {Sin, Listable} /@
            (
                If[#1 > 10,
                    endOfLazyList
                    ,
                    #1
                ]&
            ) /@ partitionedLazyRange[5]
        ,
        20
]
    ,
    partitionedLazyList[{Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], 
        Sin[7], Sin[8], Sin[9], Sin[10]}, lazyList[]]
    ,
    TestID -> "33c42b6a-5684-46b6-b03b-de033e81ecc1"
]

VerificationTest[
    Take[
        Sin /@
            {
                If[Max[#1] > 10,
                    Append[#1, endOfLazyList]
                    ,
                    #1
                ]&
                ,
                Listable
            } /@ partitionedLazyRange[5]
        ,
        20
]
    ,
    partitionedLazyList[{Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], 
        Sin[7], Sin[8], Sin[9], Sin[10], Sin[11], Sin[12], Sin[13], Sin[14], 
        Sin[15]}, lazyList[]]
    ,
    TestID -> "827b77e3-adc4-411d-9a3d-cfd9afce8fd8"
]

VerificationTest[
    Take[
        {Sin, Listable} /@
            {
                If[Max[#1] > 10,
                    Append[#1, endOfLazyList]
                    ,
                    #1
                ]&
                ,
                Listable
            } /@ partitionedLazyRange[5]
        ,
        20
]
    ,
    partitionedLazyList[{Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], 
        Sin[7], Sin[8], Sin[9], Sin[10], Sin[11], Sin[12], Sin[13], Sin[14], 
        Sin[15]}, lazyList[]]
    ,
    TestID -> "73355d47-e7bc-43ca-af53-c934312e1588"
]

VerificationTest[
    Take[
        composeMappedFunctions[
            Sin /@
                (
                    If[#1 === 10,
                        endOfLazyList
                        ,
                        #1
                    ]&
                ) /@ lazyRange[]
        ]
        ,
        20
]
    ,
    Take[
        Sin /@
            (
                If[#1 === 10,
                    endOfLazyList
                    ,
                    #1
                ]&
            ) /@ lazyRange[]
        ,
        20
]
    ,
    TestID -> "d8075c3e-aa4f-4c8f-b42e-6b89ece12e84"
]

EndTestSection[]

BeginTestSection["lazyAggregate"]

VerificationTest[
    nmax = 10^4; lazyAggregate[lazyTruncate[partitionedLazyRange[100], nmax
        ], {CountsBy[PrimeQ], Merge[Total]}]
    ,
    {Association[False -> 8771, True -> 1229], lazyList[]}
    ,
    TestID -> "00720e91-d9ae-4630-894d-b79a77912522"
]

VerificationTest[
    {result, tail} = lazyAggregate[partitionedLazyRange[100], {CountsBy[PrimeQ
        ], Merge[Total]}, 10^4]; result
    ,
    Association[False -> 8771, True -> 1229]
    ,
    TestID -> "9d1ed9dc-6f28-4bb0-ac33-faffadfbd46e"
]

VerificationTest[
    First[lazyAggregate[tail, {CountsBy[PrimeQ], Merge[Total]}, 10^4]]
    ,
    Association[False -> 8967, True -> 1033]
    ,
    TestID -> "a2850e34-4c80-430d-ae46-9d038dfd767e"
]

VerificationTest[
    First[lazyAggregate[lazyRange[], {CountsBy[PrimeQ], Merge[Total]}, 10
        ^4, 100]]
    ,
    Association[False -> 8771, True -> 1229]
    ,
    TestID -> "b1cc1458-5bb0-42ea-b8cd-795dd4b8fd7b"
]

VerificationTest[
    lazyAggregate[lazyTruncate[lazyRange[], 10^4], {CountsBy[PrimeQ], Merge[
        Total]}, Infinity, 10]
    ,
    {Association[False -> 8771, True -> 1229], lazyList[]}
    ,
    TestID -> "32157966-3dcb-4245-8ce7-887ab4af0bc1"
]

EndTestSection[]

BeginTestSection["AnyTrue etc."]

VerificationTest[
    AssociationMap[#1[lazyList[], f]&, {AnyTrue, AllTrue, NoneTrue}]
    ,
    Association[AnyTrue -> False, AllTrue -> True, NoneTrue -> True]
    ,
    TestID -> "57928a8b-9706-473e-b3cd-37b085633c9c"
]

VerificationTest[
    AssociationMap[#1[lazyRange[], #1 < 100&]&, {AnyTrue, AllTrue, NoneTrue
        }]
    ,
    Association[AnyTrue -> True, AllTrue -> False, NoneTrue -> False]
    ,
    TestID -> "6177e1d4-4861-439e-9804-67f36a0d299c"
]

VerificationTest[
    AssociationMap[#1[lazyTruncate[lazyRange[], 99], #1 > 100&]&, {AnyTrue,
         AllTrue, NoneTrue}]
    ,
    Association[AnyTrue -> False, AllTrue -> False, NoneTrue -> True]
    ,
    TestID -> "841b2ab8-4f34-4641-8949-fc5e1e56186a"
]

VerificationTest[
    AssociationMap[#1[lazyTruncate[lazyRange[], 99], #1 < 100&]&, {AnyTrue,
         AllTrue, NoneTrue}]
    ,
    Association[AnyTrue -> True, AllTrue -> True, NoneTrue -> False]
    ,
    TestID -> "b5c9b699-3441-464e-9c50-cf1ec32ca193"
]

EndTestSection[]

BeginTestSection["Edge cases"]

VerificationTest[
    badExample = (lazyList[1, #0[]]&)[]
    ,
    lazyList[1, (lazyList[1, #0[]]&)[]]
    ,
    TestID -> "cca6f375-6ddb-4152-aa3d-2349457bc8e2"
]

VerificationTest[
    Last[badExample]
    ,
    badExample
    ,
    TestID -> "d5669f68-30d9-4e7a-a0e0-4a892a683a43"
]

VerificationTest[
    First[Take[badExample, 20]]
    ,
    {1, 1}
    ,
    TestID -> "0820b214-6494-4848-9ae0-3811250773bb"
]

VerificationTest[
    example = (lazyList[1, #0[#1 + 1]]&)[1]
    ,
    lazyList[1, (lazyList[1, #0[#1 + 1]]&)[1 + 1]]
    ,
    TestID -> "70bea84b-fb82-4ee1-8fff-c75fed296f60"
]

VerificationTest[
    example === Last[example]
    ,
    False
    ,
    TestID -> "1346241a-d07f-43e4-b438-f6bb7f8bcc01"
]

VerificationTest[
    Take[example, 20]
    ,
    lazyList[{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
         (lazyList[1, #0[#1 + 1]]&)[20 + 1]]
    ,
    TestID -> "8cc85caf-0ded-497b-bc70-c8c40b5ed440"
]

VerificationTest[
    position = Replace[Last[Take[example, 20]], {lazyList[_, (__&)[i_]] :>
         i}]
    ,
    22
    ,
    TestID -> "276824c8-0ef1-470e-ab70-bcf516bda143"
]

EndTestSection[]

BeginTestSection["End"]

EndTestSection[]

EndTestSection[]