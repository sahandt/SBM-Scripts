--[[This script generates 2 input files, in metric and imperial units, to be used by Frame3DD structural analysis software. It also generates batch files to run the Frame3DD software with the generated input files. The location of the Frame3DD excecutive file should be already saved in the application setting. This script works in  SBM version 1.3.4.0 and later ]]

local now = GetDateTimeNow("yy MM dd hh mm")
StructReset("test project"..now)


--[[Converting nodes:]]
local ele_tbl= GetAllElements()
local tag = ""
local type= ""
local xp = 0
local yp = 0
local zp =0

for i,ele in ipairs(ele_tbl) do
      for j,props in ipairs(ele) do
           if props[1]=="Type" then
             type = props[2]
           elseif props[1]=="Tag" then
             tag = props[2]
           elseif props[1]=="PosX" then
              xp = props[2]
           elseif props[1]=="PosY" then
              yp = props[2]
           elseif props[1]=="PosZ" then
              zp = props[2]
           end
      end
     

      if type=="STRUCT_NODE" then
          print("Adding Node: "..tag)
          StructAddNode(tag)

      elseif type=="STRUCT_LINK" then
          print("Adding Link: "..tag)
          StructAddLink(tag)

     end
end

StructSetNumbers();
StructGenOutputs();

OpenAppWorkingFolder('STRUCT');
