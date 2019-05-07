BeginTestSection["VerificationTests"]

VerificationTest[(* 1 *)
	CompoundExpression[Set[$HistoryLength, 10], SetDirectory[DirectoryName[$TestFileName]], Quiet[Get["lazyLists`"]], ClearAll["Global`*"], "Done"]
	,
	"Done"	
	,
	TestID->"429d6b44-7f18-408a-a11b-af3070fbdc57"
]

VerificationTest[(* 2 *)
	lazyRange[]
	,
	lazyList[1, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1]]	
	,
	TestID->"5a25109e-e409-4241-87e2-2e902c6c5621"
]

VerificationTest[(* 3 *)
	First[lazyRange[]]
	,
	1	
	,
	TestID->"b9198889-9149-4424-b10c-43d57703131e"
]

VerificationTest[(* 4 *)
	Most[lazyRange[]]
	,
	List[1]	
	,
	TestID->"dbf3e3e3-8e73-4b2f-a1d7-0f145d1e87e1"
]

VerificationTest[(* 5 *)
	Last[lazyRange[]]
	,
	lazyList[2, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1]]	
	,
	TestID->"d4851321-d20b-4240-83d1-aa2d81aa1e7c"
]

VerificationTest[(* 6 *)
	Rest[lazyRange[]]
	,
	lazyList[2, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1]]	
	,
	TestID->"49ad39c2-0849-4f5f-b430-9193a4949bc9"
]

VerificationTest[(* 7 *)
	Part[lazyRange[], 4]
	,
	4	
	,
	TestID->"ba87fc3c-eb8d-4448-8546-547454d4a9fb"
]

VerificationTest[(* 8 *)
	Set[lz, Part[lazyRange[], List[4]]]
	,
	lazyList[4, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 4], 1]]	
	,
	TestID->"a4bc3d25-02c8-423d-92b4-9c5ac9fdff09"
]

VerificationTest[(* 9 *)
	Last[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"29f5d1ec-7934-4a76-81d2-ec1ec1be6c80"
]

VerificationTest[(* 10 *)
	Rest[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"8d821ca7-a9b9-4630-99f7-8a40c4cfaf6f"
]

VerificationTest[(* 11 *)
	Part[lazyRange[], List[1, 4, 10, 5]]
	,
	lazyList[List[1, 4, 10, 5], lazyList[10, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]]	
	,
	TestID->"6b6636be-5f74-4d4d-918b-e44168475c5f"
]

VerificationTest[(* 12 *)
	Part[lazyRange[], Span[10, 2, -2]]
	,
	lazyList[List[10, 8, 6, 4, 2], lazyList[10, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]]	
	,
	TestID->"26072312-18bb-48bd-8b29-c63cce600e6f"
]

VerificationTest[(* 13 *)
	lazyPartMap[lazyRange[], Range[2, 22, 4]]
	,
	List[lazyList[2, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1]], lazyList[6, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 6], 1]], lazyList[10, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]], lazyList[14, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 14], 1]], lazyList[18, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 18], 1]], lazyList[22, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 22], 1]]]	
	,
	TestID->"95dae054-97de-45f6-ae80-bbbdcead8954"
]

VerificationTest[(* 14 *)
	Set[lz, lazyList[Range[4]]]
	,
	lazyList[1, lazyList[List[2, 3, 4]]]	
	,
	TestID->"63bec182-5474-409f-81ca-9f28d83c0dfc"
]

VerificationTest[(* 15 *)
	Part[lz, 5]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"71b8cba2-0230-4342-90a4-9e869195a1c2"
]

VerificationTest[(* 16 *)
	Part[lz, List[5]]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"6a91f54c-35b3-4c44-86c6-96c0bde3c0df"
]

VerificationTest[(* 17 *)
	Part[lz, List[2, 5]]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"b2b4c750-b002-45f9-854c-da29568cb0c9"
]

VerificationTest[(* 18 *)
	Part[lz, Span[2, 5]]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"2bd7171f-20a3-4542-954e-8137f83dc785"
]

VerificationTest[(* 19 *)
	Set[lz, Take[lazyRange[], 4]]
	,
	lazyList[List[1, 2, 3, 4], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 4], 1]]	
	,
	TestID->"5e0a950c-6c9b-479a-9577-f510d070b785"
]

VerificationTest[(* 20 *)
	First[lz]
	,
	List[1, 2, 3, 4]	
	,
	TestID->"ebfa7b55-47b5-47c4-bee9-368a472669c6"
]

VerificationTest[(* 21 *)
	Most[lz]
	,
	List[List[1, 2, 3, 4]]	
	,
	TestID->"fbd20cda-4809-49ed-91df-ad61c9b9c942"
]

VerificationTest[(* 22 *)
	Rest[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"11352ee2-0d75-44ae-b3cd-6f4a282119a2"
]

VerificationTest[(* 23 *)
	Last[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"27f2157e-5ce0-4e7b-9b23-c2c1c7ff64cb"
]

VerificationTest[(* 24 *)
	Take[Last[lz], 5]
	,
	lazyList[List[5, 6, 7, 8, 9], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 9], 1]]	
	,
	TestID->"fcd31aec-14e9-41b1-bd12-6ce307d8406f"
]

VerificationTest[(* 25 *)
	Take[lazyRange[], List[5, 10]]
	,
	lazyList[List[5, 6, 7, 8, 9, 10], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]	
	,
	TestID->"55c73f74-6a40-47f7-89eb-d36da337137c"
]

VerificationTest[(* 26 *)
	Take[lazyRange[], List[10, 5]]
	,
	lazyList[List[10, 9, 8, 7, 6, 5], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]	
	,
	TestID->"e961e37f-0278-4737-bff0-90e02ec06117"
]

VerificationTest[(* 27 *)
	CompoundExpression[Set[lz, lazyList[Range[4]]], Take[lz, 5]]
	,
	lazyList[List[1, 2, 3, 4], lazyList[]]	
	,
	TestID->"edf4f33b-9540-4ae5-b809-3e26f8ae02f8"
]

VerificationTest[(* 28 *)
	Take[lz, List[3, 5]]
	,
	lazyList[List[3, 4], lazyList[]]	
	,
	TestID->"871119d8-1679-42f3-b233-42e5a60e8432"
]

VerificationTest[(* 29 *)
	Take[lz, List[5, 10]]
	,
	lazyList[]	
	,
	TestID->"7125c3bc-998d-4824-92b5-8eadb7c0e4ff"
]

VerificationTest[(* 30 *)
	Take[lz, List[10, 3]]
	,
	lazyList[List[4, 3], lazyList[]]	
	,
	TestID->"dfcd0c72-873e-4da7-8046-867f8377fe08"
]

