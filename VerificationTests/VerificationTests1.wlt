BeginTestSection["VerificationTests1"]

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

BeginTestSection["Normal lazy lists"]

BeginTestSection["Elementary tests"]

VerificationTest[
    lazyList[{}]
    ,
    lazyList[]
    ,
    TestID -> "0aa677fe-81d8-4776-8b22-218127c5e3f3"
]

VerificationTest[
    lazyList[Nothing, "stuff"]
    ,
    "stuff"
    ,
    TestID -> "aab229e7-6fe6-4877-b94d-e6384e43ffe5"
]

VerificationTest[
    lazyList[Range[10]]
    ,
    lazyList[1, lazyList[{2, 3, 4, 5, 6, 7, 8, 9, 10}]]
    ,
    TestID -> "906af855-65d9-4a0f-8f45-8b9e50ea4bbe"
]

EndTestSection[]

BeginTestSection["lazyGenerator"]

VerificationTest[
    lazyGenerator[f]
    ,
    lazyList[f[1], lazyLists`Private`twoSidedGenerator[f, 1 + 1, 1]]
    ,
    TestID -> "85cf9838-9b39-4011-816a-fcca14ff538a"
]

VerificationTest[
    lazyGenerator[f, 2]
    ,
    lazyList[f[2], lazyLists`Private`twoSidedGenerator[f, 2 + 1, 1]]
    ,
    TestID -> "3327cab0-d7aa-4997-8b45-21e81e4fe2c8"
]

VerificationTest[
    lazyGenerator[f, 2, -1]
    ,
    lazyList[f[2], lazyLists`Private`rightSidedGenerator[f, 2 + 1, -1, 1]
        ]
    ,
    TestID -> "cc912d94-a5c6-499e-baf8-0d31abd12bc0"
]

VerificationTest[
    lazyGenerator[f, 2, 3]
    ,
    lazyList[]
    ,
    {lazyGenerator::badSpec}
    ,
    TestID -> "8d8a181a-232e-4002-832a-84251bae6c14"
]

VerificationTest[
    lazySetState[lazyGenerator[f, 2, -1], -1]
    ,
    lazyList[f[-1], lazyLists`Private`rightSidedGenerator[f, -1 + 1, -1, 
        1]]
    ,
    TestID -> "f984074f-5977-48f6-90ee-804563196302"
]

VerificationTest[
    lazySetState[lazyGenerator[f, 2, -1], -2]
    ,
    lazyList[f[2], lazyLists`Private`rightSidedGenerator[f, 2 + 1, -1, 1]
        ]
    ,
    {Part::partw}
    ,
    TestID -> "e5c1e524-3ba2-43b0-b8f1-f27ba41461ce"
]

VerificationTest[
    lazyGenerator[f, 2, -Infinity]
    ,
    lazyList[f[2], lazyLists`Private`twoSidedGenerator[f, 2 + 1, 1]]
    ,
    TestID -> "97b46cdb-8023-415c-8dd6-2ed4c695aa28"
]

VerificationTest[
    lazyGenerator[f, -1, -Infinity, 3]
    ,
    lazyList[f[-1], lazyLists`Private`leftSidedGenerator[f, -1 + 1, 3, 1]
        ]
    ,
    TestID -> "e1c956b5-2151-43f7-8b7e-5ff206119768"
]

VerificationTest[
    lazyGenerator[f, 4, -Infinity, 3]
    ,
    lazyList[]
    ,
    {lazyGenerator::badSpec}
    ,
    TestID -> "8c7e86ea-620b-44ab-8aa2-db140ee35dc8"
]

VerificationTest[
    lazySetState[lazyGenerator[f, -1, -Infinity, 3], 2]
    ,
    lazyList[f[2], lazyLists`Private`leftSidedGenerator[f, 2 + 1, 3, 1]]
    ,
    TestID -> "98c938f6-fac2-4cc9-95fb-c832d1147566"
]

VerificationTest[
    lazySetState[lazyGenerator[f, -1, -Infinity, 3], 4]
    ,
    lazyList[f[-1], lazyLists`Private`leftSidedGenerator[f, -1 + 1, 3, 1]
        ]
    ,
    {Part::partw}
    ,
    TestID -> "c916b38f-189f-4976-a05c-81f6f5de2fae"
]

