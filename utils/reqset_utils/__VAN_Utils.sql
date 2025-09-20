-- FILE:    __VAN_Utils.sql
-- AUTHOR:  Vanadium
-- PURPOSE: Common reqset defination

-- reqset: city has each district
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType)
    SELECT 'REQSET_VAN_CITY_HAS_' || DistrictType, 'REQUIREMENTSET_TEST_ALL' FROM Districts;
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'REQSET_VAN_CITY_HAS_' || DistrictType, 'REQ_VAN_CITY_HAS_' || DistrictType || FROM Districts;
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'REQ_VAN_CITY_HAS_' || DistrictType ||, 'REQUIREMENT_CITY_HAS_DISTRICT' FROM Districts;
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'REQ_VAN_CITY_HAS_' || DistrictType ||, 'DistrictType', DistrictType FROM Districts;

-- reqset: district is special districts
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('REQSET_VAN_DISTRICT_IS_SPECIALTY_DISTRICT', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    SELECT 'REQSET_VAN_DISTRICT_IS_SPECIALTY_DISTRICT', 'REQ_VAN_DISTRICT_IS_' || DistrictType FROM Districts WHERE RequiresPopulation=1;

-- reqset: district is each district
INSERT INTO RequirementSets(RequirementSetId , RequirementSetType)
    SELECT 'REQSET_VAN_DISTRICT_IS_' || DistrictType, 'REQUIREMENTSET_TEST_ALL' FROM Districts;
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'REQSET_VAN_DISTRICT_IS_' || DistrictType, 'REQ_VAN_DISTRICT_IS_' || DistrictType FROM Districts;
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'REQ_VAN_DISTRICT_IS_' || DistrictType, 'REQUIREMENT_DISTRICT_TYPE_MATCHES' FROM Districts;
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'REQ_VAN_DISTRICT_IS_' || DistrictType, 'DistrictType', DistrictType FROM Districts;

-- reqset: player has each technology
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'REQSET_VAN_PLAYER_HAS_' || TechnologyType, 'REQUIREMENTSET_TEST_ALL' FROM Technologies;
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'REQ_VAN_PLAYER_HAS_' || TechnologyType, 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY' FROM Technologies;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_VAN_PLAYER_HAS_' || TechnologyType, 'TechnologyType', TechnologyType FROM Technologies;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'REQSET_VAN_PLAYER_HAS_' || TechnologyType, 'REQSET_VAN_PLAYER_HAS_' || TechnologyType FROM Technologies;

-- reqset: player has each civic
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'REQSET_VAN_PLAYER_HAS_' || CivicType, 'REQUIREMENTSET_TEST_ALL' FROM Civics;
INSERT INTO Requirements(RequirementId, RequirementType)
    SELECT 'REQ_VAN_PLAYER_HAS_' || CivicType, 'REQUIREMENT_PLAYER_HAS_CIVIC' FROM Civics;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
    SELECT 'REQ_VAN_PLAYER_HAS_' || CivicType, 'CivicType', CivicType FROM Civics;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
    SELECT 'REQSET_VAN_PLAYER_HAS_' || CivicType, 'REQSET_VAN_PLAYER_HAS_' || CivicType FROM Civics;

-- reqset: player's leader type matches each leader
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
    SELECT 'REQSET_VAN_PLAYER_IS_' || LeaderType, 'REQUIREMENTSET_TEST_ANY' FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';
INSERT INTO RequirementSetRequirements(RequirementSetId , RequirementId)
    SELECT 'REQSET_VAN_PLAYER_IS_' || LeaderType, 'REQ_VAN_PLAYER_IS_' || LeaderType FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';
INSERT INTO Requirements(RequirementId , RequirementType)
    SELECT 'REQ_VAN_PLAYER_IS_' || LeaderType, 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES' FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';
INSERT INTO RequirementArguments(RequirementId , Name, Value)
    SELECT 'REQ_VAN_PLAYER_IS_' || LeaderType, 'LeaderType', LeaderType FROM Leaders WHERE InheritFrom='LEADER_DEFAULT';