BeginTestSection["VerificationTests"]

BeginTestSection["Initialisation"]

VerificationTest[(* 1 *)
	CompoundExpression[Set[$HistoryLength, 10], With[List[Set[dir, If[Quiet[TrueQ[FileExistsQ[$TestFileName]]], DirectoryName[$TestFileName], NotebookDirectory[]]]], SetDirectory[dir]], Quiet[Get["lazyLists`"]], ClearAll["Global`*"], "Done"]
	,
	"Done"	
	,
	TestID->"429d6b44-7f18-408a-a11b-af3070fbdc57"
]

EndTestSection[]

BeginTestSection["Normal lazy lists"]

BeginTestSection["Elementary tests"]

VerificationTest[(* 2 *)
	lazyList[List[]]
	,
	lazyList[]	
	,
	TestID->"0aa677fe-81d8-4776-8b22-218127c5e3f3"
]

VerificationTest[(* 3 *)
	lazyList[Nothing, "stuff"]
	,
	"stuff"	
	,
	TestID->"aab229e7-6fe6-4877-b94d-e6384e43ffe5"
]

VerificationTest[(* 4 *)
	lazyList[Range[10]]
	,
	lazyList[1, lazyList[List[2, 3, 4, 5, 6, 7, 8, 9, 10]]]	
	,
	TestID->"906af855-65d9-4a0f-8f45-8b9e50ea4bbe"
]

EndTestSection[]

BeginTestSection["lazyGenerator"]

VerificationTest[(* 5 *)
	lazyGenerator[f]
	,
	lazyList[f[1], lazyLists`Private`twoSidedGenerator[f, Plus[1, 1], 1]]	
	,
	TestID->"85cf9838-9b39-4011-816a-fcca14ff538a"
]

VerificationTest[(* 6 *)
	lazyGenerator[f, 2]
	,
	lazyList[f[2], lazyLists`Private`twoSidedGenerator[f, Plus[2, 1], 1]]	
	,
	TestID->"3327cab0-d7aa-4997-8b45-21e81e4fe2c8"
]

VerificationTest[(* 7 *)
	lazyGenerator[f, 2, -1]
	,
	lazyList[f[2], lazyLists`Private`rightSidedGenerator[f, Plus[2, 1], -1, 1]]	
	,
	TestID->"cc912d94-a5c6-499e-baf8-0d31abd12bc0"
]

VerificationTest[(* 8 *)
	lazyGenerator[f, 2, 3]
	,
	lazyList[]
	,
	{lazyGenerator::badSpec}
	,
	TestID->"8d8a181a-232e-4002-832a-84251bae6c14"
]

VerificationTest[(* 9 *)
	lazySetState[lazyGenerator[f, 2, -1], -1]
	,
	lazyList[f[-1], lazyLists`Private`rightSidedGenerator[f, Plus[-1, 1], -1, 1]]	
	,
	TestID->"f984074f-5977-48f6-90ee-804563196302"
]

VerificationTest[(* 10 *)
	lazySetState[lazyGenerator[f, 2, -1], -2]
	,
	lazyList[f[2], lazyLists`Private`rightSidedGenerator[f, Plus[2, 1], -1, 1]]
	,
	{Part::partw}
	,
	TestID->"e5c1e524-3ba2-43b0-b8f1-f27ba41461ce"
]

VerificationTest[(* 11 *)
	lazyGenerator[f, 2, Times[-1, Infinity]]
	,
	lazyList[f[2], lazyLists`Private`twoSidedGenerator[f, Plus[2, 1], 1]]	
	,
	TestID->"97b46cdb-8023-415c-8dd6-2ed4c695aa28"
]

VerificationTest[(* 12 *)
	lazyGenerator[f, -1, Times[-1, Infinity], 3]
	,
	lazyList[f[-1], lazyLists`Private`leftSidedGenerator[f, Plus[-1, 1], 3, 1]]	
	,
	TestID->"e1c956b5-2151-43f7-8b7e-5ff206119768"
]

VerificationTest[(* 13 *)
	lazyGenerator[f, 4, Times[-1, Infinity], 3]
	,
	lazyList[]
	,
	{lazyGenerator::badSpec}
	,
	TestID->"8c7e86ea-620b-44ab-8aa2-db140ee35dc8"
]

VerificationTest[(* 14 *)
	lazySetState[lazyGenerator[f, -1, Times[-1, Infinity], 3], 2]
	,
	lazyList[f[2], lazyLists`Private`leftSidedGenerator[f, Plus[2, 1], 3, 1]]	
	,
	TestID->"98c938f6-fac2-4cc9-95fb-c832d1147566"
]

VerificationTest[(* 15 *)
	lazySetState[lazyGenerator[f, -1, Times[-1, Infinity], 3], 4]
	,
	lazyList[f[-1], lazyLists`Private`leftSidedGenerator[f, Plus[-1, 1], 3, 1]]
	,
	{Part::partw}
	,
	TestID->"c916b38f-189f-4976-a05c-81f6f5de2fae"
]

VerificationTest[(* 16 *)
	lazyGenerator[f, -1, -3, 3]
	,
	lazyList[f[-1], lazyLists`Private`finiteGenerator[f, Plus[-1, 1], -3, 3, 1]]	
	,
	TestID->"3a1febb1-5752-484e-ab0e-9d9bb308b1aa"
]

VerificationTest[(* 17 *)
	lazyGenerator[f, -4, -3, 3]
	,
	lazyList[]
	,
	{lazyGenerator::badSpec}
	,
	TestID->"da930bb9-74f3-4be8-adde-86d727d0db26"
]

VerificationTest[(* 18 *)
	lazyGenerator[f, 4, -3, 3]
	,
	lazyList[]
	,
	{lazyGenerator::badSpec}
	,
	TestID->"8063f64e-dd4e-4afa-82ca-728521dba0e5"
]

VerificationTest[(* 19 *)
	lazySetState[lazyGenerator[f, -1, -3, 3], 2]
	,
	lazyList[f[2], lazyLists`Private`finiteGenerator[f, Plus[2, 1], -3, 3, 1]]	
	,
	TestID->"cbb5d08c-2a18-491c-abbb-c81f5dc99a56"
]

VerificationTest[(* 20 *)
	lazySetState[lazyGenerator[f, -1, -3, 3], 4]
	,
	lazyList[f[-1], lazyLists`Private`finiteGenerator[f, Plus[-1, 1], -3, 3, 1]]
	,
	{Part::partw}
	,
	TestID->"4ba95654-41db-45e9-a5c3-e270b62d5e8c"
]

VerificationTest[(* 21 *)
	lazySetState[lazyGenerator[f, -1, -3, 3], -4]
	,
	lazyList[f[-1], lazyLists`Private`finiteGenerator[f, Plus[-1, 1], -3, 3, 1]]
	,
	{Part::partw}
	,
	TestID->"ab0b420c-b3a3-4a33-9395-035ca9c2ada2"
]

VerificationTest[(* 22 *)
	Set[symbolicGenerator, lazyGenerator[f, start, Times[-1, Infinity], Infinity, step]]
	,
	lazyList[f[start], lazyLists`Private`twoSidedGenerator[f, Plus[start, step], step]]	
	,
	TestID->"e9ed830c-b556-4951-868b-db5959c367f7"
]

VerificationTest[(* 23 *)
	First[symbolicGenerator]
	,
	f[start]	
	,
	TestID->"03b84bb1-f51d-4db8-8121-cedb17db058e"
]

VerificationTest[(* 24 *)
	Rest[symbolicGenerator]
	,
	lazyList[f[Plus[start, step]], lazyLists`Private`twoSidedGenerator[f, Plus[Plus[start, step], step], step]]	
	,
	TestID->"ffc71697-2ed6-473e-9aa6-f1ab34671b59"
]

VerificationTest[(* 25 *)
	Most[symbolicGenerator]
	,
	List[f[start]]	
	,
	TestID->"b184721d-1ebf-4a52-b653-c207188109bf"
]

VerificationTest[(* 26 *)
	Last[symbolicGenerator]
	,
	lazyList[f[Plus[start, step]], lazyLists`Private`twoSidedGenerator[f, Plus[Plus[start, step], step], step]]	
	,
	TestID->"7c737812-143f-476b-a401-9e63785cb078"
]

VerificationTest[(* 27 *)
	First[Take[symbolicGenerator, 5]]
	,
	List[f[start], f[Plus[start, step]], f[Plus[start, Times[2, step]]], f[Plus[start, Times[3, step]]], f[Plus[start, Times[4, step]]]]	
	,
	TestID->"08ed6fb4-ba7e-4b2c-af71-c73815d1f2ae"
]

VerificationTest[(* 28 *)
	First[Take[lazyGenerator[f, 2, 1, 10, 2], 50]]
	,
	List[f[2], f[4], f[6], f[8], f[10]]	
	,
	TestID->"c1fb5cd2-752c-4f59-a9e0-1ccded5e3e9c"
]

VerificationTest[(* 29 *)
	Take[lazyGenerator[f, 2, 1, 10, 2], All]
	,
	lazyList[List[f[2], f[4], f[6], f[8], f[10]], lazyList[]]	
	,
	TestID->"e955f0bb-c384-4afa-86f8-e4a14194aab4"
]

VerificationTest[(* 30 *)
	LengthWhile[lazyGenerator[f, 2, 1, 10, 2]]
	,
	Association[Rule["Index", 5], Rule["Element", lazyList[f[10], lazyList[]]]]	
	,
	TestID->"aaba755e-f009-4647-9b80-513c0b1fbbc1"
]

VerificationTest[(* 31 *)
	Part[lazyGenerator[f, 2, 1, 10, 2], List[-1]]
	,
	lazyList[f[10], lazyList[]]	
	,
	TestID->"f1a60652-a2d1-4d3d-bd51-b266b6fb7327"
]

VerificationTest[(* 32 *)
	Part[lazyGenerator[f, 2, 1, 10, 2], -1]
	,
	f[10]	
	,
	TestID->"1a693f76-eb36-4d09-8805-38dc77a07a9d"
]

