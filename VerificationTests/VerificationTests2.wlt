BeginTestSection["VerificationTests2"]

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

BeginTestSection["lazyPeriodicList"]

VerificationTest[
    First[Take[lazyPeriodicList[Range[5]], 10]]
    ,
    {1, 2, 3, 4, 5, 1, 2, 3, 4, 5}
    ,
    TestID -> "559d78de-10c5-49f7-98d5-c893792ccd08"
]

VerificationTest[
    First[Take[lazyPeriodicList[lazyRange[1, 5]], 10]]
    ,
    {1, 2, 3, 4, 5, 1, 2, 3, 4, 5}
    ,
    TestID -> "7b97cea7-d9d3-433a-ad17-556fb3613643"
]

VerificationTest[
    Most[Take[lazyPeriodicList[Range[5], 3], 10]]
    ,
    {1, 2, 3, 4, 5, 1, 2, 3, 4, 5}
    ,
    TestID -> "69dee00f-638d-4753-b4b3-342b4400b94f"
]

VerificationTest[
    {Most[Take[lazyPeriodicList[partitionedLazyRange[1, 5, 3]], 10]], Most[
        Take[lazyPeriodicList[partitionedLazyRange[1, 5, 5]], 10]]}
    ,
    {{1, 2, 3, 4, 5, 1, 2, 3, 4, 5}, {1, 2, 3, 4, 5, 1, 2, 3, 4, 5}}
    ,
    TestID -> "66cedb13-6e11-4c17-8c04-55c5f39c4524"
]

EndTestSection[]

BeginTestSection["partitionedLazyList"]

BeginTestSection["Construction"]

VerificationTest[
    lazyPartition[lazyList[Fibonacci[Range[10]]], 5]
    ,
    partitionedLazyList[{1, 1, 2, 3, 5}, lazyPartition[{8, 13, 21, 34, 55
        }, 5]]
    ,
    TestID -> "01bf8674-8020-456c-b246-5e53b2c6a0d1"
]

VerificationTest[
    Take[lazyPartition[lazyList[Fibonacci[Range[10]]], 5], All]
    ,
    partitionedLazyList[{1, 1, 2, 3, 5, 8, 13, 21, 34, 55}, lazyList[]]
    ,
    TestID -> "c787722b-c06f-492e-ba9e-a6761bdb6ebc"
]

VerificationTest[
    Take[lazyPartition[Fibonacci[Range[10]], 5], All]
    ,
    partitionedLazyList[{1, 1, 2, 3, 5, 8, 13, 21, 34, 55}, lazyList[]]
    ,
    TestID -> "732c1566-7183-4c6c-a41f-f2ac3016d1b6"
]

VerificationTest[
    lz = partitionedLazyList[lazyGenerator[Range]]
    ,
    partitionedLazyList[{1}, partitionedLazyList[lazyLists`Private`twoSidedGenerator[
        Range, 1 + 1, 1]]]
    ,
    TestID -> "fe027550-a112-47ea-b5c6-c8fb3ab25ab3"
]

VerificationTest[
    Take[lz, 20]
    ,
    partitionedLazyList[{1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 
        2, 3, 4, 5}, partitionedLazyList[{6}, partitionedLazyList[lazyLists`Private`twoSidedGenerator[
        Range, 6 + 1, 1]]]]
    ,
    TestID -> "74ee957c-35b9-4288-b87d-a44a6461a75a"
]

VerificationTest[
    First[Take[lz, 10]]
    ,
    1
    ,
    TestID -> "1530a19f-7b3b-4fa6-801e-235cb5df2ec0"
]

VerificationTest[
    Rest[Take[lz, 10]]
    ,
    partitionedLazyList[{1, 2, 1, 2, 3, 1, 2, 3, 4}, partitionedLazyList[
        {1, 2, 3, 4, 5}, partitionedLazyList[lazyLists`Private`twoSidedGenerator[
        Range, 5 + 1, 1]]]]
    ,
    TestID -> "7414b466-3025-448c-8c06-5576951b0a84"
]

