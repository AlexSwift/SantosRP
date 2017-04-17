
--This is for other projects outside GMod. Just needed to write down some things here

function Vec3:cross(v)
    local x,y,z
    x = self.y * v.z - self.z * v.y
    y = self.z * v.x - self.x * v.z
    z = self.x * v.y - self.y * v.x
    return Vec3(x,y,z)
end