VerificationTest[
    lazyGenerator[f, -1, -3, 3]
    ,
    lazyList[f[-1], lazyLists`Private`finiteGenerator[f, -1 + 1, -3, 3, 1
        ]]
    ,
    TestID -> "3a1febb1-5752-484e-ab0e-9d9bb308b1aa"
]

VerificationTest[
    lazyGenerator[f, -4, -3, 3]
    ,
    lazyList[]
    ,
    {lazyGenerator::badSpec}
    ,
    TestID -> "da930bb9-74f3-4be8-adde-86d727d0db26"
]

VerificationTest[
    lazyGenerator[f, 4, -3, 3]
    ,
    lazyList[]
    ,
    {lazyGenerator::badSpec}
    ,
    TestID -> "8063f64e-dd4e-4afa-82ca-728521dba0e5"
]

VerificationTest[
    lazySetState[lazyGenerator[f, -1, -3, 3], 2]
    ,
    lazyList[f[2], lazyLists`Private`finiteGenerator[f, 2 + 1, -3, 3, 1]]
    ,
    TestID -> "cbb5d08c-2a18-491c-abbb-c81f5dc99a56"
]

VerificationTest[
    lazySetState[lazyGenerator[f, -1, -3, 3], 4]
    ,
    lazyList[f[-1], lazyLists`Private`finiteGenerator[f, -1 + 1, -3, 3, 1
        ]]
    ,
    {Part::partw}
    ,
    TestID -> "4ba95654-41db-45e9-a5c3-e270b62d5e8c"
]

VerificationTest[
    lazySetState[lazyGenerator[f, -1, -3, 3], -4]
    ,
    lazyList[f[-1], lazyLists`Private`finiteGenerator[f, -1 + 1, -3, 3, 1
        ]]
    ,
    {Part::partw}
    ,
    TestID -> "ab0b420c-b3a3-4a33-9395-035ca9c2ada2"
]

VerificationTest[
    symbolicGenerator = lazyGenerator[f, start, -Infinity, Infinity, step
        ]
    ,
    lazyList[f[start], lazyLists`Private`twoSidedGenerator[f, start + step,
         step]]
    ,
    TestID -> "e9ed830c-b556-4951-868b-db5959c367f7"
]

VerificationTest[
    First[symbolicGenerator]
    ,
    f[start]
    ,
    TestID -> "03b84bb1-f51d-4db8-8121-cedb17db058e"
]

VerificationTest[
    Rest[symbolicGenerator]
    ,
    lazyList[f[start + step], lazyLists`Private`twoSidedGenerator[f, (start
         + step) + step, step]]
    ,
    TestID -> "ffc71697-2ed6-473e-9aa6-f1ab34671b59"
]

VerificationTest[
    Most[symbolicGenerator]
    ,
    {f[start]}
    ,
    TestID -> "b184721d-1ebf-4a52-b653-c207188109bf"
]

VerificationTest[
    Last[symbolicGenerator]
    ,
    lazyList[f[start + step], lazyLists`Private`twoSidedGenerator[f, (start
         + step) + step, step]]
    ,
    TestID -> "7c737812-143f-476b-a401-9e63785cb078"
]

VerificationTest[
    First[Take[symbolicGenerator, 5]]
    ,
    {f[start], f[start + step], f[start + 2 * step], f[start + 3 * step],
         f[start + 4 * step]}
    ,
    TestID -> "08ed6fb4-ba7e-4b2c-af71-c73815d1f2ae"
]

VerificationTest[
    First[Take[lazyGenerator[f, 2, 1, 10, 2], 50]]
    ,
    {f[2], f[4], f[6], f[8], f[10]}
    ,
    TestID -> "c1fb5cd2-752c-4f59-a9e0-1ccded5e3e9c"
]

VerificationTest[
    Take[lazyGenerator[f, 2, 1, 10, 2], All]
    ,
    lazyList[{f[2], f[4], f[6], f[8], f[10]}, lazyList[]]
    ,
    TestID -> "e955f0bb-c384-4afa-86f8-e4a14194aab4"
]