VerificationTest[(* 31 *)
	lazyList[1, lazyRange[]]
	,
	lazyList[1, lazyRange[]]	
	,
	TestID->"b015e0c0-8f15-4ee7-940e-c628d027f9eb"
]

VerificationTest[(* 32 *)
	lazyList[endOfLazyList, lazyRange[]]
	,
	lazyList[]	
	,
	TestID->"4f792f28-e364-415a-b4ef-4bcfc98a7be5"
]

VerificationTest[(* 33 *)
	TakeWhile[lazyPowerRange[2, 2], Function[Less[Slot[1], 100]]]
	,
	lazyList[List[2, 4, 8, 16, 32, 64], lazyList[128, Function[lazyList[Slot[1], Slot[0][Times[Slot[2], Slot[1]], Slot[2]]]][Times[2, 128], 2]]]	
	,
	TestID->"823b8a25-80e8-46f8-b67b-44cdddedf15b"
]

VerificationTest[(* 34 *)
	LengthWhile[lazyPowerRange[2, 2], Function[Less[Slot[1], 100]]]
	,
	Association[Rule["Index", 6], Rule["Element", lazyList[64, lazyList[128, Function[lazyList[Slot[1], Slot[0][Times[Slot[2], Slot[1]], Slot[2]]]][Times[2, 128], 2]]]]]	
	,
	TestID->"af7f0c1f-ca15-4c58-83bd-9d23e9dba98c"
]

VerificationTest[(* 35 *)
	First[Take[lazyList[Fibonacci[Range[10]]], 5]]
	,
	List[1, 1, 2, 3, 5]	
	,
	TestID->"6972598e-d646-4f13-8632-ea6074b82608"
]

VerificationTest[(* 36 *)
	Take[lazyPartition[lazyList[Fibonacci[Range[10]]], 5], All]
	,
	partitionedLazyList[List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55], lazyList[]]	
	,
	TestID->"c787722b-c06f-492e-ba9e-a6761bdb6ebc"
]

VerificationTest[(* 37 *)
	Take[lazyPartition[Fibonacci[Range[10]], 5], All]
	,
	partitionedLazyList[List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55], lazyList[]]	
	,
	TestID->"732c1566-7183-4c6c-a41f-f2ac3016d1b6"
]

VerificationTest[(* 38 *)
	CompoundExpression[Set[fibList, Fibonacci[Range[10]]], Set[finiteLz, lazyList[Hold[fibList]]]]
	,
	lazyList[1, lazyLists`Private`lazyFiniteList[fibList, Plus[1, 1]]]	
	,
	TestID->"dd7dc047-d5b9-4a27-bdd5-eea56763a8ee"
]

VerificationTest[(* 39 *)
	First[Take[finiteLz, All]]
	,
	List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55]	
	,
	TestID->"6cabf47c-9bca-4941-93f1-b4db9a6519dd"
]

VerificationTest[(* 40 *)
	CompoundExpression[Set[fibList, Fibonacci[Range[20]]], First[Take[finiteLz, All]]]
	,
	List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]	
	,
	TestID->"4b556f22-babb-4365-9b20-0f83c95616ef"
]

VerificationTest[(* 41 *)
	CompoundExpression[Set[fibList, Fibonacci[Range[1000]]], lazyFinitePart[finiteLz, 4]]
	,
	Part[fibList, 4]	
	,
	TestID->"1f75b7a2-c9d4-4047-bbaa-274f038436fd"
]

VerificationTest[(* 42 *)
	lazyFiniteTake[finiteLz, List[2, 4]]
	,
	Take[fibList, List[2, 4]]	
	,
	TestID->"fcb2dcea-1434-4617-9121-24c0f4abf5ab"
]

VerificationTest[(* 43 *)
	lazySetState[finiteLz, -1]
	,
	lazyList[43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875, lazyLists`Private`lazyFiniteList[fibList, Plus[1000, 1]]]	
	,
	TestID->"4fd54ea8-9db6-4091-bebe-646a9fa05b5a"
]

VerificationTest[(* 44 *)
	First[Take[lazyTranspose[List[lazyRange[], lazyConstantArray[0]]], 5]]
	,
	List[List[1, 0], List[2, 0], List[3, 0], List[4, 0], List[5, 0]]	
	,
	TestID->"4b2cca41-177e-4c1e-a292-185fd30f3cd8"
]

VerificationTest[(* 45 *)
	First[Take[lazyTranspose[List[lazyRange[], Range[5]]], All]]
	,
	List[List[1, 1], List[2, 2], List[3, 3], List[4, 4], List[5, 5]]	
	,
	TestID->"7e29229f-4c36-47c4-b0cf-77b1e12970de"
]

VerificationTest[(* 46 *)
	Set[lz, lazyPartition[lazyGenerator[Function[ConstantArray[Slot[1], 5]]], 3]]
	,
	partitionedLazyList[List[List[1, 1, 1, 1, 1], List[2, 2, 2, 2, 2], List[3, 3, 3, 3, 3]], lazyPartition[lazyLists`Private`twoSidedGenerator[Function[ConstantArray[Slot[1], 5]], Plus[3, 1], 1], 3]]	
	,
	TestID->"5d38a3ac-f6bd-4521-8938-63627ebbfbdb"
]

VerificationTest[(* 47 *)
	lazyTranspose[lz]
	,
	partitionedLazyList[List[List[1, 2, 3], List[1, 2, 3], List[1, 2, 3], List[1, 2, 3], List[1, 2, 3]], Map[List[Transpose, Listable], lazyPartition[lazyLists`Private`twoSidedGenerator[Function[ConstantArray[Slot[1], 5]], Plus[3, 1], 1], 3]]]	
	,
	TestID->"29795b28-319d-4474-b894-5b87a8044998"
]

VerificationTest[(* 48 *)
	Set[infiniteInBothDirections, lazyGenerator[f]]
	,
	lazyList[f[1], lazyLists`Private`twoSidedGenerator[f, Plus[1, 1], 1]]	
	,
	TestID->"7d510cd5-6253-419a-909d-b1a1b71cb108"
]

VerificationTest[(* 49 *)
	First[Take[infiniteInBothDirections, 5]]
	,
	List[f[1], f[2], f[3], f[4], f[5]]	
	,
	TestID->"82617601-f40e-481e-ab2e-33d645b93feb"
]

VerificationTest[(* 50 *)
	Set[symbolicGenerator, lazyGenerator[f, start, Times[-1, Infinity], Infinity, step]]
	,
	lazyList[f[start], lazyLists`Private`twoSidedGenerator[f, Plus[start, step], step]]	
	,
	TestID->"e9ed830c-b556-4951-868b-db5959c367f7"
]

