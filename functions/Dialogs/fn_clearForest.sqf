if (player != theBoss) exitWith {hint "Тільки командир може зачищати ліс"};
if (!isMultiplayer) then {{ _x hideObject true } foreach (nearestTerrainObjects [getMarkerPos respawnTeamPlayer,["tree","bush"],70])} else {{[_x,true] remoteExec ["hideObjectGlobal",2]} foreach (nearestTerrainObjects [getMarkerPos respawnTeamPlayer,["tree","bush"],70])};
hint "Корчі і дерева почищені.";
chopForest = true; publicVariable "chopForest";