VerificationTest[(* 33 *)
	Set[l, Take[lazyGenerator[f, 2, 1, 10, 2], 3]]
	,
	lazyList[List[f[2], f[4], f[6]], lazyLists`Private`finiteGenerator[f, Plus[6, 2], 1, 10, 2]]	
	,
	TestID->"b37425f9-c20f-4f84-a718-f951063df8be"
]

VerificationTest[(* 34 *)
	Take[lazySetState[Last[l], 3], 3]
	,
	lazyList[List[f[3], f[5], f[7]], lazyLists`Private`finiteGenerator[f, Plus[7, 2], 1, 10, 2]]	
	,
	TestID->"0e297879-53fe-4b9e-8edc-e03241aabc38"
]

VerificationTest[(* 35 *)
	lazySetState[lazyRange[start, step], newStart]
	,
	lazyList[newStart, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[step, newStart], step]]	
	,
	TestID->"41a767ac-0948-486e-ad67-68276213a197"
]

VerificationTest[(* 36 *)
	lazySetState[lazyPowerRange[start, r], newStart]
	,
	lazyList[newStart, Function[lazyList[Slot[1], Slot[0][Times[Slot[2], Slot[1]], Slot[2]]]][Times[r, newStart], r]]	
	,
	TestID->"17271240-7711-4341-9f6b-d73ae952bafb"
]

VerificationTest[(* 37 *)
	lazySetState[lazyNestList[f, start], newStart]
	,
	lazyList[newStart, Function[lazyList[Slot[1], Slot[0][f[Slot[1]], Plus[Slot[2], 1]]]][f[newStart], Plus[2, 1]]]	
	,
	TestID->"85d28eb3-0b69-4023-9a62-e0bca0fea29a"
]

VerificationTest[(* 38 *)
	Set[infiniteInBothDirections, lazyGenerator[f]]
	,
	lazyList[f[1], lazyLists`Private`twoSidedGenerator[f, Plus[1, 1], 1]]	
	,
	TestID->"7d510cd5-6253-419a-909d-b1a1b71cb108"
]

VerificationTest[(* 39 *)
	First[Take[infiniteInBothDirections, 5]]
	,
	List[f[1], f[2], f[3], f[4], f[5]]	
	,
	TestID->"82617601-f40e-481e-ab2e-33d645b93feb"
]

EndTestSection[]

BeginTestSection["lazyRange"]

VerificationTest[(* 40 *)
	lazyRange[]
	,
	lazyList[1, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1]]	
	,
	TestID->"5a25109e-e409-4241-87e2-2e902c6c5621"
]

VerificationTest[(* 41 *)
	lazyRange[4]
	,
	lazyList[4, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 4], 1]]	
	,
	TestID->"db625667-1aaa-4627-a9e3-474c84985890"
]

VerificationTest[(* 42 *)
	lazyRange[4, 2]
	,
	lazyList[4, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[2, 4], 2]]	
	,
	TestID->"4bdbc2fc-4056-40de-8e7c-2bfa553ba08d"
]

VerificationTest[(* 43 *)
	lazyRange[m]
	,
	lazyList[m, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, m], 1]]	
	,
	TestID->"208d84be-1c98-4209-a0f6-d832e7fc2b83"
]

VerificationTest[(* 44 *)
	lazyRange[m, n]
	,
	lazyList[m, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[n, m], n]]	
	,
	TestID->"e5808f50-f05b-429f-b532-45a4451a62f8"
]

VerificationTest[(* 45 *)
	First[lazyRange[]]
	,
	1	
	,
	TestID->"b9198889-9149-4424-b10c-43d57703131e"
]

VerificationTest[(* 46 *)
	Most[lazyRange[]]
	,
	List[1]	
	,
	TestID->"dbf3e3e3-8e73-4b2f-a1d7-0f145d1e87e1"
]

VerificationTest[(* 47 *)
	Last[lazyRange[]]
	,
	lazyList[2, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1]]	
	,
	TestID->"d4851321-d20b-4240-83d1-aa2d81aa1e7c"
]

VerificationTest[(* 48 *)
	Rest[lazyRange[]]
	,
	lazyList[2, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1]]	
	,
	TestID->"49ad39c2-0849-4f5f-b430-9193a4949bc9"
]

EndTestSection[]

BeginTestSection["Part & Take"]

VerificationTest[(* 49 *)
	Part[lazyRange[], 4]
	,
	4	
	,
	TestID->"ba87fc3c-eb8d-4448-8546-547454d4a9fb"
]

VerificationTest[(* 50 *)
	Set[lz, Part[lazyRange[], List[4]]]
	,
	lazyList[4, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 4], 1]]	
	,
	TestID->"a4bc3d25-02c8-423d-92b4-9c5ac9fdff09"
]

VerificationTest[(* 51 *)
	Last[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"29f5d1ec-7934-4a76-81d2-ec1ec1be6c80"
]

VerificationTest[(* 52 *)
	Rest[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"8d821ca7-a9b9-4630-99f7-8a40c4cfaf6f"
]

VerificationTest[(* 53 *)
	Part[lazyRange[], List[1, 4, 10, 5]]
	,
	lazyList[List[1, 4, 10, 5], lazyList[10, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]]	
	,
	TestID->"6b6636be-5f74-4d4d-918b-e44168475c5f"
]

VerificationTest[(* 54 *)
	Part[lazyRange[], Span[10, 2, -2]]
	,
	lazyList[List[10, 8, 6, 4, 2], lazyList[10, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]]	
	,
	TestID->"26072312-18bb-48bd-8b29-c63cce600e6f"
]

VerificationTest[(* 55 *)
	lazyPartMap[lazyRange[], Range[2, 22, 4]]
	,
	List[lazyList[2, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1]], lazyList[6, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 6], 1]], lazyList[10, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]], lazyList[14, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 14], 1]], lazyList[18, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 18], 1]], lazyList[22, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 22], 1]]]	
	,
	TestID->"95dae054-97de-45f6-ae80-bbbdcead8954"
]

VerificationTest[(* 56 *)
	Set[lz, lazyList[Range[4]]]
	,
	lazyList[1, lazyList[List[2, 3, 4]]]	
	,
	TestID->"63bec182-5474-409f-81ca-9f28d83c0dfc"
]

VerificationTest[(* 57 *)
	Part[lz, 5]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"71b8cba2-0230-4342-90a4-9e869195a1c2"
]

VerificationTest[(* 58 *)
	Part[lz, List[5]]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"6a91f54c-35b3-4c44-86c6-96c0bde3c0df"
]

VerificationTest[(* 59 *)
	Part[lz, List[2, 5]]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"b2b4c750-b002-45f9-854c-da29568cb0c9"
]

VerificationTest[(* 60 *)
	Part[lz, Span[2, 5]]
	,
	$Failed
	,
	{Part::partw}
	,
	TestID->"2bd7171f-20a3-4542-954e-8137f83dc785"
]

VerificationTest[(* 61 *)
	Set[lz, Take[lazyRange[], 4]]
	,
	lazyList[List[1, 2, 3, 4], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 4], 1]]	
	,
	TestID->"5e0a950c-6c9b-479a-9577-f510d070b785"
]

VerificationTest[(* 62 *)
	First[lz]
	,
	List[1, 2, 3, 4]	
	,
	TestID->"ebfa7b55-47b5-47c4-bee9-368a472669c6"
]

VerificationTest[(* 63 *)
	Most[lz]
	,
	List[List[1, 2, 3, 4]]	
	,
	TestID->"fbd20cda-4809-49ed-91df-ad61c9b9c942"
]

VerificationTest[(* 64 *)
	Rest[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"11352ee2-0d75-44ae-b3cd-6f4a282119a2"
]

VerificationTest[(* 65 *)
	Last[lz]
	,
	lazyList[5, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1]]	
	,
	TestID->"27f2157e-5ce0-4e7b-9b23-c2c1c7ff64cb"
]

VerificationTest[(* 66 *)
	Take[Last[lz], 5]
	,
	lazyList[List[5, 6, 7, 8, 9], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 9], 1]]	
	,
	TestID->"fcd31aec-14e9-41b1-bd12-6ce307d8406f"
]

VerificationTest[(* 67 *)
	Take[lazyRange[], List[5, 10]]
	,
	lazyList[List[5, 6, 7, 8, 9, 10], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]	
	,
	TestID->"55c73f74-6a40-47f7-89eb-d36da337137c"
]

VerificationTest[(* 68 *)
	Take[lazyRange[], List[10, 5]]
	,
	lazyList[List[10, 9, 8, 7, 6, 5], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 10], 1]]	
	,
	TestID->"e961e37f-0278-4737-bff0-90e02ec06117"
]

VerificationTest[(* 69 *)
	CompoundExpression[Set[lz, lazyList[Range[4]]], Take[lz, 5]]
	,
	lazyList[List[1, 2, 3, 4], lazyList[]]	
	,
	TestID->"edf4f33b-9540-4ae5-b809-3e26f8ae02f8"
]

VerificationTest[(* 70 *)
	Take[lz, List[3, 5]]
	,
	lazyList[List[3, 4], lazyList[]]	
	,
	TestID->"871119d8-1679-42f3-b233-42e5a60e8432"
]

VerificationTest[(* 71 *)
	Take[lz, List[5, 10]]
	,
	lazyList[]	
	,
	TestID->"7125c3bc-998d-4824-92b5-8eadb7c0e4ff"
]

VerificationTest[(* 72 *)
	Take[lz, List[10, 3]]
	,
	lazyList[List[4, 3], lazyList[]]	
	,
	TestID->"dfcd0c72-873e-4da7-8046-867f8377fe08"
]

VerificationTest[(* 73 *)
	lazyList[1, lazyRange[]]
	,
	lazyList[1, lazyRange[]]	
	,
	TestID->"b015e0c0-8f15-4ee7-940e-c628d027f9eb"
]

EndTestSection[]

BeginTestSection["TakeWhile & LengthWhile"]

