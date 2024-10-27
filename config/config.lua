SDC = {}

---------------------------------------------------------------------------------
-------------------------------Important Configs---------------------------------
---------------------------------------------------------------------------------
SDC.Framework = "qb-core" --Either "qb-core" or "esx"
SDC.Target = "qb-target" --Can be one of these (If "none" is selected it will use TextUi): ["qb-target","ox-target","none"]
SDC.NotificationSystem = "framework" -- ['mythic_old', 'mythic_new', 'tnotify', 'okoknotify', 'print', 'framework', 'none'] --Notification system you prefer to use
SDC.UseProgBar = "ox_lib" --If you want to use a progress bar resource, options: ["progressBars", "mythic_progbar", "ox_lib", "none"]
SDC.DispatchSystem = "none" --Can be one of these (If "none" it will use built in police notification) ["none", "cd_dispatch", "ps-dispatch"]

SDC.DisplayNameLength = {Min = 2, Max = 16} --The min/max length for display names on leaderboard
SDC.LeaderboardLength = 15 --How many places are showed on the leaderboard

SDC.ServerSyncTimer = 5 --How often the server will check cooldown times (In Seconds)

SDC.Commands = { --All command configs
    MainMenu = "pumpkinsmash", --Command to open main pumpkin smash menu
    ResetCommand = "resetpumpkins" --Command for police to use to reset nearby player's pumpkin count
}
SDC.JobsThatCanResetPumpkinsSmashed = { --All jobs that can reset pumpkin counts
    --EX: ["job_name"] = "Job Label"

    ["police"] = "Police",
}
---------------------------------------------------------------------------------
----------------------------Pumpkin Smash Configs--------------------------------
---------------------------------------------------------------------------------
SDC.SmashMinigame = { --All minigame configs
    Enabled = true, --If you want the minigame to be enabled
    Checks = 4, --How many keypress checks are done
    Difficulty = "easy", -- Options: ["easy", "medium", "hard"]
    Keys = {"w", "a", "s", "d"} --The keys that are used for the keypress
}
SDC.SmashAnimationTime = 10 --How long the smashing pumpkin animation is played for
SDC.RequiredItemsToSmash = { --All required items to smash a pumpkin
    --EX: ["item_name"] = {label = "Item Label", AmtNeeded = 1}

    ["weapon_hammer"] = {Label = "Hammer", AmtNeeded = 1},
}

SDC.SmashPumpkinDist = 1.5 --How close you have to be to smash a pumpkin (ONLY FOR TEXT UI)
SDC.SmashPKeybind = {Input = 38, Label = "E"} --Keybind to start smashing a pumpkin (ONLY FOR TEXT UI)

SDC.PumpkinSpawnDist = 75 --How close/far you have to be for it to spawn/delete the pumpkins
SDC.PumpkinModels = { --All pumpkin models used
    "skrill_pumpkin_finished"
}

SDC.CallPolice = { --Police Call Notfications
    ChanceToCall = 100, --The 0-100% chance that police will be called when smashing a pumpkin
    CallOnMinigameFail = true, --If you want the police to be called when you fail the smash minigame
    Blip = {Sprite = 468, Color = 1, Size = 1.0}, --Pumpkin smashing blip configs
    AlertJobs = { --All jobs that are alerted when someone smashes a pumpkin
        --EX: "job_name",

        "police",
    }
}