VerificationTest[
    LengthWhile[lazyGenerator[f, 2, 1, 10, 2]]
    ,
    Association["Index" -> 5, "Element" -> lazyList[f[10], lazyList[]]]
    ,
    TestID -> "aaba755e-f009-4647-9b80-513c0b1fbbc1"
]

VerificationTest[
    lazyGenerator[f, 2, 1, 10, 2][[{-1}]]
    ,
    lazyList[f[10], lazyList[]]
    ,
    TestID -> "f1a60652-a2d1-4d3d-bd51-b266b6fb7327"
]

VerificationTest[
    lazyGenerator[f, 2, 1, 10, 2][[-1]]
    ,
    f[10]
    ,
    TestID -> "1a693f76-eb36-4d09-8805-38dc77a07a9d"
]

VerificationTest[
    l = Take[lazyGenerator[f, 2, 1, 10, 2], 3]
    ,
    lazyList[{f[2], f[4], f[6]}, lazyLists`Private`finiteGenerator[f, 6 +
         2, 1, 10, 2]]
    ,
    TestID -> "b37425f9-c20f-4f84-a718-f951063df8be"
]

VerificationTest[
    Take[lazySetState[Last[l], 3], 3]
    ,
    lazyList[{f[3], f[5], f[7]}, lazyLists`Private`finiteGenerator[f, 7 +
         2, 1, 10, 2]]
    ,
    TestID -> "0e297879-53fe-4b9e-8edc-e03241aabc38"
]

VerificationTest[
    First[lazySetState[lazyRange[start, Infinity, step], newStart]]
    ,
    newStart
    ,
    TestID -> "41a767ac-0948-486e-ad67-68276213a197"
]

VerificationTest[
    First[lazySetState[lazyPowerRange[start, r], newStart]]
    ,
    newStart
    ,
    TestID -> "17271240-7711-4341-9f6b-d73ae952bafb"
]

VerificationTest[
    First[lazySetState[lazyNestList[f, start], newStart]]
    ,
    newStart
    ,
    TestID -> "85d28eb3-0b69-4023-9a62-e0bca0fea29a"
]

VerificationTest[
    infiniteInBothDirections = lazyGenerator[f]
    ,
    lazyList[f[1], lazyLists`Private`twoSidedGenerator[f, 1 + 1, 1]]
    ,
    TestID -> "7d510cd5-6253-419a-909d-b1a1b71cb108"
]

VerificationTest[
    First[Take[infiniteInBothDirections, 5]]
    ,
    {f[1], f[2], f[3], f[4], f[5]}
    ,
    TestID -> "82617601-f40e-481e-ab2e-33d645b93feb"
]

EndTestSection[]

BeginTestSection["lazyRange"]

VerificationTest[
    First[lazyRange[]]
    ,
    1
    ,
    TestID -> "5a25109e-e409-4241-87e2-2e902c6c5621"
]

VerificationTest[
    First[lazyRange[4]]
    ,
    4
    ,
    TestID -> "db625667-1aaa-4627-a9e3-474c84985890"
]

VerificationTest[
    {Most[Take[lazyRange[1, 15], 10]], Most[Take[lazyRange[1, 5], 10]]}
    ,
    {{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}}, {{1, 2, 3, 4, 5}}}
    ,
    TestID -> "5a845995-c79a-4f99-a247-3473502b6cd5"
]

VerificationTest[
    {Most[Take[lazyRange[1, 15, 3], 10]], Most[Take[lazyRange[1, 5, 3], 10
        ]]}
    ,
    {{{1, 4, 7, 10, 13}}, {{1, 4}}}
    ,
    TestID -> "eba44c9b-1827-4313-b0fc-32218485593a"
]

VerificationTest[
    First[lazyRange[4, Infinity, 2]]
    ,
    4
    ,
    TestID -> "4bdbc2fc-4056-40de-8e7c-2bfa553ba08d"
]

VerificationTest[
    lazyRange[4, Infinity, 2][[2]]
    ,
    6
    ,
    TestID -> "9d97b9e9-95d1-4c32-be7b-1c7af9a10f48"
]

VerificationTest[
    First[lazyRange[m][[{1, 2}]]]
    ,
    {m, 1 + m}
    ,
    TestID -> "208d84be-1c98-4209-a0f6-d832e7fc2b83"
]