VerificationTest[(* 74 *)
	TakeWhile[lazyPowerRange[2, 2], Function[Less[Slot[1], 100]]]
	,
	lazyList[List[2, 4, 8, 16, 32, 64], lazyList[128, Function[lazyList[Slot[1], Slot[0][Times[Slot[2], Slot[1]], Slot[2]]]][Times[2, 128], 2]]]	
	,
	TestID->"823b8a25-80e8-46f8-b67b-44cdddedf15b"
]

VerificationTest[(* 75 *)
	LengthWhile[lazyPowerRange[2, 2], Function[Less[Slot[1], 100]]]
	,
	Association[Rule["Index", 6], Rule["Element", lazyList[64, lazyList[128, Function[lazyList[Slot[1], Slot[0][Times[Slot[2], Slot[1]], Slot[2]]]][Times[2, 128], 2]]]]]	
	,
	TestID->"af7f0c1f-ca15-4c58-83bd-9d23e9dba98c"
]

EndTestSection[]

BeginTestSection["Finite lists"]

VerificationTest[(* 76 *)
	lazyList[Fibonacci[Range[10]]]
	,
	lazyList[1, lazyList[List[1, 2, 3, 5, 8, 13, 21, 34, 55]]]	
	,
	TestID->"d8d804be-7edb-4c0f-9fc4-74513e0d407d"
]

VerificationTest[(* 77 *)
	First[Take[lazyList[Fibonacci[Range[10]]], 5]]
	,
	List[1, 1, 2, 3, 5]	
	,
	TestID->"6972598e-d646-4f13-8632-ea6074b82608"
]

VerificationTest[(* 78 *)
	CompoundExpression[Set[fibList, Fibonacci[Range[10]]], Set[finiteLz, lazyList[Hold[fibList]]]]
	,
	lazyList[1, lazyLists`Private`lazyFiniteList[fibList, Plus[1, 1]]]	
	,
	TestID->"dd7dc047-d5b9-4a27-bdd5-eea56763a8ee"
]

VerificationTest[(* 79 *)
	First[Take[finiteLz, All]]
	,
	List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55]	
	,
	TestID->"6cabf47c-9bca-4941-93f1-b4db9a6519dd"
]

VerificationTest[(* 80 *)
	CompoundExpression[Set[fibList, Fibonacci[Range[20]]], First[Take[finiteLz, All]]]
	,
	List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]	
	,
	TestID->"4b556f22-babb-4365-9b20-0f83c95616ef"
]

VerificationTest[(* 81 *)
	CompoundExpression[Set[fibList, Fibonacci[Range[1000]]], lazyFinitePart[finiteLz, 4]]
	,
	Part[fibList, 4]	
	,
	TestID->"1f75b7a2-c9d4-4047-bbaa-274f038436fd"
]

VerificationTest[(* 82 *)
	lazyFiniteTake[finiteLz, List[2, 4]]
	,
	Take[fibList, List[2, 4]]	
	,
	TestID->"fcb2dcea-1434-4617-9121-24c0f4abf5ab"
]

VerificationTest[(* 83 *)
	lazySetState[finiteLz, -1]
	,
	lazyList[43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875, lazyLists`Private`lazyFiniteList[fibList, Plus[1000, 1]]]	
	,
	TestID->"4fd54ea8-9db6-4091-bebe-646a9fa05b5a"
]

VerificationTest[(* 84 *)
	First[Take[lazyTranspose[List[lazyRange[], lazyConstantArray[0]]], 5]]
	,
	List[List[1, 0], List[2, 0], List[3, 0], List[4, 0], List[5, 0]]	
	,
	TestID->"4b2cca41-177e-4c1e-a292-185fd30f3cd8"
]

VerificationTest[(* 85 *)
	First[Take[lazyTranspose[List[lazyRange[], Range[5]]], All]]
	,
	List[List[1, 1], List[2, 2], List[3, 3], List[4, 4], List[5, 5]]	
	,
	TestID->"7e29229f-4c36-47c4-b0cf-77b1e12970de"
]

EndTestSection[]

EndTestSection[]

BeginTestSection["partitionedLazyList"]

BeginTestSection["Construction"]

VerificationTest[(* 86 *)
	lazyPartition[lazyList[Fibonacci[Range[10]]], 5]
	,
	partitionedLazyList[List[1, 1, 2, 3, 5], lazyPartition[List[8, 13, 21, 34, 55], 5]]	
	,
	TestID->"01bf8674-8020-456c-b246-5e53b2c6a0d1"
]

VerificationTest[(* 87 *)
	Take[lazyPartition[lazyList[Fibonacci[Range[10]]], 5], All]
	,
	partitionedLazyList[List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55], lazyList[]]	
	,
	TestID->"c787722b-c06f-492e-ba9e-a6761bdb6ebc"
]

VerificationTest[(* 88 *)
	Take[lazyPartition[Fibonacci[Range[10]], 5], All]
	,
	partitionedLazyList[List[1, 1, 2, 3, 5, 8, 13, 21, 34, 55], lazyList[]]	
	,
	TestID->"732c1566-7183-4c6c-a41f-f2ac3016d1b6"
]

VerificationTest[(* 89 *)
	Set[lz, partitionedLazyList[lazyGenerator[Range]]]
	,
	partitionedLazyList[List[1], partitionedLazyList[lazyLists`Private`twoSidedGenerator[Range, Plus[1, 1], 1]]]	
	,
	TestID->"fe027550-a112-47ea-b5c6-c8fb3ab25ab3"
]

VerificationTest[(* 90 *)
	Take[lz, 20]
	,
	partitionedLazyList[List[1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5], partitionedLazyList[List[6], partitionedLazyList[lazyLists`Private`twoSidedGenerator[Range, Plus[6, 1], 1]]]]	
	,
	TestID->"74ee957c-35b9-4288-b87d-a44a6461a75a"
]

VerificationTest[(* 91 *)
	First[Take[lz, 10]]
	,
	1	
	,
	TestID->"1530a19f-7b3b-4fa6-801e-235cb5df2ec0"
]

VerificationTest[(* 92 *)
	Rest[Take[lz, 10]]
	,
	partitionedLazyList[List[1, 2, 1, 2, 3, 1, 2, 3, 4], partitionedLazyList[List[1, 2, 3, 4, 5], partitionedLazyList[lazyLists`Private`twoSidedGenerator[Range, Plus[5, 1], 1]]]]	
	,
	TestID->"7414b466-3025-448c-8c06-5576951b0a84"
]

VerificationTest[(* 93 *)
	Most[Take[lz, 10]]
	,
	List[1, 1, 2, 1, 2, 3, 1, 2, 3, 4]	
	,
	TestID->"fa132159-8a8f-4beb-86df-e2bba144c4ef"
]

VerificationTest[(* 94 *)
	Last[Take[lz, 10]]
	,
	partitionedLazyList[List[1, 2, 3, 4, 5], partitionedLazyList[lazyLists`Private`twoSidedGenerator[Range, Plus[5, 1], 1]]]	
	,
	TestID->"5a9e1259-745c-4927-997b-aa932934f6e2"
]

VerificationTest[(* 95 *)
	Set[lz, lazyPartition[lazyGenerator[Function[ConstantArray[Slot[1], 5]]], 3]]
	,
	partitionedLazyList[List[List[1, 1, 1, 1, 1], List[2, 2, 2, 2, 2], List[3, 3, 3, 3, 3]], lazyPartition[lazyLists`Private`twoSidedGenerator[Function[ConstantArray[Slot[1], 5]], Plus[3, 1], 1], 3]]	
	,
	TestID->"5d38a3ac-f6bd-4521-8938-63627ebbfbdb"
]

VerificationTest[(* 96 *)
	lazyTranspose[lz]
	,
	partitionedLazyList[List[List[1, 2, 3], List[1, 2, 3], List[1, 2, 3], List[1, 2, 3], List[1, 2, 3]], Map[List[Transpose, Listable], lazyPartition[lazyLists`Private`twoSidedGenerator[Function[ConstantArray[Slot[1], 5]], Plus[3, 1], 1], 3]]]	
	,
	TestID->"29795b28-319d-4474-b894-5b87a8044998"
]

EndTestSection[]

BeginTestSection["Part and Take"]

VerificationTest[(* 97 *)
	Set[lz, partitionedLazyRange[start, step, 5]]
	,
	partitionedLazyList[List[start, Plus[start, step], Plus[start, Times[2, step]], Plus[start, Times[3, step]], Plus[start, Times[4, step]]], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[Times[5, step], List[start, Plus[start, step], Plus[start, Times[2, step]], Plus[start, Times[3, step]], Plus[start, Times[4, step]]]], Times[5, step]]]]	
	,
	TestID->"e48434ad-194e-4c1d-9181-bafefa2cd018"
]

VerificationTest[(* 98 *)
	First[Take[lz, 20]]
	,
	start	
	,
	TestID->"d1633934-c1bb-4947-a9ac-4f90c3f3a7da"
]

VerificationTest[(* 99 *)
	Most[Take[lz, 20]]
	,
	List[start, Plus[start, step], Plus[start, Times[2, step]], Plus[start, Times[3, step]], Plus[start, Times[4, step]], Plus[start, Times[5, step]], Plus[start, Times[6, step]], Plus[start, Times[7, step]], Plus[start, Times[8, step]], Plus[start, Times[9, step]], Plus[start, Times[10, step]], Plus[start, Times[11, step]], Plus[start, Times[12, step]], Plus[start, Times[13, step]], Plus[start, Times[14, step]], Plus[start, Times[15, step]], Plus[start, Times[16, step]], Plus[start, Times[17, step]], Plus[start, Times[18, step]], Plus[start, Times[19, step]]]	
	,
	TestID->"e3c13e65-15f5-40ab-a369-a0739f6ce9cd"
]

VerificationTest[(* 100 *)
	Set[rangeRange, partitionedLazyList[lazyGenerator[Range, 1, 1, 8]]]
	,
	partitionedLazyList[List[1], partitionedLazyList[lazyLists`Private`finiteGenerator[Range, Plus[1, 1], 1, 8, 1]]]	
	,
	TestID->"abbb180b-6296-4777-ac14-9878e48e5e91"
]

