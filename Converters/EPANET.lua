--[[This script converts current project model to an EPANET project and saves the input file (.inp). Then it verifies the input, runs hydraulic analysis, and saves report (.rpt) and hydraulic (.hyd) files ]]

--[[Initialising a new EPANET project:]]
ENinit("Report".. GetDateTimeNow("yy MM dd hh mm ss"),"Output1", EN_C( "EN_CMH"), EN_C( "EN_DW"))

--[[Or you can read the project from an input file located in EPANET folder inside working directory]]
--[[ENopen("eptest1.inp","","")]]

local now = GetDateTimeNow("yy MM dd hh mm")

ENsettitle("EPANET Model for "..GetProjectProperty("NAME") , "Created on "..now, "Scripted by Sahand Tashak")

MaterialClearCollection()
--[[This is the liquid used in calculations.]]
MaterialAddtoCollection("SysLiq", "L1300")
--[[Or you can use the liquid property of liquid distribution system in the project:]]
--[[MaterialAddtoCollection("SysLiq", GetSystemLiquidID())]]

MaterialAddtoCollection("water", "L1430")

print("System liquid is:"..MaterialGetProperty("SysLiq","NAME"))
local liqDensity = MaterialGetProperty("SysLiq","DENSITY")
local liqVisc = MaterialGetProperty("SysLiq","DYNAMIC_VISCOSITY")

local waterDensity = MaterialGetProperty("water","DENSITY")
local waterVisc = MaterialGetProperty("water","DYNAMIC_VISCOSITY")

local specGravity = liqDensity/waterDensity
local specVisco = liqVisc/waterVisc;
print(" liqDensity : ".. liqDensity )
print("liqVisc : "..liqVisc )
print("specific Gravity : "..specGravity )
print("specific Viscosity : "..specVisco )
ENsetoption(EN_C("EN_SP_GRAVITY"),specGravity )  
ENsetoption(EN_C("EN_SP_VISCOS"), specVisco )  

--[[This function calculates volume of a horizontal cylindrical tank.]]
local function HCTankVolume( liquidHeight, tankLength, tankRadius)
   return tankLength *( tankRadius*tankRadius* math.acos(( tankRadius-liquidHeight)/tankRadius)-( tankRadius-liquidHeight)* math.sqrt(2*tankRadius*liquidHeight-liquidHeight*liquidHeight)) 
end 

--[[This function generates volume curve of a horizontal cylindrical tank.]]
local function AddHCTankVolumeCurve (id, tankLength, tankRadius, N)
   ENaddcurve(id)
   local curveIndex = ENgetcurveindex(id)
   ENsetcurvevalue( curveIndex, 1, 0, 0) 
   local i = 2
   local h=0
     while i<=N do
          h =  tankRadius*2*i/N
          ENsetcurvevalue( curveIndex, i,h , HCTankVolume( h, tankLength, tankRadius)) 
      i = i + 1
     end
   return curveIndex
end

--[[This function generates flow curve of a pump.]]
local function AddPumpCurve (id, maxFlow, CurveFormula, N)
   ENaddcurve(id)
   local curveIndex = ENgetcurveindex(id)
   local i = 1
   local f=0
     while i<=N do
          f =   maxFlow*i/N
          ENsetcurvevalue( curveIndex, i,f ,ParseMathExpression(CurveFormula,"x",f)) 
      i = i + 1
     end
   return curveIndex
end