VerificationTest[
    First[lazyRange[m, Infinity, n][[1 ;; 3]]]
    ,
    {m, m + n, m + 2 * n}
    ,
    TestID -> "e5808f50-f05b-429f-b532-45a4451a62f8"
]

VerificationTest[
    First[lazyRange[]]
    ,
    1
    ,
    TestID -> "b9198889-9149-4424-b10c-43d57703131e"
]

VerificationTest[
    Most[lazyRange[]]
    ,
    {1}
    ,
    TestID -> "dbf3e3e3-8e73-4b2f-a1d7-0f145d1e87e1"
]

VerificationTest[
    First[Last[lazyRange[]]]
    ,
    2
    ,
    TestID -> "d4851321-d20b-4240-83d1-aa2d81aa1e7c"
]

VerificationTest[
    Rest[lazyRange[]]
    ,
    Last[lazyRange[]]
    ,
    TestID -> "49ad39c2-0849-4f5f-b430-9193a4949bc9"
]

EndTestSection[]

BeginTestSection["Part & Take"]

VerificationTest[
    lazyRange[][[4]]
    ,
    4
    ,
    TestID -> "ba87fc3c-eb8d-4448-8546-547454d4a9fb"
]

VerificationTest[
    lz = lazyRange[][[{4}]]; First[lz]
    ,
    4
    ,
    TestID -> "a4bc3d25-02c8-423d-92b4-9c5ac9fdff09"
]

VerificationTest[
    First[Last[lz]]
    ,
    5
    ,
    TestID -> "29f5d1ec-7934-4a76-81d2-ec1ec1be6c80"
]

VerificationTest[
    First[Rest[lz]]
    ,
    5
    ,
    TestID -> "8d821ca7-a9b9-4630-99f7-8a40c4cfaf6f"
]

VerificationTest[
    First[lazyRange[][[{1, 4, 10, 5}]]]
    ,
    {1, 4, 10, 5}
    ,
    TestID -> "6b6636be-5f74-4d4d-918b-e44168475c5f"
]

VerificationTest[
    First[lazyRange[][[10 ;; 2 ;; -2]]]
    ,
    {10, 8, 6, 4, 2}
    ,
    TestID -> "26072312-18bb-48bd-8b29-c63cce600e6f"
]

VerificationTest[
    First /@ lazyPartMap[lazyRange[], Range[2, 22, 4]]
    ,
    {2, 6, 10, 14, 18, 22}
    ,
    TestID -> "95dae054-97de-45f6-ae80-bbbdcead8954"
]

VerificationTest[
    lz = lazyList[Range[4]]; First[lz[[{1, 2, 3, 4}]]]
    ,
    {1, 2, 3, 4}
    ,
    TestID -> "63bec182-5474-409f-81ca-9f28d83c0dfc"
]

VerificationTest[
    lz[[5]]
    ,
    $Failed
    ,
    {Part::partw}
    ,
    TestID -> "71b8cba2-0230-4342-90a4-9e869195a1c2"
]

VerificationTest[
    lz[[{5}]]
    ,
    $Failed
    ,
    {Part::partw}
    ,
    TestID -> "6a91f54c-35b3-4c44-86c6-96c0bde3c0df"
]

VerificationTest[
    lz[[{2, 5}]]
    ,
    $Failed
    ,
    {Part::partw}
    ,
    TestID -> "b2b4c750-b002-45f9-854c-da29568cb0c9"
]

VerificationTest[
    lz[[2 ;; 5]]
    ,
    $Failed
    ,
    {Part::partw}
    ,
    TestID -> "2bd7171f-20a3-4542-954e-8137f83dc785"
]

VerificationTest[
    lz = Take[lazyRange[], 4]; First[lz]
    ,
    {1, 2, 3, 4}
    ,
    TestID -> "5e0a950c-6c9b-479a-9577-f510d070b785"
]

VerificationTest[
    Most[lz]
    ,
    {{1, 2, 3, 4}}
    ,
    TestID -> "fbd20cda-4809-49ed-91df-ad61c9b9c942"
]

VerificationTest[
    First[Rest[lz]]
    ,
    5
    ,
    TestID -> "11352ee2-0d75-44ae-b3cd-6f4a282119a2"
]