VerificationTest[(* 101 *)
	Most[Take[rangeRange, 20]]
	,
	List[1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5]	
	,
	TestID->"51609d85-e54a-44ed-91d9-4b64c4990fe4"
]

VerificationTest[(* 102 *)
	Most[Take[rangeRange, List[18, 5, -3]]]
	,
	List[3, 5, 2, 3, 3]	
	,
	TestID->"820df117-1d98-44c2-a62a-edec62a21a0a"
]

VerificationTest[(* 103 *)
	Most[Take[rangeRange, List[5, 18, 3]]]
	,
	List[2, 2, 1, 4, 2]	
	,
	TestID->"6dcf221b-d910-4a2e-b4e3-86711adeb89f"
]

VerificationTest[(* 104 *)
	lazyPartition[lazyRange[], 5]
	,
	partitionedLazyList[List[1, 2, 3, 4, 5], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 5], 1], 5]]	
	,
	TestID->"9a72acee-8279-49cc-b52e-428f405cc087"
]

VerificationTest[(* 105 *)
	lazyPartition[rangeRange, 5]
	,
	partitionedLazyList[List[1, 1, 2, 1, 2], lazyPartition[partitionedLazyList[List[3], partitionedLazyList[lazyLists`Private`finiteGenerator[Range, Plus[3, 1], 1, 8, 1]]], 5]]	
	,
	TestID->"e007465e-1e97-47b0-be7c-b8aac867396c"
]

VerificationTest[(* 106 *)
	lazyPartition[lazyPartition[lazyRange[], 5], 10]
	,
	partitionedLazyList[List[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], partitionedLazyList[List[11, 12, 13, 14, 15], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 15], 1], 10]]]	
	,
	TestID->"82525b95-d50e-41ef-b3f4-c8dc4e471c7e"
]

EndTestSection[]

BeginTestSection["lazyTuples"]

VerificationTest[(* 107 *)
	CompoundExpression[Set[lists, List[List[a, b, c], List[1, 2], List[u, v, w, x, y, z]]], Set[lzTup, lazyTuples[lists, Rule["PartitionSize", 10]]], MatchQ[lzTup, partitionedLazyList[List[List[a, 1, u], List[a, 1, v], List[a, 1, w], List[a, 1, x], List[a, 1, y], List[a, 1, z], List[a, 2, u], List[a, 2, v], List[a, 2, w], List[a, 2, x]], Blank[Map]]]]
	,
	True	
	,
	TestID->"24b2d102-74b8-448e-b98e-e96436dc4582"
]

VerificationTest[(* 108 *)
	Most[Take[lzTup, All]]
	,
	Tuples[lists]	
	,
	TestID->"7e1cd504-6344-4ea6-945b-c5c473fce372"
]

VerificationTest[(* 109 *)
	Most[Take[lazyTuples[List[a, b, c], 5], 10]]
	,
	Take[Tuples[List[a, b, c], 5], 10]	
	,
	TestID->"2504436e-333c-4451-8e5c-5008d03ff2e1"
]

VerificationTest[(* 110 *)
	CompoundExpression[Set[largeLists, Map[Range, List[50, 40, 60, 80]]], Most[Take[lazyTuples[Hold[largeLists]], 10]]]
	,
	List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 1, 3], List[1, 1, 1, 4], List[1, 1, 1, 5], List[1, 1, 1, 6], List[1, 1, 1, 7], List[1, 1, 1, 8], List[1, 1, 1, 9], List[1, 1, 1, 10]]	
	,
	TestID->"049881ce-6fad-454f-b4d5-405e0871d698"
]

VerificationTest[(* 111 *)
	Most[Take[lazyTuples[Hold[largeLists], Rule["PartitionSize", 1000]], 100]]
	,
	List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 1, 3], List[1, 1, 1, 4], List[1, 1, 1, 5], List[1, 1, 1, 6], List[1, 1, 1, 7], List[1, 1, 1, 8], List[1, 1, 1, 9], List[1, 1, 1, 10], List[1, 1, 1, 11], List[1, 1, 1, 12], List[1, 1, 1, 13], List[1, 1, 1, 14], List[1, 1, 1, 15], List[1, 1, 1, 16], List[1, 1, 1, 17], List[1, 1, 1, 18], List[1, 1, 1, 19], List[1, 1, 1, 20], List[1, 1, 1, 21], List[1, 1, 1, 22], List[1, 1, 1, 23], List[1, 1, 1, 24], List[1, 1, 1, 25], List[1, 1, 1, 26], List[1, 1, 1, 27], List[1, 1, 1, 28], List[1, 1, 1, 29], List[1, 1, 1, 30], List[1, 1, 1, 31], List[1, 1, 1, 32], List[1, 1, 1, 33], List[1, 1, 1, 34], List[1, 1, 1, 35], List[1, 1, 1, 36], List[1, 1, 1, 37], List[1, 1, 1, 38], List[1, 1, 1, 39], List[1, 1, 1, 40], List[1, 1, 1, 41], List[1, 1, 1, 42], List[1, 1, 1, 43], List[1, 1, 1, 44], List[1, 1, 1, 45], List[1, 1, 1, 46], List[1, 1, 1, 47], List[1, 1, 1, 48], List[1, 1, 1, 49], List[1, 1, 1, 50], List[1, 1, 1, 51], List[1, 1, 1, 52], List[1, 1, 1, 53], List[1, 1, 1, 54], List[1, 1, 1, 55], List[1, 1, 1, 56], List[1, 1, 1, 57], List[1, 1, 1, 58], List[1, 1, 1, 59], List[1, 1, 1, 60], List[1, 1, 1, 61], List[1, 1, 1, 62], List[1, 1, 1, 63], List[1, 1, 1, 64], List[1, 1, 1, 65], List[1, 1, 1, 66], List[1, 1, 1, 67], List[1, 1, 1, 68], List[1, 1, 1, 69], List[1, 1, 1, 70], List[1, 1, 1, 71], List[1, 1, 1, 72], List[1, 1, 1, 73], List[1, 1, 1, 74], List[1, 1, 1, 75], List[1, 1, 1, 76], List[1, 1, 1, 77], List[1, 1, 1, 78], List[1, 1, 1, 79], List[1, 1, 1, 80], List[1, 1, 2, 1], List[1, 1, 2, 2], List[1, 1, 2, 3], List[1, 1, 2, 4], List[1, 1, 2, 5], List[1, 1, 2, 6], List[1, 1, 2, 7], List[1, 1, 2, 8], List[1, 1, 2, 9], List[1, 1, 2, 10], List[1, 1, 2, 11], List[1, 1, 2, 12], List[1, 1, 2, 13], List[1, 1, 2, 14], List[1, 1, 2, 15], List[1, 1, 2, 16], List[1, 1, 2, 17], List[1, 1, 2, 18], List[1, 1, 2, 19], List[1, 1, 2, 20]]	
	,
	TestID->"0a6ccfa4-19db-450c-91fe-c3131cfa38b5"
]

VerificationTest[(* 112 *)
	CompoundExpression[Set[integers, Map[Length, lists]], Set[integerLzTup, lazyTuples[integers]], MatchQ[integerLzTup, partitionedLazyList[List[List[1, 1, 1], List[1, 1, 2], List[1, 1, 3], List[1, 1, 4], List[1, 1, 5], List[1, 1, 6], List[1, 2, 1], List[1, 2, 2], List[1, 2, 3], List[1, 2, 4]], Blank[Map]]]]
	,
	True	
	,
	TestID->"abe8de04-193c-434c-9de1-f0e74ad365d8"
]

VerificationTest[(* 113 *)
	Set[indices, Most[Take[integerLzTup, 10]]]
	,
	List[List[1, 1, 1], List[1, 1, 2], List[1, 1, 3], List[1, 1, 4], List[1, 1, 5], List[1, 1, 6], List[1, 2, 1], List[1, 2, 2], List[1, 2, 3], List[1, 2, 4]]	
	,
	TestID->"1dc8febd-3448-49d6-be28-1ccd6ec9c3a9"
]

VerificationTest[(* 114 *)
	Take[Tuples[Map[Range, integers]], 10]
	,
	List[List[1, 1, 1], List[1, 1, 2], List[1, 1, 3], List[1, 1, 4], List[1, 1, 5], List[1, 1, 6], List[1, 2, 1], List[1, 2, 2], List[1, 2, 3], List[1, 2, 4]]	
	,
	TestID->"4d3ad108-8eda-4b86-b437-4ae9f711021e"
]

VerificationTest[(* 115 *)
	bulkExtractElementsUsingIndexList[lists][Transpose[indices]]
	,
	Take[Tuples[lists], 10]	
	,
	TestID->"aba8a778-a2ca-4ee0-b9cd-836bd89bf9f2"
]

VerificationTest[(* 116 *)
	bulkExtractElementsUsingIndexList[Hold[lists]][Transpose[indices]]
	,
	Take[Tuples[lists], 10]	
	,
	TestID->"cddc03cf-2e55-41ff-8f12-cfaf4b33ac36"
]

VerificationTest[(* 117 *)
	Module[List[Set[list, List[a, b, c, d, e]], Set[tupLength, 3], indices], CompoundExpression[Set[indices, Most[Take[lazyTuples[Range[Length[list]], tupLength], 10]]], bulkExtractElementsUsingIndexList[list, tupLength][Transpose[indices]]]]
	,
	Take[Tuples[List[a, b, c, d, e], 3], 10]	
	,
	TestID->"2cfc8d44-a522-49e1-a6d3-b57badf7858e"
]

VerificationTest[(* 118 *)
	Most[Take[lazyTuples[integers, Rule["Start", 10]], 11]]
	,
	List[List[1, 2, 4], List[1, 2, 5], List[1, 2, 6], List[2, 1, 1], List[2, 1, 2], List[2, 1, 3], List[2, 1, 4], List[2, 1, 5], List[2, 1, 6], List[2, 2, 1], List[2, 2, 2]]	
	,
	TestID->"6d6b52ee-9463-4ee8-be50-d35a81016de8"
]