VerificationTest[
    Most[Take[lz, 10]]
    ,
    {1, 1, 2, 1, 2, 3, 1, 2, 3, 4}
    ,
    TestID -> "fa132159-8a8f-4beb-86df-e2bba144c4ef"
]

VerificationTest[
    Last[Take[lz, 10]]
    ,
    partitionedLazyList[{1, 2, 3, 4, 5}, partitionedLazyList[lazyLists`Private`twoSidedGenerator[
        Range, 5 + 1, 1]]]
    ,
    TestID -> "5a9e1259-745c-4927-997b-aa932934f6e2"
]

VerificationTest[
    lz = lazyPartition[lazyGenerator[ConstantArray[#1, 5]&], 3]
    ,
    partitionedLazyList[{{1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {3, 3, 3, 3, 3
        }}, lazyPartition[lazyLists`Private`twoSidedGenerator[ConstantArray[#1,
         5]&, 3 + 1, 1], 3]]
    ,
    TestID -> "5d38a3ac-f6bd-4521-8938-63627ebbfbdb"
]

VerificationTest[
    lazyTranspose[lz]
    ,
    partitionedLazyList[{{1, 2, 3}, {1, 2, 3}, {1, 2, 3}, {1, 2, 3}, {1, 
        2, 3}}, {Transpose, Listable} /@ lazyPartition[lazyLists`Private`twoSidedGenerator[
        ConstantArray[#1, 5]&, 3 + 1, 1], 3]]
    ,
    TestID -> "29795b28-319d-4474-b894-5b87a8044998"
]

VerificationTest[
    (Most[Take[#1, 10]]&) /@ {partitionedLazyRange[5], partitionedLazyRange[
        3, 5], partitionedLazyRange[3, 7, 5], partitionedLazyRange[3, 23, 5],
         partitionedLazyRange[3, 9, 4, 5], partitionedLazyRange[3, 23, 2, 5]}
    ,
    {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, {3, 4, 5, 6, 7, 8, 9, 10, 11, 12}, 
        {3, 4, 5, 6, 7}, {3, 4, 5, 6, 7, 8, 9, 10, 11, 12}, {3, 7}, {3, 5, 7,
         9, 11, 13, 15, 17, 19, 21}}
    ,
    TestID -> "945b5cf9-4873-4d5c-bd3c-8d4f1b1dbe86"
]

EndTestSection[]

BeginTestSection["Part and Take"]

VerificationTest[
    lz = partitionedLazyRange[start, Infinity, step, 5]
    ,
    partitionedLazyList[{start, start + step, start + 2 * step, start + 3
         * step, start + 4 * step}, partitionedLazyList[__]]
    ,
    TestID -> "e48434ad-194e-4c1d-9181-bafefa2cd018"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    First[Take[lz, 20]]
    ,
    start
    ,
    TestID -> "d1633934-c1bb-4947-a9ac-4f90c3f3a7da"
]

VerificationTest[
    Most[Take[lz, 20]]
    ,
    {start, start + step, start + 2 * step, start + 3 * step, start + 4 *
         step, start + 5 * step, start + 6 * step, start + 7 * step, start + 
        8 * step, start + 9 * step, start + 10 * step, start + 11 * step, start
         + 12 * step, start + 13 * step, start + 14 * step, start + 15 * step,
         start + 16 * step, start + 17 * step, start + 18 * step, start + 19 
        * step}
    ,
    TestID -> "e3c13e65-15f5-40ab-a369-a0739f6ce9cd"
]

VerificationTest[
    rangeRange = partitionedLazyList[lazyGenerator[Range, 1, 1, 8]]
    ,
    partitionedLazyList[{1}, partitionedLazyList[__]]
    ,
    TestID -> "abbb180b-6296-4777-ac14-9878e48e5e91"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    Most[Take[rangeRange, 20]]
    ,
    {1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5}
    ,
    TestID -> "51609d85-e54a-44ed-91d9-4b64c4990fe4"
]

VerificationTest[
    Most[Take[rangeRange, {18, 5, -3}]]
    ,
    {3, 5, 2, 3, 3}
    ,
    TestID -> "820df117-1d98-44c2-a62a-edec62a21a0a"
]

VerificationTest[
    Most[Take[rangeRange, {5, 18, 3}]]
    ,
    {2, 2, 1, 4, 2}
    ,
    TestID -> "6dcf221b-d910-4a2e-b4e3-86711adeb89f"
]

VerificationTest[
    Most[lazyPartition[lazyRange[], 5]]
    ,
    {1, 2, 3, 4, 5}
    ,
    TestID -> "9a72acee-8279-49cc-b52e-428f405cc087"
]

VerificationTest[
    Most[lazyPartition[rangeRange, 5]]
    ,
    {1, 1, 2, 1, 2}
    ,
    TestID -> "e007465e-1e97-47b0-be7c-b8aac867396c"
]

VerificationTest[
    Most[lazyPartition[lazyPartition[lazyRange[], 5], 10]]
    ,
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    ,
    TestID -> "82525b95-d50e-41ef-b3f4-c8dc4e471c7e"
]

VerificationTest[
    Most[Take[lazyTruncate[partitionedLazyRange[10], 25], 5]]
    ,
    {1, 2, 3, 4, 5}
    ,
    TestID -> "f14281d3-eaf3-4020-a824-62abf93dba28"
]

VerificationTest[
    Most[Take[lazyTruncate[partitionedLazyRange[10], 25], 15]]
    ,
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
    ,
    TestID -> "d3cf0a29-083f-45c8-b7cd-e0dd05f8f838"
]

VerificationTest[
    Most[Take[lazyTruncate[Log /@ partitionedLazyRange[10], 25], 15]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5], Log[6], Log[7], Log[8], Log[9], Log[
        10], Log[11], Log[12], Log[13], Log[14], Log[15]}
    ,
    TestID -> "8426109a-6af3-4499-919c-dcd996f6167e"
]

VerificationTest[
    Most[Take[Log /@ lazyTruncate[partitionedLazyRange[10], 25], 15]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5], Log[6], Log[7], Log[8], Log[9], Log[
        10], Log[11], Log[12], Log[13], Log[14], Log[15]}
    ,
    TestID -> "ac33716d-80d5-489b-899b-5c8a4e62fd8d"
]

VerificationTest[
    Most[Take[lazyTruncate[partitionedLazyRange[10], 25], 50]]
    ,
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
         21, 22, 23, 24, 25}
    ,
    TestID -> "8ebdf7c2-55e9-4b2f-8c3a-8feae18c691f"
]

VerificationTest[
    Most[Take[lazyTruncate[Log /@ partitionedLazyRange[10], 25], 50]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5], Log[6], Log[7], Log[8], Log[9], Log[
        10], Log[11], Log[12], Log[13], Log[14], Log[15], Log[16], Log[17], Log[
        18], Log[19], Log[20], Log[21], Log[22], Log[23], Log[24], Log[25]}
    ,
    TestID -> "700bbfe1-4326-45e1-a89f-23332ffb1b64"
]

VerificationTest[
    Most[Take[Log /@ lazyTruncate[partitionedLazyRange[10], 25], 50]]
    ,
    {0, Log[2], Log[3], Log[4], Log[5], Log[6], Log[7], Log[8], Log[9], Log[
        10], Log[11], Log[12], Log[13], Log[14], Log[15], Log[16], Log[17], Log[
        18], Log[19], Log[20], Log[21], Log[22], Log[23], Log[24], Log[25]}
    ,
    TestID -> "62d9d377-d23d-433c-a4f8-4c088693c998"
]

VerificationTest[
    TakeDrop[partitionedLazyRange[10], 5]
    ,
    {{1, 2, 3, 4, 5}, _partitionedLazyList}
    ,
    TestID -> "bc6e4bf3-9ed7-494b-ac27-5e750f70b76f"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    TakeDrop[partitionedLazyRange[10], 15]
    ,
    {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}, _partitionedLazyList
        }
    ,
    TestID -> "0a677117-8637-459e-a817-a24e88a77766"
    ,
    SameTest -> MatchQ
]

VerificationTest[
    AssociationMap[TakeDrop[partitionedLazyList[Range[3]], #1]&, Range[5]
        ]
    ,
    Association[1 -> {{1}, partitionedLazyList[{2, 3}, lazyList[]]}, 2 ->
         {{1, 2}, partitionedLazyList[{3}, lazyList[]]}, 3 -> {{1, 2, 3}, lazyList[
        ]}, 4 -> {{1, 2, 3}, lazyList[]}, 5 -> {{1, 2, 3}, lazyList[]}]
    ,
    TestID -> "9c71a79c-082e-453e-82ce-bf530ecbfb54"
]

VerificationTest[
    (Drop[partitionedLazyRange[10], #1]&) /@ {5, 15}
    ,
    (Last[Take[partitionedLazyRange[10], #1]]&) /@ {5, 15}
    ,
    TestID -> "6c7a81da-7f2d-48f7-a8fd-02a660066d84"
]

VerificationTest[
    (Drop[lazyPartition[Range[20], 10], #1]&) /@ {5, 15, 25}
    ,
    (Last[Take[lazyPartition[Range[20], 10], #1]]&) /@ {5, 15, 25}
    ,
    TestID -> "0ed52e26-9b2f-4d75-8088-8e628e3e6599"
]

EndTestSection[]

BeginTestSection["lazyTuples"]

VerificationTest[
    lists = {{a, b, c}, {1, 2}, {u, v, w, x, y, z}}; lzTup = lazyTuples[lists,
         "PartitionSize" -> 10]; MatchQ[lzTup, partitionedLazyList[{{a, 1, u},
         {a, 1, v}, {a, 1, w}, {a, 1, x}, {a, 1, y}, {a, 1, z}, {a, 2, u}, {a,
         2, v}, {a, 2, w}, {a, 2, x}}, _Map]]
    ,
    True
    ,
    TestID -> "24b2d102-74b8-448e-b98e-e96436dc4582"
]

VerificationTest[
    Most[Take[lzTup, All]]
    ,
    Tuples[lists]
    ,
    TestID -> "7e1cd504-6344-4ea6-945b-c5c473fce372"
]

VerificationTest[
    Most[Take[lazyTuples[{a, b, c}, 5], 10]]
    ,
    Take[Tuples[{a, b, c}, 5], 10]
    ,
    TestID -> "2504436e-333c-4451-8e5c-5008d03ff2e1"
]

VerificationTest[
    largeLists = Range /@ {50, 40, 60, 80}; Most[Take[lazyTuples[Hold[largeLists
        ]], 10]]
    ,
    {{1, 1, 1, 1}, {1, 1, 1, 2}, {1, 1, 1, 3}, {1, 1, 1, 4}, {1, 1, 1, 5},
         {1, 1, 1, 6}, {1, 1, 1, 7}, {1, 1, 1, 8}, {1, 1, 1, 9}, {1, 1, 1, 10
        }}
    ,
    TestID -> "049881ce-6fad-454f-b4d5-405e0871d698"
]

VerificationTest[
    Most[Take[lazyTuples[Hold[largeLists], "PartitionSize" -> 1000], 100]
        ]
    ,
    {{1, 1, 1, 1}, {1, 1, 1, 2}, {1, 1, 1, 3}, {1, 1, 1, 4}, {1, 1, 1, 5},
         {1, 1, 1, 6}, {1, 1, 1, 7}, {1, 1, 1, 8}, {1, 1, 1, 9}, {1, 1, 1, 10
        }, {1, 1, 1, 11}, {1, 1, 1, 12}, {1, 1, 1, 13}, {1, 1, 1, 14}, {1, 1,
         1, 15}, {1, 1, 1, 16}, {1, 1, 1, 17}, {1, 1, 1, 18}, {1, 1, 1, 19}, 
        {1, 1, 1, 20}, {1, 1, 1, 21}, {1, 1, 1, 22}, {1, 1, 1, 23}, {1, 1, 1,
         24}, {1, 1, 1, 25}, {1, 1, 1, 26}, {1, 1, 1, 27}, {1, 1, 1, 28}, {1,
         1, 1, 29}, {1, 1, 1, 30}, {1, 1, 1, 31}, {1, 1, 1, 32}, {1, 1, 1, 33
        }, {1, 1, 1, 34}, {1, 1, 1, 35}, {1, 1, 1, 36}, {1, 1, 1, 37}, {1, 1,
         1, 38}, {1, 1, 1, 39}, {1, 1, 1, 40}, {1, 1, 1, 41}, {1, 1, 1, 42}, 
        {1, 1, 1, 43}, {1, 1, 1, 44}, {1, 1, 1, 45}, {1, 1, 1, 46}, {1, 1, 1,
         47}, {1, 1, 1, 48}, {1, 1, 1, 49}, {1, 1, 1, 50}, {1, 1, 1, 51}, {1,
         1, 1, 52}, {1, 1, 1, 53}, {1, 1, 1, 54}, {1, 1, 1, 55}, {1, 1, 1, 56
        }, {1, 1, 1, 57}, {1, 1, 1, 58}, {1, 1, 1, 59}, {1, 1, 1, 60}, {1, 1,
         1, 61}, {1, 1, 1, 62}, {1, 1, 1, 63}, {1, 1, 1, 64}, {1, 1, 1, 65}, 
        {1, 1, 1, 66}, {1, 1, 1, 67}, {1, 1, 1, 68}, {1, 1, 1, 69}, {1, 1, 1,
         70}, {1, 1, 1, 71}, {1, 1, 1, 72}, {1, 1, 1, 73}, {1, 1, 1, 74}, {1,
         1, 1, 75}, {1, 1, 1, 76}, {1, 1, 1, 77}, {1, 1, 1, 78}, {1, 1, 1, 79
        }, {1, 1, 1, 80}, {1, 1, 2, 1}, {1, 1, 2, 2}, {1, 1, 2, 3}, {1, 1, 2,
         4}, {1, 1, 2, 5}, {1, 1, 2, 6}, {1, 1, 2, 7}, {1, 1, 2, 8}, {1, 1, 2,
         9}, {1, 1, 2, 10}, {1, 1, 2, 11}, {1, 1, 2, 12}, {1, 1, 2, 13}, {1, 
        1, 2, 14}, {1, 1, 2, 15}, {1, 1, 2, 16}, {1, 1, 2, 17}, {1, 1, 2, 18},
         {1, 1, 2, 19}, {1, 1, 2, 20}}
    ,
    TestID -> "0a6ccfa4-19db-450c-91fe-c3131cfa38b5"
]

VerificationTest[
    integers = Length /@ lists; integerLzTup = lazyTuples[integers]; MatchQ[
        integerLzTup, partitionedLazyList[{{1, 1, 1}, {1, 1, 2}, {1, 1, 3}, {
        1, 1, 4}, {1, 1, 5}, {1, 1, 6}, {1, 2, 1}, {1, 2, 2}, {1, 2, 3}, {1, 
        2, 4}}, _Map]]
    ,
    True
    ,
    TestID -> "abe8de04-193c-434c-9de1-f0e74ad365d8"
]

VerificationTest[
    indices = Most[Take[integerLzTup, 10]]
    ,
    {{1, 1, 1}, {1, 1, 2}, {1, 1, 3}, {1, 1, 4}, {1, 1, 5}, {1, 1, 6}, {1,
         2, 1}, {1, 2, 2}, {1, 2, 3}, {1, 2, 4}}
    ,
    TestID -> "1dc8febd-3448-49d6-be28-1ccd6ec9c3a9"
]

VerificationTest[
    Take[Tuples[Range /@ integers], 10]
    ,
    {{1, 1, 1}, {1, 1, 2}, {1, 1, 3}, {1, 1, 4}, {1, 1, 5}, {1, 1, 6}, {1,
         2, 1}, {1, 2, 2}, {1, 2, 3}, {1, 2, 4}}
    ,
    TestID -> "4d3ad108-8eda-4b86-b437-4ae9f711021e"
]

VerificationTest[
    bulkExtractElementsUsingIndexList[lists][Transpose[indices]]
    ,
    Take[Tuples[lists], 10]
    ,
    TestID -> "aba8a778-a2ca-4ee0-b9cd-836bd89bf9f2"
]

VerificationTest[
    bulkExtractElementsUsingIndexList[Hold[lists]][Transpose[indices]]
    ,
    Take[Tuples[lists], 10]
    ,
    TestID -> "cddc03cf-2e55-41ff-8f12-cfaf4b33ac36"
]

VerificationTest[
    Module[{list = {a, b, c, d, e}, tupLength = 3, indices},
        indices = Most[Take[lazyTuples[Range[Length[list]], tupLength], 10
            ]];
        bulkExtractElementsUsingIndexList[list, tupLength][Transpose[indices
            ]]
]
    ,
    Take[Tuples[{a, b, c, d, e}, 3], 10]
    ,
    TestID -> "2cfc8d44-a522-49e1-a6d3-b57badf7858e"
]

VerificationTest[
    Most[Take[lazyTuples[integers, "Start" -> 10], 11]]
    ,
    {{1, 2, 4}, {1, 2, 5}, {1, 2, 6}, {2, 1, 1}, {2, 1, 2}, {2, 1, 3}, {2,
         1, 4}, {2, 1, 5}, {2, 1, 6}, {2, 2, 1}, {2, 2, 2}}
    ,
    TestID -> "6d6b52ee-9463-4ee8-be50-d35a81016de8"
]

VerificationTest[
    Take[Tuples[Range /@ integers], {10, 20}]
    ,
    {{1, 2, 4}, {1, 2, 5}, {1, 2, 6}, {2, 1, 1}, {2, 1, 2}, {2, 1, 3}, {2,
         1, 4}, {2, 1, 5}, {2, 1, 6}, {2, 2, 1}, {2, 2, 2}}
    ,
    TestID -> "265a55bb-649d-416f-9440-2683e88bd339"
]

VerificationTest[
    tuplesGenerator = rangeTuplesAtPositions[integers]; Head[tuplesGenerator
        ] === CompiledFunction
    ,
    True
    ,
    TestID -> "6039388a-a7fb-41f9-af49-0a1d7879ba7a"
]

VerificationTest[
    randomPositions = RandomInteger[{1, Times @@ integers}, 10]; MatchQ[randomPositions,
         {__Integer}]
    ,
    True
    ,
    TestID -> "89cad6c5-e497-4ab9-90a4-68a3e04af6ea"
]

VerificationTest[
    tuplesGenerator[randomPositions]
    ,
    Transpose[Tuples[Range /@ integers][[randomPositions]]]
    ,
    TestID -> "84552981-9693-4342-93a1-48f1974e46dc"
]

VerificationTest[
    infTuples = lazyTuples[4]; MatchQ[infTuples, partitionedLazyList[{{1,
         1, 1, 1}, {1, 1, 1, 2}, {1, 1, 2, 1}, {1, 2, 1, 1}, {2, 1, 1, 1}, {1,
         1, 1, 3}, {1, 1, 2, 2}, {1, 1, 3, 1}, {1, 2, 1, 2}, {1, 2, 2, 1}}, _
        ]]
    ,
    True
    ,
    TestID -> "78889fbc-8259-4d38-97ef-1b93bd574df7"
]

VerificationTest[
    Most[Take[infTuples, 75]]
    ,
    {{1, 1, 1, 1}, {1, 1, 1, 2}, {1, 1, 2, 1}, {1, 2, 1, 1}, {2, 1, 1, 1},
         {1, 1, 1, 3}, {1, 1, 2, 2}, {1, 1, 3, 1}, {1, 2, 1, 2}, {1, 2, 2, 1},
         {1, 3, 1, 1}, {2, 1, 1, 2}, {2, 1, 2, 1}, {2, 2, 1, 1}, {3, 1, 1, 1},
         {1, 1, 1, 4}, {1, 1, 2, 3}, {1, 1, 3, 2}, {1, 1, 4, 1}, {1, 2, 1, 3},
         {1, 2, 2, 2}, {1, 2, 3, 1}, {1, 3, 1, 2}, {1, 3, 2, 1}, {1, 4, 1, 1},
         {2, 1, 1, 3}, {2, 1, 2, 2}, {2, 1, 3, 1}, {2, 2, 1, 2}, {2, 2, 2, 1},
         {2, 3, 1, 1}, {3, 1, 1, 2}, {3, 1, 2, 1}, {3, 2, 1, 1}, {4, 1, 1, 1},
         {1, 1, 1, 5}, {1, 1, 2, 4}, {1, 1, 3, 3}, {1, 1, 4, 2}, {1, 1, 5, 1},
         {1, 2, 1, 4}, {1, 2, 2, 3}, {1, 2, 3, 2}, {1, 2, 4, 1}, {1, 3, 1, 3},
         {1, 3, 2, 2}, {1, 3, 3, 1}, {1, 4, 1, 2}, {1, 4, 2, 1}, {1, 5, 1, 1},
         {2, 1, 1, 4}, {2, 1, 2, 3}, {2, 1, 3, 2}, {2, 1, 4, 1}, {2, 2, 1, 3},
         {2, 2, 2, 2}, {2, 2, 3, 1}, {2, 3, 1, 2}, {2, 3, 2, 1}, {2, 4, 1, 1},
         {3, 1, 1, 3}, {3, 1, 2, 2}, {3, 1, 3, 1}, {3, 2, 1, 2}, {3, 2, 2, 1},
         {3, 3, 1, 1}, {4, 1, 1, 2}, {4, 1, 2, 1}, {4, 2, 1, 1}, {5, 1, 1, 1},
         {1, 1, 1, 6}, {1, 1, 2, 5}, {1, 1, 3, 4}, {1, 1, 4, 3}, {1, 1, 5, 2}
        }
    ,
    TestID -> "c70e9cab-91be-484e-883e-2f0f1f811260"
]

VerificationTest[
    Sort[Select[Most[Take[infTuples, 75]], Total[#1] < 9&]]
    ,
    Sort[Select[Tuples[Range[10], 4], Total[#1] < 9&]]
    ,
    TestID -> "aa1b845f-e3c7-4baa-85ae-d14d3a58ac3e"
]

VerificationTest[
    Most[Take[lazyTuples[4, {1, 4, 10, 2}], 20]]
    ,
    {{1, 4, 10, 2}, {1, 4, 11, 1}, {1, 5, 1, 10}, {1, 5, 2, 9}, {1, 5, 3,
         8}, {1, 5, 4, 7}, {1, 5, 5, 6}, {1, 5, 6, 5}, {1, 5, 7, 4}, {1, 5, 8,
         3}, {1, 5, 9, 2}, {1, 5, 10, 1}, {1, 6, 1, 9}, {1, 6, 2, 8}, {1, 6, 
        3, 7}, {1, 6, 4, 6}, {1, 6, 5, 5}, {1, 6, 6, 4}, {1, 6, 7, 3}, {1, 6,
         8, 2}}
    ,
    TestID -> "f3adf59a-4b10-4bd6-8798-52b9ea706312"
]

EndTestSection[]

BeginTestSection["lazyStream"]

VerificationTest[
    stmp = OpenWrite["tmp"]; Write[stmp, a, b, c]; Write[stmp, x]; Write[
        stmp, "Hello"]; Write[stmp, "Hello"]; Write[stmp, "Hello"]; Close[stmp
        ]
    ,
    "tmp"
    ,
    TestID -> "0f990c29-bc3b-4212-b56f-dd4fc18990e6"
]

VerificationTest[
    Module[{stream = OpenRead["tmp"], result},
        result = First[Take[lazyStream[stream], 3]];
        Close[stream];
        result
]
    ,
    {abc, x, "Hello"}
    ,
    TestID -> "52120357-4e6a-4818-9638-c55b4ec44945"
]

VerificationTest[
    Module[{stream = OpenRead["tmp"], result},
        result = First[TakeWhile[lazyStream[stream], True&]];
        Close[stream];
        DeleteFile["tmp"];
        result
]
    ,
    {abc, x, "Hello", "Hello", "Hello", EndOfFile}
    ,
    TestID -> "a781eda4-bab2-4dd5-a39e-3a8a90b2e152"
]

EndTestSection[]

EndTestSection[]

BeginTestSection["cachedPart"]

VerificationTest[
    cp = cachedPart[lazyRange[]]; {cp[[1]], cp[[-1]], cp[[{2, 3}]], cp[[-
        1]], cp[[5]], cp[[{-1, 1, 2, 10}]]}
    ,
    {1, 1, {2, 3}, 3, 5, {10, 1, 2, 10}}
    ,
    TestID -> "cd896f4c-aaf9-43d3-bcad-13de6a56d487"
]

VerificationTest[
    {Length[cp], Most[cp], First[Last[cp]]}
    ,
    {10, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 11}
    ,
    TestID -> "0344ec83-962a-47a3-8cf5-8021b6badeda"
]

VerificationTest[
    cp = cachedPart[partitionedLazyRange[10]]; {cp[[1]], cp[[-1]], cp[[{2,
         3}]], cp[[-1]], cp[[5]], cp[[{-1, 1, 2, 10}]], cp[[11]], cp[[-1]]}
    ,
    {1, 1, {2, 3}, 3, 5, {10, 1, 2, 10}, 11, 11}
    ,
    TestID -> "5b71576d-7381-43a9-8d74-ab7ac200cac4"
]

VerificationTest[
    {Length[cp], Most[cp], First[Last[cp]]}
    ,
    {11, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 12}
    ,
    TestID -> "64262380-4bbb-42cd-9168-6a5d69c03b0d"
]

VerificationTest[
    cp = cachedPart[lazyRange[1, 5]]; cp[[6]]
    ,
    {1, 2, 3, 4, 5}[[6]]
    ,
    {Part::partw}
    ,
    TestID -> "50bcce61-a491-4d16-ad40-05ef5347fcaf"
]

VerificationTest[
    {Length[cp], cp[[-1]], Most[cp]}
    ,
    {5, 5, {1, 2, 3, 4, 5}}
    ,
    TestID -> "d0488ba5-6a7c-4090-9af7-0c9f9562cff8"
]

VerificationTest[
    cp = cachedPart[partitionedLazyRange[1, 5, 3]]; cp[[6]]
    ,
    {1, 2, 3, 4, 5}[[6]]
    ,
    {Part::partw}
    ,
    TestID -> "e90181f9-d555-4852-a9ac-3bfe5e17c68c"
]

VerificationTest[
    {Length[cp], cp[[-1]], Most[cp]}
    ,
    {5, 5, {1, 2, 3, 4, 5}}
    ,
    TestID -> "77e8f768-d6ba-4b68-a6c8-df35338dd510"
]

EndTestSection[]

BeginTestSection["End"]

EndTestSection[]

EndTestSection[]