VerificationTest[(* 51 *)
	First[Take[symbolicGenerator, 5]]
	,
	List[f[start], f[Plus[start, step]], f[Plus[start, Times[2, step]]], f[Plus[start, Times[3, step]]], f[Plus[start, Times[4, step]]]]	
	,
	TestID->"08ed6fb4-ba7e-4b2c-af71-c73815d1f2ae"
]

VerificationTest[(* 52 *)
	First[Take[lazyGenerator[f, 2, 1, 10, 2], 50]]
	,
	List[f[2], f[4], f[6], f[8], f[10]]	
	,
	TestID->"c1fb5cd2-752c-4f59-a9e0-1ccded5e3e9c"
]

VerificationTest[(* 53 *)
	Take[lazyGenerator[f, 2, 1, 10, 2], All]
	,
	lazyList[List[f[2], f[4], f[6], f[8], f[10]], lazyList[]]	
	,
	TestID->"e955f0bb-c384-4afa-86f8-e4a14194aab4"
]

VerificationTest[(* 54 *)
	LengthWhile[lazyGenerator[f, 2, 1, 10, 2]]
	,
	Association[Rule["Index", 5], Rule["Element", lazyList[f[10], lazyList[]]]]	
	,
	TestID->"aaba755e-f009-4647-9b80-513c0b1fbbc1"
]

VerificationTest[(* 55 *)
	Part[lazyGenerator[f, 2, 1, 10, 2], List[-1]]
	,
	lazyList[f[10], lazyList[]]	
	,
	TestID->"f1a60652-a2d1-4d3d-bd51-b266b6fb7327"
]

VerificationTest[(* 56 *)
	Part[lazyGenerator[f, 2, 1, 10, 2], -1]
	,
	f[10]	
	,
	TestID->"1a693f76-eb36-4d09-8805-38dc77a07a9d"
]

VerificationTest[(* 57 *)
	Set[l, Take[lazyGenerator[f, 2, 1, 10, 2], 3]]
	,
	lazyList[List[f[2], f[4], f[6]], lazyLists`Private`finiteGenerator[f, Plus[6, 2], 1, 10, 2]]	
	,
	TestID->"b37425f9-c20f-4f84-a718-f951063df8be"
]

VerificationTest[(* 58 *)
	Take[lazySetState[Last[l], 3], 3]
	,
	lazyList[List[f[3], f[5], f[7]], lazyLists`Private`finiteGenerator[f, Plus[7, 2], 1, 10, 2]]	
	,
	TestID->"0e297879-53fe-4b9e-8edc-e03241aabc38"
]

VerificationTest[(* 59 *)
	lazySetState[lazyRange[start, step], newStart]
	,
	lazyList[newStart, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[step, newStart], step]]	
	,
	TestID->"41a767ac-0948-486e-ad67-68276213a197"
]

VerificationTest[(* 60 *)
	lazySetState[lazyPowerRange[start, r], newStart]
	,
	lazyList[newStart, Function[lazyList[Slot[1], Slot[0][Times[Slot[2], Slot[1]], Slot[2]]]][Times[r, newStart], r]]	
	,
	TestID->"17271240-7711-4341-9f6b-d73ae952bafb"
]

VerificationTest[(* 61 *)
	lazySetState[lazyNestList[f, start], newStart]
	,
	lazyList[newStart, Function[lazyList[Slot[1], Slot[0][f[Slot[1]], Plus[Slot[2], 1]]]][f[newStart], Plus[2, 1]]]	
	,
	TestID->"85d28eb3-0b69-4023-9a62-e0bca0fea29a"
]

VerificationTest[(* 62 *)
	Set[lz, partitionedLazyRange[start, step, 5]]
	,
	partitionedLazyList[List[start, Plus[start, step], Plus[start, Times[2, step]], Plus[start, Times[3, step]], Plus[start, Times[4, step]]], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[Times[5, step], List[start, Plus[start, step], Plus[start, Times[2, step]], Plus[start, Times[3, step]], Plus[start, Times[4, step]]]], Times[5, step]]]]	
	,
	TestID->"e48434ad-194e-4c1d-9181-bafefa2cd018"
]

VerificationTest[(* 63 *)
	First[Take[lz, 20]]
	,
	start	
	,
	TestID->"d1633934-c1bb-4947-a9ac-4f90c3f3a7da"
]

VerificationTest[(* 64 *)
	Most[Take[lz, 20]]
	,
	List[start, Plus[start, step], Plus[start, Times[2, step]], Plus[start, Times[3, step]], Plus[start, Times[4, step]], Plus[start, Times[5, step]], Plus[start, Times[6, step]], Plus[start, Times[7, step]], Plus[start, Times[8, step]], Plus[start, Times[9, step]], Plus[start, Times[10, step]], Plus[start, Times[11, step]], Plus[start, Times[12, step]], Plus[start, Times[13, step]], Plus[start, Times[14, step]], Plus[start, Times[15, step]], Plus[start, Times[16, step]], Plus[start, Times[17, step]], Plus[start, Times[18, step]], Plus[start, Times[19, step]]]	
	,
	TestID->"e3c13e65-15f5-40ab-a369-a0739f6ce9cd"
]

VerificationTest[(* 65 *)
	partitionedLazyList[List[1, 2, 3, endOfLazyList, otherStuff], anyTail]
	,
	partitionedLazyList[List[1, 2, 3], lazyList[]]	
	,
	TestID->"94817bc0-0d2d-4936-a5db-71739d8c11d6"
]

VerificationTest[(* 66 *)
	Set[rangeRange, partitionedLazyList[lazyGenerator[Range, 1, 1, 8]]]
	,
	partitionedLazyList[List[1], partitionedLazyList[lazyLists`Private`finiteGenerator[Range, Plus[1, 1], 1, 8, 1]]]	
	,
	TestID->"abbb180b-6296-4777-ac14-9878e48e5e91"
]

VerificationTest[(* 67 *)
	Most[Take[rangeRange, 20]]
	,
	List[1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5]	
	,
	TestID->"51609d85-e54a-44ed-91d9-4b64c4990fe4"
]

VerificationTest[(* 68 *)
	Most[Take[rangeRange, List[18, 5, -3]]]
	,
	List[3, 5, 2, 3, 3]	
	,
	TestID->"820df117-1d98-44c2-a62a-edec62a21a0a"
]

VerificationTest[(* 69 *)
	Most[Take[rangeRange, List[5, 18, 3]]]
	,
	List[2, 2, 1, 4, 2]	
	,
	TestID->"6dcf221b-d910-4a2e-b4e3-86711adeb89f"
]

VerificationTest[(* 70 *)
	lazyPartition[lazyRange[], 5]
	,
	partitionedLazyList[List[1, 2, 3, 4, 5], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1], 5]]	
	,
	TestID->"9a72acee-8279-49cc-b52e-428f405cc087"
]