VerificationTest[
    First[Last[lz]]
    ,
    5
    ,
    TestID -> "27f2157e-5ce0-4e7b-9b23-c2c1c7ff64cb"
]

VerificationTest[
    First[Take[Last[lz], 5]]
    ,
    {5, 6, 7, 8, 9}
    ,
    TestID -> "fcd31aec-14e9-41b1-bd12-6ce307d8406f"
]

VerificationTest[
    First[Take[lazyRange[], {5, 10}]]
    ,
    {5, 6, 7, 8, 9, 10}
    ,
    TestID -> "55c73f74-6a40-47f7-89eb-d36da337137c"
]

VerificationTest[
    lz = Take[lazyRange[], {10, 5}]; First[lz]
    ,
    {10, 9, 8, 7, 6, 5}
    ,
    TestID -> "e961e37f-0278-4737-bff0-90e02ec06117"
]

VerificationTest[
    First[Last[lz]]
    ,
    11
    ,
    TestID -> "576c82be-5968-4ce2-b54c-9a1c73b197e5"
]

VerificationTest[
    lz = lazyList[Range[4]]; Take[lz, 5]
    ,
    lazyList[{1, 2, 3, 4}, lazyList[]]
    ,
    TestID -> "edf4f33b-9540-4ae5-b809-3e26f8ae02f8"
]

VerificationTest[
    Take[lz, {3, 5}]
    ,
    lazyList[{3, 4}, lazyList[]]
    ,
    TestID -> "871119d8-1679-42f3-b233-42e5a60e8432"
]

VerificationTest[
    Take[lz, {5, 10}]
    ,
    lazyList[]
    ,
    TestID -> "7125c3bc-998d-4824-92b5-8eadb7c0e4ff"
]

VerificationTest[
    Take[lz, {10, 3}]
    ,
    lazyList[{4, 3}, lazyList[]]
    ,
    TestID -> "dfcd0c72-873e-4da7-8046-867f8377fe08"
]

VerificationTest[
    lazyList[1, lazyRange[]]
    ,
    lazyList[1, lazyRange[]]
    ,
    TestID -> "b015e0c0-8f15-4ee7-940e-c628d027f9eb"
]