VerificationTest[(* 119 *)
	Take[Tuples[Map[Range, integers]], List[10, 20]]
	,
	List[List[1, 2, 4], List[1, 2, 5], List[1, 2, 6], List[2, 1, 1], List[2, 1, 2], List[2, 1, 3], List[2, 1, 4], List[2, 1, 5], List[2, 1, 6], List[2, 2, 1], List[2, 2, 2]]	
	,
	TestID->"265a55bb-649d-416f-9440-2683e88bd339"
]

VerificationTest[(* 120 *)
	CompoundExpression[Set[tuplesGenerator, rangeTuplesAtPositions[integers]], SameQ[Head[tuplesGenerator], CompiledFunction]]
	,
	True	
	,
	TestID->"6039388a-a7fb-41f9-af49-0a1d7879ba7a"
]

VerificationTest[(* 121 *)
	CompoundExpression[Set[randomPositions, RandomInteger[List[1, Apply[Times, integers]], 10]], MatchQ[randomPositions, List[BlankSequence[Integer]]]]
	,
	True	
	,
	TestID->"89cad6c5-e497-4ab9-90a4-68a3e04af6ea"
]

VerificationTest[(* 122 *)
	tuplesGenerator[randomPositions]
	,
	Transpose[Part[Tuples[Map[Range, integers]], randomPositions]]	
	,
	TestID->"84552981-9693-4342-93a1-48f1974e46dc"
]

VerificationTest[(* 123 *)
	CompoundExpression[Set[infTuples, lazyTuples[4]], MatchQ[infTuples, partitionedLazyList[List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 2, 1], List[1, 2, 1, 1], List[2, 1, 1, 1], List[1, 1, 1, 3], List[1, 1, 2, 2], List[1, 1, 3, 1], List[1, 2, 1, 2], List[1, 2, 2, 1]], Blank[]]]]
	,
	True	
	,
	TestID->"78889fbc-8259-4d38-97ef-1b93bd574df7"
]

VerificationTest[(* 124 *)
	Most[Take[infTuples, 75]]
	,
	List[List[1, 1, 1, 1], List[1, 1, 1, 2], List[1, 1, 2, 1], List[1, 2, 1, 1], List[2, 1, 1, 1], List[1, 1, 1, 3], List[1, 1, 2, 2], List[1, 1, 3, 1], List[1, 2, 1, 2], List[1, 2, 2, 1], List[1, 3, 1, 1], List[2, 1, 1, 2], List[2, 1, 2, 1], List[2, 2, 1, 1], List[3, 1, 1, 1], List[1, 1, 1, 4], List[1, 1, 2, 3], List[1, 1, 3, 2], List[1, 1, 4, 1], List[1, 2, 1, 3], List[1, 2, 2, 2], List[1, 2, 3, 1], List[1, 3, 1, 2], List[1, 3, 2, 1], List[1, 4, 1, 1], List[2, 1, 1, 3], List[2, 1, 2, 2], List[2, 1, 3, 1], List[2, 2, 1, 2], List[2, 2, 2, 1], List[2, 3, 1, 1], List[3, 1, 1, 2], List[3, 1, 2, 1], List[3, 2, 1, 1], List[4, 1, 1, 1], List[1, 1, 1, 5], List[1, 1, 2, 4], List[1, 1, 3, 3], List[1, 1, 4, 2], List[1, 1, 5, 1], List[1, 2, 1, 4], List[1, 2, 2, 3], List[1, 2, 3, 2], List[1, 2, 4, 1], List[1, 3, 1, 3], List[1, 3, 2, 2], List[1, 3, 3, 1], List[1, 4, 1, 2], List[1, 4, 2, 1], List[1, 5, 1, 1], List[2, 1, 1, 4], List[2, 1, 2, 3], List[2, 1, 3, 2], List[2, 1, 4, 1], List[2, 2, 1, 3], List[2, 2, 2, 2], List[2, 2, 3, 1], List[2, 3, 1, 2], List[2, 3, 2, 1], List[2, 4, 1, 1], List[3, 1, 1, 3], List[3, 1, 2, 2], List[3, 1, 3, 1], List[3, 2, 1, 2], List[3, 2, 2, 1], List[3, 3, 1, 1], List[4, 1, 1, 2], List[4, 1, 2, 1], List[4, 2, 1, 1], List[5, 1, 1, 1], List[1, 1, 1, 6], List[1, 1, 2, 5], List[1, 1, 3, 4], List[1, 1, 4, 3], List[1, 1, 5, 2]]	
	,
	TestID->"c70e9cab-91be-484e-883e-2f0f1f811260"
]

VerificationTest[(* 125 *)
	Sort[Select[Most[Take[infTuples, 75]], Function[Less[Total[Slot[1]], 9]]]]
	,
	Sort[Select[Tuples[Range[10], 4], Function[Less[Total[Slot[1]], 9]]]]	
	,
	TestID->"aa1b845f-e3c7-4baa-85ae-d14d3a58ac3e"
]

VerificationTest[(* 126 *)
	Most[Take[lazyTuples[4, List[1, 4, 10, 2]], 20]]
	,
	List[List[1, 4, 10, 2], List[1, 4, 11, 1], List[1, 5, 1, 10], List[1, 5, 2, 9], List[1, 5, 3, 8], List[1, 5, 4, 7], List[1, 5, 5, 6], List[1, 5, 6, 5], List[1, 5, 7, 4], List[1, 5, 8, 3], List[1, 5, 9, 2], List[1, 5, 10, 1], List[1, 6, 1, 9], List[1, 6, 2, 8], List[1, 6, 3, 7], List[1, 6, 4, 6], List[1, 6, 5, 5], List[1, 6, 6, 4], List[1, 6, 7, 3], List[1, 6, 8, 2]]	
	,
	TestID->"f3adf59a-4b10-4bd6-8798-52b9ea706312"
]

EndTestSection[]

BeginTestSection["lazyStream"]

VerificationTest[(* 127 *)
	CompoundExpression[Set[stmp, OpenWrite["tmp"]], Write[stmp, a, b, c], Write[stmp, x], Write[stmp, "Hello"], Write[stmp, "Hello"], Write[stmp, "Hello"], Close[stmp]]
	,
	"tmp"	
	,
	TestID->"0f990c29-bc3b-4212-b56f-dd4fc18990e6"
]

VerificationTest[(* 128 *)
	Module[List[Set[stream, OpenRead["tmp"]], result], CompoundExpression[Set[result, First[Take[lazyStream[stream], 3]]], Close[stream], result]]
	,
	List[abc, x, "Hello"]	
	,
	TestID->"52120357-4e6a-4818-9638-c55b4ec44945"
]

VerificationTest[(* 129 *)
	Module[List[Set[stream, OpenRead["tmp"]], result], CompoundExpression[Set[result, First[TakeWhile[lazyStream[stream], Function[True]]]], Close[stream], DeleteFile["tmp"], result]]
	,
	List[abc, x, "Hello", "Hello", "Hello", EndOfFile]	
	,
	TestID->"3a10c3aa-3bf6-467b-9474-a4f28c714065"
]

EndTestSection[]

EndTestSection[]

BeginTestSection["lazyListable"]

VerificationTest[(* 130 *)
	First[Take[Plus[lazyRange[], lazyRange[2]], 5]]
	,
	List[3, 5, 7, 9, 11]	
	,
	TestID->"10ffdd73-035c-4ba5-a271-64a4e1bf04b9"
]

VerificationTest[(* 131 *)
	First[Take[Plus[Times[2, lazyRange[]], Times[3, lazyRange[1, 2]]], 5]]
	,
	List[5, 13, 21, 29, 37]	
	,
	TestID->"d7ff3a30-f6b5-4d8a-9ab2-ff7f8ed70d73"
]

VerificationTest[(* 132 *)
	First[Take[Power[lazyRange[], lazyRange[]], 5]]
	,
	List[1, 4, 27, 256, 3125]	
	,
	TestID->"cb32bc98-d965-431f-9f96-3ada1f100757"
]

VerificationTest[(* 133 *)
	First[Take[Divide[1, lazyRange[2, 2]], 5]]
	,
	List[Times[1, Power[2, -1]], Times[1, Power[4, -1]], Times[1, Power[6, -1]], Times[1, Power[8, -1]], Times[1, Power[10, -1]]]	
	,
	TestID->"88f9cdf0-0340-44dd-9935-af0cfe6259f5"
]

VerificationTest[(* 134 *)
	setLazyListable[listableSymbol]
	,
	listableSymbol	
	,
	TestID->"160be7e3-bf2c-448e-91f6-7bbd9a33e714"
]

VerificationTest[(* 135 *)
	First[Take[listableSymbol[lazyRange[], lazyRange[2], 5], 5]]
	,
	List[listableSymbol[1, 2, 5], listableSymbol[2, 3, 5], listableSymbol[3, 4, 5], listableSymbol[4, 5, 5], listableSymbol[5, 6, 5]]	
	,
	TestID->"c7310b38-f3a8-455d-920e-531b0051796e"
]

VerificationTest[(* 136 *)
	CompoundExpression[SetAttributes[listableSymbol, List[Listable]], listableSymbol[lazyRange[], lazyRange[2], 5, List[1, 2]]]
	,
	List[lazyList[listableSymbol[1, 2, 5, 1], listableSymbol[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1], 5, 1]], lazyList[listableSymbol[1, 2, 5, 2], listableSymbol[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 2], 1], 5, 2]]]	
	,
	TestID->"56038233-6e7c-403b-bd23-ff528dab83bf"
]

VerificationTest[(* 137 *)
	Plus[lazyPartition[lazyRange[], 3], lazyRange[]]
	,
	lazyList[partitionedLazyList[List[2, 3, 4], Plus[lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 3], 1], 3], 1]], Plus[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], partitionedLazyList[List[1, 2, 3], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 3], 1], 3]]]]	
	,
	TestID->"34f45468-23b2-4a28-b664-75d96b3a95a6"
]