VerificationTest[(* 71 *)
	lazyPartition[rangeRange, 5]
	,
	partitionedLazyList[List[1, 1, 2, 1, 2], lazyPartition[partitionedLazyList[List[3], partitionedLazyList[lazyLists`Private`finiteGenerator[Range, Plus[3, 1], 1, 8, 1]]], 5]]	
	,
	TestID->"e007465e-1e97-47b0-be7c-b8aac867396c"
]

VerificationTest[(* 72 *)
	lazyPartition[lazyPartition[lazyRange[], 5], 10]
	,
	partitionedLazyList[List[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], partitionedLazyList[List[11, 12, 13, 14, 15], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 15], 1], 10]]]	
	,
	TestID->"82525b95-d50e-41ef-b3f4-c8dc4e471c7e"
]

VerificationTest[(* 73 *)
	Reap[Most[Take[Map[Function[Sqrt[Sow[Slot[1]]]], partitionedLazyRange[3]], 4]]]
	,
	List[List[1, Sqrt[2], Sqrt[3], 2], List[List[1, 2, 3, 4, 5, 6]]]	
	,
	TestID->"6440fb8d-a118-491f-88fd-43fd54af5daf"
]

VerificationTest[(* 74 *)
	Reap[Most[Take[Map[List[Function[Sqrt[Sow[Slot[1]]]], Listable], partitionedLazyRange[3]], 4]]]
	,
	List[List[1, Sqrt[2], Sqrt[3], 2], List[List[List[1, 2, 3], List[4, 5, 6]]]]	
	,
	TestID->"aff39ed4-8213-41e6-8228-aeceabbf621c"
]

VerificationTest[(* 75 *)
	CompoundExpression[Set[lists, List[List[a, b, c], List[1, 2], List[u, v, w, x, y, z]]], Set[lzTup, lazyTuples[lists, Rule["PartitionSize", 10]]], MatchQ[lzTup, partitionedLazyList[List[List[a, 1, u], List[a, 1, v], List[a, 1, w], List[a, 1, x], List[a, 1, y], List[a, 1, z], List[a, 2, u], List[a, 2, v], List[a, 2, w], List[a, 2, x]], Blank[Map]]]]
	,
	True	
	,
	TestID->"24b2d102-74b8-448e-b98e-e96436dc4582"
]

VerificationTest[(* 76 *)
	Most[Take[lzTup, All]]
	,
	Tuples[lists]	
	,
	TestID->"7e1cd504-6344-4ea6-945b-c5c473fce372"
]

VerificationTest[(* 77 *)
	Most[Take[lazyTuples[List[a, b, c], 5], 10]]
	,
	Take[Tuples[List[a, b, c], 5], 10]	
	,
	TestID->"2504436e-333c-4451-8e5c-5008d03ff2e1"
]

VerificationTest[(* 78 *)
	CompoundExpression[Set[largeLists, Map[Range, List[50, 40, 60, 80]]], Most[Take[lazyTuples[Hold[largeLists]], 10]]]
	,
	List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 1, 3], List[1, 1, 1, 4], List[1, 1, 1, 5], List[1, 1, 1, 6], List[1, 1, 1, 7], List[1, 1, 1, 8], List[1, 1, 1, 9], List[1, 1, 1, 10]]	
	,
	TestID->"049881ce-6fad-454f-b4d5-405e0871d698"
]

VerificationTest[(* 79 *)
	Most[Take[lazyTuples[Hold[largeLists], Rule["PartitionSize", 1000]], 100]]
	,
	List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 1, 3], List[1, 1, 1, 4], List[1, 1, 1, 5], List[1, 1, 1, 6], List[1, 1, 1, 7], List[1, 1, 1, 8], List[1, 1, 1, 9], List[1, 1, 1, 10], List[1, 1, 1, 11], List[1, 1, 1, 12], List[1, 1, 1, 13], List[1, 1, 1, 14], List[1, 1, 1, 15], List[1, 1, 1, 16], List[1, 1, 1, 17], List[1, 1, 1, 18], List[1, 1, 1, 19], List[1, 1, 1, 20], List[1, 1, 1, 21], List[1, 1, 1, 22], List[1, 1, 1, 23], List[1, 1, 1, 24], List[1, 1, 1, 25], List[1, 1, 1, 26], List[1, 1, 1, 27], List[1, 1, 1, 28], List[1, 1, 1, 29], List[1, 1, 1, 30], List[1, 1, 1, 31], List[1, 1, 1, 32], List[1, 1, 1, 33], List[1, 1, 1, 34], List[1, 1, 1, 35], List[1, 1, 1, 36], List[1, 1, 1, 37], List[1, 1, 1, 38], List[1, 1, 1, 39], List[1, 1, 1, 40], List[1, 1, 1, 41], List[1, 1, 1, 42], List[1, 1, 1, 43], List[1, 1, 1, 44], List[1, 1, 1, 45], List[1, 1, 1, 46], List[1, 1, 1, 47], List[1, 1, 1, 48], List[1, 1, 1, 49], List[1, 1, 1, 50], List[1, 1, 1, 51], List[1, 1, 1, 52], List[1, 1, 1, 53], List[1, 1, 1, 54], List[1, 1, 1, 55], List[1, 1, 1, 56], List[1, 1, 1, 57], List[1, 1, 1, 58], List[1, 1, 1, 59], List[1, 1, 1, 60], List[1, 1, 1, 61], List[1, 1, 1, 62], List[1, 1, 1, 63], List[1, 1, 1, 64], List[1, 1, 1, 65], List[1, 1, 1, 66], List[1, 1, 1, 67], List[1, 1, 1, 68], List[1, 1, 1, 69], List[1, 1, 1, 70], List[1, 1, 1, 71], List[1, 1, 1, 72], List[1, 1, 1, 73], List[1, 1, 1, 74], List[1, 1, 1, 75], List[1, 1, 1, 76], List[1, 1, 1, 77], List[1, 1, 1, 78], List[1, 1, 1, 79], List[1, 1, 1, 80], List[1, 1, 2, 1], List[1, 1, 2, 2], List[1, 1, 2, 3], List[1, 1, 2, 4], List[1, 1, 2, 5], List[1, 1, 2, 6], List[1, 1, 2, 7], List[1, 1, 2, 8], List[1, 1, 2, 9], List[1, 1, 2, 10], List[1, 1, 2, 11], List[1, 1, 2, 12], List[1, 1, 2, 13], List[1, 1, 2, 14], List[1, 1, 2, 15], List[1, 1, 2, 16], List[1, 1, 2, 17], List[1, 1, 2, 18], List[1, 1, 2, 19], List[1, 1, 2, 20]]	
	,
	TestID->"0a6ccfa4-19db-450c-91fe-c3131cfa38b5"
]