VerificationTest[
    TakeDrop[lazyRange[], 5]
    ,
    {{1, 2, 3, 4, 5}, _lazyList}
    ,
    TestID -> "bbd9c60c-3e52-4d5c-b0da-fa8b1aed4844"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    AssociationMap[TakeDrop[lazyList[Range[3]], #1]&, Range[5]]
    ,
    Association[1 -> {{1}, lazyList[2, _lazyList]}, 2 -> {{1, 2}, lazyList[
        3, _lazyList]}, 3 -> {{1, 2, 3}, lazyList[]}, 4 -> {{1, 2, 3}, lazyList[
        ]}, 5 -> {{1, 2, 3}, lazyList[]}]
    ,
    TestID -> "07133d91-553e-44a5-980b-bac94a2a9acc"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    Drop[lazyRange[], 5]
    ,
    Last[Take[lazyRange[], 5]]
    ,
    TestID -> "2cad0899-c41a-4b5c-a2ca-09822b847b3e"
]

VerificationTest[
    (Drop[lazyList[Range[3]], #1]&) /@ Range[4]
    ,
    (Last[Take[lazyList[Range[3]], #1]]&) /@ Range[4]
    ,
    TestID -> "8979eca1-6251-4da4-aa30-ce937fa26f8d"
]

EndTestSection[]

BeginTestSection["TakeWhile & LengthWhile"]

VerificationTest[
    TakeWhile[lazyPowerRange[2, 2], #1 < 100&]
    ,
    lazyList[{2, 4, 8, 16, 32, 64}, lazyList[_, _]]
    ,
    TestID -> "823b8a25-80e8-46f8-b67b-44cdddedf15b"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    LengthWhile[lazyPowerRange[2, 2], #1 < 100&]
    ,
    Association["Index" -> 6, "Element" -> lazyList[64, _lazyList]]
    ,
    TestID -> "af7f0c1f-ca15-4c58-83bd-9d23e9dba98c"
    ,
    SameTest -> MatchQ
]

EndTestSection[]

BeginTestSection["Finite lists"]

VerificationTest[
    lazyList[Fibonacci[Range[10]]]
    ,
    lazyList[1, lazyList[{1, 2, 3, 5, 8, 13, 21, 34, 55}]]
    ,
    TestID -> "d8d804be-7edb-4c0f-9fc4-74513e0d407d"
]

VerificationTest[
    First[Take[lazyList[Fibonacci[Range[10]]], 5]]
    ,
    {1, 1, 2, 3, 5}
    ,
    TestID -> "6972598e-d646-4f13-8632-ea6074b82608"
]

VerificationTest[
    fibList = Fibonacci[Range[10]]; finiteLz = lazyList[Hold[fibList]]
    ,
    lazyList[1, lazyLists`Private`lazyFiniteList[fibList, 1 + 1]]
    ,
    TestID -> "dd7dc047-d5b9-4a27-bdd5-eea56763a8ee"
]

VerificationTest[
    First[Take[finiteLz, All]]
    ,
    {1, 1, 2, 3, 5, 8, 13, 21, 34, 55}
    ,
    TestID -> "6cabf47c-9bca-4941-93f1-b4db9a6519dd"
]

VerificationTest[
    fibList = Fibonacci[Range[20]]; First[Take[finiteLz, All]]
    ,
    {1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597,
         2584, 4181, 6765}
    ,
    TestID -> "4b556f22-babb-4365-9b20-0f83c95616ef"
]

VerificationTest[
    fibList = Fibonacci[Range[1000]]; lazyFinitePart[finiteLz, 4]
    ,
    fibList[[4]]
    ,
    TestID -> "1f75b7a2-c9d4-4047-bbaa-274f038436fd"
]

VerificationTest[
    lazyFiniteTake[finiteLz, {2, 4}]
    ,
    Take[fibList, {2, 4}]
    ,
    TestID -> "fcb2dcea-1434-4617-9121-24c0f4abf5ab"
]

VerificationTest[
    lazySetState[finiteLz, -1]
    ,
    lazyList[43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875,
         lazyLists`Private`lazyFiniteList[fibList, 1000 + 1]]
    ,
    TestID -> "4fd54ea8-9db6-4091-bebe-646a9fa05b5a"
]

VerificationTest[
    First[Take[lazyTranspose[{lazyRange[], lazyConstantArray[0]}], 5]]
    ,
    {{1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}}
    ,
    TestID -> "4b2cca41-177e-4c1e-a292-185fd30f3cd8"
]

VerificationTest[
    First[Take[lazyTranspose[{lazyRange[], Range[5]}], All]]
    ,
    {{1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}}
    ,
    TestID -> "7e29229f-4c36-47c4-b0cf-77b1e12970de"
]

VerificationTest[
    First[Take[lazyTruncate[lazyRange[], 10], 5]]
    ,
    {1, 2, 3, 4, 5}
    ,
    TestID -> "e0cea9ea-d5de-4f48-bd29-23d139e578c5"
]

VerificationTest[
    First[Take[Log /@ lazyTruncate[lazyRange[], 10], 5]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5]}
    ,
    TestID -> "aeb778a2-d1ff-4dfe-a1b3-39ac250af7dc"
]

VerificationTest[
    First[Take[lazyTruncate[Log /@ lazyRange[], 10], 5]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5]}
    ,
    TestID -> "c1ee8cf5-1678-4774-aab4-865c3590c396"
]

VerificationTest[
    First[Take[lazyTruncate[lazyRange[], 10], 20]]
    ,
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    ,
    TestID -> "4b303bf3-71dd-47e9-8208-93dfd28bd79a"
]

VerificationTest[
    First[Take[Log /@ lazyTruncate[lazyRange[], 10], 20]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5], Log[6], Log[7], Log[8], Log[9], Log[
        10]}
    ,
    TestID -> "bf209a66-bfc9-42b0-93f3-5819df531373"
]

VerificationTest[
    First[Take[lazyTruncate[Log /@ lazyRange[], 10], 20]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5], Log[6], Log[7], Log[8], Log[9], Log[
        10]}
    ,
    TestID -> "1b31b9fa-d0a4-4a0f-9b0b-7ca9493dc612"
]

EndTestSection[]

EndTestSection[]

BeginTestSection["End"]

EndTestSection[]

EndTestSection[]