VerificationTest[(* 138 *)
	Most[Take[Plus[Times[a, partitionedLazyList[lazyGenerator[Range, 1, 1]]], Times[b, Power[partitionedLazyList[lazyGenerator[Range, 2, 2]], -1]]], 5]]
	,
	List[Plus[a, b], Plus[a, Times[b, Power[2, -1]]], Plus[Times[2, a], b], Plus[a, Times[b, Power[2, -1]]], Plus[Times[2, a], Times[b, Power[3, -1]]]]	
	,
	TestID->"c11cacfe-c700-4812-8a51-95a151ee3eaf"
]

VerificationTest[(* 139 *)
	Most[Plus[partitionedLazyRange[3], partitionedLazyRange[5], partitionedLazyRange[6]]]
	,
	List[3, 6, 9, 12, 15, 18]	
	,
	TestID->"b19f5a9c-bda9-4c9e-9d66-abbe90d7064d"
]

VerificationTest[(* 140 *)
	setLazyListable[List[Sin, Listable]]
	,
	Sin	
	,
	TestID->"33e34634-2c70-48c3-867d-7d1129c95903"
]

VerificationTest[(* 141 *)
	Most[Sin[partitionedLazyRange[10]]]
	,
	List[Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[9], Sin[10]]	
	,
	TestID->"1cc79346-5d1d-4988-b0ce-81b7ae7f4be7"
]

EndTestSection[]

BeginTestSection["Map"]

VerificationTest[(* 142 *)
	Reap[Most[Take[Map[Function[Sqrt[Sow[Slot[1]]]], partitionedLazyRange[3]], 4]]]
	,
	List[List[1, Sqrt[2], Sqrt[3], 2], List[List[1, 2, 3, 4, 5, 6]]]	
	,
	TestID->"6440fb8d-a118-491f-88fd-43fd54af5daf"
]

VerificationTest[(* 143 *)
	Reap[Most[Take[Map[List[Function[Sqrt[Sow[Slot[1]]]], Listable], partitionedLazyRange[3]], 4]]]
	,
	List[List[1, Sqrt[2], Sqrt[3], 2], List[List[List[1, 2, 3], List[4, 5, 6]]]]	
	,
	TestID->"aff39ed4-8213-41e6-8228-aeceabbf621c"
]

VerificationTest[(* 144 *)
	Map[Sqrt, lazyRange[0, 2]]
	,
	lazyList[0, Map[Sqrt, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[2, 0], 2]]]	
	,
	TestID->"c6d789ea-cab2-47f5-b533-b8d08cbea2f1"
]

VerificationTest[(* 145 *)
	First[Take[Map[Sqrt, lazyRange[0, 2]], 5]]
	,
	List[0, Sqrt[2], 2, Sqrt[6], Times[2, Sqrt[2]]]	
	,
	TestID->"8e897f69-0991-43b0-a47e-33c4c2ad2605"
]

VerificationTest[(* 146 *)
	Map[Cos, Map[Sin, Map[Exp, lazyRange[]]]]
	,
	lazyList[Cos[Sin[E]], Map[Cos, Map[Sin, Map[Exp, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1]]]]]	
	,
	TestID->"fb24aab4-c206-439c-9a7b-3f300593d086"
]

VerificationTest[(* 147 *)
	composeMappedFunctions[Map[Cos, Map[Sin, Map[Exp, lazyRange[]]]]]
	,
	lazyList[Cos[Sin[E]], Map[Composition[Cos, Sin, Exp], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1]]]	
	,
	TestID->"66f1eb1f-2b16-4e07-8261-69e9233b6d4f"
]

VerificationTest[(* 148 *)
	Map[Cos, Map[Exp, lazyGenerator[Sin]]]
	,
	lazyList[Cos[Power[E, Sin[1]]], Map[Cos, Map[Exp, lazyLists`Private`twoSidedGenerator[Sin, Plus[1, 1], 1]]]]	
	,
	TestID->"f152549d-6a7c-4270-a618-b0ee9d3c21a9"
]

VerificationTest[(* 149 *)
	composeMappedFunctions[Map[Cos, Map[Exp, lazyGenerator[Sin]]]]
	,
	lazyList[Cos[Power[E, Sin[1]]], lazyLists`Private`twoSidedGenerator[Composition[Cos, Exp, Sin], Plus[1, 1], 1]]	
	,
	TestID->"cd24d0b2-3f35-4442-8db5-122d8b62a9fa"
]