VerificationTest[(* 80 *)
	CompoundExpression[Set[integers, Map[Length, lists]], Set[integerLzTup, lazyTuples[integers]], MatchQ[integerLzTup, partitionedLazyList[List[List[1, 1, 1], List[1, 1, 2], List[1, 1, 3], List[1, 1, 4], List[1, 1, 5], List[1, 1, 6], List[1, 2, 1], List[1, 2, 2], List[1, 2, 3], List[1, 2, 4]], Blank[Map]]]]
	,
	True	
	,
	TestID->"abe8de04-193c-434c-9de1-f0e74ad365d8"
]

VerificationTest[(* 81 *)
	Set[indices, Most[Take[integerLzTup, 10]]]
	,
	List[List[1, 1, 1], List[1, 1, 2], List[1, 1, 3], List[1, 1, 4], List[1, 1, 5], List[1, 1, 6], List[1, 2, 1], List[1, 2, 2], List[1, 2, 3], List[1, 2, 4]]	
	,
	TestID->"1dc8febd-3448-49d6-be28-1ccd6ec9c3a9"
]

VerificationTest[(* 82 *)
	Take[Tuples[Map[Range, integers]], 10]
	,
	List[List[1, 1, 1], List[1, 1, 2], List[1, 1, 3], List[1, 1, 4], List[1, 1, 5], List[1, 1, 6], List[1, 2, 1], List[1, 2, 2], List[1, 2, 3], List[1, 2, 4]]	
	,
	TestID->"4d3ad108-8eda-4b86-b437-4ae9f711021e"
]

VerificationTest[(* 83 *)
	bulkExtractElementsUsingIndexList[lists][Transpose[indices]]
	,
	Take[Tuples[lists], 10]	
	,
	TestID->"aba8a778-a2ca-4ee0-b9cd-836bd89bf9f2"
]

VerificationTest[(* 84 *)
	bulkExtractElementsUsingIndexList[Hold[lists]][Transpose[indices]]
	,
	Take[Tuples[lists], 10]	
	,
	TestID->"cddc03cf-2e55-41ff-8f12-cfaf4b33ac36"
]

VerificationTest[(* 85 *)
	Module[List[Set[list, List[a, b, c, d, e]], Set[tupLength, 3], indices], CompoundExpression[Set[indices, Most[Take[lazyTuples[Range[Length[list]], tupLength], 10]]], bulkExtractElementsUsingIndexList[list, tupLength][Transpose[indices]]]]
	,
	Take[Tuples[List[a, b, c, d, e], 3], 10]	
	,
	TestID->"2cfc8d44-a522-49e1-a6d3-b57badf7858e"
]

VerificationTest[(* 86 *)
	Most[Take[lazyTuples[integers, Rule["Start", 10]], 11]]
	,
	List[List[1, 2, 4], List[1, 2, 5], List[1, 2, 6], List[2, 1, 1], List[2, 1, 2], List[2, 1, 3], List[2, 1, 4], List[2, 1, 5], List[2, 1, 6], List[2, 2, 1], List[2, 2, 2]]	
	,
	TestID->"6d6b52ee-9463-4ee8-be50-d35a81016de8"
]

VerificationTest[(* 87 *)
	Take[Tuples[Map[Range, integers]], List[10, 20]]
	,
	List[List[1, 2, 4], List[1, 2, 5], List[1, 2, 6], List[2, 1, 1], List[2, 1, 2], List[2, 1, 3], List[2, 1, 4], List[2, 1, 5], List[2, 1, 6], List[2, 2, 1], List[2, 2, 2]]	
	,
	TestID->"265a55bb-649d-416f-9440-2683e88bd339"
]

VerificationTest[(* 88 *)
	CompoundExpression[Set[tuplesGenerator, rangeTuplesAtPositions[integers]], SameQ[Head[tuplesGenerator], CompiledFunction]]
	,
	True	
	,
	TestID->"6039388a-a7fb-41f9-af49-0a1d7879ba7a"
]

VerificationTest[(* 89 *)
	CompoundExpression[Set[randomPositions, RandomInteger[List[1, Apply[Times, integers]], 10]], MatchQ[randomPositions, List[BlankSequence[Integer]]]]
	,
	True	
	,
	TestID->"89cad6c5-e497-4ab9-90a4-68a3e04af6ea"
]

VerificationTest[(* 90 *)
	tuplesGenerator[randomPositions]
	,
	Transpose[Part[Tuples[Map[Range, integers]], randomPositions]]	
	,
	TestID->"84552981-9693-4342-93a1-48f1974e46dc"
]

VerificationTest[(* 91 *)
	CompoundExpression[Set[infTuples, lazyTuples[4]], MatchQ[infTuples, partitionedLazyList[List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 2, 1], List[1, 2, 1, 1], List[2, 1, 1, 1], List[1, 1, 1, 3], List[1, 1, 2, 2], List[1, 1, 3, 1], List[1, 2, 1, 2], List[1, 2, 2, 1]], Blank[]]]]
	,
	True	
	,
	TestID->"78889fbc-8259-4d38-97ef-1b93bd574df7"
]

VerificationTest[(* 92 *)
	Most[Take[infTuples, 75]]
	,
	List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 2, 1], List[1, 2, 1, 1], List[2, 1, 1, 1], List[1, 1, 1, 3], List[1, 1, 2, 2], List[1, 1, 3, 1], List[1, 2, 1, 2], List[1, 2, 2, 1], List[1, 3, 1, 1], List[2, 1, 1, 2], List[2, 1, 2, 1], List[2, 2, 1, 1], List[3, 1, 1, 1], List[1, 1, 1, 4], List[1, 1, 2, 3], List[1, 1, 3, 2], List[1, 1, 4, 1], List[1, 2, 1, 3], List[1, 2, 2, 2], List[1, 2, 3, 1], List[1, 3, 1, 2], List[1, 3, 2, 1], List[1, 4, 1, 1], List[2, 1, 1, 3], List[2, 1, 2, 2], List[2, 1, 3, 1], List[2, 2, 1, 2], List[2, 2, 2, 1], List[2, 3, 1, 1], List[3, 1, 1, 2], List[3, 1, 2, 1], List[3, 2, 1, 1], List[4, 1, 1, 1], List[1, 1, 1, 5], List[1, 1, 2, 4], List[1, 1, 3, 3], List[1, 1, 4, 2], List[1, 1, 5, 1], List[1, 2, 1, 4], List[1, 2, 2, 3], List[1, 2, 3, 2], List[1, 2, 4, 1], List[1, 3, 1, 3], List[1, 3, 2, 2], List[1, 3, 3, 1], List[1, 4, 1, 2], List[1, 4, 2, 1], List[1, 5, 1, 1], List[2, 1, 1, 4], List[2, 1, 2, 3], List[2, 1, 3, 2], List[2, 1, 4, 1], List[2, 2, 1, 3], List[2, 2, 2, 2], List[2, 2, 3, 1], List[2, 3, 1, 2], List[2, 3, 2, 1], List[2, 4, 1, 1], List[3, 1, 1, 3], List[3, 1, 2, 2], List[3, 1, 3, 1], List[3, 2, 1, 2], List[3, 2, 2, 1], List[3, 3, 1, 1], List[4, 1, 1, 2], List[4, 1, 2, 1], List[4, 2, 1, 1], List[5, 1, 1, 1], List[1, 1, 1, 6], List[1, 1, 2, 5], List[1, 1, 3, 4], List[1, 1, 4, 3], List[1, 1, 5, 2]]	
	,
	TestID->"c70e9cab-91be-484e-883e-2f0f1f811260"
]