---------------------------------------------------------------------------------
----------------------------Pumpkin Spawn Configs--------------------------------
---------------------------------------------------------------------------------
SDC.SmashLocationCooldown = 30 --How long a smashed pumpkin is on cooldown for before it can be smashed again (In Minutes)
SDC.SpawnLocations = { --All pumpkin spawn locations
    --EX: vec4(0.0, 0.0, 0.0, 0.0),

    vec4(1264.3644, -647.7693, 67.9215, 124.6948),
    vec4(1263.6769, -646.5180, 67.9215, 118.4895),
    vec4(1262.9214, -645.1613, 67.9215, 117.1967),
    vec4(1265.2052, -645.1191, 67.9214, 119.2781),
    vec4(1252.1498, -620.9244, 69.4134, 26.6679),
    vec4(1240.6520, -603.0362, 69.4867, 99.6007),
    vec4(1240.6143, -600.2218, 69.4877, 80.6067),
    vec4(1240.8944, -565.5770, 69.6575, 90.2513),
    vec4(1251.0996, -514.5793, 69.3494, 38.5367),
    vec4(1250.6013, -516.3538, 69.3495, 114.3790),
    vec4(1251.9534, -495.3668, 69.7104, 120.5069),
    vec4(1259.7188, -476.8745, 70.1891, 82.6983),
    vec4(1259.4718, -478.0674, 70.1891, 86.8438),
    vec4(1259.2594, -479.3236, 70.1891, 84.8037),
    vec4(1265.8013, -456.8888, 70.5176, 66.4538),
    vec4(1263.6295, -427.0257, 69.8008, 114.1405),
    vec4(1263.3060, -425.9420, 69.8008, 114.2238),
    vec4(1302.1075, -573.9267, 71.7323, 179.1032),
    vec4(1324.7909, -583.1365, 73.1587, 155.7435),
    vec4(1322.5697, -582.0824, 73.1893, 153.9879),
    vec4(1341.5709, -597.9088, 74.7008, 140.8579),
    vec4(1342.7229, -598.7322, 74.7008, 143.6843),
    vec4(1344.6725, -600.1389, 74.7008, 144.7081),
    vec4(1366.5453, -606.1039, 74.7109, 157.4436),
    vec4(1386.2651, -592.5437, 74.4854, 255.7914),
    vec4(1388.0232, -568.9165, 74.4965, 299.9429),
    vec4(1388.6869, -570.5543, 74.4965, 293.2146),
    vec4(1371.0719, -555.7109, 74.6858, 344.5542),
    vec4(1349.4119, -547.8869, 73.8147, 342.3466),
    vec4(1346.8931, -546.7761, 73.8139, 339.9190),
    vec4(1326.9836, -535.0212, 72.4409, 339.3918),
    vec4(1328.2908, -535.5791, 72.4409, 340.5342),
    vec4(1301.7201, -527.6177, 71.3240, 343.2424),
    vec4(1029.5068, -410.7584, 65.9493, 53.6815),
    vec4(1011.5258, -424.3230, 64.9535, 117.0915),
    vec4(1012.2548, -425.3628, 64.9527, 109.5760),
    vec4(988.7675, -432.7715, 63.8907, 24.7038),
    vec4(966.4763, -452.0290, 62.7896, 79.0949),
    vec4(944.5215, -464.5685, 61.3958, 301.6653),
    vec4(943.5939, -463.0253, 61.3958, 33.9104),
    vec4(920.0194, -478.7773, 60.7047, 22.5992),
    vec4(917.8562, -478.8668, 60.7050, 351.5454),
    vec4(113.1790, -1961.6949, 20.9452, 199.7564),
    vec4(85.0562, -1959.6018, 21.1217, 140.7216),
    vec4(84.0522, -1958.8685, 21.1217, 137.8706),
    vec4(76.9938, -1949.3638, 21.1741, 138.7638),
    vec4(70.8903, -1937.8197, 21.3694, 134.1612),
    vec4(73.3845, -1940.3325, 21.3688, 132.8505),
    vec4(55.4493, -1921.9293, 21.6208, 142.7713),
    vec4(40.1302, -1910.2087, 21.9655, 49.2442),
    vec4(41.1733, -1909.8199, 21.9655, 319.9141),
    vec4(42.3710, -1910.8380, 21.9655, 316.7153),
    vec4(24.9864, -1898.3228, 22.9659, 137.1559),
    vec4(24.0897, -1897.5925, 22.9659, 138.8005),
    vec4(6.7621, -1883.9569, 23.3195, 140.0434),
    vec4(7.8019, -1884.7676, 23.3195, 152.2259),
    vec4(-6.5648, -1870.6166, 24.1512, 48.8811),
    vec4(-6.2230, -1871.6805, 24.1511, 138.5622),
    vec4(-20.9897, -1858.8221, 25.4087, 143.5789),
    vec4(-33.2564, -1846.0645, 26.1936, 51.2133),
    vec4(-32.4146, -1845.1604, 26.1936, 51.3113),
    vec4(198.8048, -1727.7694, 29.6636, 113.6556),
    vec4(217.2216, -1718.3778, 29.2918, 94.7100),
    vec4(224.0769, -1701.6121, 29.6969, 35.7025),
    vec4(221.1342, -1703.6862, 29.6947, 40.3107),
    vec4(241.5161, -1688.9817, 29.2848, 140.2072),
    vec4(251.4261, -1671.8134, 29.6632, 40.5414),
    vec4(252.3457, -1670.7328, 29.6632, 48.6109),
    vec4(283.3168, -1693.3623, 29.6472, 231.6451),
    vec4(283.9203, -1692.4988, 29.6479, 226.5654),
    vec4(269.6595, -1713.3994, 29.6688, 229.0833),
    vec4(254.6224, -1720.7948, 29.3125, 225.5361),
    vec4(253.8396, -1721.6873, 29.3043, 232.0342),
    vec4(249.2050, -1731.7332, 29.3657, 219.7398),
    vec4(492.4358, -1712.4287, 29.3209, 338.9349),
    vec4(493.4144, -1712.7804, 29.3370, 337.0418),
    vec4(478.5842, -1737.2036, 29.1510, 72.8999),
    vec4(478.9185, -1735.9728, 29.1510, 72.2979),
    vec4(474.8718, -1756.5200, 28.7053, 72.0708),
    vec4(472.2830, -1773.5194, 29.0709, 36.2665),
    vec4(514.1775, -1779.3546, 28.9134, 278.8589),
    vec4(514.2258, -1782.6210, 28.9140, 261.8498),
    vec4(512.5048, -1791.9832, 28.5030, 269.9679),
    vec4(500.5230, -1811.3790, 28.5030, 184.8904),
    vec4(494.0250, -1819.3610, 28.4758, 233.4607),
    vec4(492.8982, -1820.7311, 28.4697, 232.1842),
    vec4(1260.5989, -1761.3315, 49.6586, 228.7747),
    vec4(1257.7788, -1762.5870, 49.6585, 196.2591),
    vec4(1249.5284, -1734.8942, 51.6376, 29.3097),
    vec4(1273.2971, -1721.4077, 54.6551, 30.0833),
    vec4(1295.8971, -1738.2065, 53.8795, 157.3580),
    vec4(1287.9186, -1711.0514, 55.4764, 29.3223),
    vec4(1290.6774, -1710.0062, 55.4754, 339.8038),
    vec4(1314.9761, -1729.0074, 54.3503, 205.0887),
    vec4(1313.6986, -1729.4951, 54.3503, 207.3699),
    vec4(1314.5459, -1698.3240, 57.8379, 289.0221),
    vec4(1311.0514, -1697.6597, 57.8383, 342.9316),
    vec4(1356.9075, -1692.9980, 60.5184, 78.4200),
    vec4(1357.4431, -1688.6351, 60.5184, 77.5472),
    vec4(1357.6478, -1686.8323, 60.5184, 116.5837),
    vec4(1357.8877, -1685.4075, 60.5184, 83.2877),
}