VerificationTest[(* 150 *)
	Take[Map[f, Map[g, partitionedLazyRange[5]]], 10]
	,
	partitionedLazyList[List[f[g[1]], f[g[2]], f[g[3]], f[g[4]], f[g[5]], f[g[6]], f[g[7]], f[g[8]], f[g[9]], f[g[10]]], partitionedLazyList[List[f[g[11]], f[g[12]], f[g[13]], f[g[14]], f[g[15]]], Map[f, Map[g, partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]]	
	,
	TestID->"a5450e1b-fb2c-44eb-8b13-ade880632dd7"
]

VerificationTest[(* 151 *)
	Take[composeMappedFunctions[Map[f, Map[g, partitionedLazyRange[5]]]], 10]
	,
	partitionedLazyList[List[f[g[1]], f[g[2]], f[g[3]], f[g[4]], f[g[5]], f[g[6]], f[g[7]], f[g[8]], f[g[9]], f[g[10]]], partitionedLazyList[List[f[g[11]], f[g[12]], f[g[13]], f[g[14]], f[g[15]]], Map[Function[f[g[Slot[1]]]], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]	
	,
	TestID->"97e07718-e310-4d36-8af1-187f48e2fc4b"
]

VerificationTest[(* 152 *)
	Take[Map[f, Map[List[Exp, Listable], partitionedLazyRange[5]]], 10]
	,
	partitionedLazyList[List[f[E], f[Power[E, 2]], f[Power[E, 3]], f[Power[E, 4]], f[Power[E, 5]], f[Power[E, 6]], f[Power[E, 7]], f[Power[E, 8]], f[Power[E, 9]], f[Power[E, 10]]], partitionedLazyList[List[f[Power[E, 11]], f[Power[E, 12]], f[Power[E, 13]], f[Power[E, 14]], f[Power[E, 15]]], Map[f, Map[List[Exp, Listable], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]]	
	,
	TestID->"13563dea-b677-4304-9187-2d1566ecc789"
]

VerificationTest[(* 153 *)
	Take[composeMappedFunctions[Map[f, Map[List[Exp, Listable], partitionedLazyRange[5]]]], 10]
	,
	partitionedLazyList[List[f[E], f[Power[E, 2]], f[Power[E, 3]], f[Power[E, 4]], f[Power[E, 5]], f[Power[E, 6]], f[Power[E, 7]], f[Power[E, 8]], f[Power[E, 9]], f[Power[E, 10]]], partitionedLazyList[List[f[Power[E, 11]], f[Power[E, 12]], f[Power[E, 13]], f[Power[E, 14]], f[Power[E, 15]]], Map[List[Function[Map[f, Exp[Slot[1]]]], Listable], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]	
	,
	TestID->"933709fd-737f-4c46-9d86-9b35f41696a2"
]

VerificationTest[(* 154 *)
	Take[Map[List[Exp, Listable], Map[f, partitionedLazyRange[5]]], 10]
	,
	partitionedLazyList[List[Power[E, f[1]], Power[E, f[2]], Power[E, f[3]], Power[E, f[4]], Power[E, f[5]], Power[E, f[6]], Power[E, f[7]], Power[E, f[8]], Power[E, f[9]], Power[E, f[10]]], partitionedLazyList[List[Power[E, f[11]], Power[E, f[12]], Power[E, f[13]], Power[E, f[14]], Power[E, f[15]]], Map[List[Exp, Listable], Map[f, partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]]	
	,
	TestID->"8b28ed93-5599-4b12-b84d-bd37d052ecea"
]

VerificationTest[(* 155 *)
	Take[composeMappedFunctions[Map[List[Exp, Listable], Map[f, partitionedLazyRange[5]]]], 10]
	,
	partitionedLazyList[List[Power[E, f[1]], Power[E, f[2]], Power[E, f[3]], Power[E, f[4]], Power[E, f[5]], Power[E, f[6]], Power[E, f[7]], Power[E, f[8]], Power[E, f[9]], Power[E, f[10]]], partitionedLazyList[List[Power[E, f[11]], Power[E, f[12]], Power[E, f[13]], Power[E, f[14]], Power[E, f[15]]], Map[List[Function[Exp[Map[f, Slot[1]]]], Listable], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]	
	,
	TestID->"6f341dd2-f2d3-41b5-a19e-e8565a0603be"
]

VerificationTest[(* 156 *)
	Take[Map[List[Cos, Listable], Map[List[Exp, Listable], partitionedLazyRange[5]]], 10]
	,
	partitionedLazyList[List[Cos[E], Cos[Power[E, 2]], Cos[Power[E, 3]], Cos[Power[E, 4]], Cos[Power[E, 5]], Cos[Power[E, 6]], Cos[Power[E, 7]], Cos[Power[E, 8]], Cos[Power[E, 9]], Cos[Power[E, 10]]], partitionedLazyList[List[Cos[Power[E, 11]], Cos[Power[E, 12]], Cos[Power[E, 13]], Cos[Power[E, 14]], Cos[Power[E, 15]]], Map[List[Cos, Listable], Map[List[Exp, Listable], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]]	
	,
	TestID->"4e2acbd3-503b-4447-a034-2730b0328cb1"
]

VerificationTest[(* 157 *)
	Take[composeMappedFunctions[Map[List[Cos, Listable], Map[List[Exp, Listable], partitionedLazyRange[5]]]], 10]
	,
	partitionedLazyList[List[Cos[E], Cos[Power[E, 2]], Cos[Power[E, 3]], Cos[Power[E, 4]], Cos[Power[E, 5]], Cos[Power[E, 6]], Cos[Power[E, 7]], Cos[Power[E, 8]], Cos[Power[E, 9]], Cos[Power[E, 10]]], partitionedLazyList[List[Cos[Power[E, 11]], Cos[Power[E, 12]], Cos[Power[E, 13]], Cos[Power[E, 14]], Cos[Power[E, 15]]], Map[List[Function[Cos[Exp[Slot[1]]]], Listable], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[11, 12, 13, 14, 15]], 5]]]]]	
	,
	TestID->"5d044afc-f4b7-4dfc-8614-388fa9ae2138"
]

VerificationTest[(* 158 *)
	Take[Map[List[someFunction, Listable], partitionedLazyRange[3]], 4]
	,
	lazyList[]
	,
	{lazyList::take}
	,
	TestID->"e590682e-ebf3-47af-b876-76df923fbbb8"
]

VerificationTest[(* 159 *)
	MapIndexed[Function[List[Slot[1], Slot[2]]], lazyRange[2, 2]]
	,
	lazyList[List[2, 1], MapIndexed[Function[List[Slot[1], Slot[2]]], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[2, 2], 2], Plus[1, 1]]]	
	,
	TestID->"c92d00e7-e6d1-47aa-a5f1-df872503201e"
]

VerificationTest[(* 160 *)
	MapIndexed[Function[List[Slot[1], Slot[2]]], partitionedLazyRange[10, 2, 5]]
	,
	partitionedLazyList[List[List[10, 1], List[12, 2], List[14, 3], List[16, 4], List[18, 5]], MapIndexed[Function[List[Slot[1], Slot[2]]], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[10, List[10, 12, 14, 16, 18]], 10]], Plus[1, 5]]]	
	,
	TestID->"940191b2-9c52-43c6-80e9-ca109bcf4440"
]

VerificationTest[(* 161 *)
	First[Take[MapIndexed[Function[List[Slot[1], Slot[2]]], lazyRange[2, 2]], 5]]
	,
	List[List[2, 1], List[4, 2], List[6, 3], List[8, 4], List[10, 5]]	
	,
	TestID->"755a2a31-5e94-41a8-b2bc-a72cb672099b"
]

VerificationTest[(* 162 *)
	First[Take[MapIndexed[Function[List[Slot[1], Slot[2]]], lazyRange[], 20], 5]]
	,
	List[List[1, 20], List[2, 21], List[3, 22], List[4, 23], List[5, 24]]	
	,
	TestID->"e7f47333-553c-4f61-bf2b-454329529868"
]

VerificationTest[(* 163 *)
	lazySetState[Map[f, lazyRange[]], 20]
	,
	lazyList[f[20], Map[f, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 20], 1]]]	
	,
	TestID->"0d6c8aaf-3971-4513-b6b5-c7a976370960"
]

VerificationTest[(* 164 *)
	CompoundExpression[Set[lst, Range[10]], lazySetState[Map[f, lazyList[Hold[lst]]], 5]]
	,
	lazyList[f[5], Map[f, lazyLists`Private`lazyFiniteList[lst, Plus[5, 1]]]]	
	,
	TestID->"031e4dc8-5c16-47a2-9fc3-07410474c6bd"
]

VerificationTest[(* 165 *)
	lazySetState[Map[f, lazyList[Hold[lst]]], 20]
	,
	lazyList[f[1], Map[f, lazyLists`Private`lazyFiniteList[lst, Plus[1, 1]]]]
	,
	{Part::partw}
	,
	TestID->"8bc09958-c00d-4608-a327-fb972e14312e"
]

EndTestSection[]

BeginTestSection["Fold"]

VerificationTest[(* 166 *)
	FoldList[Plus, x0, lazyRange[n, m]]
	,
	lazyList[x0, FoldList[Plus, Plus[x0, n], Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[m, n], m]]]	
	,
	TestID->"78ede253-0641-40d1-91a6-ada7c363db06"
]

VerificationTest[(* 167 *)
	First[Take[FoldList[Plus, x0, lazyRange[n, m]], 5]]
	,
	List[x0, Plus[n, x0], Plus[m, Times[2, n], x0], Plus[Times[3, m], Times[3, n], x0], Plus[Times[6, m], Times[4, n], x0]]	
	,
	TestID->"db188c97-bab5-4d20-9c9c-d317201c07d3"
]

VerificationTest[(* 168 *)
	First[Take[FoldPairList[Function[List[p[Slot[1], Slot[2]], q[Slot[1], Slot[2]]]], u, lazyRange[]], 4]]
	,
	List[p[u, 1], p[q[u, 1], 2], p[q[q[u, 1], 2], 3], p[q[q[q[u, 1], 2], 3], 4]]	
	,
	TestID->"22e0751b-1a8b-4c64-ab0d-7d245c004db7"
]

EndTestSection[]

BeginTestSection["Cases, Pick, Select"]

VerificationTest[(* 169 *)
	MatchQ[Cases[lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], lazyList[0, Blank[]]]
	,
	True	
	,
	TestID->"eef58711-9a2b-4adf-bb35-fd6ddc3b49a1"
]

VerificationTest[(* 170 *)
	First[Take[Cases[lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], 5]]
	,
	List[0, 2, 4, 6, 8]	
	,
	TestID->"1c11a617-94ea-42b9-bf57-ccb346d33046"
]

VerificationTest[(* 171 *)
	MatchQ[Pick[lazyRange[0, 2], lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], lazyList[0, Blank[]]]
	,
	True	
	,
	TestID->"df1ac686-6c55-4310-b8be-df2063f48b70"
]

VerificationTest[(* 172 *)
	First[Take[Pick[lazyRange[0, 2], lazyRange[0, Times[2, Power[3, -1]]], Blank[Integer]], 5]]
	,
	List[0, 6, 12, 18, 24]	
	,
	TestID->"232b3f69-ae25-4cc2-9e08-7fc39008ebff"
]

VerificationTest[(* 173 *)
	Select[lazyRange[], OddQ]
	,
	lazyList[1, Select[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1], OddQ]]	
	,
	TestID->"8d8036f1-5720-4811-8629-7c25ce67842b"
]

VerificationTest[(* 174 *)
	First[Take[Select[lazyRange[], OddQ], 5]]
	,
	List[1, 3, 5, 7, 9]	
	,
	TestID->"2ff4ea71-a191-4c9f-9760-83fb52d4606d"
]

EndTestSection[]

BeginTestSection["lazyMapThread, lazyTranspose"]

VerificationTest[(* 175 *)
	First[Take[lazyMapThread[f, List[lazyRange[], lazyRange[2, 2]]], 5]]
	,
	List[f[List[1, 2]], f[List[2, 4]], f[List[3, 6]], f[List[4, 8]], f[List[5, 10]]]	
	,
	TestID->"713e38e1-53ae-455a-bbf8-0bbc02d45524"
]

VerificationTest[(* 176 *)
	MapThread[f, List[Range[5], Times[2, Range[5]]]]
	,
	List[f[1, 2], f[2, 4], f[3, 6], f[4, 8], f[5, 10]]	
	,
	TestID->"04ba0346-ff2e-4659-8597-53624df2a10d"
]

VerificationTest[(* 177 *)
	First[Take[lazyMapThread[f, List[lazyRange[], Range[5]]], All]]
	,
	List[f[List[1, 1]], f[List[2, 2]], f[List[3, 3]], f[List[4, 4]], f[List[5, 5]]]	
	,
	TestID->"32188d20-9d34-4122-bf92-06bb3cf26702"
]

VerificationTest[(* 178 *)
	Most[Take[lazyMapThread[f, List[partitionedLazyList[Map[Range, lazyRange[]]], partitionedLazyRange[4], partitionedLazyRange[2, 2, 6]]], 10]]
	,
	List[f[1, 1, 2], f[1, 2, 4], f[2, 3, 6], f[1, 4, 8], f[2, 5, 10], f[3, 6, 12], f[1, 7, 14], f[2, 8, 16], f[3, 9, 18], f[4, 10, 20]]	
	,
	TestID->"1da06e68-9eab-497a-92fa-298cc059d2a2"
]

VerificationTest[(* 179 *)
	lazyMapThread[f, List[partitionedLazyRange[3], lazyRange[]]]
	,
	partitionedLazyList[List[f[1, 1], f[2, 2], f[3, 3]], lazyMapThread[f, List[partitionedLazyList[List[4, 5, 6], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[3, List[4, 5, 6]], 3]]], partitionedLazyList[List[4, 5, 6], lazyPartition[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 6], 1], 3]]]]]	
	,
	TestID->"afa9dc39-c825-4926-a453-fdf3dc86c42d"
]

VerificationTest[(* 180 *)
	First[Take[lazyTranspose[List[lazyRange[], lazyRange[start]]], 5]]
	,
	List[List[1, start], List[2, Plus[1, start]], List[3, Plus[2, start]], List[4, Plus[3, start]], List[5, Plus[4, start]]]	
	,
	TestID->"6f32f0a8-9388-4926-998a-161b2cdd31a4"
]

VerificationTest[(* 181 *)
	First[Take[lazyMapThread[Identity, List[lazyRange[], lazyRange[start]]], 5]]
	,
	List[List[1, start], List[2, Plus[1, start]], List[3, Plus[2, start]], List[4, Plus[3, start]], List[5, Plus[4, start]]]	
	,
	TestID->"6d546c3e-83bb-4b12-832a-cc468addc674"
]

EndTestSection[]

BeginTestSection["lazyCatenate"]

VerificationTest[(* 182 *)
	lazyCatenate[List[List[1, 2]]]
	,
	lazyList[1, lazyList[List[2]]]	
	,
	TestID->"d44e1a68-eed8-4007-8121-b5732cbc3f46"
]

VerificationTest[(* 183 *)
	lazyCatenate[List[lazyRange[]]]
	,
	lazyList[1, Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[1, 1], 1]]	
	,
	TestID->"5a71142c-3026-4188-bf98-8c2241e3e39e"
]

VerificationTest[(* 184 *)
	lazyCatenate[List[partitionedLazyRange[5]]]
	,
	partitionedLazyList[List[1, 2, 3, 4, 5], partitionedLazyList[Function[lazyList[Slot[1], Slot[0][Plus[Slot[2], Slot[1]], Slot[2]]]][Plus[5, List[1, 2, 3, 4, 5]], 5]]]	
	,
	TestID->"503585d1-e1e3-4211-9795-8c4c977a7c4d"
]

VerificationTest[(* 185 *)
	lazyCatenate[List[List[1, 2], List[2, 3, 4]]]
	,
	lazyList[1, lazyList[List[2, 2, 3, 4]]]	
	,
	TestID->"b2868662-c220-4ca5-9934-cf1408f55c4c"
]