VerificationTest[(* 93 *)
	Sort[Select[Most[Take[infTuples, 75]], Function[Less[Total[Slot[1]], 9]]]]
	,
	Sort[Select[Tuples[Range[10], 4], Function[Less[Total[Slot[1]], 9]]]]	
	,
	TestID->"aa1b845f-e3c7-4baa-85ae-d14d3a58ac3e"
]

VerificationTest[(* 94 *)
	Most[Take[lazyTuples[4, List[1, 4, 10, 2]], 20]]
	,
	List[List[1, 4, 10, 2], List[1, 4, 11, 1], List[1, 5, 1, 10], List[1, 5, 2, 9], List[1, 5, 3, 8], List[1, 5, 4, 7], List[1, 5, 5, 6], List[1, 5, 6, 5], List[1, 5, 7, 4], List[1, 5, 8, 3], List[1, 5, 9, 2], List[1, 5, 10, 1], List[1, 6, 1, 9], List[1, 6, 2, 8], List[1, 6, 3, 7], List[1, 6, 4, 6], List[1, 6, 5, 5], List[1, 6, 6, 4], List[1, 6, 7, 3], List[1, 6, 8, 2]]	
	,
	TestID->"f3adf59a-4b10-4bd6-8798-52b9ea706312"
]

VerificationTest[(* 95 *)
	CompoundExpression[Set[stmp, OpenWrite["tmp"]], Write[stmp, a, b, c], Write[stmp, x], Write[stmp, "Hello"], Write[stmp, "Hello"], Write[stmp, "Hello"], Close[stmp]]
	,
	"tmp"	
	,
	TestID->"0f990c29-bc3b-4212-b56f-dd4fc18990e6"
]

VerificationTest[(* 96 *)
	Module[List[Set[stream, OpenRead["tmp"]], result], CompoundExpression[Set[result, First[Take[lazyStream[stream], 3]]], Close[stream], result]]
	,
	List[abc, x, "Hello"]	
	,
	TestID->"52120357-4e6a-4818-9638-c55b4ec44945"
]

VerificationTest[(* 97 *)
	Module[List[Set[stream, OpenRead["tmp"]], result], CompoundExpression[Set[result, First[TakeWhile[lazyStream[stream], Function[True]]]], Close[stream], DeleteFile["tmp"], result]]
	,
	List[abc, x, "Hello", "Hello", "Hello", EndOfFile]	
	,
	TestID->"3a10c3aa-3bf6-467b-9474-a4f28c714065"
]

VerificationTest[(* 98 *)
	First[Take[Plus[lazyRange[], lazyRange[2]], 5]]
	,
	List[3, 5, 7, 9, 11]	
	,
	TestID->"10ffdd73-035c-4ba5-a271-64a4e1bf04b9"
]

VerificationTest[(* 99 *)
	First[Take[Plus[Times[2, lazyRange[]], Times[3, lazyRange[1, 2]]], 5]]
	,
	List[5, 13, 21, 29, 37]	
	,
	TestID->"d7ff3a30-f6b5-4d8a-9ab2-ff7f8ed70d73"
]

VerificationTest[(* 100 *)
	First[Take[Power[lazyRange[], lazyRange[]], 5]]
	,
	List[1, 4, 27, 256, 3125]	
	,
	TestID->"cb32bc98-d965-431f-9f96-3ada1f100757"
]

VerificationTest[(* 101 *)
	First[Take[Divide[1, lazyRange[2, 2]], 5]]
	,
	List[Times[1, Power[2, -1]], Times[1, Power[4, -1]], Times[1, Power[6, -1]], Times[1, Power[8, -1]], Times[1, Power[10, -1]]]	
	,
	TestID->"88f9cdf0-0340-44dd-9935-af0cfe6259f5"
]

VerificationTest[(* 102 *)
	setLazyListable[listableSymbol]
	,
	listableSymbol	
	,
	TestID->"160be7e3-bf2c-448e-91f6-7bbd9a33e714"
]

VerificationTest[(* 103 *)
	First[Take[listableSymbol[lazyRange[], lazyRange[2], 5], 5]]
	,
	List[listableSymbol[1, 2, 5], listableSymbol[2, 3, 5], listableSymbol[3, 4, 5], listableSymbol[4, 5, 5], listableSymbol[5, 6, 5]]	
	,
	TestID->"c7310b38-f3a8-455d-920e-531b0051796e"
]

VerificationTest[(* 104 *)
	SetAttributes[listableSymbol, List[Listable]]
	,
	Null	
	,
	TestID->"f5a4e14c-dc83-40fe-91f5-21b4cd822967"
]

VerificationTest[(* 105 *)
	listableSymbol[lazyRange[], lazyRange[2], 5, List[1, 2]]
	,
	List[lazyList[listableSymbol[1, 2, 5, 1], listableSymbol[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1], 5, 1]], lazyList[listableSymbol[1, 2, 5, 2], listableSymbol[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1], 5, 2]]]	
	,
	TestID->"56038233-6e7c-403b-bd23-ff528dab83bf"
]

VerificationTest[(* 106 *)
	Plus[lazyPartition[lazyRange[], 3], lazyRange[]]
	,
	lazyList[partitionedLazyList[List[2, 3, 4], Plus[lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 3], 1], 3], 1]], Plus[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], partitionedLazyList[List[1, 2, 3], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 3], 1], 3]]]]	
	,
	TestID->"34f45468-23b2-4a28-b664-75d96b3a95a6"
]

