--add by hy 20160407
local CharacterDefine={}


CharacterDefine.ANIS_STAND={
    "idle_down",
    "idle_rightdown",
    "idle_right",
    "idle_rightup",
    "idle_up",
}

CharacterDefine.ANIS_RUN={
    "run_down",
    "run_rightdown",
    "run_right",
    "run_rightup",
    "run_up",
}

CharacterDefine.ANIS_ATK={
    "attack_down",
    "attack_rightdown",
    "attack_right",
    "attack_rightup",
    "attack_up",
}

CharacterDefine.ANIS_SKILL1={
    "skill1_down",
    "skill1_rightdown",
    "skill1_right",
    "skill1_rightup",
    "skill1_up",
}

CharacterDefine.ANIS_SKILL2={
    "skill2_down",
    "skill2_rightdown",
    "skill2_right",
    "skill2_rightup",
    "skill2_up",
}

CharacterDefine.ANIS_SKILL3={
    "skill3_down",
    "skill3_rightdown",
    "skill3_right",
    "skill3_rightup",
    "skill3_up",
}

CharacterDefine.ANIS_SKILL4={
    "skill4_down",
    "skill4_rightdown",
    "skill4_right",
    "skill4_rightup",
    "skill4_up",
}

CharacterDefine.ANIS_DEAD={
    "dead",
}

CharacterDefine.ANIS_WIN={
    "win_down",
    "win_rightdown",
    "win_right",
    "win_rightup",
    "win_up",
}

CharacterDefine.FACE_DIR={
    DIR_DOWN=1,
    DIR_RIGHT_DOWN=2,
    DIR_RIGHT=3,
    DIR_RIGHT_UP=4,
    DIR_UP=5,
    DIR_LEFT_DOWN=6,
    DIR_LEFT=7,
    DIR_LEFT_UP=8
}

CharacterDefine.ACTION_TYPE={
    ACTION_STAND=0,
    ACTION_MOVE=1,
    ACTION_ATK=3,
    ACTION_SKILL=4,
    ACTION_WIN=5
}


CharacterDefine.ANI_TYPE={
    STAND=1,
    RUN=2,
    ATK=3,
    SKILL1=5,
    SKILL2=6,
    SKILL3=9,
    SKILL4=10,
    DEAD=7,
    WIN=8,
}

return CharacterDefine