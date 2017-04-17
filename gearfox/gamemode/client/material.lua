
local SourceSkyname = GetConVar("sv_skyname"):GetString() --We need the source of the maps original skybox texture so we can manipulate it.
local SourceSkyPre  = {"lf","ft","rt","bk","dn","up",}
local SourceSkyMat  = {
	Material("skybox/"..SourceSkyname.."lf"),
	Material("skybox/"..SourceSkyname.."ft"),
	Material("skybox/"..SourceSkyname.."rt"),
	Material("skybox/"..SourceSkyname.."bk"),
	Material("skybox/"..SourceSkyname.."dn"),
	Material("skybox/"..SourceSkyname.."up"),
}

function ChangeSkybox(skyboxname)
	for i = 1,6 do
		local D = Material("skybox/"..skyboxname..SourceSkyPre[i]):GetTexture("$basetexture")
		SourceSkyMat[i]:SetTexture("$basetexture",D)
	end
end