VerificationTest[(* 107 *)
	Most[Take[Plus[Times[a, partitionedLazyList[lazyGenerator[Range, 1, 1]]], Times[b, Power[partitionedLazyList[lazyGenerator[Range, 2, 2]], -1]]], 5]]
	,
	List[Plus[a, b], Plus[a, Times[b, Power[2, -1]]], Plus[Times[2, a], b], Plus[a, Times[b, Power[2, -1]]], Plus[Times[2, a], Times[b, Power[3, -1]]]]	
	,
	TestID->"c11cacfe-c700-4812-8a51-95a151ee3eaf"
]

VerificationTest[(* 108 *)
	Most[Plus[partitionedLazyRange[3], partitionedLazyRange[5], partitionedLazyRange[6]]]
	,
	List[3, 6, 9, 12, 15, 18]	
	,
	TestID->"b19f5a9c-bda9-4c9e-9d66-abbe90d7064d"
]

VerificationTest[(* 109 *)
	setLazyListable[List[Sin, Listable]]
	,
	Sin	
	,
	TestID->"33e34634-2c70-48c3-867d-7d1129c95903"
]

VerificationTest[(* 110 *)
	Most[Sin[partitionedLazyRange[10]]]
	,
	List[Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[9], Sin[10]]	
	,
	TestID->"1cc79346-5d1d-4988-b0ce-81b7ae7f4be7"
]

VerificationTest[(* 111 *)
	Map[Sqrt, lazyRange[0, 2]]
	,
	lazyList[0, Map[Sqrt, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[2, 0], 2]]]	
	,
	TestID->"c6d789ea-cab2-47f5-b533-b8d08cbea2f1"
]

VerificationTest[(* 112 *)
	First[Take[Map[Sqrt, lazyRange[0, 2]], 5]]
	,
	List[0, Sqrt[2], 2, Sqrt[6], Times[2, Sqrt[2]]]	
	,
	TestID->"8e897f69-0991-43b0-a47e-33c4c2ad2605"
]

VerificationTest[(* 113 *)
	Map[Sqrt, Map[Exp, Map[Sin, lazyRange[]]]]
	,
	lazyList[Power[E, Times[Sin[1], Power[2, -1]]], Map[Composition[Sqrt, Exp, Sin], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1]]]	
	,
	TestID->"fb24aab4-c206-439c-9a7b-3f300593d086"
]

VerificationTest[(* 114 *)
	Map[Sqrt, Map[Exp, lazyGenerator[Sin]]]
	,
	lazyList[Power[E, Times[Sin[1], Power[2, -1]]], lazyLists`Private`twoSidedGenerator[Composition[Sqrt, Exp, Sin], Plus[1, 1], 1]]	
	,
	TestID->"f152549d-6a7c-4270-a618-b0ee9d3c21a9"
]

VerificationTest[(* 115 *)
	Take[Map[List[someFunction, Listable], partitionedLazyRange[3]], 4]
	,
	lazyList[]
	,
	{lazyList::take}
	,
	TestID->"e590682e-ebf3-47af-b876-76df923fbbb8"
]

VerificationTest[(* 116 *)
	FoldList[Plus, x0, lazyRange[n, m]]
	,
	lazyList[x0, FoldList[Plus, Plus[x0, n], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[m, n], m]]]	
	,
	TestID->"78ede253-0641-40d1-91a6-ada7c363db06"
]

VerificationTest[(* 117 *)
	First[Take[FoldList[Plus, x0, lazyRange[n, m]], 5]]
	,
	List[x0, Plus[n, x0], Plus[m, Times[2, n], x0], Plus[Times[3, m], Times[3, n], x0], Plus[Times[6, m], Times[4, n], x0]]	
	,
	TestID->"db188c97-bab5-4d20-9c9c-d317201c07d3"
]

VerificationTest[(* 118 *)
	First[Take[FoldPairList[Function[List[p[Slot[1], Slot[2]], q[Slot[1], Slot[2]]]], u, lazyRange[]], 4]]
	,
	List[p[u, 1], p[q[u, 1], 2], p[q[q[u, 1], 2], 3], p[q[q[q[u, 1], 2], 3], 4]]	
	,
	TestID->"22e0751b-1a8b-4c64-ab0d-7d245c004db7"
]

VerificationTest[(* 119 *)
	MatchQ[Cases[lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], lazyList[0, Blank[]]]
	,
	True	
	,
	TestID->"eef58711-9a2b-4adf-bb35-fd6ddc3b49a1"
]

VerificationTest[(* 120 *)
	First[Take[Cases[lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], 5]]
	,
	List[0, 2, 4, 6, 8]	
	,
	TestID->"1c11a617-94ea-42b9-bf57-ccb346d33046"
]

VerificationTest[(* 121 *)
	MatchQ[Pick[lazyRange[0, 2], lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], lazyList[0, Blank[]]]
	,
	True	
	,
	TestID->"df1ac686-6c55-4310-b8be-df2063f48b70"
]

VerificationTest[(* 122 *)
	First[Take[Pick[lazyRange[0, 2], lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], 5]]
	,
	List[0, 6, 12, 18, 24]	
	,
	TestID->"232b3f69-ae25-4cc2-9e08-7fc39008ebff"
]

VerificationTest[(* 123 *)
	Select[lazyRange[], OddQ]
	,
	lazyList[1, Select[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], OddQ]]	
	,
	TestID->"8d8036f1-5720-4811-8629-7c25ce67842b"
]

VerificationTest[(* 124 *)
	First[Take[Select[lazyRange[], OddQ], 5]]
	,
	List[1, 3, 5, 7, 9]	
	,
	TestID->"2ff4ea71-a191-4c9f-9760-83fb52d4606d"
]

VerificationTest[(* 125 *)
	First[Take[MapIndexed[Function[List[Slot[1], Slot[2]]], lazyRange[2, 2]], 5]]
	,
	List[List[2, 1], List[4, 2], List[6, 3], List[8, 4], List[10, 5]]	
	,
	TestID->"755a2a31-5e94-41a8-b2bc-a72cb672099b"
]

VerificationTest[(* 126 *)
	First[Take[MapIndexed[Function[List[Slot[1], Slot[2]]], lazyRange[], 20], 5]]
	,
	List[List[1, 20], List[2, 21], List[3, 22], List[4, 23], List[5, 24]]	
	,
	TestID->"e7f47333-553c-4f61-bf2b-454329529868"
]

VerificationTest[(* 127 *)
	First[Take[lazyMapThread[f, List[lazyRange[], lazyRange[2, 2]]], 5]]
	,
	List[f[List[1, 2]], f[List[2, 4]], f[List[3, 6]], f[List[4, 8]], f[List[5, 10]]]	
	,
	TestID->"713e38e1-53ae-455a-bbf8-0bbc02d45524"
]