VerificationTest[(* 186 *)
	First[Take[lazyCatenate[List[List[1, 2], List[2, 3, 4]]], All]]
	,
	List[1, 2, 2, 3, 4]	
	,
	TestID->"26cc958a-8c1c-46fb-8da0-897ff4d162d5"
]

VerificationTest[(* 187 *)
	First[Take[lazyCatenate[List[lazyGenerator[f, 1, 1, 5], lazyGenerator[g, 1, 1, 5]]], All]]
	,
	List[f[1], f[2], f[3], f[4], f[5], g[1], g[2], g[3], g[4], g[5]]	
	,
	TestID->"23dbb7e0-0165-415b-873b-c8ea5d62ef15"
]

VerificationTest[(* 188 *)
	First[Take[lazyCatenate[lazyGenerator[Range, 1, 1, 5]], All]]
	,
	List[1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5]	
	,
	TestID->"6b951aba-15c0-4b1d-942a-9a5eb2395281"
]

VerificationTest[(* 189 *)
	First[Take[lazyCatenate[lazyGenerator[Function[lazyGenerator[Subscript[f, Slot[1]], Slot[1], Slot[1], Plus[Slot[1], 3]]], 1, 1, 5]], All]]
	,
	List[Subscript[f, 1][1], Subscript[f, 1][2], Subscript[f, 1][3], Subscript[f, 1][4], Subscript[f, 2][2], Subscript[f, 2][3], Subscript[f, 2][4], Subscript[f, 2][5], Subscript[f, 3][3], Subscript[f, 3][4], Subscript[f, 3][5], Subscript[f, 3][6], Subscript[f, 4][4], Subscript[f, 4][5], Subscript[f, 4][6], Subscript[f, 4][7], Subscript[f, 5][5], Subscript[f, 5][6], Subscript[f, 5][7], Subscript[f, 5][8]]	
	,
	TestID->"5a550561-3bb0-4958-ae50-af45c4caf47c"
]

EndTestSection[]

BeginTestSection["endOfLazyList"]

VerificationTest[(* 190 *)
	lazyList[endOfLazyList, "stuff"]
	,
	lazyList[]	
	,
	TestID->"9dc7e6eb-3363-4834-a585-2c2a9296a68d"
]

VerificationTest[(* 191 *)
	lazyList[endOfLazyList, lazyRange[]]
	,
	lazyList[]	
	,
	TestID->"4f792f28-e364-415a-b4ef-4bcfc98a7be5"
]

VerificationTest[(* 192 *)
	partitionedLazyList[List[1, 2, 3, endOfLazyList, otherStuff], anyTail]
	,
	partitionedLazyList[List[1, 2, 3], lazyList[]]	
	,
	TestID->"94817bc0-0d2d-4936-a5db-71739d8c11d6"
]

VerificationTest[(* 193 *)
	Take[Map[f, partitionedLazyList[List[1, 2, 3], partitionedLazyList[List[4, 5, 6, endOfLazyList, Apply[Sequence, Range[10]]], partitionedLazyRange[5]]]], 20]
	,
	partitionedLazyList[List[f[1], f[2], f[3], f[4], f[5], f[6]], lazyList[]]	
	,
	TestID->"ed006187-1cdf-429c-bf81-1372cb1c21b2"
]

VerificationTest[(* 194 *)
	Take[Map[g, Map[f, partitionedLazyList[List[1, 2, 3], partitionedLazyList[List[4, 5, 6, endOfLazyList, Apply[Sequence, Range[10]]], partitionedLazyRange[5]]]]], 20]
	,
	partitionedLazyList[List[g[f[1]], g[f[2]], g[f[3]], g[f[4]], g[f[5]], g[f[6]]], lazyList[]]	
	,
	TestID->"570c9489-e01d-4aa5-aa36-9409385fa8bf"
]

VerificationTest[(* 195 *)
	Take[Map[g, Map[List[Sin, Listable], partitionedLazyList[List[1, 2, 3], partitionedLazyList[List[4, 5, 6, endOfLazyList, Apply[Sequence, Range[10]]], partitionedLazyRange[5]]]]], 20]
	,
	partitionedLazyList[List[g[Sin[1]], g[Sin[2]], g[Sin[3]], g[Sin[4]], g[Sin[5]], g[Sin[6]]], lazyList[]]	
	,
	TestID->"a82e8b8e-e760-4b09-8799-a58114510cc3"
]

VerificationTest[(* 196 *)
	Take[Map[List[Sqrt, Listable], Map[List[Sin, Listable], partitionedLazyList[List[1, 2, 3], partitionedLazyList[List[4, 5, 6, endOfLazyList, Apply[Sequence, Range[10]]], partitionedLazyRange[5]]]]], 20]
	,
	partitionedLazyList[List[Sqrt[Sin[1]], Sqrt[Sin[2]], Sqrt[Sin[3]], Sqrt[Sin[4]], Sqrt[Sin[5]], Sqrt[Sin[6]]], lazyList[]]	
	,
	TestID->"7f54badb-04eb-4387-839f-c61a96a88f32"
]

VerificationTest[(* 197 *)
	Take[Map[List[Sqrt, Listable], Map[f, partitionedLazyList[List[1, 2, 3], partitionedLazyList[List[4, 5, 6, endOfLazyList, Apply[Sequence, Range[10]]], partitionedLazyRange[5]]]]], 20]
	,
	partitionedLazyList[List[Sqrt[f[1]], Sqrt[f[2]], Sqrt[f[3]], Sqrt[f[4]], Sqrt[f[5]], Sqrt[f[6]]], lazyList[]]	
	,
	TestID->"081a33cc-6d46-4a5d-9e20-4f80c8af8f5c"
]

(* ::Text:: *)
(*Fails currently:*)

VerificationTest[(* 198 *)
	Take[Map[Sin, Map[Function[If[Greater[Slot[1], 10], endOfLazyList, Slot[1]]], lazyRange[]]], 20]
	,
	lazyList[List[Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[9], Sin[10]], lazyList[]]	
	,
	TestID->"d45fb48f-f591-4dc9-8f64-ddaa030a3ebd"
]

VerificationTest[(* 199 *)
	Take[Map[Sin, Map[Function[If[Greater[Slot[1], 10], endOfLazyList, Slot[1]]], partitionedLazyRange[5]]], 20]
	,
	partitionedLazyList[List[Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[9], Sin[10]], lazyList[]]	
	,
	TestID->"cb8edc20-4697-48dd-bd1b-bf5a62532ba3"
]

VerificationTest[(* 200 *)
	Take[Map[List[Sin, Listable], Map[Function[If[Greater[Slot[1], 10], endOfLazyList, Slot[1]]], partitionedLazyRange[5]]], 20]
	,
	partitionedLazyList[List[Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[9], Sin[10]], lazyList[]]	
	,
	TestID->"33c42b6a-5684-46b6-b03b-de033e81ecc1"
]

VerificationTest[(* 201 *)
	Take[Map[Sin, Map[List[Function[If[Greater[Max[Slot[1]], 10], Append[Slot[1], endOfLazyList], Slot[1]]], Listable], partitionedLazyRange[5]]], 20]
	,
	partitionedLazyList[List[Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[9], Sin[10], Sin[11], Sin[12], Sin[13], Sin[14], Sin[15]], lazyList[]]	
	,
	TestID->"827b77e3-adc4-411d-9a3d-cfd9afce8fd8"
]

VerificationTest[(* 202 *)
	Take[Map[List[Sin, Listable], Map[List[Function[If[Greater[Max[Slot[1]], 10], Append[Slot[1], endOfLazyList], Slot[1]]], Listable], partitionedLazyRange[5]]], 20]
	,
	partitionedLazyList[List[Sin[1], Sin[2], Sin[3], Sin[4], Sin[5], Sin[6], Sin[7], Sin[8], Sin[9], Sin[10], Sin[11], Sin[12], Sin[13], Sin[14], Sin[15]], lazyList[]]	
	,
	TestID->"73355d47-e7bc-43ca-af53-c934312e1588"
]

EndTestSection[]

BeginTestSection["Edge cases"]

VerificationTest[(* 203 *)
	Set[badExample, Function[lazyList[1, Slot[0][]]][]]
	,
	lazyList[1, Function[lazyList[1, Slot[0][]]][]]	
	,
	TestID->"cca6f375-6ddb-4152-aa3d-2349457bc8e2"
]

VerificationTest[(* 204 *)
	Last[badExample]
	,
	badExample	
	,
	TestID->"d5669f68-30d9-4e7a-a0e0-4a892a683a43"
]

VerificationTest[(* 205 *)
	First[Take[badExample, 20]]
	,
	List[1, 1]	
	,
	TestID->"0820b214-6494-4848-9ae0-3811250773bb"
]

VerificationTest[(* 206 *)
	Set[example, Function[lazyList[1, Slot[0][Plus[Slot[1], 1]]]][1]]
	,
	lazyList[1, Function[lazyList[1, Slot[0][Plus[Slot[1], 1]]]][Plus[1, 1]]]	
	,
	TestID->"70bea84b-fb82-4ee1-8fff-c75fed296f60"
]

VerificationTest[(* 207 *)
	SameQ[example, Last[example]]
	,
	False	
	,
	TestID->"1346241a-d07f-43e4-b438-f6bb7f8bcc01"
]

VerificationTest[(* 208 *)
	Take[example, 20]
	,
	lazyList[List[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], Function[lazyList[1, Slot[0][Plus[Slot[1], 1]]]][Plus[20, 1]]]	
	,
	TestID->"8cc85caf-0ded-497b-bc70-c8c40b5ed440"
]

VerificationTest[(* 209 *)
	Set[position, Replace[Last[Take[example, 20]], List[RuleDelayed[lazyList[Blank[], Function[BlankSequence[]][Pattern[i, Blank[]]]], i]]]]
	,
	22	
	,
	TestID->"276824c8-0ef1-470e-ab70-bcf516bda143"
]

EndTestSection[]

EndTestSection[]