--[[Verify that each element has a unique tag:]]
CheckDuplicate(true)

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

       if type=="PIPE_FITTING" then
            index = ENaddnode(tag,EN_C("EN_JUNCTION"))
            ENsetjuncdata( index, zp, 0, "")
            ENsetcoord(index, yp,xp)
      elseif type=="HYDRAULIC_APPLIANCE" then
            local baseDemand = GetProperty(tag,"BASE_DEMAND") 
            --[[If demand is positive, a junction will be added, otherwise a reservoir will be added.]]
            if baseDemand>0 then
               index = ENaddnode(tag,EN_C("EN_JUNCTION"))
               ENsetjuncdata( index, zp, baseDemand, "")
               ENsetcoord(index, yp,xp)
           else
               index = ENaddnode(tag,EN_C("EN_RESERVOIR"))
               local aheight = GetProperty(tag,"HEIGHT") 
               ENsetnodevalue(index ,EN_C("EN_ELEVATION"),zp+aheight/2) 
               ENsetcoord(index, yp,xp)
           end
      elseif type=="VCYL_AS_TANK" then
            index = ENaddnode(tag,EN_C("EN_TANK"))
            local outsidediam= GetProperty(tag,"DIAMETER")
            local wallthickness = GetProperty(tag,"WALL_THICKNESS")
            local diam = outsidediam-2*wallthickness
            local initlvl = GetProperty(tag,"INIT_LIQ_ELEV")
            local minlvl = GetProperty(tag,"MIN_LIQ_ELEV")
            local maxlvl = GetProperty(tag,"MAX_LIQ_ELEV")
            ENsettankdata(index, zp, initlvl,  minlvl, maxlvl, diam, 0, "")
            ENsetcoord(index, yp,xp)
      elseif type=="RECT_AS_TANK" then
            index = ENaddnode(tag,EN_C("EN_TANK"))
            local wallthickness = GetProperty(tag,"WALL_THICKNESS")
            local tanklength = GetProperty(tag,"LENGTH")-2*wallthickness
            local tankwidth = GetProperty(tag,"WIDTH")-2*wallthickness
            local diam =  2* math.sqrt(tanklength*  tankwidth/math.pi)
            local initlvl = GetProperty(tag,"INIT_LIQ_ELEV")
            local minlvl = GetProperty(tag,"MIN_LIQ_ELEV")
            local maxlvl = GetProperty(tag,"MAX_LIQ_ELEV")
            ENsettankdata(index, zp, initlvl,  minlvl, maxlvl, diam, 0, "")
            ENsetcoord(index, yp,xp)
      elseif type=="HCYL_AS_TANK" then
            index = ENaddnode(tag,EN_C("EN_TANK"))
            local outsidediam= GetProperty(tag,"DIAMETER")
            local wallthickness = GetProperty(tag,"WALL_THICKNESS")
            local diam = outsidediam-2*wallthickness
            local  tankLength = GetProperty(tag,"LENGTH")
            local initlvl = GetProperty(tag,"INIT_LIQ_ELEV")
            local minlvl = GetProperty(tag,"MIN_LIQ_ELEV")
            local maxlvl = GetProperty(tag,"MAX_LIQ_ELEV")
            local minvol =HCTankVolume( minlvl , tankLength, diam/2)
            local id = tag.."volume_curve"
            AddHCTankVolumeCurve(id, tankLength, diam/2, 20)
            ENsettankdata(index, zp-diam/2, initlvl,  minlvl, maxlvl, 0,minvol , id)
            ENsetcoord(index, yp,xp)
            end
end