VerificationTest[(* 128 *)
	MapThread[f, List[Range[5], Times[2, Range[5]]]]
	,
	List[f[1, 2], f[2, 4], f[3, 6], f[4, 8], f[5, 10]]	
	,
	TestID->"04ba0346-ff2e-4659-8597-53624df2a10d"
]

VerificationTest[(* 129 *)
	First[Take[lazyMapThread[f, List[lazyRange[], Range[5]]], All]]
	,
	List[f[List[1, 1]], f[List[2, 2]], f[List[3, 3]], f[List[4, 4]], f[List[5, 5]]]	
	,
	TestID->"32188d20-9d34-4122-bf92-06bb3cf26702"
]

VerificationTest[(* 130 *)
	Most[Take[lazyMapThread[f, List[partitionedLazyList[Map[Range, lazyRange[]]], partitionedLazyRange[4], partitionedLazyRange[2, 2, 6]]], 10]]
	,
	List[f[1, 1, 2], f[1, 2, 4], f[2, 3, 6], f[1, 4, 8], f[2, 5, 10], f[3, 6, 12], f[1, 7, 14], f[2, 8, 16], f[3, 9, 18], f[4, 10, 20]]	
	,
	TestID->"1da06e68-9eab-497a-92fa-298cc059d2a2"
]

VerificationTest[(* 131 *)
	lazyMapThread[f, List[partitionedLazyRange[3], lazyRange[]]]
	,
	partitionedLazyList[List[f[1, 1], f[2, 2], f[3, 3]], lazyMapThread[f, List[partitionedLazyList[List[4, 5, 6], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[3, List[4, 5, 6]], 3]]], partitionedLazyList[List[4, 5, 6], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 6], 1], 3]]]]]	
	,
	TestID->"afa9dc39-c825-4926-a453-fdf3dc86c42d"
]

VerificationTest[(* 132 *)
	First[Take[lazyTranspose[List[lazyRange[], lazyRange[start]]], 5]]
	,
	List[List[1, start], List[2, Plus[1, start]], List[3, Plus[2, start]], List[4, Plus[3, start]], List[5, Plus[4, start]]]	
	,
	TestID->"6f32f0a8-9388-4926-998a-161b2cdd31a4"
]

VerificationTest[(* 133 *)
	First[Take[lazyMapThread[Identity, List[lazyRange[], lazyRange[start]]], 5]]
	,
	List[List[1, start], List[2, Plus[1, start]], List[3, Plus[2, start]], List[4, Plus[3, start]], List[5, Plus[4, start]]]	
	,
	TestID->"6d546c3e-83bb-4b12-832a-cc468addc674"
]

VerificationTest[(* 134 *)
	lazyCatenate[List[List[1, 2], List[2, 3, 4]]]
	,
	lazyList[1, lazyList[List[2, 2, 3, 4]]]	
	,
	TestID->"b2868662-c220-4ca5-9934-cf1408f55c4c"
]

VerificationTest[(* 135 *)
	First[Take[lazyCatenate[List[List[1, 2], List[2, 3, 4]]], All]]
	,
	List[1, 2, 2, 3, 4]	
	,
	TestID->"26cc958a-8c1c-46fb-8da0-897ff4d162d5"
]

VerificationTest[(* 136 *)
	First[Take[lazyCatenate[List[lazyGenerator[f, 1, 1, 5], lazyGenerator[g, 1, 1, 5]]], All]]
	,
	List[f[1], f[2], f[3], f[4], f[5], g[1], g[2], g[3], g[4], g[5]]	
	,
	TestID->"23dbb7e0-0165-415b-873b-c8ea5d62ef15"
]

VerificationTest[(* 137 *)
	First[Take[lazyCatenate[lazyGenerator[Range, 1, 1, 5]], All]]
	,
	List[1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5]	
	,
	TestID->"6b951aba-15c0-4b1d-942a-9a5eb2395281"
]

VerificationTest[(* 138 *)
	First[Take[lazyCatenate[lazyGenerator[Function[lazyGenerator[Subscript[f, Slot[1]], Slot[1], Slot[1], Plus[Slot[1], 3]]], 1, 1, 5]], All]]
	,
	List[Subscript[f, 1][1], Subscript[f, 1][2], Subscript[f, 1][3], Subscript[f, 1][4], Subscript[f, 2][2], Subscript[f, 2][3], Subscript[f, 2][4], Subscript[f, 2][5], Subscript[f, 3][3], Subscript[f, 3][4], Subscript[f, 3][5], Subscript[f, 3][6], Subscript[f, 4][4], Subscript[f, 4][5], Subscript[f, 4][6], Subscript[f, 4][7], Subscript[f, 5][5], Subscript[f, 5][6], Subscript[f, 5][7], Subscript[f, 5][8]]	
	,
	TestID->"5a550561-3bb0-4958-ae50-af45c4caf47c"
]

VerificationTest[(* 139 *)
	Set[badExample, Function[lazyList[1, Slot[0][]]][]]
	,
	lazyList[1, Function[lazyList[1, Slot[0][]]][]]	
	,
	TestID->"cca6f375-6ddb-4152-aa3d-2349457bc8e2"
]

VerificationTest[(* 140 *)
	Last[badExample]
	,
	badExample	
	,
	TestID->"d5669f68-30d9-4e7a-a0e0-4a892a683a43"
]

VerificationTest[(* 141 *)
	First[Take[badExample, 20]]
	,
	List[1, 1]	
	,
	TestID->"0820b214-6494-4848-9ae0-3811250773bb"
]

VerificationTest[(* 142 *)
	Set[example, Function[lazyList[1, Slot[0][Plus[Slot[1], 1]]]][1]]
	,
	lazyList[1, Function[lazyList[1, Slot[0][Plus[Slot[1], 1]]]][Plus[1, 1]]]	
	,
	TestID->"70bea84b-fb82-4ee1-8fff-c75fed296f60"
]

VerificationTest[(* 143 *)
	SameQ[example, Last[example]]
	,
	False	
	,
	TestID->"1346241a-d07f-43e4-b438-f6bb7f8bcc01"
]

VerificationTest[(* 144 *)
	Take[example, 20]
	,
	lazyList[List[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], Function[lazyList[1, Slot[0][Plus[Slot[1], 1]]]][Plus[20, 1]]]	
	,
	TestID->"8cc85caf-0ded-497b-bc70-c8c40b5ed440"
]

VerificationTest[(* 145 *)
	Set[position, Replace[Last[Take[example, 20]], List[RuleDelayed[lazyList[Blank[], Function[BlankSequence[]][Pattern[i, Blank[]]]], i]]]]
	,
	22	
	,
	TestID->"276824c8-0ef1-470e-ab70-bcf516bda143"
]

EndTestSection[]