--[[Adding links:]]
for i,ele in ipairs(ele_tbl) do
      for j,props in ipairs(ele) do
           if props[1]=="Type" then
             type = props[2]
           end
           if props[1]=="Tag" then
             tag = props[2]
           end
           if props[1]=="PosX" then
              xp = props[2]
           end
           if props[1]=="PosY" then
              yp = props[2]
           end
           if props[1]=="PosZ" then
              zp = props[2]
           end
      end

       if type=="PIPE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_PIPE"), node1tag, node2tag);
           ENsetpipedata(index, pipelength, pipeid, DWrghns, 0);
       elseif type=="FCVALVE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_FCV"), node1tag, node2tag);
            ENsetpipedata(index, pipelength, pipeid,  DWrghns, 0);
       elseif type=="GPVALVE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_GPV"), node1tag, node2tag);
            ENsetpipedata(index, pipelength, pipeid,  DWrghns, 0);
       elseif type=="TCVALVE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_TCV"), node1tag, node2tag);
            ENsetpipedata(index, pipelength, pipeid,  DWrghns, 0);
       elseif type=="PRVALVE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_PRV"), node1tag, node2tag);
            ENsetpipedata(index, pipelength, pipeid,  DWrghns, 0);
       elseif type=="PSVALVE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_PSV"), node1tag, node2tag);
            ENsetpipedata(index, pipelength, pipeid,  DWrghns, 0);
       elseif type=="PBVALVE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_PBV"), node1tag, node2tag);
            ENsetpipedata(index, pipelength, pipeid,  DWrghns, 0);
      elseif type=="CHVALVE" then
            local pipelength = GetProperty(tag,"PIPE_LENGTH")
            local pipeod = GetProperty(tag,"OUTSIDE_DIAMETER")
            local pipethk = GetProperty(tag,"WALL_THICKNESS")
            local DWrghns = GetProperty(tag,"ABSOLUTE_ROUGHNESS")*1000
            local pipeid= (pipeod-2*pipethk)*1000;
            local nodes = GetLinkNodes(tag);
            local node1tag = nodes[1]
            local node2tag = nodes[2]
            index= ENaddlink(tag, EN_C( "EN_CVPIPE"), node1tag, node2tag);
            ENsetpipedata(index, pipelength, pipeid,  DWrghns, 0);
       elseif type=="PIPE_FITTING" then
            local isNozzle= GetProperty(tag,"LOCK_2_PARENT" )
            if isNozzle then
                local holderTag= GetHolderTag(tag)
                if GetElementType(holderTag)!="PUMP" then
                   local nozzlelength = GetProperty(tag,"CONNECTION_LENGTH" )
                   local nozzleod = GetProperty(tag,"OUTSIDE_DIAMETER")
                   local nozzlethk = GetProperty(tag,"WALL_THICKNESS")
                   local nozzleid= (nozzleod-2*nozzlethk)*1000;
                   local nozzlepipetag = tag.."_NZL_PIPE"
                   index= ENaddlink(nozzlepipetag, EN_C( "EN_PIPE"), tag, holderTag);
                   ENsetpipedata(index, nozzlelength, nozzleid, 0.046, 0);
                end
           end 
       elseif type=="PUMP" then
           local childrentable = GetChildrenInfo(tag);
           local childtag = ""
           local childtype= ""
           local inlet = ""
           local outlet = ""
           for i,ele in ipairs(childrentable) do
                for j,props in ipairs(ele) do
                   if props[1]=="Type" then
                       childtype = props[2]
                   end
                   if props[1]=="Tag" then
                     childtag = props[2]
                   end
                end
                if childtype=="PIPE_FITTING" then
                  if inlet == "" then
                       inlet = childtag
                  else
                       outlet = childtag 
                end
            end
            end
          if inlet ~="" and outlet ~= "" then
              index= ENaddlink( tag, EN_C( "EN_PUMP"), inlet, outlet);
              local maxFlow = GetProperty(tag,"MAX_FLOW" )
              local CurveFormula = GetProperty(tag,"HEAD_FLOW_CURVE_FORMULA"  )
              local id = tag.."_flow_head_curve"
              local cindex= AddPumpCurve (id, maxFlow, CurveFormula, 10)
              ENsetlinkvalue(index, EN_C("EN_PUMP_HCURVE"), cindex);
          end
       end 
end


local filename ="EPANET input "..now
ENsaveinpfile(filename);
print("File: "..filename.." is saved in application folder!")

if(ENVerifyInput()) then 

      --[[Opening project's hydraulic solver:]]
      ENopenH();
      
      --[[Creating a lua table to add calculation results inside a HTML table:]]
      local fittingTable = {}
      local ftHeader = {}
      table.insert(ftHeader, "Row")
      
      for fittingTag in GetElementsByType("PIPE_FITTING") do
         table.insert(ftHeader, fittingTag)
      end 
      table.insert(fittingTable, ftHeader)
      
      --[[initializing project's hydraulic solver:]]
      ENinitH(EN_C("EN_SAVE_AND_INIT"));
      
      --[[
      initializing options:
      EN_NOSAVE: Don't save hydraulics; don't re-initialize flows.
      EN_SAVE: Save hydraulics to file, don't re-initialize flows.
      EN_INITFLOW: Don't save hydraulics; re-initialize flows.
      EN_SAVE_AND_INIT: Save hydraulics; re-initialize flows.
      ]]

       ENsolveH()
       ENsaveH();

      local ftRow = {}
      table.insert(ftRow, "Pressure")
      for fittingTag in GetElementsByType("PIPE_FITTING") do
         table.insert(ftRow,  ENgetnodevalue(ENgetnodeindex(fittingTag), EN_C("EN_PRESSURE")))
      end 
      table.insert(fittingTable, ftRow)
   
      hydraulicsFileName="Hydraulics ".. now;
   
      ENsavehydfile(hydraulicsFileName);
      ENreport();
      ENsaveRepfile();

          ENcloseH();
          printTable("Nodes Results", fittingTable)
end
ENclose();
OpenAppWorkingFolder('EPANET');
